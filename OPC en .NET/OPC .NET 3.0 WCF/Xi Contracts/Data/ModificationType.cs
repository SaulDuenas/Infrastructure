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
	/// This enumeration identifies the type of modification to 
	/// perform for a given journal entry.  For the Insert, 
	/// Replace, and Insert/Replace, the server receives a new  
	/// journal entry, and attempts to locate a journal entry 
	/// for the same data object with the same timestamp, or for 
	/// the same event based on the event id.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public enum ModificationType : uint
	{
		/// <summary>
		/// Inserts a new entry in the journal in timestamp order. 
		/// </summary>
		[EnumMember] Insert = 1,

		/// <summary>
		/// Replaces an existing entry in the journal.
		/// </summary>
		[EnumMember] Replace = 2,

		/// <summary>
		/// Replaces an existing entry in the journal if it exists,
		/// and inserts a new entry in timestamp order if it does 
		/// not exist.
		/// </summary>
		[EnumMember] InsertReplace = 3,

		/// <summary>
		/// Deletes an existing entry from the journal.
		/// </summary>
		[EnumMember] Delete = 4

	}
}
