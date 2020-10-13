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
using System.ServiceModel;
//using System.ServiceModel.Web;
using Xi.Contracts.Data;

namespace Xi.Contracts
{
	/// <summary>
	/// This interface is used to locate Xi servers on the network 
	/// and their Resource Management endpoints.  Servers that 
	/// implement this interface may apply access controls to limit 
	/// the servers a client may discover.  
	/// </summary>
	[ServiceContract(Namespace = "urn:xi/contracts")]
	public interface IServerDiscovery
	{
		/// <summary>
		/// This method returns the list of servers the client is 
		/// authorized to discover.
		/// </summary>
		/// <returns>
		/// List of server entries.
		/// </returns>
		//[OperationContract, WebGet]
		[OperationContract, FaultContract(typeof(XiFault))]
		List<ServerEntry> DiscoverServers();

		/// <summary>
		/// <para>This method is used to get the description of the 
		/// server.  It is intended to be used by Xi Directory Services 
		/// servers to identify an Xi server and obtain its list of 
		/// Mex endpoint names.</para>
		/// </summary>
		/// <returns>
		/// The description of the server. 
		/// </returns>
		[OperationContract, FaultContract(typeof(XiFault))]
		ServerEntry DiscoverServerInfo();

		/// <summary>
		/// This method returns an abbreviated set of endpoint definition parameters for 
		/// use by Silverlight clients and other clients that cannot use Metadata Exhange 
		/// to retrieve complete endpoint descriptions from the server.  Client 
		/// applications capable of using Metadata Exchange should not call this method.
		/// </summary>
		/// <returns>
		/// Returns a list of EndpointConfigurationEx objects, one for each endpoint 
		/// supported by the server.
		/// </returns>
		[OperationContract, FaultContract(typeof(XiFault))]
		List<EndpointConfigurationEx> DiscoverAbbreviatedEndpointInfo();
	}
}
