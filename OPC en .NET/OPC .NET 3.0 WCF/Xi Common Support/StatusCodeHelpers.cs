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
using Xi.Contracts.Constants;

namespace Xi.Common.Support
{
	public class StatusCodeHelpers
	{
		public static uint MakeGoodXiStatusCode()
		{
			byte statusByte = XiStatusCode.MakeStatusByte((byte)XiStatusCodeStatusBits.GoodNonSpecific, (byte)XiStatusCodeLimitBits.NotLimited);
			return XiStatusCode.MakeStatusCode(statusByte, 0, 0);
		}

		public static uint MakeGoodHistoricalXiStatusCode(byte flagsByte)
		{
			byte statusByte = XiStatusCode.MakeStatusByte((byte)XiStatusCodeStatusBits.GoodNonSpecific, (byte)XiStatusCodeLimitBits.NotLimited);
			return XiStatusCode.MakeStatusCode(statusByte, 0, 0);
		}

	}
}
