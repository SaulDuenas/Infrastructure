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
	/// This class is used to return the results of attempting to 
	/// add a data object to a data list.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class AddDataObjectResult : AliasResult
	{
		#region Data Members
		/// <summary>
		/// The data type of a data object.  Null if the object is not a 
		/// data object.
		/// </summary>
		[DataMember] public TypeId DataTypeId;

		/// <summary>
		/// Indicates, when TRUE, that the data object can be read.  
		/// </summary>
		[DataMember] public bool IsReadable;

		/// <summary>
		/// Indicates, when TRUE, that the data object can be written.  
		/// </summary>
		[DataMember] public bool IsWritable;


		#endregion

		#region Constructors

		/// <summary>
		/// This constructor creates an AliasResult from a result code, 
		/// a client alias, and a server alias.
		/// </summary>
		/// <param name="result">
		/// The result code.
		/// </param>
		/// <param name="ca">
		/// The client alias of the data object.
		/// </param>
		/// <param name="sa">
		/// The server alias of the data object.
		/// </param>
		/// /// <param name="dataTypeId">
		/// The data type id of the data object.
		/// </param>
		/// <param name="isReadable">
		/// The IsReadable attribute of the data object.
		/// </param>
		/// <param name="isWritable">
		/// The IsWritable attribute of the data object.
		/// </param>
		public AddDataObjectResult(uint result, uint ca, uint sa, TypeId dataTypeId, bool isReadable, bool isWritable)
			:base(result, ca, sa)
		{
			DataTypeId = dataTypeId;
			IsReadable = isReadable;
			IsWritable = isWritable;
		}

		#endregion
	}
}
