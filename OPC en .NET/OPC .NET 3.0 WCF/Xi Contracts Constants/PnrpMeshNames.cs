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
using System.Text;

namespace Xi.Contracts.Constants
{
	/// <summary>
	/// This class defines standard mesh names used to register Xi Servers and 
	/// Xi Discovery Servers
	/// </summary>
	public class PnrpMeshNames
	{
		/// <summary>
		/// <para>The Peer TypeId Resolution Protocol (PNRP) standard peer name for the 
		/// mesh of Xi Directory Services.  The IServerDiscovery.DiscoverServers() 
		/// method supported by Xi Directory Services is used by clients to access 
		/// a list Xi Servers.</para>
		/// <para>Xi Directory Services maintain a list of Xi servers that it 
		/// discovers using PNRP XiDiscoveryServerMesh and/or other means. </para>
		/// </summary>
		public const string XiDiscoveryServerMesh = "XiDiscoveryServerMesh";

		/// <summary>
		/// The standard peer name for the mesh of Xi Servers.  This mesh is used 
		/// by Xi Directory Services to discover Xi servers that are capable of 
		/// registering themselves using the Peer TypeId Resolution Protocol (PNRP).
		/// </summary>
		public const string XiServerMesh = "XiServerMesh";
	}
}
