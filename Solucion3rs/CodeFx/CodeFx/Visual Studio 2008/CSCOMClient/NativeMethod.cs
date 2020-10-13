/****************************** Module Header ******************************\
* Module Name:	NativeMethod.cs
* Project:		CSCOMClient
* Copyright (c) Microsoft Corporation.
* 
* The P/Invoke signatures of some native APIs.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 2/28/2009 2:53 PM Jialiang Ge Created
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
#endregion


internal class NativeMethod
{
    /// <summary>
    /// Get current thread ID.
    /// </summary>
    /// <returns></returns>
    [DllImport("kernel32.dll")]
    internal static extern uint GetCurrentThreadId();

    /// <summary>
    /// Get current process ID.
    /// </summary>
    [DllImport("kernel32.dll")]
    internal static extern uint GetCurrentProcessId();
}