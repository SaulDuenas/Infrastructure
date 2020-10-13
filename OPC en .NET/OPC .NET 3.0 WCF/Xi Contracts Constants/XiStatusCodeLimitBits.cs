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

namespace Xi.Contracts.Constants
{
	/// <summary>
	/// The Limit bits indicates whether a value is liimited or not.
	/// It is valid regardless of the values of the StatusBits and SubstatusBits. 
	/// </summary>
	public enum XiStatusCodeLimitBits
	{
		/// <summary>
		/// The value is free to move up or down. This value is 
		/// used as the default value when the limit bits do not apply.
		/// </summary>
		NotLimited  = 0,

		/// <summary>
		/// The value has ‘pegged’ at some lower limit and 
		/// cannot move any lower.
		/// </summary>
		LowLimited  = 1,

		/// <summary>
		/// The value has ‘pegged’ at some high limit and 
		/// cannot move any higher.
		/// </summary>
		HighLimited = 2,

		/// <summary>
		/// The value is a constant and cannot move.
		/// </summary>
		Constant    = 3,
	}
}
