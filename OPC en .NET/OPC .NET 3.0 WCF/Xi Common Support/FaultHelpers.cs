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
using System.ServiceModel;
using Xi.Contracts.Data;

namespace Xi.Common.Support
{
	/// <summary>
	/// Static class used to create FaultException<XiFalultInfo> to support WCF compliant faults.
	/// The FaultException<XiFalultInfo> class is a subclass of the CommunicationException class. 
	/// faults of this class are thrown by the server if they are intended to be communicated back 
	/// to the client.
	/// </summary>
	public static class FaultHelpers
	{
		/// <summary>
		/// This method will return a FaultException with a XiFault
		/// where the ErrorCode will be E_XIMESSAGEFROMEXCEPTION.
		/// The message is from the exception passed into this method.
		/// </summary>
		/// <param name="ex"></param>
		static public FaultException<XiFault> Create(Exception ex)
		{
			if (ex is FaultException<XiFault>)
				return (FaultException<XiFault>)ex;
			return new FaultException<XiFault>(new XiFault(ex.Message), ex.Message);
		}

		/// <summary>
		/// This method will return a FaultException with a XiFault
		/// where the ErrorCode will be E_XIFAULTMESSAGE.
		/// </summary>
		/// <param name="message">Error string</param>
		static public FaultException<XiFault> Create(string message)
		{
			return new FaultException<XiFault>(new XiFault(message), message);
		}

		/// <summary>
		/// This throws a new FaultException with the XiFault detail
		/// </summary>
		/// <param name="errorCode">Error string</param>
		static public FaultException<XiFault> Create(uint errorCode)
		{
			string text = FaultStrings.Get(errorCode);
			return new FaultException<XiFault>(new XiFault(errorCode, text), text);
		}

		/// <summary>
		/// This throws a new FaultException with the XiFault detail
		/// </summary>
		/// <param name="errorCode">Error code</param>
		/// <param name="message">Error string</param>
		static public FaultException<XiFault> Create(uint errorCode, string message)
		{
			return new FaultException<XiFault>(new XiFault(errorCode, message), message);
		}

		/// <summary>
		/// This method provides functionality like the SUCCEEDED macro.
		/// </summary>
		/// <param name="errorCode"></param>
		/// <returns></returns>
		static public bool Succeeded(uint errorCode)
		{
			return (0 == (0x80000000u & errorCode));
		}

		/// <summary>
		/// This method provides functionality like the FAILED marco.
		/// </summary>
		/// <param name="errorCode"></param>
		/// <returns></returns>
		static public bool Failed(uint errorCode)
		{
			return !Succeeded(errorCode);
		}
	}
}
