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
using System.Runtime.Serialization;

namespace Xi.Contracts.Data
{
	/// <summary>
	/// This class contains descriptive information about the server.   
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class ServerDetails
	{
		/// <summary>
		/// The time the server was last started.
		/// </summary>
		[DataMember] public DateTime StartTime;

		/// <summary>
		/// The build number of the server.
		/// </summary>
		[DataMember] public string BuildNumber;

		/// <summary>
		/// The version of the server.
		/// </summary>
		[DataMember] public string Version;

		/// <summary>
		/// Vendor-specific information about the server.
		/// </summary>
		[DataMember] public string VendorInfo;

	}
}
