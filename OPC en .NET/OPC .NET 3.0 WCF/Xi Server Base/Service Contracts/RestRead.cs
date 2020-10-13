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

using Xi.Contracts;
using Xi.Contracts.Data;

namespace Xi.Server.Base
{
	/// <summary>
	/// This partial class implements the IIRestRead interface
	/// </summary>
	public abstract partial class ServerBase<TContext, TList> : ServerRoot
									, IRestRead
									where TContext : ContextBase<TList>
									where TList : ListRoot
	{

		/// <summary>
		/// <para>This method is used to read the values of the 
		/// data objects in a list.</para>
		/// </para> 
		/// </summary>
		/// <param name="contextId">
		/// The context identifier.
		/// </param>
		/// <param name="listId">
		/// The identifier of the list that contains data objects to be read.
		/// </param>
		/// <returns>
		/// The list of requested values. The size and order of this list 
		/// matches the size and order of serverAliases parameter.
		/// </returns>
		DataValueArraysWithAlias IRestRead.RestReadData(string contextId, string listId)
		{
			return ((IRead)this).ReadData(contextId, UInt32.Parse(listId), null);
		}

	}
}
