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
	/// This class is used to return a result code along with 
	/// a client and server alias if the result code indicates 
	/// success.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class AliasResult
	{
		#region Data Members
		/// <summary>
		/// The Result Code being returned.
		/// </summary>
		[DataMember] public uint Result { get; set; }

		/// <summary>
		/// The client-assigned alias (identifier) for an InstanceId. Set to 0 if unknown.
		/// </summary>
		[DataMember] public uint ClientAlias { get; set; }

		/// <summary>
		/// The server-assigned alias (identifier) for an InstanceId.
		/// </summary>
		[DataMember] public uint ServerAlias { get; set; }

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
		/// The client alias.
		/// </param>
		/// <param name="sa">
		/// The server alias.
		/// </param>
		public AliasResult(uint result, uint ca, uint sa)
		{
			ClientAlias = ca;
			ServerAlias = sa;
			Result = result;
		}

		#endregion
	}
}
