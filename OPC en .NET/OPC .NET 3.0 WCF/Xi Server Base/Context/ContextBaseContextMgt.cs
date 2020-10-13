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
using System.ServiceModel;

using Xi.Contracts.Constants;
using Xi.Common.Support;
using Xi.Common.Support.Extensions;

namespace Xi.Server.Base
{
	/// <summary>
	/// This partial class defines the methods to be overridden by the server implementation 
	/// to support the Context Management methods of the IResourceManagement interface.
	/// </summary>
	public abstract partial class ContextBase<TList>
		where TList : ListRoot
	{
		/// <summary>
		/// This method is to be overridden by the context implementation in the 
		/// Server Implementation project.
		/// </summary>
		/// <param name="negotiatedContextOptions"></param>
		/// <param name="reInitiateKey"></param>
		public void OnReInitiate(bool allowDifferentClientIpAddress, uint negotiatedContextOptions, ref string reInitiateKey)
		{
			lock (ContextLock)
			{
				if (ReInitiateKey == null) // Not having an existing ReInitiateKey is an error
				{
					LastAccess = DateTime.Now - ContextTimeout; // set last access back so it will timeout
					throw FaultHelpers.Create(XiFaultCodes.E_NOCONTEXT);
				}
				// otherwise if the reInitiateKey parameter doesn't match the ReIniitateKey of the context
				else if (   (reInitiateKey == null)
						 || (string.Compare(reInitiateKey, ReInitiateKey, false) != 0))
				{
					throw FaultHelpers.Create(XiFaultCodes.E_BADARGUMENT);
				}

				// Validate OperationContext 
				if (OperationContext.Current == null)
					throw FaultHelpers.Create(XiFaultCodes.E_INVALIDREQUEST, "No OperationsContext");

				// No security?
				if (OperationContext.Current.ServiceSecurityContext == null)
					throw FaultHelpers.Create(XiFaultCodes.E_INVALIDREQUEST, "No ServiceSecurityContext");

				// Different user name?
				if (OperationContext.Current.ServiceSecurityContext.PrimaryIdentity.Name != Identity.Name)
					throw FaultHelpers.Create(XiFaultCodes.E_INVALIDREQUEST, "Different User");

				if (allowDifferentClientIpAddress == false) // if the client connection must originate on the same machine as the last
				{
					// Different client IP Address?
					string clientIpAddress = null; // The ip address used to send the current request.
					int clientPort = -1;
					OperationContext.Current.GetRemoteAddress(out clientIpAddress, out clientPort);

					if (string.Compare(_connectedResourceManagementEndpoint.ClientIpAddress, clientIpAddress) != 0)
					{
						throw FaultHelpers.Create(XiFaultCodes.E_INVALIDREQUEST, "Invalid IP Address");
					}
				}

				_NegotiatedContextOptions = negotiatedContextOptions;

				// call implementation-specific processing
				OnReInitiate(OperationContext.Current);
			}
		}

		/// <summary>
		/// This method is to be overridden by the context implementation in the 
		/// Server Implementation project.
		/// </summary>
		public virtual void OnReInitiate(OperationContext ctx)
		{
			// TODO - Implement an override of the OnReInitiate method for any additional processing associated with OnReInitiate();
		}

		/// <summary>
		/// This method is to be overridden by the context implementation in the 
		/// Server Implementation project. This method is invoked when the context times-out.
		/// </summary>
		public abstract void OnClientKeepAlive();

		public void CloseEndpointConnections()
		{
			if ((_connectedResourceManagementEndpoint != null) && (_connectedResourceManagementEndpoint.WcfChannel != null))
			{
				try { ChannelCloser.Close(_connectedResourceManagementEndpoint.WcfChannel); }
				catch { }
				_connectedResourceManagementEndpoint.WcfChannel = null;
				_connectedResourceManagementEndpoint.Dispose();
				_connectedResourceManagementEndpoint = null;
			}

			if ((_iRegisterForCallbackEndpointEntry != null) && (_iRegisterForCallbackEndpointEntry.WcfChannel != null))
			{
				try { ChannelCloser.Close(_iRegisterForCallbackEndpointEntry.WcfChannel); }
				catch { }
				_iRegisterForCallbackEndpointEntry.WcfChannel = null;
				_iRegisterForCallbackEndpointEntry.Dispose();
				_iRegisterForCallbackEndpointEntry = null;
			}

			foreach (var ep in this._XiEndpoints)
			{
				if (ep.Value.WcfChannel != null)
				{
					try { ChannelCloser.Close(ep.Value.WcfChannel); }
					catch { }
					ep.Value.WcfChannel = null;
					ep.Value.Dispose();
				}
			}
			_XiEndpoints.Clear();
		}

		/// <summary>
		/// This method validates that a Read, Write, Poll, or RegisterForCallback endpoint can be used.
		/// </summary>
		/// <param name="endpointEntry">The endpoint entry for the Read, Write, Poll, or RegisterForCallback endpoint.</param>
		public void AuthorizeEndpointUse(EndpointEntry<TList> endpointEntry)
		{
			bool success = false;
			string clientIpAddress = null; // The ip address used to send the current request.
			int clientPort = -1;
			OperationContext.Current.GetRemoteAddress(out clientIpAddress, out clientPort);

			if (endpointEntry != null)
			{
				if (endpointEntry.WcfChannel == null) // The WcfChannel will be null for read, write, and poll endpoints the first time through
				{
					if (string.Compare(_connectedResourceManagementEndpoint.ClientIpAddress, clientIpAddress) == 0)
					{
						endpointEntry.IsOpen = true;
						endpointEntry.WcfChannel = OperationContext.Current.Channel;
						endpointEntry.SessionId = OperationContext.Current.SessionId;
						endpointEntry.ClientIpAddress = clientIpAddress;
						success = true;
					}
				}
				else if (clientIpAddress == endpointEntry.ClientIpAddress)
				{
					// if a new session after recovery
					if (endpointEntry.SessionId != OperationContext.Current.SessionId)
					{
						endpointEntry.WcfChannel = OperationContext.Current.Channel;
						endpointEntry.SessionId = OperationContext.Current.SessionId;
					}
					success = true;
				}
			}
			if (success == false)
			{
				// TODO:  Log the authorization failure in the AuthorizeEndpointUse() method
				ChannelCloser.Close(OperationContext.Current.Channel);
			}
		}

	}
}
