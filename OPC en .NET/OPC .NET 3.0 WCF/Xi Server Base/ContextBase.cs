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
using System.Security.Principal;
using System.ServiceModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;

using Xi.Contracts;
using Xi.Contracts.Data;
using Xi.Common.Support.Extensions;

namespace Xi.Server.Base
{
	/// <summary>
	/// This class is intended to be used as the base class for the server-side context of a client
	/// connection.  An instance of this class is instantiated for each client context established 
	/// by IResourceManagement.Initiate(...). <see cref="ResourceManagement.Initiate"/>
	/// </summary>
	/// <typeparam name="TList">
	/// The concrete type used for the Xi Lists managed by this Context.  
	/// This is commonly specified as "ListRoot" as a context will generally 
	/// manage lists of multiple types.
	/// </typeparam>
	public abstract partial class ContextBase<TList> 
		: IDisposable
		where TList : ListRoot
	{
		/// <summary>
		/// This object provides the general lock used to control access to an instance of a context.
		/// Each method that may change the state of this context instance should obtain this lock on entry.
		/// </summary>
		protected object ContextLock = new object();

		/// <summary>
		/// Constructor
		/// </summary>
		protected ContextBase()
		{
			LastAccess = DateTime.UtcNow;
		}

		/// <summary>
		/// "finalizer" This method is invoked by the garbage collector when all 
		/// reference to this instance have been removed.  This method then takes 
		/// care of any cleanup needed by this instance.
		/// </summary>
		~ContextBase()
		{
			Dispose(false);
		}

		/// <summary>
		/// Invoke the dispose method to clean up this context instance.
		/// </summary>
		public void Dispose()
		{
			if (Dispose(true))
				GC.SuppressFinalize(this);
		}

		/// <summary>
		/// Subclasses are allowed to overload this method to take care of any cleanup 
		/// needed by the subclass.  The subclass should also invoke this method to 
		/// take care of cleaning up this base class.
		/// </summary>
		/// <param name="isDisposing"></param>
		/// <returns></returns>
		protected virtual bool Dispose(bool isDisposing)
		{
			if (_hasBeenDisposed)
				return false;

			lock (ContextLock)
			{
				List<KeyValuePair<uint, TList>> xiLists = _XiLists.ToList<KeyValuePair<uint, TList>>();
				foreach (var kvp in xiLists)
				{
					kvp.Value.Dispose();
				}
				_XiLists.Clear();
			}

			_hasBeenDisposed = true;
			return true;
		}
		/// <summary>
		/// This flag may (should) be checked to insure that this 
		/// context instance is still valid.
		/// </summary>
		protected bool _hasBeenDisposed = false;

		private IIdentity _identity;
		private DateTime _lastAccess;

		/// <summary>
		/// The collection of lists for this context.
		/// </summary>
		protected readonly Dictionary<uint, TList> _XiLists = new Dictionary<uint, TList>();

		/// <summary>
		/// The collection of Endpoints for this context.
		/// The key for this dictionary is the Endpoint LocalId a GUID created by the Xi Server.
		/// </summary>
		protected readonly Dictionary<string, EndpointEntry<TList>> _XiEndpoints 
			= new Dictionary<string, EndpointEntry<TList>>();

		private Random rand = new Random(unchecked((int)(DateTime.UtcNow.Ticks & 0x000000007FFFFFFFFL)));
		/// <summary>
		/// This method is used to obtain a unique list identification (server alias) for a Xi List instance.
		/// Note: "ContextLock" should be locked prior to invoking this method and remain locked until the 
		/// Xi List has been added to this Xi Context.
		/// </summary>
		/// <returns></returns>
		protected uint NewUniqueListId()
		{
			uint key = 0;
			do
			{
				key = (uint)rand.Next(1, 0x3FFFFFFF);
			} while (_XiLists.ContainsKey(key));
			return key;
		}

		/// <summary>
		/// Context identifier (must be unique).
		/// </summary>
		public string Id { get; set; }

		/// <summary>
		/// The key to be used when re-initiating the context.
		/// </summary>
		public string ReInitiateKey { get; set; }

		/// <summary>
		/// Transport session identifier (may be null or not present).
		/// </summary>
		public string TransportSessionId { get; set; }

		/// <summary>
		/// Application name handed to server when context was created.
		/// </summary>
		public string ApplicationName { get; set; }

		/// <summary>
		/// Workstation name handed to server when context was created.
		/// </summary>
		public string WorkstationName { get; set; }

		/// <summary>
		/// User identity (may be null).
		/// </summary>
		public IIdentity Identity
		{
			get { return _identity; }
			set { _identity = value; }
		}

		/// <summary>
		/// User's locale, negotiated when context was created, zero for default.
		/// </summary>
		public uint LocaleId
		{
			get { return _LocaleId; }
			set { _LocaleId = ValidateLocalId(value); }
		}
		private uint _LocaleId = 0x0409u;

		/// <summary>
		/// This method is used to validate the selected LocalId.  
		/// It will default to 0x409 (US English) if not in the 
		/// supported list.  This method may be overridden if 
		/// an alternative validation is desired.
		/// </summary>
		/// <param name="localId"></param>
		/// <returns></returns>
		protected virtual uint ValidateLocalId(uint localId)
		{
			if (_LocaleIds.Contains(localId)) return localId;
			return 0x0409u;
		}

		/// <summary>
		/// This method is used to set the list of valid or supported 
		/// LocalId’s for the server.  This list is then used in the 
		/// validation of the LocalId.
		/// </summary>
		/// <param name="localIds"></param>
		public void SetSupportedLocals(List<uint> localIds)
		{
			// Do not allow an empty list.
			if (   (localIds != null)   
				&& (0 < localIds.Count))
				_LocaleIds = localIds;
		}
		private List<uint> _LocaleIds = new List<uint>() { 0x0409u };

		/// <summary>
		/// The negotiated timeout in milliseconds from the Resource Discover Initiate
		/// </summary>
		public TimeSpan ContextTimeout
		{
			get { return _ContextTimeout; }
			set { _ContextTimeout = ValidateTimeout(value); }
		}
		private TimeSpan _ContextTimeout = new TimeSpan(0, 10, 0);

		/// <summary>
		/// The implementation class may override this method to 
		/// validate an acceptable timeout for the server instance.
		/// </summary>
		/// <param name="value"></param>
		/// <returns></returns>
		protected virtual TimeSpan ValidateTimeout(TimeSpan value)
		{
			if (TimeSpan.Zero == value) return new TimeSpan(0, 10, 0);			// Default is 10 Minutes (a long time)
			if (new TimeSpan(0, 0, 9) > value) return new TimeSpan(0, 0, 9);	// The minimum timeout is nine seconds.
			if (new TimeSpan(0, 30, 0) < value) return new TimeSpan(0, 30, 0);	// The maximum timeout is 30 minutes.
			return value;
		}

		/// <summary>
		/// The last time the context was accessed.
		/// </summary>
		internal DateTime LastAccess
		{
			get { return _lastAccess; }
			set { _lastAccess = value; }
		}

		/// <summary>
		/// This method is invoked to determine if this context 
		/// instance has timed out.  And thus should be disposed.
		/// </summary>
		/// <param name="timeNow"></param>
		/// <returns></returns>
		internal bool CheckTimeout(DateTime timeNow)
		{
			return (timeNow - LastAccess) > ContextTimeout;
		}

		/// <summary>
		/// Invoke this method to set the valid endpoint for this context.
		/// </summary>
		/// <param name="listEndpointDefinitions"></param>
		public virtual void OnInitiate(List<EndpointDefinition> listEndpointDefinitions)
		{
			lock (ContextLock)
			{
				foreach (var ed in listEndpointDefinitions)
				{
					_XiEndpoints.Add(ed.EndpointId, new EndpointEntry<TList>(ed));
				}
			}
		}

		/// <summary>
		/// This validates the security credentials of the user each time the
		/// context is retrieved.  It should ensure the Paged credentials match
		/// the current transport security credentials.
		/// </summary>
		/// <param name="ctx">WCF operation context currently active</param>
		/// <returns>true/false</returns>
		public abstract bool ValidateSecurity(OperationContext ctx);
	}
}
