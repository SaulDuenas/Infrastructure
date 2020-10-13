/****************************** Module Header ******************************\
* Module Name:	Program.cs
* Project:		CSLoadLibrary
* Copyright (c) Microsoft Corporation.
* 
* CSLoadLibrary in C# mimics the behavior of CppLoadLibrary to dynamically 
* load a native DLL (LoadLibrary) get the address of a function in the export  
* table (GetProcAddress, Marshal.GetDelegateForFunctionPointer), and call it. 
* It serves as a supplement for the P/Invoke technique and is useful  
* especially when the target DLL is not in the search path of P/Invoke.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/21/2009 11:04 PM Jialiang Ge Created
* * 3/22/2009 5:48 PM Jialiang Ge Reviewed
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
#endregion


class Program
{
    #region Function Delegates
    
    delegate void HelloWorld1(
        // The string parameter must be marshaled as LPTStr, otherwise, the
        // string will be passed into the native as an ANSI string that the
        // Unicode API cannot resolve appropriately.
        [MarshalAs(UnmanagedType.LPTStr)] out string strRet);

    delegate bool DeleteFile(
        // The string parameter must be marshaled as LPTStr, otherwise, the
        // string will be passed into the native as an ANSI string that the
        // Unicode API cannot resolve appropriately.
        [MarshalAs(UnmanagedType.LPTStr)] string fileName);

    #endregion


    static void Main(string[] args)
    {
        // Load CppDllExport.dll and call its exported symbols
        using (UnmanagedLibrary lib = new UnmanagedLibrary("CppDllExport"))
        {
            // GetProcAddress
            HelloWorld1 function = lib.GetUnmanagedFunction<HelloWorld1>(
                "HelloWorld1");

            // Call the function
            string result;
            function(out result);
            Console.WriteLine("CppDllExport!HelloWorld1 => {0}", result);

        } // The native module CppDllExport.dll should be unloaded here.


        // Load kernel32.dll and call its exported symbols
        using (UnmanagedLibrary lib = new UnmanagedLibrary("kernel32"))
        {
            // GetProcAddress
            DeleteFile function = lib.GetUnmanagedFunction<DeleteFile>(
                "DeleteFileW");

            // Call the function
            if (!function(@"temp.txt"))
            {
                int hr = Marshal.GetHRForLastWin32Error();
                Console.WriteLine(
                    "DeleteFileW(\"temp.txt\") failed w/err 0x{0:X}", hr);
            }
        }
    }
}
