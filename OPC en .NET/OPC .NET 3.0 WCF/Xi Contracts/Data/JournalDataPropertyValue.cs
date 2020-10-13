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
	/// This class contains the results of attmepting to access a set of historized 
	/// property values for a given data object.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class JournalDataPropertyValue
	{
		/// <summary>
		/// The result code associated with accessing the property.  
		/// See XiFaultCodes claass for standardized result codes. 
		/// </summary>
		[DataMember] public uint ResultCode { get; set; }

		/// <summary>
		/// The client-assigned alias for the historized data object.
		/// </summary>
		[DataMember] public uint ClientAlias { get; set; }

		/// <summary>
		/// The id of the property being accessed.
		/// </summary>
		[DataMember] public TypeId PropertyId { get; set; }

		/// <summary>
		/// An optional list of history properties of the historized data object.  
		/// </summary>
		[DataMember] public DataValueArrays PropertyValues { get; set; }
	}
}
