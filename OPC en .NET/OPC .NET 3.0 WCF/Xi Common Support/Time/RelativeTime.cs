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

namespace Xi.Common.Support
{
	/// <summary>
	/// Possible base or offset types for relative times.
	/// </summary>
	public enum RelativeTime
	{
		/// <summary>
		/// Start from the current time.
		/// </summary>
		Now,

		/// <summary>
		/// The start of the current second or an offset in seconds.
		/// </summary>
		Second,

		/// <summary>
		/// The start of the current minutes or an offset in minutes.
		/// </summary>
		Minute,

		/// <summary>
		/// The start of the current hour or an offset in hours.
		/// </summary>
		Hour,

		/// <summary>
		/// The start of the current day or an offset in days.
		/// </summary>
		Day,

		/// <summary>
		/// The start of the current week or an offset in weeks.
		/// </summary>
		Week,

		/// <summary>
		/// The start of the current month or an offset in months.
		/// </summary>
		Month,

		/// <summary>
		/// The start of the current year or an offset in years.
		/// </summary>
		Year
	}
}
