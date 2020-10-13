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
	/// This enumeration specifies how a list is sorted.
	/// The sort keys are defined by the list attributes.
	/// </summary>
	public enum SortType : ushort
	{
		/// <summary>
		/// The list is not sorted.
		/// </summary>
		NotSorted = 0,

		/// <summary>
		/// The list is sorted in ascending order.
		/// </summary>
		Ascending = 1,

		/// <summary>
		/// The list is sorted in descending order.
		/// </summary>
		Descending = 2,
	}
}
