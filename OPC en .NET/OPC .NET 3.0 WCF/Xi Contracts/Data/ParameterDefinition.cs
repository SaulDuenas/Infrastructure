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
	/// This class is used to define parameters, fields, and properties.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class ParameterDefinition : IExtensibleDataObject
	{
		/// <summary>
		/// This member supports the addition of new members to a data 
		/// contract class by recording versioning information about it.  
		/// </summary>
		ExtensionDataObject IExtensibleDataObject.ExtensionData { get; set; }

		/// <summary>
		/// The display name of the parameter, field, or property.  Names 
		/// are not permitted to contain the forward slash ('/') character.  
		/// This name is used as the FilterOperand in FilterCriterion.
		/// </summary>
		[DataMember] public string Name;

		/// <summary>
		/// The optional description of the parameter, field, or property.  
		/// Null if unused.
		/// </summary>
		[DataMember] public string Description;

		/// <summary>
		/// The object type of the parameter, field, or property.
		/// </summary>
		[DataMember] public TypeId ObjectTypeId;

		/// <summary>
		/// The data type of the parameter, field, or property.
		/// </summary>
		[DataMember] public TypeId DataTypeId;

	}
}
