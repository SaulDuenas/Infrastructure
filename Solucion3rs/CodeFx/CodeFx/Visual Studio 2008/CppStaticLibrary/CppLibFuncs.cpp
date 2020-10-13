/****************************** Module Header ******************************\
* Module Name:	CppLibFuncs.cpp
* Project:		CppStaticLibrary
* Copyright (c) Microsoft Corporation.
* 
* The implementation of the functions in the static library.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 3/22/2009 4:40 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include "CppLibFuncs.h"
#pragma endregion


void /*__cdecl*/ HelloWorld(_TCHAR** pRet)
{
	*pRet = _T("HelloWorld");
}

void __stdcall StdHelloWorld(_TCHAR** pRet)
{
	*pRet = _T("HelloWorld");
}