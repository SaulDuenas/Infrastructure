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
using System.Diagnostics;

using Xi.Common.Support;
using Xi.Contracts.Constants;
using Xi.Contracts.Data;

namespace Xi.Server.Base
{
	/// <summary>
	/// This is the base class from which an implementation of a Xi server 
	/// would subclass to provide access to current process data values.
	/// </summary>
	public abstract class DataListBase
		: DataListRoot
	{
		/// <summary>
		/// The constructor for this class.
		/// </summary>
		/// <param name="context"></param>
		/// <param name="clientId"></param>
		/// <param name="updateRate"></param>
		/// <param name="bufferingRate"></param>
		/// <param name="listType"></param>
		/// <param name="listKey"></param>
		public DataListBase(ContextBase<ListRoot> context, uint clientId, uint updateRate,
							uint bufferingRate, uint listType, uint listKey, StandardMib mib)
			: base(context, clientId, updateRate, bufferingRate, listType, listKey, mib)
		{
		}

		/// <summary>
		/// This method may be overridden in the implementation subclass.  However, 
		/// the implementation provided here should be adequate when the changed 
		/// data values are added to the queue of changed Entry Root by setting 
		/// the Entry Queued property of the data value.
		/// </summary>
		/// <returns></returns>
		public override DataValueArraysWithAlias OnPollDataChanges()
		{
			if (null == _iPollEndpointEntry)
				throw FaultHelpers.Create("List not attached to the IPoll endpoint.");
			if (!Enabled)
				throw FaultHelpers.Create("List not Enabled.");

			lock (_ListLock)
			{
				if (0 < _queueOfChangedValues.Count)
				{
					int doubleCount = 0;
					int uintCount = 0;
					int objectCount = 0;
					foreach (var entryRoot in _queueOfChangedValues)
					{
						if (entryRoot.GetType() != typeof(QueueMarker)) // ignore queue markers
						{
							switch (entryRoot.ValueTransportTypeKey)
							{
								case TransportDataType.Double:
									doubleCount += 1;
									break;
								case TransportDataType.Uint:
									uintCount += 1;
									break;
								case TransportDataType.Object:
									objectCount += 1;
									break;
								default:
									Debug.Assert(false, "Bad Data Value Key");
									break;
							}
						}
						else
						{
						}
					}

					// Call this method to create the response array. This method will add shutdown messages if they are queued 
					// and also the number of discarded entries if there were any
					DataValueArraysWithAlias readValueArray = OwnerContext.CreatePollResponse(this, doubleCount, uintCount, objectCount);
					if (0 < _queueOfChangedValues.Count)
					{
						int doubleIdx = 0;
						int uintIdx = 0;
						int objectIdx = 0;
						foreach (var entryRoot in _queueOfChangedValues)
						{
							if (entryRoot.GetType() != typeof(QueueMarker)) // ignore queue markers
							{
								DataListValueBase dataValue = (entryRoot as DataListValueBase);
								switch (entryRoot.ValueTransportTypeKey)
								{
									case TransportDataType.Double:
										readValueArray.SetDouble(doubleIdx++, dataValue.ClientAlias,
											dataValue.StatusCode, dataValue.TimeStamp, dataValue.DoubleValue);
										break;
									case TransportDataType.Uint:
										readValueArray.SetUint(uintIdx++, dataValue.ClientAlias,
											dataValue.StatusCode, dataValue.TimeStamp, dataValue.UintValue);
										break;
									case TransportDataType.Object:
										readValueArray.SetObject(objectIdx++, dataValue.ClientAlias,
											dataValue.StatusCode, dataValue.TimeStamp, dataValue.ObjectValue);
										break;
									default:
										Debug.Assert(false, "Bad Data Value Key");
										break;
								}
								dataValue.EntryQueued = false;
							}
						}
						_discardedQueueEntries = 0; // reset this counter for each poll 
						_queueOfChangedValues.Clear();
					}
					return readValueArray;
				}
				return null;
			}
		}

		/// <summary>
		/// This method provides a default implementation for On Read Data which 
		/// is invoked by Context Base {Read}.  This implementation should be 
		/// adequate for most situations.  This method in turn invokes another 
		/// version of On Read Data which is generally overridden by the 
		/// implementation subclass.
		/// </summary>
		/// <param name="serverAliases"></param>
		/// <returns></returns>
		public override DataValueArraysWithAlias OnReadData(List<uint> serverAliases)
		{
			if (null == _iReadEndpointEntry)
				throw FaultHelpers.Create("List not attached to the IRead endpoint.");
			if (!Enabled)
				throw FaultHelpers.Create("List not Enabled.");

			lock (_ListLock)
			{
				Debug.Assert(false, "This On Read Data method should not be invoked");
				throw FaultHelpers.Create(XiFaultCodes.E_NOTIMPL, "IRead.ReadData");
			}
		}

		/// <summary>
		/// Generally this method will be overridden in the implementation subclass.  
		/// The default behavior is to return the Data List Value in the cache.
		/// </summary>
		/// <param name="readRequests"></param>
		protected virtual DataValueArraysWithAlias OnReadData(List<DataListValueBase> readRequests)
		{
			// No need to lock a return
			return null;
		}
	}
}
