/**********************************************************************
 * Copyright © 2009, 2010 OPC Foundation, Inc. 
 *
 * All binaries built with the "OPC .NET 3.0 (WCF Edition)" source code 
 * are subject to the terms of the Express Interface Public License (Xi-PL).
 * See http://www.opcfoundation.org/License/Xi-PL/
 *
 * The source code itself is also covered by the Xi-PL except the source code 
 * cannot be redistributed in its original or modified form unless
 * it has been incorporated into a product or system sold by an OPC Foundation 
 * member that adds value to the codebase. 
 *
 * You must not remove this notice, or any other, from this software.
 *
 *********************************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Threading;
using System.Diagnostics;

namespace Xi.Server.Base
{
	/// <summary>
	/// This is the Context Manager for the reference implementation of an Express Interface (Xi) Server.
	/// The reference implantation provides some base classes that allow for the implantation of 
	/// a Xi Server with some common or standardized behavior.
	/// This class manages the active contexts (sessions) and provides lookup, timeout and caching support.
	/// </summary>
	/// <typeparam name="TContext">Concrete server context type</typeparam>
	/// <typeparam name="TList">Concrete server List type base class</typeparam>
	public static class ContextManager<TContext, TList>
		where TContext : ContextBase<TList>
		where TList : ListRoot
	{
		
		private static volatile uint _timeoutMilliSeconds;
		private static readonly Dictionary<string, TContext> _activeContexts = new Dictionary<string, TContext>();

		/// <summary>
		/// This event is raised when the context collection managed by this class is altered.  It provides
		/// an opportunity for the server implementation to know about clients added/removed outside of the WCF
		/// connections (i.e. timeout conditions, etc.)
		/// </summary>
		public static event EventHandler<ContextCollectionChangedEventArgs<TContext>> ContextChanged;

		/// <summary>
		/// Enforced context timeout, set to zero to disable context timeout support
		/// </summary>
		public static uint ContextTimeout
		{
			get
			{
				return _timeoutMilliSeconds;
			}

			set
			{
				if (_timeoutMilliSeconds != value)
				{
					_timeoutMilliSeconds = value;
					if (_timeoutMilliSeconds > 0)
					{
						StartContextMonitor();
					}
					else
					{
						StopContextMonitor();
					}
				}
			}
		}

		/// <summary>
		/// This method locates a context object using the context ID.
		/// Proper security checks are performed.
		/// </summary>
		/// <param name="contextId">ContextID</param>
		/// <returns>TContext object</returns>
		public static TContext LookupContext(string contextId)
		{
			return LookupContext(contextId, true);
		}

		/// <summary>
		/// This method locates a context object using the context ID.
		/// It allows security checks to be disabled
		/// </summary>
		/// <param name="contextId">Context ID</param>
		/// <param name="validate">Whether to validate the context credentials</param>
		/// <returns>TContext object</returns>
		public static TContext LookupContext(string contextId, bool validate)
		{
			TContext context = null;
			OperationContext ctx = OperationContext.Current;
			if (null != ctx)
			{
				if (!(validate && (ctx.ServiceSecurityContext == null 
						|| ctx.ServiceSecurityContext.PrimaryIdentity == null)))
				{
					lock (_activeContexts)
					{
						if (_activeContexts.TryGetValue(contextId, out context))
						{
							if (validate == false || context.ValidateSecurity(ctx))
							{
								context.LastAccess = DateTime.UtcNow;
							}
						}
					}
				}
				if (null == context)
				{
					ctx.Channel.Close();
				}
			}
			return context;
		}

		/// <summary>
		/// This method adds a new context to the manager's collection.  The assigned
		/// Context.LocalId is used to store the context object.
		/// </summary>
		/// <param name="context">Context to add</param>
		internal static void AddContext(TContext context)
		{
			lock (_activeContexts)
			{
				_activeContexts.Add(context.Id, context);
			}
			RaiseContextChanged(new ContextCollectionChangedEventArgs<TContext>(context, null));
		}

		/// <summary>
		/// This method removes a context from the context manager collection.
		/// </summary>
		/// <param name="contextId">Context ID to remove</param>
		internal static void RemoveContext(string contextId)
		{
			TContext context = LookupContext(contextId, false);
			if (context != null)
			{
				lock (_activeContexts)
				{
					_activeContexts.Remove(contextId);
				}
				RaiseContextChanged(new ContextCollectionChangedEventArgs<TContext>(null, context));
			}
		}

		/// <summary>
		/// This returns the current (active) list of contexts.
		/// </summary>
		public static List<TContext> Contexts
		{
			get
			{
				lock (_activeContexts)
				{
					return _activeContexts.Values.ToList();
				}
			}
		}

		private static void RaiseContextChanged(ContextCollectionChangedEventArgs<TContext> e)
		{
			EventHandler<ContextCollectionChangedEventArgs<TContext>> changed = ContextChanged;
			if (changed != null)
				changed(null, e);
		}

		private static volatile bool _stopMonitor;
		private static Thread _contextMonitor;

		private static void StartContextMonitor()
		{
			if (_contextMonitor == null)
			{
				_stopMonitor = false;
				_contextMonitor = new Thread(CheckContextTimeout)
									  {
										  Name = "Context Timeout Thread",
										  IsBackground = true,
										  Priority = ThreadPriority.BelowNormal
									  };
				_contextMonitor.Start();
			}
		}

		private static void StopContextMonitor()
		{
			if (_contextMonitor != null)
			{
				_stopMonitor = true;
				if (!_contextMonitor.Join(500))
					_contextMonitor.Interrupt();
				_contextMonitor = null;                                
			}
		}

		private static void CheckContextTimeout()
		{
			DateTime previousTimeoutCheckTime = DateTime.UtcNow;
			DateTime currentTimeoutCheckTime = DateTime.UtcNow;
			while (!_stopMonitor)
			{
				try
				{
					Thread.Sleep(3000);
					currentTimeoutCheckTime = DateTime.UtcNow;
					// This is here for debug.  Don’t do the timeout if the 
					// Check Context Timeout thread has not been running.
					if (5000 > (currentTimeoutCheckTime - previousTimeoutCheckTime).TotalMilliseconds)
					{
						// Get list of dead contexts
						List<TContext> deadContexts;
						lock (_activeContexts)
						{
							deadContexts =
								_activeContexts.Values.Where(
									ctx => (ctx.CheckTimeout(currentTimeoutCheckTime))).ToList();
						}
						if (deadContexts.Count > 0)
						{
							lock (_activeContexts)
							{
								deadContexts.ForEach(sess => _activeContexts.Remove(sess.Id));
							}

							deadContexts.ForEach(ctx =>
												 Xi.Server.Base.XiTracer.TraceSource.TraceEvent(
													 TraceEventType.Information, 1, "Timeout out Context {0}", ctx.Id));
							foreach (TContext context in deadContexts)
							{
								RaiseContextChanged(new ContextCollectionChangedEventArgs<TContext>(null, context));
							}
						}
					}
					previousTimeoutCheckTime = currentTimeoutCheckTime;
				}
				catch (ThreadInterruptedException)
				{
				}
			}
		}
	}

	/// <summary>
	/// This event is raised when the context collection is changed.
	/// The removal of a context may be a due to closing the context or the context timed out.
	/// </summary>
	/// <typeparam name="TContext"></typeparam>
	public class ContextCollectionChangedEventArgs<TContext> : EventArgs
	{
		/// <summary>
		/// The Xi Context that was added or null.
		/// </summary>
		public TContext AddedContext { get; private set; }

		/// <summary>
		/// The Xi Context that was removed or null
		/// </summary>
		public TContext RemovedContext { get; private set; }

		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="added"></param>
		/// <param name="removed"></param>
		internal ContextCollectionChangedEventArgs(TContext added, TContext removed)
		{
			AddedContext = added;
			RemovedContext = removed;
		}
	}
}
