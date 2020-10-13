========================================================================
    CONSOLE APPLICATION : CSPInvokeDll Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

Platform Invocation Services (PInvoke) in .NET allows managed code to call  
unmanaged functions that are implemented and exported in unmanaged DLLs. This 
sample shows you what you need to do to be able to call the exported 
functions in the unmanaged DLLs like CppDllExport.dll, msvcrt.dll, from C#.


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CSPInvokeDll -> CppDllExport
CSPInvokeDll, a .NET executable, dynamically loads the native DLL and uses 
its symbols through P/Invoke.


/////////////////////////////////////////////////////////////////////////////
Creation:

A. Declaring the methods as having an implementation from a DLL export.

Step1. Declare the method with the static and extern C# keywords.

Step2. Attach the DllImport attribute to the method. The DllImport attribute 
allows us to specify the name of the DLL that contains the method. The common 
practice is to name the C# method the same as the exported method, but we can
also use a different name for the C# method. 
 
Optionally, specify custom marshaling information for the method's parameters
and return value, which will override the .NET Framework default marshaling. 

These tools may help writing the declartion.

	Dumpbin: View the export table of a DLL

	PInvoke.NET: PInvoke.net is primarily a wiki, allowing developers to find, 
	edit and add PInvoke* signatures, user-defined types, and any other info 
	related to calling Win32 and other unmanaged APIs from managed code such 
	as C# or VB.NET.
	
	PInvoke Interop Assistant: It is a toolkit that helps developers to 
	efficiently convert from C to managed P/Invoke signatures or verse visa. 

B. Calling the methods through the PInvoke signatures. For example:

	[DllImport("CppDllExport.dll", CharSet = CharSet.Auto)]
    public static extern void HelloWorld1(out string pRet);

	NativeMethod.HelloWorld1(out result);


/////////////////////////////////////////////////////////////////////////////
References:

Platform Invoke Tutorial
http://msdn.microsoft.com/en-us/library/aa288468.aspx

Using P/Invoke to Call Unmanaged APIs from Your Managed Classes
http://msdn.microsoft.com/en-us/library/aa719104.aspx

Calling Win32 DLLs in C# with P/Invoke
http://msdn.microsoft.com/en-us/magazine/cc164123.aspx

PInvoke.NET
http://www.pinvoke.net/

PInvoke Interop Assistant 
http://www.codeplex.com/clrinterop


/////////////////////////////////////////////////////////////////////////////
