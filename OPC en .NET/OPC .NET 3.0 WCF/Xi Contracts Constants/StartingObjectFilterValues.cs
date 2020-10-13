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

namespace Xi.Contracts.Constants
{
	/// <summary>
	/// This enumeration defines the valid values for the StartingObjectAttributes 
	/// filter operand.  All values for this operand are passed in FilterCriterion as 
	/// integers.
	/// </summary>
	public enum StartingObjectFilterValues
	{
		/// <summary>
		/// A valid FilterOperand.StartingObjectAttributes value.
		/// This value is used to specify that the server is to return 
		/// ObjectAttributes only for the object identified by the starting 
		/// path.
		/// </summary>
		StartingObjectOnly = 1,

		/// <summary>
		/// A valid FilterOperand.StartingObjectAttributes value.
		/// This value is used to specify that the server is to return 
		/// ObjectAttributes for the object identified by the starting 
		/// path AND for the objects found below it.
		/// </summary>
		AllObjects         = 2,
	}
}
