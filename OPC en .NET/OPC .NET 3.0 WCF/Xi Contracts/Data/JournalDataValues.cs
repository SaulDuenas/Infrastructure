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
	/// This class is used to return requested historical data values or 
	/// historical attribute values to the client.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class JournalDataValues
	{
		/// <summary>
		/// The Result Code being returned for the associated data 
		/// object identified by the ClientAlias and ServerAlias.
		/// </summary>
		[DataMember] public uint ResultCode { get; set; }

		/// <summary>
		/// The overall Error Info associated with this ResultCode,
		/// or null if there is no additional error information.
		/// </summary>
		[DataMember] public ErrorInfo ErrorInfo { get; set; }

		/// <summary>
		/// When used in a read context (returned from the server) 
		/// this is the Client Alias.  When used in a write context 
		/// (sent to the server) this is the Server Alias.
		/// </summary>
		[DataMember] public uint ClientAlias { get; set; }

		/// <summary>
		/// The calculation used to derive these Historical Values
		/// </summary>
		[DataMember] public TypeId Calculation { get; set; }

		/// <summary>
		/// The servers start time for the response values.
		/// </summary>
		[DataMember] public DateTime StartTime { get; set; }

		/// <summary>
		/// The servers end time for the response values.
		/// </summary>
		[DataMember] public DateTime EndTime { get; set; }

		/// <summary>
		/// The list of requested history values if the Result Code indicates success; otherwise null.
		/// </summary>
		[DataMember] public DataValueArrays HistoricalValues { get; set; }

	}
}
