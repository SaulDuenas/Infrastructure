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
	/// Standard sample types for historical data
	/// </summary>
	public class JournalDataSampleTypes
	{
		/// <summary>
		/// This is the Calculation LocalId for Raw Data Reads.
		/// </summary>
		public const uint RawDataSamples = 2000000001u;

		/// <summary>
		/// This is the Calculation LocalId for Specific Times.
		/// </summary>
		public const uint AtTimeDataSamples = 2000000002u;

		/// <summary>
		/// This is the Calculation LocalId for Changed Samples.
		/// </summary>
		public const uint ChangedDataSamples = 2000000003u;

		/// <summary>
		/// Values equal to or greater than this value for Calculation LocalId are undefined.
		/// They are reserved to indicated that the Calculation LocalId has not beeen set.
		/// value should be considered reserved.
		/// </summary>
		public const uint DataSampleTypeUndefined = 2200000000u;

	}
}
