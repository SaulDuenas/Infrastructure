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
using System.ServiceModel;

using Xi.Contracts.Data;

namespace Xi.Server.Base
{
	/// <summary>
	/// An instance of this class is used to hold the associations between an endpoint 
	/// and an Xi List.  A Xi List must be associated with the proper type of end point 
	/// for the actions associated with the endpoint to be performed on the Xi List.  
	/// For example an "Write" can not be performed on elements of an Xi List unless 
	/// that list is associated with the "IWrite" endpoint.  Each instance of this class 
	/// is associated with an EndpointDefinition.
	/// </summary>
	/// <typeparam name="TList"></typeparam>
	public class EndpointEntry<TList> : IDisposable
							where TList : ListRoot
	{
		public List<TList> XiLists { get { return _XiLists; } }
		/// <summary>
		/// List of Xi Lists associated with this EndpointDefinition.
		/// </summary>
		private readonly List<TList> _XiLists = new List<TList>();

		/// <summary>
		/// Constructor used to create an instance of this class allowing for the 
		/// association between Xi Lists and Endpoint Definitions.
		/// </summary>
		/// <param name="endpointDefinition">
		/// The Endpoint Definition this instance of Endpoint Entry to which 
		/// the Xi Lists will be associated.
		/// </param>
		public EndpointEntry(EndpointDefinition endpointDefinition)
		{
			_endpointDefinition = endpointDefinition;
			IsOpen = false;
			WcfChannel = null;
		}

		/// <summary>
		/// This property returns true if this endpoint is open and ready for use 
		/// and false if the endpoint has not been opened or has been closed.
		/// </summary>
		public bool IsOpen
		{
			get { return _isOpen; }
			set { _isOpen = value; }
		}
		private bool _isOpen = false;

		/// <summary>
		/// Attribute providing the Endpoint Definition for this instance.
		/// </summary>
		public EndpointDefinition EndpointDefinition { get { return _endpointDefinition; } }
		private EndpointDefinition _endpointDefinition;

		/// <summary>
		/// Attribute providing the wcf channel used to communicate with the client
		/// </summary>
		public ICommunicationObject WcfChannel { get { return _wcfChannel; } set { _wcfChannel = value; } }
		private ICommunicationObject _wcfChannel;

		/// <summary>
		/// Attribute providing the wcf channel used to communicate with the client
		/// </summary>
		public string ClientIpAddress { get { return _clientIpAddress; } set { _clientIpAddress = value; } }
		private string _clientIpAddress;

		/// <summary>
		/// Attribute providing the Operation Context Session Id
		/// </summary>
		public string SessionId { get { return _sessionId; } set { _sessionId = value; } }
		private string _sessionId;

		/// <summary>
		/// see IDisposable interface.
		/// </summary>
		public void Dispose()
		{
			OnCloseEndpoint();
		}

		/// <summary>
		/// This method is invoked to associate a Xi List with an endpoint.
		/// </summary>
		/// <param name="listToAdd">
		/// The Xi List to be associated with the endpoint managed by this instance.
		/// </param>
		public void OnAddListToEndpoint(TList listToAdd)
		{
			_XiLists.Add(listToAdd);
		}

		/// <summary>
		/// This method is invoked to remove a Xi List association from an endpoint.
		/// </summary>
		/// <param name="listToRemove">
		/// The Xi List to be removed from this endpoint entry.
		/// </param>
		public void OnRemoveListFromEndpoint(TList listToRemove)
		{
			_XiLists.Remove(listToRemove);
		}

		/// <summary>
		/// Remove all associations between this endpoint and the lists.
		/// </summary>
		public void OnCloseEndpoint()
		{
			foreach (var xiList in _XiLists)
			{
				xiList.RemoveEndpointReference(this as EndpointEntry<ListRoot>);
			}
			_XiLists.Clear();
			IsOpen = false;
		}
	}
}
