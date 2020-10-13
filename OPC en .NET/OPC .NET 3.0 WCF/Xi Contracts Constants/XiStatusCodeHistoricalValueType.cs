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
	/// The HistoricalValueType is a 3-bit property that describes the 
	/// the historical data value associated with the Status Code.  
	/// </summary>
	public enum XiStatusCodeHistoricalValueType
	{
		/// <summary>
		/// The historical value type is not used. 
		/// </summary>
		NotUsed                = 0,

		/// <summary>
		/// The value is the raw value.
		/// </summary>
		RawValue               = 1,

		/// <summary>
		/// No value exists in the journal for the requested data object 
		/// that meets the specified selection criteria.
		/// </summary>
		NoValue                = 2,

		/// <summary>
		/// More than one value exists at same timestamp. 
		/// </summary>
		ExtraValue             = 3,

		/// <summary>
		/// Collection started / stopped / lost.
		/// </summary>
		LostValue              = 4,

		/// <summary>
		/// The value has been interpolated.
		/// </summary>
		InterpolatedValue      = 5,

		/// <summary>
		/// The value has been calculated.
		/// </summary>
		CalculatedValue        = 6,

		/// <summary>
		/// The value is a calculated value for an incomplete interval.
		/// </summary>
		PartialCalculatedValue = 7,

	}
}
