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
	/// This enumeration assigns a flag value to each of the Xi 
	/// features and then defines standard sets of features required  
	/// for all data, event, data journal, and event journal servers.  
	/// </summary>
	[Flags]
	public enum XiFeatures : ulong
	{
		/// <summary>
		/// The server supports custom data types.
		/// </summary>
		CustomDataType_Feature       = 0x01,

		/// <summary>
		/// The server supports the use of absolute deadband filters in 
		/// addition to the standard percent deadband filters.  Percent 
		/// deadband filters define the the percent of change relative 
		/// to the valid value range for a data object, while absolute 
		/// deadband defines the percentage of change relative to the 
		/// value (the range is not taken into account).
		/// </summary>
		AbsoluteDeadband_Feature     = 0x02,

		/// <summary>
		/// The server supports the capability to access individual elements 
		/// of arrays and structures. Individual elements are identified 
		/// using 0-based indexes for arrays and 1-based indexes for 
		/// structures.
		/// </summary>
		IndexedAccess_Feature        = 0x04,

		/// <summary>
		/// The server supports the capability to access a range of array 
		/// elements or fields of a structure. Ranges are identified using 
		/// a pair of indexes.
		/// </summary>
		IndexedRangeAccess_Feature   = 0x08,

		/// <summary>
		/// The server supports the capability to add the Standard MIB 
		/// Version number to a list.
		/// </summary>
		MibVersionSubscribe_Feature  = 0x10,

		/// <summary>
		/// The server supports the bufferingRate parameter of the 
		/// IResourceManagement.DefineList() method.
		/// </summary>
		BufferingRate_Feature        = 0x20,

	}
}
