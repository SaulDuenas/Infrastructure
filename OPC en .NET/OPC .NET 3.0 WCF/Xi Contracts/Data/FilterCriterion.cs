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
using System.Diagnostics;
using System.Runtime.Serialization;

namespace Xi.Contracts.Data
{
	/// <summary>
	/// This class represents a single filter criterion in terms of an expression, 
	/// in which the operand is compared against a value using a comparison operator.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	[DebuggerDisplay("{Filter}")]
	[KnownType(typeof(EventType))]
	[KnownType(typeof(AlarmState))]
	[KnownType(typeof(DateTime))]
	[KnownType(typeof(InstanceId))]
	public class FilterCriterion
	{
		/// <summary>
		/// The name of the operand. Standard operand names are defined by the 
		/// FilterOperand class.  Non-standard operands and the data types for 
		/// their values are defined in the Standard MIB by the Event Message Fields 
		/// and History Properties supported by the server.
		/// </summary>
		[DataMember] public string OperandName { get; set; }

		/// <summary>
		/// The name of the operator. Standard operators are defined by the 
		/// FilterOperator enumeration.  Operator values between 0 and 
		/// UInt16.MaxValue are reserved.
		/// </summary>
		[DataMember] public uint Operator { get; set; }

		/// <summary>
		/// The comparison value.
		/// </summary>
		[DataMember] public object ComparisonValue { get; set; }

		/// <summary>
		/// This method compares this FilterCriterion against the filterToCompare 
		/// to determine if they are identical. Identical FilterCriterion are are those 
		/// with the same operand, operator, and comparison value.
		/// </summary>
		/// <param name="filterToCompare">
		/// The FilterCriterion to compare against this FilterCriterion.
		/// </param>
		/// <returns>
		/// Returns TRUE if the FilterCriterion are identical. Otherwise returns FALSE.
		/// </returns>
		public bool CompareIdentical(FilterCriterion filterToCompare)
		{
			if (filterToCompare == null)
				return false;
			if ((this.OperandName == null) && (filterToCompare.OperandName != null))
				return false;
			if ((this.OperandName != null) && (filterToCompare.OperandName == null))
				return false;
			if ((this.ComparisonValue == null) && (filterToCompare.ComparisonValue != null))
				return false;
			if ((this.ComparisonValue != null) && (filterToCompare.ComparisonValue == null))
				return false;

			// now check to see if the members are the same. If not, return false.
			if ((this.OperandName != filterToCompare.OperandName)
				|| (this.Operator != filterToCompare.Operator)
				|| (this.ComparisonValue != filterToCompare.ComparisonValue)
			   )
			{
				return false;
			}
			return true;
		}

	}
}
