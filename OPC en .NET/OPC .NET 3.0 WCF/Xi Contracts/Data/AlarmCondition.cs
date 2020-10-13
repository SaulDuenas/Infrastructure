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

namespace Xi.Contracts.Data
{
	/// <summary>
	/// <para>This class is used to define a condition for which an 
	/// alarm can be detected.</para>
	/// <para>The concepts for alarm conditions accessible through 
	/// this interface are defined in EEMUA Publication 191 "Alarm 
	/// Systems: A Guide to Design, Management and Procurement".
	/// See http://www.eemua.org</para>
	/// <para>EEMUA Publication 191 describes conditions as the  
	/// "initiating event" that "can cause" an alarm.  Further, it 
	/// states "An alarm is raised or initiated when the condition 
	/// creating the alarm has occurred.  </para>  
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class AlarmCondition : IExtensibleDataObject
	{
		/// <summary>
		/// This member supports the addition of new members to a data contract 
		/// class by recording versioning information about it.  
		/// </summary>
		ExtensionDataObject IExtensibleDataObject.ExtensionData { get; set; }

		/// <summary>
		/// The name of the alarm condition.  The name of the alarm 
		/// conditino must be unique for its event source (two alarms 
		/// generated by the same event source cannot have the same name.
		/// </summary>
		[DataMember] public string Name;

		/// <summary>
		/// The namespace qualified name of the alarm condition.  
		/// Examples include HI_HI, HI, LO, and LO_LO.  
		/// </summary>
		[DataMember] public TypeId TypeId;

		/// <summary>
		/// Indicates, when TRUE, that the condition is active.  
		/// </summary>
		[DataMember] public bool IsActive;

		/// <summary>
		/// The localized definition of the triggering criteria for the 
		/// Condition. Triggering criteria define the conditions that 
		/// cause the the alarm to transition to the active state. 
		/// </summary>
		[DataMember] public string TriggeringCriteria;

		/// <summary>
		/// The priority of the Condition.    
		/// </summary>
		[DataMember] public uint Priority;

		/// <summary>
		/// The localized text message for the Condition. This text message 
		/// is included in the TextMessage field of Event Messages that 
		/// report the Condition (see the Event Message class definition).  
		/// </summary>
		[DataMember] public string TextMessage;
	}
}