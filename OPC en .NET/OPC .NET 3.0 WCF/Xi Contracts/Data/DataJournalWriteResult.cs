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
	/// Result from a data journal write request
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class DataJournalWriteResult
	{
		/// <summary>
		/// Result code for the corresponding WriteJournalValues entry.
		/// </summary>
		[DataMember] public uint ResultCode { get; set; }

		/// <summary>
		/// List alias
		/// </summary>
		[DataMember] public uint ListAlias { get; set; }

		/// <summary>
		/// Server data alias
		/// </summary>
		[DataMember] public uint ServerDataAlias { get; set; }
	}
}
