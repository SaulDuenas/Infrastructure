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
	/// This enumeration defines the standard operators that can be used in 
	/// filters to compare an operand with a value.
	/// </summary>
	public class FilterOperator
	{
		/// <summary>
		/// Equals.
		/// </summary>
		public const uint Equal               = 1;

		/// <summary>
		/// Less than.
		/// </summary>
		public const uint LessThan            = 2;

		/// <summary>
		/// Less than or equals.
		/// </summary>
		public const uint LessThanOrEqual     = 3;

		/// <summary>
		/// Greater than.
		/// </summary>
		public const uint GreaterThan         = 4;

		/// <summary>
		/// Greater than or equals.
		/// </summary>
		public const uint GreaterThanOrEqual  = 5;

		/// <summary>
		/// Not equals.
		/// </summary>
		public const uint NotEqual            = 6;

		/// <summary>
		/// This method converts a standard filter operator to a string.
		/// </summary>
		/// <param name="filterOperator">
		/// The filter operator to convert.
		/// </param>
		/// <returns>The string representation of the filter operator.</returns>
		public static string ToString(uint filterOperator)
		{
			switch (filterOperator)
			{
				case FilterOperator.Equal:
					return " == ";
				case FilterOperator.LessThan:
					return " < ";
				case FilterOperator.LessThanOrEqual:
					return " <= ";
				case FilterOperator.GreaterThan:
					return " > ";
				case FilterOperator.GreaterThanOrEqual:
					return " >= ";
				case FilterOperator.NotEqual:
					return " != ";
				default :
					return "?#?";
			}
		}
	}
}
