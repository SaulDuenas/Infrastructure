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

using System.Collections.Generic;

using Xi.Common.Support;
using Xi.Contracts.Constants;
using Xi.Contracts.Data;

namespace Xi.Server.Base
{
	/// <summary>
	/// This is the root or base class for all lists the report data values either current or historical.
	/// </summary>
	public abstract class DataListRoot
		: ListRoot
	{
		public DataListRoot(ContextBase<ListRoot> context, uint clientId, uint updateRate, uint bufferingRate,
							uint listType, uint listKey, StandardMib mib)
			: base(context, clientId, updateRate, bufferingRate, listType, listKey, mib)
		{
		}

		/// <summary>
		/// This method is invoked from Context Base (List Management) 
		/// to Add Data objects To this List.
		/// </summary>
		/// <param name="dataObjectsToAdd"></param>
		/// <returns></returns>
		public override List<AddDataObjectResult> OnAddDataObjectsToList(
			List<ListInstanceId> dataObjectsToAdd)
		{
			lock (_ListLock)
			{
				List<ValueRoot> listDataListEntry = new List<ValueRoot>(dataObjectsToAdd.Count);
				foreach (var id in dataObjectsToAdd)
				{
					ValueRoot dataListEntry = OnNewDataListValue(id.ClientAlias,
						NewUniqueServerAlias(), id.ObjectElementId);
					AddAValue(dataListEntry);
					listDataListEntry.Add(dataListEntry);
				}
				List<AddDataObjectResult> resultsList = OnAddDataObjectsToList(listDataListEntry);
				foreach (var ir in resultsList)
				{
					if (FaultHelpers.Failed(ir.Result))
					{
						RemoveAValue(FindEntryRoot(ir.ServerAlias));
						ir.ServerAlias = 0;
					}
				}
				return resultsList;
			}
		}

		/// <summary>
		/// Normally an override will be provided in the implementation 
		/// subclass to add the Data List Value Base 
		/// instance to the Data List.
		/// </summary>
		/// <param name="listDataListEntry"></param>
		/// <returns></returns>
		protected virtual List<AddDataObjectResult> OnAddDataObjectsToList(
			List<ValueRoot> listDataListEntry)
		{
			// Note: _ListLock has been locked
			List<AddDataObjectResult> resultsList = new List<AddDataObjectResult>(listDataListEntry.Count);
			foreach (var dle in listDataListEntry)
			{
				AddDataObjectResult result = new AddDataObjectResult(
					XiFaultCodes.S_OK, dle.ClientAlias, dle.ServerAlias, null, false, false);
				resultsList.Add(result);
			}
			return resultsList;
		}

		/// <summary>
		/// The implementation subclass provides the implementation of this abstract method 
		/// to create / construct an instance of a subclass of Data List Value Base.
		/// </summary>
		/// <param name="clientAlias"></param>
		/// <param name="serverAlias"></param>
		/// <param name="instanceId"></param>
		/// <returns></returns>
		protected abstract ValueRoot OnNewDataListValue(
			uint clientAlias, uint serverAlias, InstanceId instanceId);

		/// <summary>
		/// This method is used to Remove Data Objects From this List.  
		/// It is invoked from Context Base {List Management} Remove Data Object From List.
		/// </summary>
		/// <param name="serverAliases"></param>
		/// <returns>Return null if all were successfully removed. Otherwise, an AliasResult 
		/// is returned for each whose removal failed.</returns>
		public override List<AliasResult> OnRemoveDataObjectsFromList(List<uint> serverAliases)
		{
			lock (_ListLock)
			{
				List<AliasResult> listAliasResult = new List<AliasResult>(serverAliases.Count);
				List<ValueRoot> dataListEntries = new List<ValueRoot>(serverAliases.Count);

				foreach (uint serverAlias in serverAliases)
				{
					ValueRoot dataListValue = null;
					if (this.TryGetValue(serverAlias, out dataListValue))
					{
						if (dataListValue is DataListValueBase)
						{
							dataListEntries.Add(dataListValue as DataListValueBase);
							RemoveAValue(dataListValue);
						}
						else if (dataListValue is DataJournalListValueBase)
						{
							dataListEntries.Add(dataListValue as DataJournalListValueBase);
							RemoveAValue(dataListValue);
						}
						else
						{
							AliasResult aliasResult
								= new AliasResult(XiFaultCodes.E_BADARGUMENT, 0, serverAlias);
							listAliasResult.Add(aliasResult);
						}
					}
					else
					{
						AliasResult aliasResult
							= new AliasResult(XiFaultCodes.E_ALIASNOTFOUND, 0, serverAlias);
						listAliasResult.Add(aliasResult);
					}
				}
				if (0 < dataListEntries.Count)
				{
					listAliasResult = OnRemoveDataObjectsFromList(listAliasResult, dataListEntries);
					dataListEntries.Clear();
				}
				return listAliasResult;
			}
		}

		/// <summary>
		/// This method should be overridden in the implementation 
		/// base class to take any actions needed to remove the 
		/// specified Data List Value Base instances from the list.
		/// </summary>
		/// <param name="listUintIdRes"></param>
		/// <param name="dataListEntries"></param>
		/// <returns></returns>
		protected virtual List<AliasResult> OnRemoveDataObjectsFromList(
			List<AliasResult> listAliasResult, List<ValueRoot> dataListEntries)
		{
			// Note: _ListLock has been locked
			return listAliasResult;
		}
	}
}
