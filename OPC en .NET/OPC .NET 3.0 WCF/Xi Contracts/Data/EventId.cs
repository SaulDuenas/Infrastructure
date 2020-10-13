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

using System.Runtime.Serialization;
using System.Collections.Generic;

namespace Xi.Contracts.Data
{
	/// <summary>
	/// This class is used in EventMessages to identify 
	/// the occurrence of an alarm/event.  
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class EventId
	{
		#region Data Members

		/// <summary>
		/// The object that is the source of the alarm/event.
		/// </summary>
		[DataMember] public InstanceId SourceId;

		/// <summary>
		/// The TypeId of the container for alarms with multiple conditions, 
		/// such as grouped or eclipsed alarms. The EventType enumeration defines 
		/// these types of alarms. 
		/// Null if the event is not a grouped or eclipsed alarm. 
		/// </summary>
		[DataMember] public TypeId MultiplexedAlarmContainer;

		/// <summary>
		/// <para>For system events, operator action events, simple alarms, 
		/// and complex alarms, the TypeId of the condition 
		/// that is being reported in the event message.</para>
		/// <para>For grouped or eclipsed alarms, the name of 
		/// one or more conditions that are active.</para>
		/// </summary>
		[DataMember] public List<TypeId> Condition;

		/// <summary>
		/// A server-specific id that identifies an individual occurrence of the 
		/// alarm/event.  This identifier can be constructed by the server to meet 
		/// the server's needs fo ridentifying alarms.  For example, if the server 
		/// wraps an OPC AE server, the OccurrenceId may be constructed from the 
		/// ActiveTime and Cookie parameters of the IOPCEventServer::AckCondition() 
		/// method.
		/// </summary>
		[DataMember] public string OccurrenceId;

		#endregion

	}
}
