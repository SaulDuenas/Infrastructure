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

using Xi.Contracts.Data;

namespace Xi.Common.Support.Extensions
{
	/// <summary>
	/// 
	/// </summary>
	static public class DataValueArrayExt
	{
		/// <summary>
		/// Returns true if at least one value in the DataValueArrays
		/// </summary>
		/// <param name="valueArrays"></param>
		/// <returns></returns>
		public static bool HasDataValues(this DataValueArrays valueArrays)
		{
			return
				((null != valueArrays.DoubleStatusCodes && 0 < valueArrays.DoubleStatusCodes.Length)
				|| (null != valueArrays.UintStatusCodes && 0 < valueArrays.UintStatusCodes.Length)
				|| (null != valueArrays.ObjectStatusCodes && 0 < valueArrays.ObjectStatusCodes.Length));
		}

		public static int TotalValues(this DataValueArrays valueArrays)
		{
			int total = 0;
			if (null != valueArrays.DoubleStatusCodes)
				total += valueArrays.DoubleStatusCodes.Length;
			if (null != valueArrays.UintStatusCodes)
				total += valueArrays.UintStatusCodes.Length;
			if (null != valueArrays.ObjectStatusCodes)
				total += valueArrays.ObjectStatusCodes.Length;
			return total;
		}

		public static bool HasDoubleValues(this DataValueArrays valueArrays)
		{
			return (null != valueArrays.DoubleStatusCodes && 0 < valueArrays.DoubleStatusCodes.Length);
		}

		public static bool HasUintValues(this DataValueArrays valueArrays)
		{
			return (null != valueArrays.UintStatusCodes && 0 < valueArrays.UintStatusCodes.Length);
		}

		public static bool HasObjectValues(this DataValueArrays valueArrays)
		{
			return (null != valueArrays.ObjectStatusCodes && 0 < valueArrays.ObjectStatusCodes.Length);
		}

	}
}
