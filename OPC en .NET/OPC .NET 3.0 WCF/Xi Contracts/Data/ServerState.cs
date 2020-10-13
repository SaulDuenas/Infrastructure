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
	/// This enumeration defines the standard server state values.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public enum ServerState
	{
		/// <summary>
		/// The server is operational - this is the normal running state for a server
		/// </summary>
		[EnumMember] Operational = 0,

		/// <summary>
		/// The server is running, but in diagonstics mode.
		/// </summary>
		[EnumMember] Diagnostics = 1,

		/// <summary>
		/// The server is not operational because it is starting up.
		/// </summary>
		[EnumMember] Initializing = 2,

		/// <summary>
		/// The server is not operational due to a fault.
		/// </summary>
		[EnumMember] Faulted = 3,

		/// <summary>
		/// The server is not operational because it has not been configured.
		/// </summary>
		[EnumMember] NeedsConfiguration = 4,

		/// <summary>
		/// The server is not operational because it has been taken out 
		/// of service.
		/// </summary>
		[EnumMember] OutOfService = 5,

		/// <summary>
		/// The server is not operational because it is not connected to 
		/// its underlying system/devices.
		/// </summary>
		[EnumMember] NotConnected = 6,

		/// <summary>
		/// The server is operational but it is shutting down and aborting 
		/// all of its client contexts.
		/// </summary>
		[EnumMember] Aborting = 7,

		/// <summary>
		/// The server is not operational, but the reason is not known.
		/// </summary>
		[EnumMember] NotOperational = 8,
	}
}
