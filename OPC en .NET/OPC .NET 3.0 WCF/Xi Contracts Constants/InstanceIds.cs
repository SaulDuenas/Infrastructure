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
	/// This class defines standard instance ids.
	/// </summary>
	public class InstanceIds
	{
		/// <summary>
		/// The ResourceType for access to the Standard and Vendor MIBs.
		/// </summary>
		public const string ResourceType_MIB = "MIB";

		/// <summary>
		/// The ResourceType for access to Data.
		/// </summary>
		public const string ResourceType_DA = "DA";

		/// <summary>
		/// The ResourceType for access to alarms and events.
		/// </summary>
		public const string ResourceType_AE = "AE";

		/// <summary>
		/// The ResourceType for access to historical (journaled) data.
		/// </summary>
		public const string ResourceType_HDA = "HDA";

		/// <summary>
		/// The ResourceType for access to historical (journaled) alarms and events.
		/// </summary>
		public const string ResourceType_HAE = "HAE";

		/// <summary>
		/// The InstanceId used for subscribing to the Current Version of the 
		/// Standard MIB.
		/// </summary>
		public const string MibCurrentVersion = "MIB:/CurrentVersion/";

		/// <summary>
		/// <para>The InstanceId of the Version number of Standard MIB object.  
		/// This InstanceId allows the client to add this version number to a data list 
		/// and be notified via callbacks or polling when the state changes.</para>
		/// </summary>
		public const string ServerMibVersionId = "Xi:StandardMibVersion";

	}
}
