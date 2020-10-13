========================================================================
    DYNAMIC LINK LIBRARY : CppDllExport Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

This sample Win32 DLL demonstrates exporting data, methods and classes for 
use in C or C++ language executable. Two methods are used to export the 
symbols:

1. Export symbols from a DLL using .DEF files

A module-definition (.DEF) file is a text file containing one or more module 
statements that describe various attributes of a DLL. Create a .DEF file and 
use the .def file when building the DLL. Using this approach, we can export 
functions from the DLL by ordinal rather than by name. 

2. Export symbols from a DLL using __declspec(dllexport) 

__declspec(dllexport) adds the export directive to the object file so we do 
not need to use a .def file. This convenience is most apparent when trying to
export decorated C++ function names. 

The sample DLL exports these symbols:

// Data
g_nVal1
g_nVal2

// Ordinary Functions
HelloWorld1				// void /*__cdecl*/ HelloWorld1(_TCHAR** pRet);
StdHelloWorld1			// void __stdcall StdHelloWorld1(_TCHAR** pRet);
HelloWorld2				// void /*__cdecl*/ HelloWorld2(_TCHAR** pRet);
_StdHelloWorld2@4		// void __stdcall StdHelloWorld2(_TCHAR** pRet);

// Callback Functions
g_pFunc1
FunctionA				// int FunctionA(void);
g_pFunc2
FunctionB				// int FunctionB(void);
Max						// int __stdcall Max(int a, int b, PFN_COMPARE cmpFunc)

// Class
??0CppSimpleClass@@QAE@XZ
??4CppSimpleClass@@QAEAAV0@ABV0@@Z
?get_FloatProperty@CppSimpleClass@@QAEMXZ
?set_FloatProperty@CppSimpleClass@@QAEXM@Z


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CppImplicitlyLinkDll -> CppDllExport
CppImplicitlyLinkDll implicitly links (staticly loads) the DLL and uses its 
symbols.

CppDelayloadDll -> CppDllExport
CppDelayloadDll delay-loads the DLL and uses its symbols.

CppLoadLibrary -> CppDllExport
CppLoadLibrary dynamically loads the DLL and uses its symbols.

CSLoadLibrary -> CppDllExport
CSLoadLibrary, a .NET executable, dynamically loads the native DLL and uses
its symbols through the APIs: LoadLibrary, GetProcAddress and FreeLibrary.

CSPInvokeDll -> CppDllExport
CSPInvokeDll, a .NET executable, dynamically loads the native DLL and uses 
its symbols through P/Invoke.


/////////////////////////////////////////////////////////////////////////////
Creation:

A. Creating the project

Step1. Create a Visual C++ / Win32 / Win32 Project named CppDllExport in 
Visual Studio 2008.

Step2. In the page "Application Settings" of Win32 Application Wizard, select
Application type as DLL, and check the Export symbols checkbox. Click Finish.

B. Exporting symbols from a DLL using .DEF files

Step1. Declare the data, methods to be exported in the header file. Define 
them in the corresponding .cpp file.

Step2. Add a .DEF file named CppDllExport.def to the project. Modify the .DEF
file based on this skeleton:

	LIBRARY   CppDllExport
	EXPORTS
	   DataName		@1
	   MethodName   @2

Step3. In order that the DLL project recognizes the existence of the .DEF file, 
right-click the project and open its Properties dialog. In the page Linker / 
Input, set the value of Module Definition File (/DEF:) to be CppDllExport.DEF.

C. Exporting symbols from a DLL using __declspec(dllexport)

Step1. Create the following #ifdef block in the header file to make exporting 
& importing from a DLL simpler. (This should be automatically added if we 
check the Export symbols checkbox when creating the project.)

	#ifdef CPPDLLEXPORT_EXPORTS
	#define SYMBOL_DECLSPEC __declspec(dllexport)
	#else
	#define SYMBOL_DECLSPEC __declspec(dllimport)
	#endif

Step2. Add SYMBOL_DECLSPEC to the left of the calling-convention keyword of 
the symbols to be exported with __declspec(dllexport). For example, 

	SYMBOL_DECLSPEC void /*__cdecl*/ HelloWorld2(_TCHAR** pRet);

For those data and methods that will be accessed from the C language modules 
or dynamically linked by any executable, add extern "C" to the symbols' 
declarations to specify C linkage. This removes the C++ type-safe naming 
(also known as name decoration).


/////////////////////////////////////////////////////////////////////////////
References:

Exporting from a DLL
http://msdn.microsoft.com/en-us/library/z4zxe9k8.aspx

Exporting from a DLL Using DEF Files
http://msdn.microsoft.com/en-us/library/d91k01sh.aspx

Exporting from a DLL Using __declspec(dllexport)
http://msdn.microsoft.com/en-us/library/a90k134d.aspx

Creating and Using a Dynamic Link Library (C++)
http://msdn.microsoft.com/en-us/library/ms235636.aspx

HOWTO: How To Export Data from a DLL or an Application
http://support.microsoft.com/kb/90530

Dynamic-link library
http://en.wikipedia.org/wiki/Dynamic_link_library

Stdcall and DLL tools of MSVC and MinGW
http://wyw.dcweb.cn/stdcall.htm

A Crash Course In Exporting From A DLL
http://home.hiwaay.net/~georgech/WhitePapers/Exporting/Exp.htm


/////////////////////////////////////////////////////////////////////////////