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
using System.Linq;
using System.Collections.Generic;
using System.ServiceModel;

using Xi.Common.Support;
using Xi.Contracts;
using Xi.Contracts.Constants;
using Xi.Contracts.Data;

namespace Xi.Server.Base
{
	/// <summary>
	/// This partial class defines the methods that support the methods 
	/// of the ICallback interface.
	/// </summary>
	public abstract partial class ContextBase<TList>
		where TList : ListRoot
	{
		/// <summary>
		/// Indicates, when TRUE, that the Callback endpoint is open
		/// </summary>
		public bool CallbackEndpointOpen { get { return (null != _iCallback); } }
		private ICallback _iCallback = null;

		/// <summary>
		/// Indicates, when TRUE, that the Poll endpoint is open
		/// </summary>
		public bool PollEndpointOpen { get { return _iPollEndpointEntry != null; } }
		public EndpointEntry<TList> IPollEndpointEntry { get { return _iPollEndpointEntry; } }
		protected EndpointEntry<TList> _iPollEndpointEntry;

		public EndpointEntry<TList> IRegisterForCallbackEndpointEntry { get { return _iRegisterForCallbackEndpointEntry; } }
		protected EndpointEntry<TList> _iRegisterForCallbackEndpointEntry;

		protected uint _keepAliveSkipCount;

		/// <summary>
		/// The time of the completion of the last callback sent on this context. 
		/// The value is not set until the callback call returns.
		/// </summary>
		public DateTime LastCallbackTime { get { return _lastCallbackTime; } }
		protected DateTime _lastCallbackTime;

		/// <summary>
		/// The time interval for keep-alive callbacks
		/// </summary>
		public TimeSpan CallbackRate { get { return _callbackRate; } }
		protected TimeSpan _callbackRate;

		/// <summary>
		/// This method is used to indicate to the client that the Xi Server is shutting down. 
		/// </summary>
		/// <param name="reason"></param>
		public void OnAbort(ServerStatus serverStatus, string reason)
		{
			ICallback iCallback = null;
			lock (ContextLock)
			{
				if (null == _iCallback)
					return;
				iCallback = _iCallback;
			}

			try
			{
				if (null != iCallback)
				{
					iCallback.Abort(Id, serverStatus, reason);
				}
			}
			catch { }
		}

		/// <summary>
		/// This method invokes an Information Report back to the Xi client for data changes.
		/// </summary>
		/// <param name="listId"></param>
		/// <param name="updatedValues"></param>
		public virtual void OnInformationReport(uint listId, DataValueArraysWithAlias readValueList)
		{
			ICallback iCallback = null;
			lock (ContextLock)
			{
				if (null == _iCallback)
					return;
				iCallback = _iCallback;
			}

			try
			{
				if (null != iCallback)
				{
					iCallback.InformationReport(Id, listId, readValueList);
					_lastCallbackTime = DateTime.UtcNow;
				}
			}
			catch (Exception ex)
			{
				exMsg1 = ex.Message;
			}
		}
		private static string exMsg1;

		/// <summary>
		/// This method invokes an Event Notification back to the Xi client when an event needs to be reported.
		/// </summary>
		/// <param name="listId"></param>
		/// <param name="eventList"></param>
		public virtual void OnEventNotification(uint listId, EventMessage[] eventsArray)
		{
			ICallback iCallback = null;
			lock (ContextLock)
			{
				if (null == _iCallback)
					return;
				iCallback = _iCallback;
			}

			try
			{
				if (null != iCallback)
				{
					iCallback.EventNotification(Id, listId, eventsArray);
					_lastCallbackTime = DateTime.UtcNow;
				}
			}
			catch (Exception ex)
			{
				exMsg2 = ex.Message;
			}
		}
		private static string exMsg2;

		/// <summary>
		/// This method is invoked by a Xi client to establish the clients ICallback interface.
		/// </summary>
		/// <param name="iCallBack">
		/// The reference to the callback to set.
		/// </param>
		/// <param name="keepAliveSkipCount">
		/// The number of consecutive UpdateRate cycles that occur with nothing to send before 
		/// an empty callback is sent to indicate a keep-alive message. For example, if the value 
		/// of this parameter is 1, then a keep-alive callback will be sent each UpdateRate cycle 
		/// for which there is nothing to send. A value of 0 indicates that keep-alives are not 
		/// to be sent.
		/// </param>
		/// <param name="callbackRate">
		/// <para>Optional rate that specifies how often callbacks are to be sent to the client. </para> 
		/// </para>TimeSpan.Zero if not used. When not used, the UpdateRate of the lists assigned to this 
		/// callback dictates when callbacks are sent.  </para>
		/// <para>When present, the server buffers list outputs when the callback rate is longer 
		/// than list UpdateRates.  </para>
		/// </param>
		/// <returns>
		/// The results of the operation, including the negotiated keep-alive skip count and callback rate.
		/// </returns>
		public SetCallbackResult OnSetCallback(ICallback iCallBack,
			uint keepAliveSkipCount, TimeSpan callbackRate)
		{
			lock (ContextLock)
			{
				_iCallback = iCallBack;

				if (_iRegisterForCallbackEndpointEntry == null)
				{
					OperationContext ctx = OperationContext.Current;
					List<EndpointDefinition> epDefs =
						(from ep in ServerRoot.ServiceHost.Description.Endpoints
						 where ep.Contract.Name.EndsWith(typeof(IRegisterForCallback).Name)
							&& ep.Address.Uri.OriginalString == ctx.Channel.LocalAddress.Uri.OriginalString
						 select new EndpointDefinition
						 {
							 EndpointId = Guid.NewGuid().ToString(),
							 BindingName = ep.Binding.Name,
							 ContractType = ep.Contract.Name,
							 Url = ep.Address.Uri.AbsoluteUri,
							 EndpointDescription = ep,
						 }
						).ToList<EndpointDefinition>();

					if ((epDefs == null) || (epDefs.Count == 0))
						throw FaultHelpers.Create("Unable to locate connected IRegisterForCallback Endpoint");

					lock (ContextLock)
					{
						_iRegisterForCallbackEndpointEntry = new EndpointEntry<TList>(epDefs[0]);
					}

					AuthorizeEndpointUse(_iRegisterForCallbackEndpointEntry);
				}

				return OnNegotiateCallbackParams(keepAliveSkipCount, callbackRate);
			}
		}

		/// <summary>
		/// This method can be overriddent by the implementation class to negotitate the 
		/// keep-alive skip count and the callback rate. 
		/// </summary>
		/// <param name="keepAliveSkipCount">
		/// The number of consecutive UpdateRate cycles that occur with nothing to send before 
		/// an empty callback is sent to indicate a keep-alive message. For example, if the value 
		/// of this parameter is 1, then a keep-alive callback will be sent each UpdateRate cycle 
		/// for which there is nothing to send. A value of 0 indicates that keep-alives are not 
		/// to be sent.
		/// </param>
		/// <returns>
		/// The results of the operation, including the negotiated keep-alive skip count and callback rate.
		/// </returns>
		public virtual SetCallbackResult OnNegotiateCallbackParams(uint keepAliveSkipCount, TimeSpan callbackRate)
		{
			lock (ContextLock)
			{
				_keepAliveSkipCount = 0; // Per-list keep-alives are not supported

				// Set the callback rate (the keep-alive rate) to between 5 seconds and one minute
				if (callbackRate.TotalMilliseconds < 5000)
					_callbackRate = new TimeSpan(0, 0, 0, 0, 5000);
				else if (callbackRate.TotalMilliseconds > 60000)
					_callbackRate = new TimeSpan(0, 0, 0, 0, 60000);
				else
					_callbackRate = callbackRate;
				return new SetCallbackResult(XiFaultCodes.S_OK,
					_keepAliveSkipCount, _callbackRate);
			}

		}

		/// <summary>
		/// Invoke this method to stop callbacks by letting the callback interface go.
		/// </summary>
		/// <returns></returns>
		public virtual uint OnClearCallback()
		{
			lock (ContextLock)
			{
				_iCallback = null;
				return XiFaultCodes.S_OK;
			}
		}
	}
}
