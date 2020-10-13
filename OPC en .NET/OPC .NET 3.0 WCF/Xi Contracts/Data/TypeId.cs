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

namespace Xi.Contracts.Data
{

	/// <summary>
	/// This class defines the identifier for data types and object types.  Each 
	/// element of the TypeId is case-sensitive.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class TypeId
	{
		#region Data Members

		/// <summary>
		/// <para>This string identifies the type of the type definition 
		/// (the type of its schema).  Standard values are defined by the XiSchemaType 
		/// enumeration.</para>
		/// <para>For Data Types, the value XiSchemaType.Xi is used for 
		/// the standard .NET data types and those defined by the Xi contracts.</para>
		/// <para>The forward slash '/'character and the dot character, '.', 
		/// cannot be used in the SchemaType string.</para>
		/// </summary>
		[DataMember] public string SchemaType;

		/// <summary>
		/// <para>This member is used to identify the context for the 
		/// Identifier. The context defines which organization defined 
		/// the type and any additional qualifying information. For CLS 
		/// data types, the SchemaType is set to CLS and the namespace 
		/// is set to null.</para>
		/// <para>For example, data types for Fieldbus Foundation devices 
		/// are defined either by the Fieldbus Foundation or by device 
		/// manufacturers. When defined by the Fieldbus Foundation, the 
		/// Namespace would be composed of a single string 
		/// with a value of "FF", and if defined by a device manufacturer, 
		/// the path would be composed of the Manufacturer LocalId registered by 
		/// the Fieldbus Foundation, the device type, and the device revision. 
		/// If the type is an EDDL type, the EDD revision is also needed.</para>
		/// <para>Set to XiNamespace.Xi (null) for .NET defined data types.</para>
		/// <para>For types defined by the server vendor for use in multiple 
		/// Xi servers, the ServerDescription VendorName should be used as 
		/// the namespace.  </para>
		/// <para>The forward slash '/' character is not permitted to be used 
		/// within the namespace.  Instead, the dot '.' character should be used 
		/// to separate elements of the namespace.</para>
		/// <para>Following the example above, if the vendor defines the type 
		/// specifically for a given server, then the ServerDescription ServerName, 
		/// separated by a '.' should be appended after the vendor name. 
		/// (e.g. "MyVendor.MyServer").</para>
		/// </summary>
		[DataMember] public string Namespace;

		/// <summary>
		/// The string representation of the identifier for the type.  
		/// </summary>
		[DataMember] public string LocalId;

		#endregion

		#region Constructors
		/// <summary>
		/// The default constructor. 
		/// </summary>
		public TypeId()
		{
		}

		/// <summary>
		/// Construct a Type LocalId given a .NET / CLI Type.
		/// </summary>
		/// <param name="id">
		/// The .NET / CLI Type for which the TypeId is being constructed.
		/// </param>
		public TypeId(Type id)
		{
			this.SchemaType = null;
			this.Namespace = null;
			this.LocalId = id.ToString();
		}

		/// <summary>
		/// This constructor initializes a new TypeId object.
		/// </summary>
		/// <param name="schemaType">
		/// The SchemaType.
		/// </param>
		/// <param name="nameSpace">
		/// The Namespace.
		/// </param>
		/// <param name="id">
		/// The LocalId.
		/// </param>
		public TypeId(string schemaType, string nameSpace, string id)
		{
			SchemaType = schemaType;
			Namespace = nameSpace;
			LocalId = id;
		}

		#endregion

		#region Methods

		/// <summary>
		/// This method compares this TypeId with a TypeId passed-in as a parameter.
		/// </summary>
		/// <param name="typeId">
		/// The TypeId to compare against this TypeId.
		/// </param>
		/// <returns>
		/// True if the two TypeIds are the same, and false if not.
		/// </returns>
		public bool Compare(TypeId typeId)
		{
			bool theSame = true;
			if (string.IsNullOrEmpty(this.SchemaType))
			{
				if (string.IsNullOrEmpty(typeId.SchemaType) == false)
					theSame = false;
			}
			else // this SchemaId has a value
			{
				if (string.IsNullOrEmpty(typeId.SchemaType))
					theSame = false;
				else if (string.Compare(this.SchemaType, typeId.SchemaType, false) != 0)
					theSame = false;
			}
			if (theSame) // so far
			{
				if (string.IsNullOrEmpty(this.Namespace))
				{
					if (string.IsNullOrEmpty(typeId.Namespace) == false)
						theSame = false;
				}
				else // this Namespace has a value
				{
					if (string.IsNullOrEmpty(typeId.Namespace))
						theSame = false;
					else if (string.Compare(this.Namespace, typeId.Namespace, false) != 0)
						theSame = false;
				}
			}
			if (theSame) // so far
			{
				if ((string.IsNullOrEmpty(this.LocalId)) || (string.IsNullOrEmpty(this.LocalId)))
					theSame = false;
				else if (string.Compare(this.LocalId, typeId.LocalId, false) != 0)
					theSame = false;
			}
			return theSame;
		}

		/// <summary>
		/// <para>This method converts a type id to a string. The string form of the TypeId 
		/// closely resembles a URL, containing a resource type prefix, a namespace qualifier, 
		/// and the identifier with the exception that the namespace qualifier and the local 
		/// identifier are separated by the dot '.' character.</para>
		/// <para>  SchemaType:Namespace.Identifier</para>
		/// <para>If the SchemaType is present, it is terminated with the colon ':' character, 
		/// and followed by the Namespace. </para>
		/// <para>If the SchemaType is not present, the Namespace is the first element of the 
		/// string. </para>
		/// <para>If the Namespace is present, it is terminated with the dot '.' character, and 
		/// followed by the LocalId. </para>
		/// <para>If the Namespace is not present, the LocalId follows immediately. </para>
		/// <para>For example, if the type is the CLS Int32 type, the string representation would be 
		/// "System.Int32".</para>
		/// </summary>
		/// <returns>
		/// The resulting string.
		/// </returns>
		public override string ToString()
		{
			string typeIdString = null;
			if (LocalId != null)
			{
				if (String.IsNullOrEmpty(SchemaType) == false)
					typeIdString = SchemaType + ":";

				if (String.IsNullOrEmpty(Namespace) == false)
					typeIdString += Namespace + ".";

				typeIdString += LocalId;
			}
			return typeIdString;
		}

		#endregion
	}
}
