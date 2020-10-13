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

using Xi.Contracts.Data;

namespace Xi.Server.Base
{
	/// <summary>
	/// This is the base class from which an implementation of a Xi server 
	/// would subclass to provide access historical or journaled event and 
	/// alarm data to a client.
	/// </summary>
	public abstract class EventJournalListBase : EventListRoot
	{
		public EventJournalListBase(ContextBase<ListRoot> context, uint clientId, uint updateRate,
									uint bufferingRate, uint listType, uint listKey, StandardMib mib)
			: base(context, clientId, updateRate, bufferingRate, listType, listKey, mib)
		{
		}
	}
}
