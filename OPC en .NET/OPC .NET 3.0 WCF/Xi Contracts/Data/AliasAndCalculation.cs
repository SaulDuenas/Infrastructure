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
	/// This class contains the changed historical data values for a specific data object.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class AliasAndCalculation 
	{
		/// <summary>
		/// The server alias that identifies a data object in the data journal. 
		/// </summary>
		[DataMember] public uint ServerAlias { get; set; }

		/// <summary>
		/// The calculation to perform on the historical values of the specified data object. 
		/// </summary>
		[DataMember] public TypeId Calculation { get; set; }

	}
}
