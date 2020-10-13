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

using Xi.Contracts.Constants;
using Xi.Contracts.Data;

namespace Xi.Server.Base
{
	/// <summary>
	/// The Data Journal List is used to represent a collection of historical 
	/// process data values.  Each value contained by the Data Journal List
	/// contains a collection of data values for a specified time interval.  
	/// There are several options as to the exact nature of this collection 
	/// of data values, the data value collection may be raw values or values 
	/// process (calculated) according to the servers capabilities.
	/// </summary>
	public abstract class DataJournalListBase
		: DataListRoot
	{
		/// <summary>
		/// This constructor is simply a pass through place holder.
		/// </summary>
		/// <param name="context"></param>
		/// <param name="clientId"></param>
		/// <param name="updateRate"></param>
		/// <param name="listType"></param>
		/// <param name="listKey"></param>
		public DataJournalListBase(ContextBase<ListRoot> context,
			uint clientId, uint updateRate, uint bufferingRate, uint listType, uint listKey, StandardMib mib)
			: base(context, clientId, updateRate, bufferingRate, listType, listKey, mib)
		{
		}

		public override uint OnTouchList()
		{
			return XiFaultCodes.S_OK;
		}

	}
}
