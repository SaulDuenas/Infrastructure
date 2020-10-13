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
using System.Collections.Generic;

namespace Xi.Contracts.Data
{
	/// <summary>
	/// This class defines the passthrough messages that 
	/// can be sent a given recipient.
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	public class RecipientPassthroughs
	{
		/// <summary>
		/// The identifier of the recipient of one or more passthrough 
		/// messages.  The recipient represents the entity to which 
		/// the client sends the messages and that is responsible for 
		/// processing or otherwise consuming the message.
		/// </summary>
		[DataMember] public InstanceId RecipientId { get; set; }

		/// <summary>
		/// The list of Passthough messages that can be sent to the 
		/// recipient.
		/// </summary>
		[DataMember] public List<PassthroughMessage> PassthroughMessages { get; set; }

	}
}
