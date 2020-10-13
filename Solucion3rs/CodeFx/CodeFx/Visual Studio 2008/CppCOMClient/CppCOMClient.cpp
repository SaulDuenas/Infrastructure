/****************************** Module Header ******************************\
* Module Name:	CppCOMClient.cpp
* Project:		
* Copyright (c) Microsoft Corporation.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/11/2009 2:54 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"

#include "RawAPI.h"				// The examples of using the raw COM API to  
								// consume a COM server
#include "ImportDirective.h"	// The examples of using the #import directive 
								// and smart pointers to consume a COM server
#pragma endregion


int _tmain(int argc, _TCHAR* argv[])
{
	HANDLE hThread;

	hThread = CreateThread(NULL, 0, RawConsumeSTAComponent, NULL, 0, NULL);
	WaitForSingleObject(hThread, INFINITE);
	CloseHandle(hThread);

	hThread = CreateThread(NULL, 0, ImportCSharpComponent, NULL, 0, NULL);
	WaitForSingleObject(hThread, INFINITE);	
	CloseHandle(hThread);

	return 0;
}

