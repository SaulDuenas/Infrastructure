/****************************** Module Header ******************************\
* Module Name:	CppLibFuncs.h
* Project:		CppStaticLibrary
* Copyright (c) Microsoft Corporation.
* 
* The header of the functions in the static library.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 3/22/2009 4:40 PM Jialiang Ge Created
\***************************************************************************/

#pragma once


void /*__cdecl*/ HelloWorld(_TCHAR** pRet);

void __stdcall StdHelloWorld(_TCHAR** pRet);