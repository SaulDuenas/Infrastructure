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
	/// This class is used to return an error code and the 
	/// identifier of the entity for which the requested 
	/// operation failed.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class TypeIdResult
	{
		/// <summary>
		/// The Error Code being returned.
		/// </summary>
		[DataMember] public uint ResultCode { get; set; }

		/// <summary>
		/// The TypeId of the entity associated with the error result. 
		/// </summary>
		[DataMember] public TypeId Id { get; set; }

		/// <summary>
		/// This constructor initializes the ResultCode and the TypeId based 
		/// on the corresponding input parameters.
		/// </summary>
		/// <param name="resultCode">
		/// The ResultCode to be set.
		/// </param>
		/// <param name="id">
		/// The TypeId to be set.</param>
		public TypeIdResult(uint resultCode, TypeId id)
		{
			ResultCode = resultCode;
			Id = id;
		}
	}
}
