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
	/// This enumeration specifies the standard types of lists.
	/// The enumerated values between 0 and 4095 inclusive are reserved 
	/// for standard types.
	/// </summary>
	public enum StandardListType
	{
		/// <summary>
		/// The type of list that contains data objects.
		/// </summary>
		DataList         = 1,

		/// <summary>
		/// The type of list that contains historical data objects.
		/// </summary>
		DataJournalList  = 2,

		/// <summary>
		/// The type of list that contains alarms and events.
		/// </summary>
		EventList        = 3,

		/// <summary>
		/// The type of list that contains historical alarms and events.
		/// </summary>
		EventJournalList = 4,
	}
}
