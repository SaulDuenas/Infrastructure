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
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Xi.Contracts;
using Xi.Contracts.Data;
using Xi.Common.Support.Extensions;

namespace Xi.Server.Base
{
	/// <summary>
	/// This partial class defines the methods to be overridden by the server implementation 
	/// to support the Context Management methods of the IResourceManagement interface.
	/// </summary>
	public abstract partial class ContextBase<TList>
		where TList : ListRoot
	{
		/// <summary>
		/// This method is to be overridden by the context implementation in the 
		/// Server Implementation project.
		/// </summary>
		/// <param name="contextOptions"></param>
		/// <param name="reInitiateKey"></param>
		/// <returns></returns>
		public abstract bool OnReInitiate(ref uint contextOptions, ref string reInitiateKey);

		/// <summary>
		/// This method is to be overridden by the context implementation in the 
		/// Server Implementation project.
		/// </summary>
		public abstract void OnConclude();

		/// <summary>
		/// This method should be invoked when no other request using a Context LocalId 
		/// has been invoked to keep this context from timing out.
		/// </summary>
		public abstract void OnClientKeepAlive();
	}
}
