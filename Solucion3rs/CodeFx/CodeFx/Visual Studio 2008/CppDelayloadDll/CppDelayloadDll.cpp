/****************************** Module Header ******************************\
* Module Name:	CppDelayloadDll.cpp
* Project:		CppDelayloadDll
* Copyright (c) Microsoft Corporation.
* 
* The support of delayed loading of DLLs in Visual C++ linker relieves us of 
* the need to use the API LoadLibrary and GetProcAddress to implement DLL 
* delayed loading. DLL is implicitly linked but not actually loaded until the 
* code attempts to reference a symbol contained within the DLL. An  
* application can delay load a DLL using the /DELAYLOAD (Delay Load Import) 
* linker option with a helper function (default implementation provided by 
* Visual C++, see http://msdn.microsoft.com/en-us/library/09t6x5ds.aspx). The 
* helper function will load the DLL at run time by calling LoadLibrary and 
* GetProcAddress for us. 
* 
* We should consider delay loading a DLL if the program may not call a 
* function in the DLL or a function in the DLL may not get called until late 
* in the program's execution. Delay loading a DLL saves the initialization 
* time when the executable files starts up.
* 
* This sample demonstrates delay loading CppDllExport.dll, importing and 
* using its symbols, and unloading the module.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/21/2009 11:03 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes and Imports
#include "stdafx.h"
#include <windows.h>

#include "CppDllExport.h" // The header file of the DLL to be delay-loaded

// For error handling & advanced features (e.g. Unload the delayloaded DLL)
#include <Delayimp.h>

// This line is not necessary because VS setting automatically imports
// delayimp.lib when we specify one or more DLLs for delay loading.
// #pragma comment(lib, "Delayimp.lib")
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

int _tmain(int argc, _TCHAR* argv[])
{
	// The name of the module to be delay-loaded.
	TCHAR szModuleName[] = _T("CppDllExport");

	// Check whether or not the module is loaded.
	IsModuleLoaded(szModuleName);

	// Import the data exported from the module.
	{
		// Delay-load does not allow accessing/dllimport-ing data symbols. 
		// The following line produce the fatal error LNK1194.

		/*__declspec(dllimport) int g_nVal1;
		_tprintf(_T("Get g_nVal1 => %d\n"), g_nVal1);*/

		/*_tprintf(_T("Get g_nVal2 => %d\n"), g_nVal2);*/
	}

	// Call a method exported using a DEF file.
	// void HelloWorld1(_TCHAR** pRet);
	{
		_TCHAR* result;
		HelloWorld1(&result);
		_tprintf(_T("Call HelloWorld1 => %s\n"), result);
	}

	// Call a __declspec(dllexport/dllimport) method.
	// SYMBOL_DECLSPEC void HelloWorld2(_TCHAR** pRet);
	{
		_TCHAR* result;
		HelloWorld2(&result);
		_tprintf(_T("Call HelloWorld2 => %s\n"), result);
	}

	// Use a _declspec(dllexport/dllimport) class. 
	{
		CppSimpleClass simpleObj;
		simpleObj.set_FloatProperty(1.2F);
		float result = simpleObj.get_FloatProperty();
		_tprintf(_T("Get FloatProperty = %.2f\n"), result);
	}

	// Check whether or not the module is loaded.
	IsModuleLoaded(szModuleName);

	// Unload the delay-loaded DLL
	{
		// NOTE: pszDll of __FUnloadDelayLoadedDLL2 must exactly match
		// /DelayLoad:(DllName)
		// In Project Properies / Linker / Advanced / Delay Loaded DLL, we 
		// need to select Support Unload (/DELAY:UNLOAD). If we choose 
		// "Don't Support Unload", calling __FUnloadDelayLoadedDLL2 fails
		// to unload the module. 
		PCSTR pszDll = "CppDllExport.dll";
		_tprintf(_T("__FUnloadDelayLoadedDLL2 => %d\n"),
			__FUnloadDelayLoadedDLL2(pszDll));
	}

	// Check whether or not the module is loaded.
	IsModuleLoaded(szModuleName);

	return 0;
}

