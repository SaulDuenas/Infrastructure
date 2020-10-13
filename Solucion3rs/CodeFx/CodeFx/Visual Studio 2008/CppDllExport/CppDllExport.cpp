/****************************** Module Header ******************************\
* Module Name:	CppDllExport.cpp
* Project:		CppDllExport
* Copyright (c) Microsoft Corporation.
* 
* Defines the exported functions for the DLL application.
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

#pragma region Includes
#include "stdafx.h"
#include "CppDllExport.h"
#pragma endregion


/////////////////////////////////////////////////////////////////////////////
// 1. Export symbols from a DLL using .DEF files.
// 

// An exported/imported global data with a DEF file
// Initialize it to be 1
int g_nVal1 = 1;

// An exported/imported cdecl(default) method with a DEF file
void /*__cdecl*/ HelloWorld1(_TCHAR** pRet)
{
	*pRet = _T("HelloWorld");
}

// An exported/imported stdcall method with a DEF file
void __stdcall StdHelloWorld1(_TCHAR** pRet)
{
	*pRet = _T("HelloWorld");
}

// An exported/imported global function pointer data with a DEF file
// Initialize to be NULL
void (CALLBACK *g_pFunc1)(void) = NULL;

// An exported/imported cdecl(default) method with a DEF file. Inside the 
// function, it calls the function pointed by function pointer g_pFunc1.
int FunctionA()
{
	if (g_pFunc1 != NULL)
	{
		g_pFunc1();
		return 1;
	}
	return 0;
}


/////////////////////////////////////////////////////////////////////////////
// 2. Export symbols from a DLL using __declspec(dllexport).
// 

// A dllexport-ed/dllimport-ed global data
// Initialize it to be 2
SYMBOL_DECLSPEC int g_nVal2 = 2;

// A dllexport-ed/dllimport-ed cdecl(default) method
SYMBOL_DECLSPEC void /*__cdecl*/ HelloWorld2(_TCHAR** pRet)
{
	*pRet = _T("HelloWorld");
}

// A dllexport-ed/dllimport-ed stdcall method
SYMBOL_DECLSPEC void __stdcall StdHelloWorld2(_TCHAR** pRet)
{
	*pRet = _T("HelloWorld");
}

// A dllexport-ed/dllimport-ed global function pointer data
// Initialize it to be NULL
SYMBOL_DECLSPEC void (CALLBACK *g_pFunc2)(void) = NULL;

// A dllexport-ed/dllimport-ed stdcall method
SYMBOL_DECLSPEC int FunctionB()
{
	if (g_pFunc2 != NULL)
	{
		g_pFunc2();
		return 1;
	}
	return 0;
}

// A dllexport-ed/dllimport-ed class
CppSimpleClass::CppSimpleClass() : m_fField(0.0f)
{
}

float CppSimpleClass::get_FloatProperty()
{
	return this->m_fField;
}

void CppSimpleClass::set_FloatProperty(float newVal)
{
	this->m_fField = newVal;
}


/////////////////////////////////////////////////////////////////////////////
// 3. Export symbols from a DLL by mixing DEF file and __declspec(dllexport).
// 

SYMBOL_DECLSPEC int __stdcall Max(int a, int b, PFN_COMPARE cmpFunc)
{
	// Make the callback to the comparison function

	// If a is greater than b, return a.
	if (1 == (*cmpFunc)(a, b)) return a;	
	// If b is greater than or equal to a, return b.
	return b;
}