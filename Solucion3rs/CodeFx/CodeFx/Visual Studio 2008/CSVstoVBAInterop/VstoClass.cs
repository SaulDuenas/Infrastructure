﻿/************************************* Module Header **************************************\
* Module Name:	VstoClass.cs
* Project:		CSVstoVBAInterop
* Copyright (c) Microsoft Corporation.
* 
* The CSVstoVBAInterop project demonstrates how to interop with VBA project object model in 
* VSTO projects. Including how to programmatically add Macros (or VBA UDF in Excel) into an
* Office document; how to call Macros / VBA UDFs from VSTO code; and how to call VSTO code
* from VBA code. 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 5/24/2009 1:00 PM Jie Wang Created
\******************************************************************************************/

#region Using directives
using System;
using System.Text;
using System.Reflection;
using System.Runtime.InteropServices;
#endregion


namespace CSVstoVBAInterop
{
    /// <summary>
    /// Interface for VstoClass
    /// </summary>
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface IVstoClass
    {
        string GetAsmInfo();
    }

    /// <summary>
    /// The implementation of IVstoClass interface.
    /// </summary>
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class VstoClass : IVstoClass 
    {
        public string GetAsmInfo()
        {
            return Assembly.GetExecutingAssembly().ToString();
        }
    }
}
