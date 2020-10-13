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
	public static class StdMibExt
	{
		public static bool SupportsDataLists(this StandardMib stdMib)
		{
			if (null == stdMib) return false;
			return (0 != (stdMib.MethodsSupported 
				& ((ulong)(XiMethods.IRead_ReadData
					| XiMethods.IWrite_WriteValues
					| XiMethods.IPoll_PollDataChanges
					| XiMethods.ICallback_InformationReport))));
		}

		public static bool SupportsDataJournalLists(this StandardMib stdMib)
		{
			if (null == stdMib) return false;
			return (0 != (stdMib.MethodsSupported
				& ((ulong)(XiMethods.IRead_ReadJournalDataForTimeInterval
					| XiMethods.IRead_ReadJournalDataAtSpecificTimes
					| XiMethods.IRead_ReadJournalDataChanges
					| XiMethods.IRead_ReadCalculatedJournalData
					| XiMethods.IRead_ReadJournalDataProperties))));
		}

		public static bool SupportsEventLists(this StandardMib stdMib)
		{
			if (null == stdMib) return false;
			return (0 != (stdMib.MethodsSupported
				& ((ulong)(XiMethods.ICallback_EventNotification
					| XiMethods.IRead_ReadEvents
					| XiMethods.IPoll_PollEventChanges))));
		}

		public static bool SupportsEventJournalLists(this StandardMib stdMib)
		{
			if (null == stdMib) return false;
			return (0 != (stdMib.MethodsSupported
				& ((ulong)(XiMethods.IRead_ReadJournalEvents))));
		}
	}
}
