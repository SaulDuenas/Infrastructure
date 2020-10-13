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
	/// This class defines an element of a string table.  
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class StringTableEntry
	{
		/// <summary>
		/// The index of the element.
		/// </summary>
		[DataMember] public int Index { get; set; }

		/// <summary>
		/// The string associated with the index.
		/// </summary>
		[DataMember] public string StringValue { get; set; }
	}
}
