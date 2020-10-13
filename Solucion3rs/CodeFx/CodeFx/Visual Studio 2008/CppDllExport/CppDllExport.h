/****************************** Module Header ******************************\
* Module Name:	CppDllExport.h
* Project:		CppDllExport
* Copyright (c) Microsoft Corporation.
* 
* This sample Win32 DLL demonstrates exporting data, methods and classes for 
* use in C or C++ language executables. Two methods are used to export the 
* symbols:
* 
* 1. Export symbols from a DLL using .DEF files
* 
* A module-definition (.DEF) file is a text file containing one or more  
* module statements that describe various attributes of a DLL. Create a .DEF 
* file and use the .def file when building the DLL. Using this approach, we 
* can export functions from the DLL by ordinal rather than by name. 
* 
* 2. Export symbols from a DLL using __declspec(dllexport) 
* 
* __declspec(dllexport) adds the export directive to the object file so we do 
* not need to use a .def file. This convenience is most apparent when trying 
* to export decorated C++ function names. 
* 
* Examples
*  http://support.microsoft.com/kb/90530
*  http://msdn.microsoft.com/en-us/library/d91k01sh.aspx
*  http://msdn.microsoft.com/en-us/library/a90k134d.aspx
*  http://www.codeproject.com/KB/DLL/XDllPt1.aspx
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

#pragma once

#pragma region Include
#include <windows.h>
#include <tchar.h>
#pragma endregion


// The following #ifdef block is the standard way of creating macros which 
// make exporting from a DLL simpler. All files within the DLL are compiled 
// with the CPPDLLEXPORT_EXPORTS symbol defined in preprocessor. The symbol 
// should not be defined on any project that uses this DLL. In this way any 
// other project whose source files include this file see SYMBOL_DECLSPEC 
// elements as being imported from a DLL, whereas this DLL sees symbols 
// defined with this macro as being exported.

#ifdef CPPDLLEXPORT_EXPORTS
#define SYMBOL_DECLSPEC __declspec(dllexport)
#define SYMBOL_DEF
#else
#define SYMBOL_DECLSPEC	__declspec(dllimport)
#define SYMBOL_DEF		__declspec(dllimport)
#endif


/////////////////////////////////////////////////////////////////////////////
// 1. Export symbols from a DLL using .DEF files.
// 

#pragma region Global Data

// An exported/imported global data with a DEF file
// Sym: g_nVal1
// See: CppDllExport.def
//      CppDllExport.cpp
// Ref: http://support.microsoft.com/kb/90530

#pragma endregion


#pragma region Ordinary Functions

// An exported/imported cdecl(default) method with a DEF file.
// The default calling convention of the exported function is _cdecl 
// Sym: HelloWorld1
// See: Project Properties / C/C++ / Advanced / Calling Convention
//		CppDllExport.def
//      CppDllExport.cpp
// Ref: http://msdn.microsoft.com/en-us/library/d91k01sh.aspx
SYMBOL_DEF void /*__cdecl*/ HelloWorld1(_TCHAR** pRet);

// An exported/imported stdcall method with a DEF file.
// Sym: StdHelloWorld1
// See: CppDllExport.def
//      CppDllExport.cpp
// Ref: http://msdn.microsoft.com/en-us/library/d91k01sh.aspx
SYMBOL_DEF void __stdcall StdHelloWorld1(_TCHAR** pRet);

#pragma endregion


#pragma region Callback Functions

// An exported/imported global function pointer data with a DEF file
// Sym: g_pFunc1
// See: CppDllExport.def
//      CppDllExport.cpp

// An exported/imported cdecl(default) method with a DEF file. Inside the 
// function, it calls the function pointed by function pointer g_pFunc1.
// Sym: FunctionA
// See: CppDllExport.def
//      CppDllExport.cpp
SYMBOL_DEF int FunctionA(void);

#pragma endregion


/////////////////////////////////////////////////////////////////////////////
// 2. Export symbols from a DLL using __declspec(dllexport).
// 

#pragma region Global Data

// A dllexport-ed/dllimport-ed global data
// Sym: g_nVal2
// See: CppDllExport.cpp
// Ref: http://support.microsoft.com/kb/90530
EXTERN_C SYMBOL_DECLSPEC int g_nVal2;

#pragma endregion


#pragma region Ordinary Functions

// A dllexport-ed/dllimport-ed cdecl(default) method
// The default calling convention of the exported function is _cdecl 
// Sym: HelloWorld2
// See: Project Properties / C/C++ / Advanced / Calling Convention
//		CppDllExport.cpp
// Ref: http://msdn.microsoft.com/en-us/library/a90k134d.aspx
EXTERN_C SYMBOL_DECLSPEC void /*__cdecl*/ HelloWorld2(_TCHAR** pRet);

// A dllexport-ed/dllimport-ed stdcall method.
// Sym: _StdHelloWorld2@4
// See: CppDllExport.cpp
// Ref: http://msdn.microsoft.com/en-us/library/a90k134d.aspx
EXTERN_C SYMBOL_DECLSPEC void __stdcall StdHelloWorld2(_TCHAR** pRet);

#pragma endregion


#pragma region Callback Functions

// An dllexport-ed/dllimport-ed global function pointer data
// Sym: g_pFunc2
// See: CppDllExport.cpp
EXTERN_C SYMBOL_DECLSPEC void (CALLBACK *g_pFunc2)(void);

// A dllexport-ed/dllimport-ed cdecl(default) method. Inside the function, 
// it calls the function pointed by function pointer g_pFunc2.
// Sym: FunctionB
// See: CppDllExport.cpp
EXTERN_C SYMBOL_DECLSPEC int FunctionB(void);

#pragma endregion


#pragma region Class

// A dllexport-ed/dllimport-ed class.
// It exports/imports all of the public data members and the methods.
// Sym: ??0CppSimpleClass@@QAE@XZ
// See: CppDllExport.cpp
// Ref: http://msdn.microsoft.com/en-us/library/a90k134d.aspx
class SYMBOL_DECLSPEC CppSimpleClass
{
private:
	float m_fField;

public:
	// Constructor
	CppSimpleClass();

	// Property
	float get_FloatProperty();
	void set_FloatProperty(float newVal);
};

#pragma endregion


/////////////////////////////////////////////////////////////////////////////
// 3. Export symbols from a DLL by mixing DEF file and __declspec(dllexport).
// 

#pragma region Callback Functions

// Type-definition: 'PFN_COMPARE' now can be used as type
typedef int (CALLBACK *PFN_COMPARE)(int, int);
// A dllexport-ed/dllimport-ed stdcall method with a DEF file (Because of the
// DEF file, the decoration of stdcall is removed in the exported symbol).
// It requires callback as one of the arguments.
// Sym: Max
// See: CppDllExport.cpp
EXTERN_C SYMBOL_DECLSPEC int __stdcall Max(int a, int b, PFN_COMPARE cmpFunc);

#pragma endregion