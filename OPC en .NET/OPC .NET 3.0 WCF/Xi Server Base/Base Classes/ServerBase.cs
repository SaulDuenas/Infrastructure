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

namespace Xi.Server.Base
{
	/// <summary>
	/// This is the base class handler for a XiServer.  
	/// </summary>
	/// <typeparam name="TContext">Concrete context type</typeparam>
	/// <typeparam name="TList">Concrete List type</typeparam>
	public abstract partial class ServerBase<TContext, TList> 
		: ServerRoot
		where TContext : ContextBase<TList>
		where TList : ListRoot
	{

	}
}
