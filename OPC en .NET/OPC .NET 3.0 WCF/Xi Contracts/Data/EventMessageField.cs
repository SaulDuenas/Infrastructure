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
	/// This class is used to identify a non-standard event message field.  
	/// Each field is identified by the client alias and its object id. 
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class EventMessageField : IExtensibleDataObject
	{
		/// <summary>
		/// This member supports the addition of new members to a data contract 
		/// class by recording versioning information about it.  
		/// </summary>
		ExtensionDataObject IExtensibleDataObject.ExtensionData { get; set; }

		/// <summary>
		/// The name of the event message field.  
		/// </summary>
		[DataMember] public string Name;

		/// <summary>
		/// The context-wide client alias for the non-standard event message field.  
		/// This alias is used to identify each field in list of ClientRequestedFields 
		/// contained in an EventMessage.  
		/// </summary>
		[DataMember] public uint ClientAlias;

		/// <summary>
		/// This constructor initializes the EventMessageField with the 
		/// name and client alias.
		/// </summary>
		/// <param name="name">
		/// The name of the field.
		/// </param>
		/// <param name="clientAlias">
		/// The client supplied alias for the field.
		/// </param>
		public EventMessageField(string name, uint clientAlias)
		{
			Name = name;
			ClientAlias = clientAlias;
		}
	}
}
