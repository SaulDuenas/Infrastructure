/****************************** Module Header ******************************\
* Module Name:	ConsoleRedirection.cpp
* Project:		CppRedirectConsole
* Copyright (c) Microsoft Corporation.
* 
* ConsoleRedirection demostrates redirecting stdin and stdout put from a 
* console application to a windows form application. The example uses 
* named pipes to communicate between different processes.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/6/2009 9:44 PM Hongye Sun Created
\***************************************************************************/

#include "StdAfx.h"
#include "ConsoleRedirection.h"
#include <strsafe.h>


CppConsoleRedirection::CppConsoleRedirection(void)
{
}

CppConsoleRedirection::~CppConsoleRedirection(void)
{
}

void CppConsoleRedirection::StartSubProcess(char* szProcessText)
{
	////////////////////////////////////////////////////////////////////
	// 2. Windows form process creates all the named pipes with 
	// inheritance flag enabled.

	CreateNamedPipes();
	
	///////////////////////////////////////////////////////////////////
	// 3. It also create sub process and passing named pipes to it.

	CreateChildProcess(szProcessText);
}

void CppConsoleRedirection::WriteStdIn(char* szInput)
{
	///////////////////////////////////////////////////////////////////
	// 6. Windows form process writes input to stdin pipe

	DWORD dwWritten;
	WriteFile(hChildStd_IN_Wr, szInput,
		strlen(szInput), &dwWritten, NULL);
}

BOOL CppConsoleRedirection::ReadStdOut(char* szOutput)
{
	DWORD dwAvail = 0;
	if (!::PeekNamedPipe(
		hChildStd_OUT_Rd, 
		NULL, 
		0, 
		NULL,
		&dwAvail, 
		NULL))			// error
		return false;

	if (!dwAvail)					// not data available
		return false;

	DWORD dwRead = 0;
	if (!::ReadFile(
		hChildStd_OUT_Rd, 
		szOutput, 
		min(255, dwAvail),
		&dwRead, 
		NULL) 
		|| !dwRead)	// error, the child might ended
		return false;

	szOutput[dwRead] = 0;
	return true;
}

void CppConsoleRedirection::CreateChildProcess(char szCmdline[])
// Create a child process that uses the previously created pipes for STDIN and STDOUT.
{ 
   PROCESS_INFORMATION piProcInfo; 
   STARTUPINFOA siStartInfo;
   BOOL bSuccess = FALSE; 
 
// Set up members of the PROCESS_INFORMATION structure. 
 
   ZeroMemory( &piProcInfo, sizeof(PROCESS_INFORMATION) );
 
// Set up members of the STARTUPINFO structure. 
// This structure specifies the STDIN and STDOUT handles for redirection.
 
   ZeroMemory( &siStartInfo, sizeof(STARTUPINFO) );
   siStartInfo.cb = sizeof(STARTUPINFO); 
   siStartInfo.hStdError = hChildStd_OUT_Wr;
   siStartInfo.hStdOutput = hChildStd_OUT_Wr;
   siStartInfo.hStdInput = hChildStd_IN_Rd;
   siStartInfo.dwFlags |= STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW;
 
// Create the child process. 
    
   bSuccess = CreateProcessA(NULL, 
      szCmdline,     // command line 
      NULL,          // process security attributes 
      NULL,          // primary thread security attributes 
      TRUE,          // handles are inherited 
      0,             // creation flags 
      NULL,          // use parent's environment 
      NULL,          // use parent's current directory 
      &siStartInfo,  // STARTUPINFO pointer 
      &piProcInfo);  // receives PROCESS_INFORMATION 
   
   // If an error occurs, exit the application. 
   if ( ! bSuccess )
      ErrorExit(TEXT("CreateProcess"));
   else 
   {
      // Close handles to the child process and its primary thread.
	  // Some applications might keep these handles to monitor the status
	  // of the child process, for example. 

	  hChildProcess = piProcInfo.hProcess;
      CloseHandle(piProcInfo.hThread);
   }
}



void CppConsoleRedirection::CreateNamedPipes()
{
	SECURITY_ATTRIBUTES saAttr; 

	// Set the bInheritHandle flag so pipe handles are inherited. 

	saAttr.nLength = sizeof(SECURITY_ATTRIBUTES); 
	saAttr.bInheritHandle = TRUE; 
	saAttr.lpSecurityDescriptor = NULL; 

	if ( ! CreatePipe(&hChildStd_OUT_Rd, &hChildStd_OUT_Wr, &saAttr, 0) ) 
		ErrorExit(TEXT("StdoutRd CreatePipe")); 

	// Ensure the read handle to the pipe for STDOUT is not inherited.

	if ( ! SetHandleInformation(hChildStd_OUT_Rd, HANDLE_FLAG_INHERIT, 0) )
		ErrorExit(TEXT("Stdout SetHandleInformation")); 

	// Create a pipe for the child process's STDIN. 

	if (! CreatePipe(&hChildStd_IN_Rd, &hChildStd_IN_Wr, &saAttr, 0)) 
		ErrorExit(TEXT("Stdin CreatePipe")); 

	// Ensure the write handle to the pipe for STDIN is not inherited. 

	if ( ! SetHandleInformation(hChildStd_IN_Wr, HANDLE_FLAG_INHERIT, 0) )
		ErrorExit(TEXT("Stdin SetHandleInformation")); 
 
}

void CppConsoleRedirection::ErrorExit(PTSTR lpszFunction) 
// Format a readable error message, display a message box, 
// and exit from the application.
{ 
    LPVOID lpMsgBuf;
    LPVOID lpDisplayBuf;
    DWORD dw = GetLastError(); 

    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | 
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        dw,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR) &lpMsgBuf,
        0, NULL );

    lpDisplayBuf = (LPVOID)LocalAlloc(LMEM_ZEROINIT, 
        (lstrlen((LPCTSTR)lpMsgBuf)+lstrlen((LPCTSTR)lpszFunction)+40)*sizeof(TCHAR)); 
    StringCchPrintf((LPTSTR)lpDisplayBuf, 
        LocalSize(lpDisplayBuf) / sizeof(TCHAR),
        TEXT("%s failed with error %d: %s"), 
        lpszFunction, dw, lpMsgBuf); 
    MessageBox(NULL, (LPCTSTR)lpDisplayBuf, TEXT("Error"), MB_OK); 

    LocalFree(lpMsgBuf);
    LocalFree(lpDisplayBuf);
    ExitProcess(1);
}