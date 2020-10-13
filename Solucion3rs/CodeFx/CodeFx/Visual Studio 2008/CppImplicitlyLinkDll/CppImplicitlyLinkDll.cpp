/****************************** Module Header ******************************\
* Module Name:	CppImplicitlyLinkDll.cpp
* Project:		CppImplicitlyLinkDll
* Copyright (c) Microsoft Corporation.
* 
* Normally, when we link to a DLL via a LIB file, the DLL is loaded when the  
* application starts up. This kind of loading is kwown as implicit linking,  
* because the system takes care of loading the DLL for us - all we need to  
* do is link with the LIB file.
* 
* After the configuration of linking, we can import symbols of a DLL into  
* the application using the keyword __declspec(dllimport) no matter whether  
* the symbols were exported with __declspec(dllexport) or with a .def file.
* 
* This sample demonstrates implicitly linking CppDllExport.dll and importing 
* and using its symbols.
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

#pragma region Includes and Imports
#include "stdafx.h"

#include "CppDllExport.h" // The header file of the DLL to be loaded
#pragma endregion


/*!
 * \brief
 * Check whether or not the specified module is loaded in the current process.
 * 
 * \param pszModuleName
 * The module name
 */
void IsModuleLoaded(PCTSTR pszModuleName) 
{
	// Get the module in the process according to the module name.
	HMODULE hmod = GetModuleHandle(pszModuleName);

	_tprintf(_T("Module \"%s\" is %sloaded.\n"), pszModuleName, 
		(hmod == NULL) ? _T("not ") : _T(""));
}


/*!
 * \brief
 * The callback function for the method Max exported from CppDllExport.dll
 * 
 * \param a
 * The first element.
 * 
 * \param b
 * The second element.
 * 
 * \returns
 * 1:	if a > b
 * -1:	if a < b
 * 0:	if a == b
 * 
 * \see
 * Max in CppDllExport
 */
int CALLBACK CompareInts(int a, int b)
{
	if (a < b)
		return -1;
	if (a > b)
		return 1;
	return 0;
}

/*!
 * \brief
 * The callback function for the function pointers g_pFunc1 and g_pFunc2 
 * exposed from CppDllExport.dll
 * 
 * \see
 * g_pFunc1 and g_pFunc2 in CppDllExport
 */
void CALLBACK CallbackFunc(void)
{
	_putts(_T("CallbackFunc is called"));
}

int _tmain(int argc, _TCHAR* argv[])
{
	// The name of the module that is implicitly-linked.
	TCHAR szModuleName[] = _T("CppDllExport");

	// Check whether or not the module is loaded.
	IsModuleLoaded(szModuleName);


#pragma region Access Global Data

	// Import the global data exported by the module.
	{
		// g_nVal1 was exported using a .def file, and is imported using
		// __declspec(dllimport)
		__declspec(dllimport) int g_nVal1;
		_tprintf(_T("Get g_nVal1 => %d\n"), g_nVal1);

		// g_nVal2 was exported using __declspec(dllexport), and is imported  
		// using __declspec(dllimport)
		_tprintf(_T("Get g_nVal2 => %d\n"), g_nVal2);
	}

#pragma endregion


#pragma region Call Ordinary Functions

	// Call a stdcall method exported using a DEF file.
	// void StdHelloWorld1(_TCHAR** pRet);
	{
		_TCHAR* result;
		StdHelloWorld1(&result);
		_tprintf(_T("Call StdHelloWorld1 => %s\n"), result);
	}

	// Call a stdcall __declspec(dllexport/dllimport) method.
	// void StdHelloWorld2(_TCHAR** pRet);
	{
		_TCHAR* result;
		StdHelloWorld2(&result);
		_tprintf(_T("Call StdHelloWorld2 => %s\n"), result);
	}

#pragma endregion


#pragma region Call Callback Functions

	// Call a method that calls back through a gloabl function pointer.
	{
		// g_pFunc1 was exported using a .def file, and is imported using 
		// __declspec(dllimport)
		__declspec(dllimport) void (CALLBACK *g_pFunc1)(void);
		g_pFunc1 = &CallbackFunc;
		int result = FunctionA();
		_tprintf(_T("Call FunctionA => %d\n"), result);
	}

	// Call a method that calls back through a gloabl function pointer.
	{
		// g_pFunc2 was exported using __declspec(dllexport), and is imported  
		// using __declspec(dllimport)
		g_pFunc2 = &CallbackFunc;
		int result = FunctionB();
		_tprintf(_T("Call FunctionB => %d\n"), result);
	}

	// Call a method that requires callback as one of the arguments.
	// typedef int (CALLBACK *PFN_COMPARE)(int, int);
	// int __stdcall Max(int a, int b, PFN_COMPARE cmpFunc);
	{
		int result = Max(2, 3, &CompareInts);
		_tprintf(_T("Call Max(2, 3) => %d\n"), result);
	}

#pragma endregion


#pragma region Access Class

	// Use a _declspec(dllexport/dllimport) class. 
	{
		CppSimpleClass simpleObj;
		simpleObj.set_FloatProperty(1.2F);
		float result = simpleObj.get_FloatProperty();
		_tprintf(_T("Get FloatProperty = %.2f\n"), result);
	}

#pragma endregion


	// Attempt to free the library.
	HMODULE hmod = GetModuleHandle(szModuleName);
	FreeLibrary(hmod);

	// Check whether or not the module is loaded.
	IsModuleLoaded(szModuleName);

	return 0;
}