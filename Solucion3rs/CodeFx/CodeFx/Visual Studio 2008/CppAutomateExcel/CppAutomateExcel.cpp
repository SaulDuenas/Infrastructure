/****************************** Module Header ******************************\
* Module Name:	CppAutomateExcel.cpp
* Project:		CppAutomateExcel
* Copyright (c) Microsoft Corporation.
* 
* The CppAutomateExcel example demonstrates how to write VC++ codes to create 
* a Microsoft Excel instance, create a workbook, and fill data into the 
* specified range, as well as how to clean up unmanaged COM resources and 
* quit the Excel application properly.
* 
* There are three basic ways you can write VC++ automation codes:
* 
* 1. Automating Excel using C++ and the COM APIs (RawAPI.h/cpp)
* 2. Automating Excel using the #import directive and smart pointers 
* (ImportDirecive.h/cpp)
* 3. Automating Excel using MFC (MFCAutomateExcel)
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/19/2009 12:10 AM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"

#include "RawAPI.h"				// The example of using the raw COM API to  
								// automate Excel
#include "ImportDirective.h"	// The example of using the #import directive 
								// and smart pointers to automate Excel
#pragma endregion


int _tmain(int argc, _TCHAR* argv[])
{
	HANDLE hThread;

	hThread = CreateThread(NULL, 0, RawAutomateExcel, NULL, 0, NULL);
	WaitForSingleObject(hThread, INFINITE);
	CloseHandle(hThread);

	_putts(_T(""));

	hThread = CreateThread(NULL, 0, ImportExcel, NULL, 0, NULL);
	WaitForSingleObject(hThread, INFINITE);	
	CloseHandle(hThread);

	return 0;
}