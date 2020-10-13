/****************************** Module Header ******************************\
* Module Name:	CppLoadLibrary.cpp
* Project:		CppLoadLibrary
* Copyright (c) Microsoft Corporation.
* 
* This is an example of dynamically loading a DLL using the APIs LoadLibrary, 
* GetProcAddress and FreeLibrary. In contrast with implicit linking (static 
* loading), dynamic loading does not require the LIB file, and the  
* application loads the module just before we call a function in the DLL. 
* The API functions LoadLibrary and GetProcAddress are used to load the DLL 
* and then retrieve the address of a function in the export table. Because 
* we explicitly invoke these APIs, this kind of loading is also referred to 
* as explicit linking. 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/21/2009 11:04 PM Jialiang Ge Created
* * 3/22/2009 5:48 PM Jialiang Ge Reviewed
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"

#include <windows.h>
#include <assert.h>
#pragma endregion


// The declarations of the functions exported from the module

typedef void	(* LPFNHELLOWORLD1)				(_TCHAR**);
// CALLBACK, aka __stdcall, can only be used for stdcall methods. If it is
// used for __cdecl methods, this error will be thrown in runtime: The value 
// of ESP was not properly saved across a function call. This is usually a 
// result of calling a function declared with one calling convention with a
// function pointer declared with a different calling convention.
typedef void	(CALLBACK* LPFNSTDHELLOWORLD1)	(_TCHAR**);
typedef void	(* LPFNHELLOWORLD2)				(_TCHAR**);
typedef void	(CALLBACK* LPFNSTDHELLOWORLD2)	(_TCHAR**);


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
	// The name of the module to be dynamically-loaded.
	TCHAR szModuleName[] = _T("CppDllExport");

	// Check whether or not the module is loaded.
	IsModuleLoaded(szModuleName);

	// Dynamically load the library.
	HINSTANCE hModule = LoadLibrary(_T("CppDllExport"));
	if (hModule != NULL)
	{
		// Check whether or not the module is loaded.
		IsModuleLoaded(szModuleName);

		// Call a cdecl method exported using a DEF file.
		// void HelloWorld1(_TCHAR** pRet);
		{
			LPFNHELLOWORLD1 lpfnHelloWorld1 = (LPFNHELLOWORLD1)
				GetProcAddress(hModule, "HelloWorld1");
			assert(lpfnHelloWorld1);

			_TCHAR* result;
			lpfnHelloWorld1(&result);
			_tprintf(_T("Call HelloWorld1 => %s\n"), result);
		}

		// Call a stdcall method exported using a DEF file.
		// void StdHelloHelloWorld1(_TCHAR** pRet);
		{
			LPFNSTDHELLOWORLD1 lpfnStdHelloWorld1 = (LPFNSTDHELLOWORLD1)
				GetProcAddress(hModule, "StdHelloWorld1");
			assert(lpfnStdHelloWorld1);

			_TCHAR* result;
			lpfnStdHelloWorld1(&result);
			_tprintf(_T("Call StdHelloWorld1 => %s\n"), result);
		}

		// Call a cdecl __declspec(dllexport/dllimport) method.
		// void HelloWorld2(_TCHAR** pRet);
		{
			LPFNHELLOWORLD2 lpfnHelloWorld2 = (LPFNHELLOWORLD2)
				GetProcAddress(hModule, "HelloWorld2");
			assert(lpfnHelloWorld2);

			_TCHAR* result;
			lpfnHelloWorld2(&result);
			_tprintf(_T("Call HelloWorld2 => %s\n"), result);
		}

		// Call a stdcall __declspec(dllexport/dllimport) method.
		// void StdHelloWorld2(_TCHAR** pRet);
		{
			LPFNSTDHELLOWORLD2 lpfnStdHelloWorld2 = (LPFNSTDHELLOWORLD2)
				GetProcAddress(hModule, "_StdHelloWorld2@4");
			assert(lpfnStdHelloWorld2);

			_TCHAR* result;
			lpfnStdHelloWorld2(&result);
			_tprintf(_T("Call StdHelloWorld2 => %s\n"), result);
		}

		// Attempt to free the library.
		_tprintf(_T("FreeLibrary => %d\n"), FreeLibrary(hModule));

		// Check whether or not the module is loaded.
		IsModuleLoaded(szModuleName);
	}

	return 0;
}

