/****************************** Module Header ******************************\
* Module Name:	CppAutomateOutlook.cpp
* Project:		CppAutomateOutlook
* Copyright (c) Microsoft Corporation.
* 
* The CppAutomateOutlook example demonstrates how to write VC++ codes to 
* automate Microsoft Outlook to send a mail item and enumerate contact items. 
* 
* There are three basic ways you can write VC++ automation codes:
* 
* 1. Automating Outlook using C++ and the COM APIs (RawAPI.h/cpp)
* 2. Automating Outlook using the #import directive and smart pointers 
* (ImportDirecive.h/cpp)
* 3. Automating Outlook using MFC (MFCAutomateOutlook)
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/27/2009 12:00 AM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"

#include "RawAPI.h"				// The example of using the raw COM API to  
								// automate Outlook
#include "ImportDirective.h"	// The example of using the #import directive 
								// and smart pointers to automate Outlook
#pragma endregion


int _tmain(int argc, _TCHAR* argv[])
{
	HANDLE hThread;

	hThread = CreateThread(NULL, 0, RawAutomateOutlook, NULL, 0, NULL);
	WaitForSingleObject(hThread, INFINITE);
	CloseHandle(hThread);

	/*hThread = CreateThread(NULL, 0, ImportOutlook, NULL, 0, NULL);
	WaitForSingleObject(hThread, INFINITE);
	CloseHandle(hThread);*/

	return 0;
}