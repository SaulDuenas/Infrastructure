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
	/// This class is used to specify a data object to write and the 
	/// value to write.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class WriteJournalValues
	{
		/// <summary>
		/// Identifies the list that contains the data objects 
		/// to write.
		/// </summary>
		[DataMember] public uint ListAlias { get; set; }

		/// <summary>
		/// The list of data object values to write. Each data object 
		/// is identified by its server alias. When used to write 
		/// historical values using the WriteJournalData() method, 
		/// the timestamp is used to identify a specific journal 
		/// entry for the data object.
		/// </summary>
		[DataMember] public DataValueArraysWithAlias HistoricalValues { get; set; }
	}
}
