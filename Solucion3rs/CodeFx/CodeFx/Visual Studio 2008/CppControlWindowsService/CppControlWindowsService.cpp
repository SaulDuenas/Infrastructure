/****************************** Module Header ******************************\
* Module Name:	CppControlWindowsService.cpp
* Project:		CppControlWindowsService
* Copyright (c) Microsoft Corporation.
* 
* 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 7/9/2009 11:50 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include <windows.h>
#pragma endregion


BOOL InstallService(LPCTSTR lpMachineName, LPCTSTR lpServiceName, 
					LPCTSTR lpBinaryPathName)
{
	/////////////////////////////////////////////////////////////////////////
	// Get a handle to the SCM database.
	// 

	SC_HANDLE schSCManager = OpenSCManager(lpMachineName, 
		NULL,					// ServicesActive database
		SC_MANAGER_ALL_ACCESS);	// Full access rights

	if (NULL == schSCManager) 
	{
		_tprintf(_T("OpenSCManager failed w/err 0x%08lx\n"), GetLastError());
		return FALSE;
	}


	/////////////////////////////////////////////////////////////////////////
	// Create the service.
	// 

	SC_HANDLE schService = CreateService(
        schSCManager,				// SCM database 
        lpServiceName,				// Name of service 
        lpServiceName,				// Service name to display 
        SERVICE_ALL_ACCESS,			// Desired access 
        SERVICE_WIN32_OWN_PROCESS,	// Service type 
        SERVICE_DEMAND_START,		// Start type 
        SERVICE_ERROR_NORMAL,		// Error control type 
        lpBinaryPathName,			// Path to service's binary 
        NULL,						// No load ordering group 
        NULL,						// No tag identifier 
        NULL,						// No dependencies 
        NULL,						// LocalSystem account 
        NULL);						// No password
	
	if (NULL == schService) 
	{
		_tprintf(_T("CreateService failed w/err 0x%08lx\n"), GetLastError()); 
        CloseServiceHandle(schSCManager);
        return FALSE;
    }
	else _putts(_T("Service installed successfully"));

	CloseServiceHandle(schService); 
	CloseServiceHandle(schSCManager);

	return TRUE;
}

int _tmain(int argc, _TCHAR* argv[])
{
	InstallService(_T("<machine name>"), _T("<service name>"), 
		_T("<path of the service exe file>"));

	return 0;
}