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
	/// This class is used to update the client alias of an object that is 
	/// identified by a server alias.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class AliasUpdate
	{
		#region Data Members
		/// <summary>
		/// The existing server alias (identifier) of the object whose client alias is to be updated.
		/// </summary>
		[DataMember] public uint ExistingServerAlias { get; set; }

		/// <summary>
		/// The new client alias for the object.
		/// </summary>
		[DataMember] public uint NewClientAlias { get; set; }

		#endregion

		#region Constructors

		/// <summary>
		/// This constructor creates an AliasUpdate from 
		/// an existing alias and its new alias.
		/// </summary>
		/// <param name="existingServerAlias">
		/// The existing server alias.
		/// </param>
		/// <param name="newClientAlias">
		/// The new client alias.
		/// </param>
		public AliasUpdate(uint existingServerAlias, uint newClientAlias)
		{
			ExistingServerAlias = existingServerAlias;
			NewClientAlias = newClientAlias;
		}

		#endregion
	}
}
