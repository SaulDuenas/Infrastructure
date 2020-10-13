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
using System.Runtime.Serialization;
using System.Collections.Generic;

namespace Xi.Contracts.Data
{
	/// <summary>
	/// <para>This class defines the Event Messages that are used to 
	/// report the occurrence of an event or alarm.</para> 
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class EventMessage : IExtensibleDataObject
	{
		/// <summary>
		/// This member supports the addition of new members to a data contract 
		/// class by recording versioning information about it.  
		/// </summary>
		ExtensionDataObject IExtensibleDataObject.ExtensionData { get; set; }

		#region Data Members
		/// <summary>
		/// The time of the event/alarm occurrence.  
		/// </summary>
		[DataMember] public DateTime OccurrenceTime;

		/// <summary>
		/// The type of the event/alarm that is being reported by this 
		/// event message.  
		/// </summary>
		[DataMember] public EventType EventType;

		/// <summary>
		/// The identifier for the event/alarm occurrence.  
		/// </summary>
		[DataMember] public EventId EventId;

		/// <summary>
		/// Text that describes the event occurrence.
		/// </summary>
		[DataMember] public string TextMessage;

		/// <summary>
		/// The category to which the event is assigned.
		/// </summary>
		[DataMember] public uint CategoryId;

		/// <summary>
		/// The priority of the event.
		/// </summary>
		[DataMember] public uint Priority;

		/// <summary>
		/// <para>For event messages that report operator action events, 
		/// the name of the operator who caused an operator action event 
		/// to be generated.</para>
		/// <para>For event messages that report the acknowledgement of 
		/// an alarm, the name of the operator who acknowledged the 
		/// alarm.</para>
		/// <para>Null for all other event messages.</para>  
		/// </summary>
		[DataMember] public string OperatorName;

		/// <summary>
		/// Data to be included in the event message for alarms.  Null 
		/// if the event message is not reporting an alarm.  
		/// </summary>
		[DataMember] public AlarmMessageData AlarmData;

		/// <summary>
		/// The fields selected by the client to be included in Event Messages 
		/// for the indicated Event Category.  The fields that can be selected 
		/// by the client to be returned in Event Messages for a given Category 
		/// are specified in the EventCategories member of the Event Capabilities 
		/// MIB Element.
		/// </summary>
		[DataMember] public List<object> ClientRequestedFields;

		#endregion
	}
}
