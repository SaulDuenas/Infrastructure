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

using System.Diagnostics;
using System.Runtime.Serialization;

namespace Xi.Contracts.Data
{
	/// <summary>
	/// <para>This class is used to return the definition of an endpoint 
	/// exposed by the server.</para>
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	[DebuggerDisplay("{Url}")]
	public class EndpointDefinition
	{
		#region Server Local Data Members

		/// <summary>
		/// This member is used locally by the server. It is not serialized and sent to the client.
		/// </summary>
		public System.ServiceModel.Description.ServiceEndpoint EndpointDescription;

		#endregion // Server Local Data Members

		#region Data Members

		/// <summary>
		/// The EndpointId is used to uniquely identify this endpoint definition. 
		/// This identifier is assigned by the server.
		/// </summary>
		[DataMember] public string EndpointId { get; set; }

		/// <summary>
		/// The type of the Xi interface supported by the endpoint.  Values are 
		/// defined using the typeof(IXXX).Name property, where IXXX is the contract 
		/// name (e.g. IRead, IWrite).  This value is also used as the value for the 
		/// Name property of the System.ServiceModel.Description.ServiceEndpoint.Contract 
		/// member.  
		/// </summary>
		[DataMember] public string ContractType { get; set; }

		/// <summary>
		/// <para>The type of the binding (WSHttpBinding, NetTcpBinding, etc.) 
		/// as defined in the config.app file.  For standard bindings,
		/// this is the endpoint binding attribute:</para>
		/// <para>  endpoint binding="wsHttpBinding"</para> 
		/// For custom bindings, this is the name attribute of the binding 
		/// element of the custom binding:
		/// <para>  binding name="binaryHttpBinding" </para>
		/// </summary>
		[DataMember] public string BindingName { get; set; }

		/// <summary>
		/// The URL used to access the endpoint
		/// </summary>
		[DataMember] public string Url { get; set; }
		#endregion

		#region ToString Override
		/// <summary>
		/// This method represents the endpoint as a string using 
		/// its URL.
		/// </summary>
		/// <returns>
		/// The URL of the endpoint.
		/// </returns>
		public override string ToString()
		{
			return Url + " for " + ContractType;
		}
		#endregion
	}
}
