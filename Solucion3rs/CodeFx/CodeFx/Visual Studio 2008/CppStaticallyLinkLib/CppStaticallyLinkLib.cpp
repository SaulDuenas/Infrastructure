/****************************** Module Header ******************************\
* Module Name:	CppStaticallyLinkLib.cpp
* Project:		CppStaticallyLinkLib
* Copyright (c) Microsoft Corporation.
* 
* This sample demonstrates statically linking CppStaticLibrary.lib and using 
* its functionalities.
* 
* There are several advantages to statically linking libraries with an 
* executable instead of dynamically linking them. The most significant is  
* that the application can be certain that all its libraries are present and 
* that they are the correct version. This avoids dependency problems. In some 
* cases, static linking can result in a performance improvement. Static 
* linking can also allow the application to be contained in a single 
* executable file, simplifying distribution and installation. On the other 
* hand, statically linking libraries with the executable increases its size. 
* This is because the library code is stored within the executable rather 
* than in separate files. 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 3/22/2009 5:32 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"

// The header files of the LIB to be linked
#include "CppSimpleClass.h"
#include "CppLibFuncs.h"
#pragma endregion


int _tmain(int argc, _TCHAR* argv[])
{
	// Call a cdecl method in CppLibFuncs.h
	// void HelloWorld(_TCHAR** pRet);
	{
		_TCHAR* result;
		HelloWorld(&result);
		_tprintf(_T("Call HelloWorld => %s\n"), result);
	}

	// Call a stdcall method in CppLibFuncs.h
	// void StdHelloWorld(_TCHAR** pRet);
	{
		_TCHAR* result;
		StdHelloWorld(&result);
		_tprintf(_T("Call StdHelloWorld => %s\n"), result);
	}

	// Use a class in CppSimpleClass.h
	// CppSimpleClass
	{
		CppSimpleClass simpleObj;
		simpleObj.set_FloatProperty(1.2F);
		float result = simpleObj.get_FloatProperty();
		_tprintf(_T("Get FloatProperty = %.2f\n"), result);
	}

	return 0;
}

