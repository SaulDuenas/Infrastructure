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
	/// This class defines the results of attempting to retrieve 
	/// a string.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class RequestedString : IExtensibleDataObject
	{
		/// <summary>
		/// This member supports the addition of new members to a data 
		/// contract class by recording versioning information about it.  
		/// </summary>
		ExtensionDataObject IExtensibleDataObject.ExtensionData { get; set; }

		/// <summary>
		/// The Result Code associated with retrieving the string.
		/// </summary>
		[DataMember] public uint ResultCode;

		/// <summary>
		/// The requested string.  If the ResultCode for this string 
		/// indicates failure, this string is null.   
		/// </summary>
		[DataMember] public string String;
	}
}
