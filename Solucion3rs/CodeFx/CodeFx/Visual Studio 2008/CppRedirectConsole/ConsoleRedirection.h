/****************************** Module Header ******************************\
* Module Name:	ConsoleRedirection.cpp
* Project:		CppRedirectConsole
* Copyright (c) Microsoft Corporation.
* 
* The class CppConsoleRedirection encapsulate the console redirection 
* operations.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/6/2009 9:44 PM Hongye Sun Created
\***************************************************************************/

#pragma once

class CppConsoleRedirection
{
public:
	CppConsoleRedirection(void);
	~CppConsoleRedirection(void);
	
	HANDLE hChildProcess;

	void StartSubProcess(char* szProcessText);
	void WriteStdIn(char* szInput);
	BOOL ReadStdOut(char* szOutput);

private:
	
	HANDLE hChildStd_IN_Rd;
	HANDLE hChildStd_IN_Wr;
	HANDLE hChildStd_OUT_Rd;
	HANDLE hChildStd_OUT_Wr;
	HANDLE hInputFile;

	void CreateNamedPipes(void);
	void CreateChildProcess(char* szProcessText);
	void CreateMonitorThread(void);
	void ReadFromPipe(void);
	void ErrorExit(PTSTR); 
};
