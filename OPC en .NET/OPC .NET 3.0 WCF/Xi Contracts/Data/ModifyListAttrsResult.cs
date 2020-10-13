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
	/// This class contains list attributes that can be modified. 
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class ModifyListAttrsResult
	{
		/// <summary>
		/// The updated Update Rate.  Null if UpdateRate was not modified.
		/// </summary>
		[DataMember] public Nullable<uint> RevisedUpdateRate { get; set; }

		/// <summary>
		/// The updated Buffering Rate.  Null if BufferingRate was not modified.
		/// </summary>
		[DataMember] public Nullable<uint> RevisedBufferingeRate { get; set; }

		/// <summary>
		/// The updated FilterSet.  Null if FilterSet was not modified.
		/// </summary>
		[DataMember] public FilterSet RevisedFilterSet { get; set; }

	}
}
