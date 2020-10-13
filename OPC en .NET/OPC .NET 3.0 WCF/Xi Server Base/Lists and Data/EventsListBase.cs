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

using Xi.Common.Support;
using Xi.Contracts.Data;

namespace Xi.Server.Base
{
	/// <summary>
	/// This is the base class from which an implementation of a Xi server 
	/// would subclass to provide access event and alarm data to a client.
	/// The functionality of the server may be such that a collection of 
	/// interesting alarms are kept by the server and may be obtained by the
	/// client application as desired.
	/// </summary>
	public abstract class EventsListBase
		: EventListRoot
	{
		public EventsListBase(ContextBase<ListRoot> context, uint clientId, uint updateRate,
								uint bufferingRate, uint listType, uint listKey, StandardMib mib)
			: base(context, clientId, updateRate, bufferingRate, listType, listKey, mib)
		{
		}

		/// <summary>
		/// This method is used to request that category-specific fields be 
		/// included in event messages generated for alarms and events of 
		/// the category for this Event/Alarm List.
		/// </summary>
		/// <param name="categoryId">
		/// The category for which event message fields are being added.
		/// </param>
		/// <param name="fieldObjectTypeIds">
		/// The list of category-specific fields to be included in the event 
		/// messages generated for alarms and events of the category.  Each field 
		/// is identified by its ObjectType LocalId obtained from the EventMessageFields 
		/// contained in the EventCategoryConfigurations Standard MIB element.
		/// </param>
		/// <returns>
		/// The client alias and result codes for the fields that could not be  
		/// added to the event message. Returns null if all succeeded.  
		/// </returns>
		public override List<TypeIdResult> OnAddEventMessageFields(
			uint categoryId, List<TypeId> fieldObjectTypeIds)
		{
			lock (_ListLock)
			{
				List<TypeIdResult> TypeIdResults = new List<TypeIdResult>();
				return TypeIdResults;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="filterSet"></param>
		/// <returns></returns>
		public override EventMessage[] OnPollEventChanges(FilterSet filterSet)
		{
			if (null == _iPollEndpointEntry)
				throw FaultHelpers.Create("List not attached to the IPoll endpoint.");
			if (!Enabled)
				throw FaultHelpers.Create("List not Enabled.");

			EventMessage[] eventMessages = null;
			lock (_ListLock)
			{
				int numEvtMsgs = (DiscardedQueueEntries > 0)
							   ? _queueOfChangedValues.Count + 1
							   : _queueOfChangedValues.Count;

				if (numEvtMsgs > 0)
				{
					eventMessages = new EventMessage[numEvtMsgs];

					int idx = 0; // index for eventMessages

					// Add the discard message
					if (DiscardedQueueEntries > 0)
					{
						EventMessage discardMessage = new EventMessage();
						discardMessage.OccurrenceTime = DateTime.UtcNow;
						discardMessage.EventType = EventType.DiscardedMessage;
						discardMessage.TextMessage = DiscardedQueueEntries.ToString();
						eventMessages[idx++] = discardMessage;
					}

					// if there are queued messages to send
					foreach (var entryRoot in _queueOfChangedValues)
					{
						if (entryRoot.GetType() != typeof(QueueMarker)) // ignore queue markers
						{
							EventListValueBase evtValue = (EventListValueBase)entryRoot;
							if (null != evtValue)
								eventMessages[idx++] = evtValue.EventMessage;
						}
					}
					if (idx == 0) // there were no discards and there were no valid event messages in _queueOfChangedValues
						eventMessages = null;
					_discardedQueueEntries = 0; // reset this counter for each poll 
					_queueOfChangedValues.Clear();
				}
			}
			return eventMessages;
		}
	}
}
