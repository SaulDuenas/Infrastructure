/***************************** Module Header *******************************\
* Module Name:	CppImpersonateUser.cpp
* Project:		CppImpersonateUser
* Copyright (c) Microsoft Corporation.
* 
* Windows Impersonation is a powerful feature Windows uses frequently in its 
* security model. In general Windows also uses impersonation in its client/
* server programming model.Impersonation lets a server to temporarily adopt 
* the security profile of a client making a resource request. The server can
* then access resources on behalf of the client, and the OS carries out the 
* access validations.
* A server impersonates a client only within the thread that makes the 
* impersonation request. Thread-control data structures contain an optional 
* entry for an impersonation token. However, a thread's primary token, which
* represents the thread's real security credentials, is always accessible in 
* the process's control structure.
* 
* After the server thread finishes its task, it reverts to its primary 
* security profile. These forms of impersonation are convenient for carrying 
* out specific actions at the request of a client and for ensuring that object
* accesses are audited correctly.
* 
* In this code sample we use the LogonUser API and the ImpersonateLoggedOnUser
* API to impersonate the user represented by the specified user token. Then 
* display the current user via the GetUserName API to show user impersonation.
* LogonUser can only be used to log onto the local machine; it cannot log you
* onto a remote computer. The account that you use in the LogonUser() call 
* must also be known to the local machine, either as a local account or as a
* domain account that is visible to the local computer. If LogonUser is 
* successful, then it will give you an access token that specifies the 
* credentials of the user account you chose.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 7/23/2009 5:00 PM Riquel Dong Created
* * 10/5/2009 7:17 PM Jialiang Ge Reviewed
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include <stdio.h>
#include <windows.h>
#pragma endregion


#define INFO_BUFFER_SIZE	260


int _tmain(int argc, _TCHAR* argv[])
{
	DWORD nBufSize = INFO_BUFFER_SIZE;
	TCHAR szCurrentUserName[INFO_BUFFER_SIZE] = {};
	TCHAR szUserName[INFO_BUFFER_SIZE] = {};
	TCHAR szDomain[INFO_BUFFER_SIZE] = {};
	TCHAR szPassword[INFO_BUFFER_SIZE] = {};


	/////////////////////////////////////////////////////////////////////////
	// Gather the credential information of the impersonated user.
	// 

	_putts(_T("Before impersonation ..."));
	if (GetUserName(szCurrentUserName, &nBufSize))
	{
		_tprintf(_T("Current user is %s\n"), szCurrentUserName);
	}

	_putts(_T("Input user name"));
	_fgetts(szUserName, nBufSize, stdin);
	// Remove the trailing '\n'
	TCHAR* pc = _tcschr(szUserName, _T('\n'));
	*pc = _T('\0');

	_putts(_T("Input domain name"));
	_fgetts(szDomain, nBufSize, stdin);
	// Remove the trailing '\n'
	pc = _tcschr(szDomain, _T('\n'));
	*pc = _T('\0');

	_putts(_T("Input password"));
	_fgetts(szPassword, nBufSize, stdin);
	// Remove the trailing '\n'
	pc = _tcschr(szPassword, _T('\n'));
	*pc = _T('\0');


	/////////////////////////////////////////////////////////////////////////
	// Impersonate the specified user.
	// 

	// Attempt to log on the user
	HANDLE hToken;
	 
	if (!LogonUser(szUserName, szDomain, szPassword, LOGON32_LOGON_INTERACTIVE, 
		LOGON32_PROVIDER_DEFAULT, &hToken))
	{
		_tprintf(_T("LogonUser failed w/err 0x%08lx\n"), GetLastError());
		return 1;
	}

	// Impersonate the logged on user
	if (!ImpersonateLoggedOnUser(hToken))
	{
		_tprintf(_T("ImpersonateLoggedOnUser failed w/err 0x%08lx\n"), 
			GetLastError());
		return 1;
	}

	// Clean up the buffer containing sensitive password
	SecureZeroMemory(szPassword, sizeof(szPassword));


	/////////////////////////////////////////////////////////////////////////
	// Work as the impersonated user.
	// 

	_putts(_T("\nDuring impersonation ..."));
	ZeroMemory(szCurrentUserName, sizeof(szCurrentUserName));
	nBufSize = INFO_BUFFER_SIZE;
	if (GetUserName(szCurrentUserName, &nBufSize))
	{
		_tprintf(_T("Current user is %s\n"), szCurrentUserName);
	}

	// Do other work as the user ...


	/////////////////////////////////////////////////////////////////////////
	// Undo the impersonation.
	// 

	if (!RevertToSelf())
	{
		_tprintf(_T("RevertToSelf failed w/err 0x%08lx\n"), GetLastError());
	}

	if (hToken)
	{
		CloseHandle(hToken);
		hToken = 0;
	}

	_putts(_T("\nAfter impersonation is undone ..."));
	ZeroMemory(szCurrentUserName, sizeof(szCurrentUserName));
	nBufSize = INFO_BUFFER_SIZE;
	if (GetUserName(szCurrentUserName, &nBufSize))
	{
		_tprintf(_T("Current user is %s\n"), szCurrentUserName);
	}

	return 0;
}