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

using System.Collections.Generic;
using System.Runtime.Serialization;

namespace Xi.Contracts.Data
{
	/// <summary>
	/// This class defines the resource management endpoints of a server.  
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class ServerEntry
	{
		/// <summary>
		/// The description of the server.
		/// </summary>
		[DataMember] public ServerDescription ServerDescription { get; set; }

		/// <summary>
		/// The names of available metaDataExchange endpoints.
		/// These names can only be used as a selection choice for the client.
		/// The Mex endpoint communication settings must be standardized.
		/// </summary>
		[DataMember] public List<MexEndpointInfo> MexEndpoints { get; set; }

		/// <summary>
		/// Endpoint configuration settings that are not in the endpoint metadata.
		/// </summary>
		[DataMember] public List<EndpointConfiguration> EndpointServerSettings { get; set; }
	}
}
