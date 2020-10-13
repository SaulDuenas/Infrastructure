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
using Xi.Contracts.Data;

namespace Xi.Contracts.Constants
{
	/// <summary>
	/// The AdditionalDetailType indicates how the 16-bit AdditionalDetail 
	/// property of the StatusCode is used. Unused values are reserved. 
	/// </summary>
	public class XiStatusCodeAdditionalDetailType
	{
		#region Data Members
		/// <summary>
		/// The AdditionalDetail property is not used and should be ignored.
		/// Its value should be set to 0. 
		/// </summary>
		public const byte NotUsed             = 0;

		/// <summary>
		/// The AdditionalDetail property contains a vendor-specific value. 
		/// </summary>
		public const byte VendorSpecificDetail  = 1;

		/// <summary>
		/// The AdditionalDetail property contains the low order 16-bits 
		/// of the default HRESULT (Facility Code = 0). The StatusCode.HRESULT() 
		/// method creates this HRESULT from the status code.
		/// </summary>
		public const byte DefaultHResult      = 2;

		/// <summary>
		/// The AdditionalDetail property contains the low order 16-bits 
		/// of an Xi HRESULT (Facility Code = 0x777). The StatusCode.HRESULT() 
		/// method creates this HRESULT from the status code.
		/// </summary>
		public const byte XiHResult           = 3;

		/// <summary>
		/// The AdditionalDetail property contains the low order 16-bits 
		/// of a FACILITY_IO_ERROR_CODE NTSTATUS (Facility Code = 4). The 
		/// StatusCode.HRESULT() method creates this HRESULT from the status code.
		/// </summary>
		public const byte IO_ERROR_CODE       = 4;

		/// <summary>
		/// The AdditionalDetail property contains the low order 16-bits 
		/// of a COM FACILITY_ITF HRESULT (Facility Code = 4). The 
		/// StatusCode.HRESULT() method creates this HRESULT from the status code.
		/// </summary>
		public const byte ITF_HResult         = 5;

		/// <summary>
		/// The AdditionalDetail property contains the low order 16-bits 
		/// of a Win32 HRESULT (Facility Code = 5). The StatusCode.HRESULT() 
		/// method creates this HRESULT from the status code.
		/// </summary>
		public const byte Win32HResult        = 6;

		/// <summary>
		/// <para>This code is used to indicate that an additional HRESULT 
		/// accompanies this StatusCode.  The additional HRESULT is contained 
		/// in the HResult member of an ErrorInfo object that is located in the 
		/// ErrorInfo list contained in the DataValueArrays in which this StatusCode 
		/// is present.</para>  
		/// <para>This code does not have to be present if the Context was opened 
		/// with ContextOptions set to DebugErrorMessages using either the 
		/// Initiate() or ReInitiate() method.</para>
		/// </summary>
		public const byte AdditionalErrorCode = 7;
		#endregion // Data Members

		#region Additional Detail Properties
		/// <summary>
		/// This property returns the AdditionalDetail as a 16-bit vendor-specific value 
		/// if the AdditionalDetailType is set to AdditionalDetailType.VendorSpecific.  
		/// If the AdditionalDetailType is set to a different value, 0 is returned.
		/// </summary>
		/// <param name="statusCode">
		/// The 32-bit status code from which AdditionalDetail is to be extracted. 
		/// </param>
		/// <returns>
		/// The vendor-specific AdditionalDetail value. 0 if the AdditionalDetailType 
		/// indicates that the AdditionalDetail does not contain a vendor-specific value.
		/// </returns>
		public static ushort VendorSpecific(uint statusCode)
		{
			if (XiStatusCode.AdditionalDetailType(statusCode) == (byte)XiStatusCodeAdditionalDetailType.VendorSpecificDetail)
				return (ushort)((statusCode) & 0xFFFF);
			return 0;
		}

		/// <summary>
		/// <para>This property returns the AdditionalDetail as a 32-bit HRESULT.  
		/// 
		/// The HRESULT is constructed by setting the high order 16 bits of 
		/// the HRESULT as follows. The AdditionalDetailType indicates how the 
		/// Facility bits are set.</para>
		/// <para>Bit(s)   Value</para>
		/// <para>16 (MSB) Severity. Set to 0 if the Status Bits indicate Good.</para>
		/// <para>15       R-bit. Set to 0.</para>
		/// <para>14       C-bit. Set to 0.</para>
		/// <para>13       N-bit. Set to 0.</para>
		/// <para>12       X-bit. Set to 0.</para>
		/// <para>11-1     Facility. Set to the appropriate facility code. E.g.:</para>
		/// <para>           0 (FACILITY_NULL) for the default HResult </para>
		/// <para>           4 (FACILITY_ITF) for COM</para> 
		/// <para>           7 (FACILITY_WIN32) for WIN32</para>
		/// <para>           0x777 for Xi specific</para>
		/// </summary>
		/// <param name="statusCode">
		/// The 16-bit status code from which HResult is to be constructed. 
		/// </param>
		/// <returns>
		/// The HResult value. 0 if the AdditionalDetailType indicates that the 
		/// AdditionalDetail does not contain an HRESULT.
		/// </returns>
		public static uint HResult(uint statusCode)
		{
			uint hresult = 0;
			uint severityCode = ((statusCode & 0xC0000000) > 0) ? 0x80000000 : 0x00000000;
			uint facilityCode = 0;
			switch (XiStatusCode.AdditionalDetailType(statusCode))
			{
				case XiStatusCodeAdditionalDetailType.NotUsed:
					break;
				case XiStatusCodeAdditionalDetailType.VendorSpecificDetail:
					break;
				case XiStatusCodeAdditionalDetailType.DefaultHResult:
					break;
				case XiStatusCodeAdditionalDetailType.XiHResult:
					facilityCode = 0x07770000;
					break;
				case XiStatusCodeAdditionalDetailType.IO_ERROR_CODE:
					severityCode = 0xC0000000;
					facilityCode = 0x00040000;
					break;
				case XiStatusCodeAdditionalDetailType.ITF_HResult:
					severityCode = 0x80000000;
					facilityCode = 0x00040000;
					break;
				case XiStatusCodeAdditionalDetailType.Win32HResult:
					facilityCode = 0x00050000;
					break;
				case XiStatusCodeAdditionalDetailType.AdditionalErrorCode:
					break;
				default:
					break;
			}
			hresult = severityCode | facilityCode | ((statusCode) & 0xFFFF);
			return hresult;
		}


		#endregion // Additional Detail Properties

	}
}
