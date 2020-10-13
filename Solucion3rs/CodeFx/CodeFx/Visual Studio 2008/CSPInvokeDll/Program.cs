/****************************** Module Header ******************************\
* Module Name:	Program.cs
* Project:		CSPInvokeDll
* Copyright (c) Microsoft Corporation.
* 
* Platform Invocation Services (PInvoke) in .NET allows managed code to call  
* unmanaged functions that are implemented and exported in unmanaged DLLs.  
* This sample shows you what you need to do to be able to call the exported 
* functions in the unmanaged DLLs like CppDllExport.dll, msvcrt.dll, from C#.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/21/2009 11:04 PM Jialiang Ge Created
* * 3/22/2009 5:48 PM Jialiang Ge Reviewed
* * 6/18/2009 2:53 PM Jialiang Ge Updated
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Text;
#endregion


class Program
{
    static void Main(string[] args)
    {
        #region Access Ordinary Functions in CppDllExport.dll

        // P/Invoke a method exported with a def file
        {
            string result;
            NativeMethod.HelloWorld1(out result);
            Console.WriteLine("CppDllExport!HelloWorld1 => {0}", result);
        }

        // P/Invoke a __declspec(dllexport/dllimport) method
        {
            string result;
            NativeMethod.HelloWorld2(out result);
            Console.WriteLine("CppDllExport!HelloWorld2 => {0}", result);
        }

        #endregion


        #region Access Callback Functions in CppDllExport.dll

        // Call FunctionA/FunctionB in CppDllExport.dll that invokes the 
        // function pointed by the global function pointer: g_pFunc1/g_pFunc2
        {
            // As g_pFunc1/g_pFunc2 are global data members exported from the 
            // native module, P/Invoke is not able to access them directly. 
            // You would need to either export an additional method from the 
            // native dll to access the global function pointer or write a 
            // C++/CLI wrapper (see CppCLIWrapLib).
        }

        // P/Invoke a method that requires callback as one of the args.
        {
            NativeMethod.CompareCallback cmpFunc =
                new NativeMethod.CompareCallback(CompareInts);
            int result = NativeMethod.Max(2, 3, cmpFunc);

            // Make sure the lifetime of the delegate instance covers the 
            // lifetime of the unmanaged code; otherwise, the delegate 
            // will not be available after it is garbage-collected, and you 
            // may get the Access Violation or Illegal Instruction error.
            GC.KeepAlive(cmpFunc);

            Console.WriteLine("CppDllExport!Max(2, 3) => {0}", result);
        }

        #endregion


        // P/Invoke the stdcall API, MessageBox, in user32.dll
        {
            NativeMethod.MessageBoxResult result =
                NativeMethod.MessageBox(IntPtr.Zero, "test", "test",
                NativeMethod.MessageBoxOptions.OkCancel);
            Console.WriteLine("User32!MessageBox => {0}", result);
        }

        // P/Invoke the cdecl API, printf, in msvcrt.dll
        {
            Console.Write("msvcrt!printf => ");
            NativeMethod.printf("%s!%s\n", "msvcrt", "printf");
        }
    }

    static int CompareInts(int a, int b)
    {
        if (a > b) return 1;
        if (a < b) return -1;
        return 0;
    }
}