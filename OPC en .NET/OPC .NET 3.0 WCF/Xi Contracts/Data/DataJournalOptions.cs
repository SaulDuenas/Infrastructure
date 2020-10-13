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
using System.Collections.Generic;

namespace Xi.Contracts.Data
{
	/// <summary>
	/// This class contains the options supported by the server 
	/// for history data accessible through Journal reads and 
	/// writes.  
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class DataJournalOptions
	{
		/// <summary>
		/// Historical Data Math Library supported by the server. Each 
		/// math/statistical function in the library is identified 
		/// using an InstanceId.  The namespace element of the InstanceId 
		/// identifies the party responsible for defining the function.
		/// </summary>
		[DataMember] public List<TypeAttributes> MathLibrary { get; set; }

		/// <summary>
		/// The standard and non-standard Historical Data Properties 
		/// supported by the server, and an indicator of which can 
		/// be used for filtering.    
		/// </summary>
		[DataMember] public List<ParameterDefinition> Properties;
	}
}
