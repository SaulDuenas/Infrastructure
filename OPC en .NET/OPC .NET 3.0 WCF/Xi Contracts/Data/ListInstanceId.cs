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
	/// This class identifies a data object to be added 
	/// to a list. 
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class ListInstanceId
	{
		/// <summary>
		/// The Object LocalId for the object, typically obtained 
		/// using the FindObjects() method, plus an optional 
		/// element identifier for elements of a constructed 
		/// data type.
		/// </summary>
		[DataMember] public InstanceId ObjectElementId;

		/// <summary>
		/// The client-assigned alias for the data object.
		/// This alias is used to refer to the data object 
		/// within the context of the list to which it is 
		/// added.  
		/// </summary>
		[DataMember] public uint ClientAlias;

	}
}
