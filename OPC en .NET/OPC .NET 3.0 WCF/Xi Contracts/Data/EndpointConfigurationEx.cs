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

using System.Runtime.Serialization;

namespace Xi.Contracts.Data
{
	/// <summary>
	/// <para>This class extends the EndpointConfiguration class. It is included to support Silverlight 
	/// clients and other clients that cannot use Metadata Exhange to retrieve complete service endpoint 
	/// descriptions from the server.</para>  
	/// <para>A list of EndpointConfigurationEx objects are returned by the IServerDiscovery.DiscoverEndpoints() 
	/// method. This method should not be called by client applications capable of using Metadata Exchange.</para>
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class EndpointConfigurationEx : EndpointConfiguration
	{
		/// <summary>
		/// Corresponds to "typeof(System.ServerModel.Description.ServiceEndpoint.Binding).ToString()" value 
		/// of the server endpoint.
		/// </summary>
		[DataMember] public string BindingType { get; set; }

		/// <summary>
		/// Corresponds to "System.ServerModel.Description.ServiceEndpoint.ListenUri.Scheme" value 
		/// of the server endpoint.
		/// </summary>
		[DataMember] public string BindingScheme { get; set; }

		/// <summary>
		/// Corresponds to "System.ServerModel.Description.ServiceEndpoint.Binding.Security.Mode" value 
		/// of the server endpoint.
		/// </summary>
		[DataMember] public string SecurityMode { get; set; }

		/// <summary>
		/// Corresponds to "System.ServerModel.Description.ServiceEndpoint.Binding.Security.Transport.ClientCredentialType.ToString()" 
		/// value f the server endpoint.
		/// </summary>
		[DataMember] public string ClientCredentialType { get; set; }
	}

}
