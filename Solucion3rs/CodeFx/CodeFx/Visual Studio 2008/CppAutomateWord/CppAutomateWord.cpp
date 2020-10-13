/****************************** Module Header ******************************\
* Module Name:	CppAutomateWord.cpp
* Project:		CppAutomateWord
* Copyright (c) Microsoft Corporation.
* 
* The CppAutomateWord example demonstrates how to write VC++ codes to create 
* a Microsoft Word instance, create a new document, insert a paragraph and a 
* table, as well as how to clean up unmanaged COM resources and quit the Word 
* application properly.
* 
* There are three basic ways you can write VC++ automation codes:
* 
* 1. Automating Word using C++ and the COM APIs (RawAPI.h/cpp)
* 2. Automating Word using the #import directive and smart pointers 
* (ImportDirecive.h/cpp)
* 3. Automating Word using MFC (MFCAutomateWord)
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
								// automate Word
#include "ImportDirective.h"	// The example of using the #import directive 
								// and smart pointers to automate Word
#pragma endregion


int _tmain(int argc, _TCHAR* argv[])
{
	HANDLE hThread;

	hThread = CreateThread(NULL, 0, RawAutomateWord, NULL, 0, NULL);
	WaitForSingleObject(hThread, INFINITE);
	CloseHandle(hThread);

	_putts(_T(""));

	hThread = CreateThread(NULL, 0, ImportWord, NULL, 0, NULL);
	WaitForSingleObject(hThread, INFINITE);	
	CloseHandle(hThread);

	return 0;
}