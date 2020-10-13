/****************************** Module Header ******************************\
* Module Name:	NativeMethod.cs
* Project:		CSPInvokeDll
* Copyright (c) Microsoft Corporation.
* 
* The PInvoke signatures of the methods exported from the unmanaged DLLs.
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
using System.Runtime.InteropServices;
using System.Text;
using System.Security;
#endregion


/// <summary>
/// Native methods
/// </summary>
[SuppressUnmanagedCodeSecurity]
class NativeMethod
{
    [DllImport("CppDllExport.dll", CharSet = CharSet.Auto)]
    public static extern void HelloWorld1(out string pRet);

    [DllImport("CppDllExport.dll", CharSet = CharSet.Auto)]
    public static extern void HelloWorld2(out string pRet);

    public delegate int CompareCallback(int a, int b);
    [DllImport("CppDllExport.dll", CharSet = CharSet.Auto)]
    public static extern int Max(int a, int b, CompareCallback cmpFunc);

    /// <summary>
    /// Flags that define appearance and behaviour of a standard message box 
    /// displayed by a call to the MessageBox function.
    /// </summary>
    [Flags]
    public enum MessageBoxOptions : uint
    {
        Ok = 0x000000,
        OkCancel = 0x000001,
        AbortRetryIgnore = 0x000002,
        YesNoCancel = 0x000003,
        YesNo = 0x000004,
        RetryCancel = 0x000005,
        CancelTryContinue = 0x000006,

        IconHand = 0x000010,
        IconQuestion = 0x000020,
        IconExclamation = 0x000030,
        IconAsterisk = 0x000040,
        UserIcon = 0x000080,

        IconWarning = IconExclamation,
        IconError = IconHand,
        IconInformation = IconAsterisk,
        IconStop = IconHand,

        DefButton1 = 0x000000,
        DefButton2 = 0x000100,
        DefButton3 = 0x000200,
        DefButton4 = 0x000300,

        ApplicationModal = 0x000000,
        SystemModal = 0x001000,
        TaskModal = 0x002000,

        Help = 0x004000, //Help Button
        NoFocus = 0x008000,

        SetForeground = 0x010000,
        DefaultDesktopOnly = 0x020000,
        Topmost = 0x040000,
        Right = 0x080000,
        RTLReading = 0x100000,
    }

    /// <summary>
    /// Represents possible values returned by the MessageBox function.
    /// </summary>
    public enum MessageBoxResult : uint
    {
        Ok = 1, Cancel, Abort, Retry, Ignore,
        Yes, No, Close, Help, TryAgain, Continue,
        Timeout = 32000
    }

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern MessageBoxResult MessageBox(IntPtr hWnd,
        String text, String caption, MessageBoxOptions options);

    [DllImport("msvcrt.dll", EntryPoint = "printf",
        CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
    public static extern int printf(String format, String arg1, String arg2);

}