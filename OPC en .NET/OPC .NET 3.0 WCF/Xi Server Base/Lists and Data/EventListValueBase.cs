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
using Xi.Common.Support;

namespace Xi.Server.Base
{
	public abstract class EventListValueBase
		: ValueRoot
	{
		public EventListValueBase(uint clientAlias, uint serverAlias)
			: base(clientAlias, serverAlias)
		{
		}

		public EventMessage EventMessage
		{
			get { return _eventMessage; }
			protected set { _eventMessage = value; }
		}
		private EventMessage _eventMessage;

		private uint _statusCode;
		/// <summary>
		/// 
		/// </summary>
		public override uint StatusCode { get { return _statusCode; } set { _statusCode = value; } }

		/// <summary>
		/// 
		/// </summary>
		public override TransportDataType ValueTransportTypeKey
		{
			get { return TransportDataType.EventMessage; }
			protected set { }
		}
	}
}
