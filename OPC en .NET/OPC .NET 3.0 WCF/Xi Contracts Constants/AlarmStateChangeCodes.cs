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

namespace Xi.Contracts.Constants
{
	/// <summary>
	/// This class holds a set of constants used to inform a client 
	/// as to the cause / reason for the event message to be sent.
	/// </summary>
	public class AlarmStateChangeCodes
	{
		/// <summary>
		/// The Active State has changed
		/// </summary>
		public const uint Active         = 0x01;
		/// <summary>
		/// The Acknowledge State has changed. 
		/// </summary>
		public const uint Acknowledge    = 0x02;
		/// <summary>
		/// The Disable State has changed.
		/// </summary>
		public const uint Disable        = 0x04;
		/// <summary>
		/// The Priority has changed.
		/// </summary>
		public const uint Priority       = 0x10;
		/// <summary>
		/// The Subcondition has changed.
		/// </summary>
		public const uint Subcondition   = 0x20;
		/// <summary>
		/// The Message has changed.
		/// </summary>
		public const uint Message        = 0x40;
		/// <summary>
		/// One or more of the Requested Fields has changed.
		/// </summary>
		public const uint RequestedField = 0x80;
	}

}
