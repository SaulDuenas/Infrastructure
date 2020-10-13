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
	/// This class contains dynamic information about the server.   
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class ServerStatus
	{
		/// <summary>
		/// The name of the Xi server or wrapped server. For the Xi server, 
		/// this is the ServerName contained in the ServerDescription object.  
		/// For wrapped OPC COM servers, the Prog Id of the server.
		/// </summary>
		[DataMember] public string ServerName;

		/// <summary>
		/// The type of the server for which the status is being reported.
		/// The Xi.Contracts.Constants.ServerType enumeration is used to 
		/// identify the type of the server. 
		/// </summary>
		[DataMember] public uint ServerType;

		/// <summary>
		/// The current time in the server.
		/// </summary>
		[DataMember] public DateTime CurrentTime;

		/// <summary>
		/// The current state of the server.
		/// </summary>
		[DataMember] public ServerState ServerState;

		/// <summary>
		/// Text string specific to the current state of the server.
		/// for example, when the server state is aborting, this string contains the reason.
		/// </summary>
		[DataMember] public string Info;

	}
}
