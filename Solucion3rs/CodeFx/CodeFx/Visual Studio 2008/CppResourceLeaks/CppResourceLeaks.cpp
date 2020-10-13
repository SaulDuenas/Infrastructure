/****************************** Module Header ******************************\
* Module Name:	CppResourceLeaks.cpp
* Project:		CppResourceLeaks
* Copyright (c) Microsoft Corporation.
* 
* CppResourceLeaks is designed to show typical resource leaks and their 
* consequences. It focuses on two situations of resource leaks:
* 
* 1. Handle Leak:
* 
* A handle leak is a type of software bug that occurs when a computer program 
* asks for a handle to a resource but does not free the handle when it is no 
* longer used. If this occurs frequently or repeatedly over an extended 
* period of time, a large number of handles may be marked in-use and thus  
* unavailable, causing performance problems or a crash.
* 
* 2. Memory Leak:
* 
* A memory leak is a particular type of unintentional memory consumption by a 
* computer program where the program fails to release memory when no longer 
* needed. This condition is normally the result of a bug in a program that 
* prevents it from freeing up memory that it no longer needs. Memory is 
* allocated to a program, and that program subsequently loses the ability to 
* access it due to program logic flaws.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 5/21/2009 8:23 PM Jialiang Ge Created
* * 6/27/2009 4:10 PM Jialiang Ge Modified
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include <windows.h>
#include <assert.h>
#pragma endregion


#pragma region HandleLeaks

#define BUFFER_SIZE			512

/*!
* \brief
* Leak file handles.
*/
void LeakFileHandle()
{
	// Get the current process handle count
	DWORD dwHandleCount;
	GetProcessHandleCount(GetCurrentProcess(), &dwHandleCount);
	_tprintf(_T("Current process handle count: %u\n"), dwHandleCount);


	/////////////////////////////////////////////////////////////////////////
	// Get the temp path and the temp file name.
	// 

	TCHAR szTempName[BUFFER_SIZE];

	DWORD dwRetVal = GetTempPath(BUFFER_SIZE, szTempName);
	assert(dwRetVal <= BUFFER_SIZE && dwRetVal != 0);
	
	UINT uRetVal = GetTempFileName(szTempName, _T("HLeak"), 0, szTempName);
	assert(uRetVal != 0);

	_tprintf(_T("Temp file name: %s\n"), szTempName);


	/////////////////////////////////////////////////////////////////////////
	// Create and operate on the temp file.
	// 

	_putts(_T("Create the file"));

	HANDLE hTempFile = CreateFile(szTempName, GENERIC_READ | GENERIC_WRITE, 
		0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hTempFile == INVALID_HANDLE_VALUE)
	{
		_tprintf(_T("CreateFile failed w/err 0x%08lx\n"), GetLastError());
		return;
	}

	// Read/Write the file using hTempFile
	//WriteFile(hTempFile, ...
	//ReadFile(hTempFile, ...

	_putts(_T("Duplicate the file handle"));

	// Create another handle to the file object;
	// the handle has read-only access.
	HANDLE hTempFileRO;
	DuplicateHandle(
		GetCurrentProcess(), hTempFile, 
		GetCurrentProcess(), &hTempFileRO, 
		GENERIC_READ, FALSE, 0);

	// Read the file using hTempFileRO
	//ReadFile(hTempFile, ...


	/////////////////////////////////////////////////////////////////////////
	// Close the handles.
	// 

	// Forget to close the temp file handles
	//CloseHandle(hTempFileRO);
	//CloseHandle(hTempFile);


	// Get the current process handle count
	GetProcessHandleCount(GetCurrentProcess(), &dwHandleCount);
	_tprintf(_T("Current process handle count: %u\n"), dwHandleCount);
	
	getchar();
}

/*!
* \brief
* It is possible for a process to open a handle and inject that handle into 
* another process, assuming that the injecting process has the proper access 
* rights. When that happens, and the injected handle is not closed by the 
* target process, a handle leak occurs in the target process. No leak happens 
* in the current injecting process.
*/
void LeakInjectedHandle()
{
	/////////////////////////////////////////////////////////////////////////
	// Create a mutex in the current process and get its handle.
	// 

	_putts(_T("Create the mutex \"LeakyMutex\""));

	HANDLE hMutex = CreateMutex(NULL, FALSE, _T("LeakyMutex"));
	if (hMutex == NULL)
	{
		_tprintf(_T("CreateMutex failed w/err 0x%08lx\n"), GetLastError());
		return;
	}


	/////////////////////////////////////////////////////////////////////////
	// Start the child process and inject the local handle to it.
	// 

	_putts(_T("Start the child process notepad.exe"));

	STARTUPINFO si;
	PROCESS_INFORMATION pi;
	ZeroMemory(&si, sizeof(si));
	si.cb = sizeof(si);
	ZeroMemory(&pi, sizeof(pi));
	TCHAR szCommandLine[] = TEXT("NOTEPAD");
	if (!CreateProcess(NULL, szCommandLine, NULL, NULL, FALSE, 0, NULL, NULL, 
		&si, &pi))
	{
		_tprintf(_T("CreateProcess w/err 0x%08lx\n"), GetLastError());
		return;
	}

	getchar();	// Allow attaching windbg to notepad.exe and trace handles

	_putts(_T("Inject (duplicate) the handle to the child process"));

	// hMutexInProcessT is a handle relative to the target process. It's  
	// meaningless to the current process.
	HANDLE hMutexInProcessT;
	DuplicateHandle(
		GetCurrentProcess(), hMutex, 
		pi.hProcess, &hMutexInProcessT,
		0, FALSE, DUPLICATE_SAME_ACCESS);

	// Use some IPC mechanism to inform the target process about the injected
	// handle value (hMutexInProcessT). The target process is then responsible 
	// for closing the handle.
	// ...


	/////////////////////////////////////////////////////////////////////////
	// Close the handles. (No handle leak in the current injecting process)
	// 

	// Close process and thread handles. 
	CloseHandle(pi.hThread);
	CloseHandle(pi.hProcess);
	
	// Close mutex handle
	CloseHandle(hMutex);

	// NOTE: hMutexInProcessT is a handle relative to target process 
	// (notepad.exe) that identifies the same mutex object in kernel. The  
	// current (injecting) process should never attempt to close the  
	// duplicated handle by executing the code: CloseHandle(hMutexInProcessT);  
	// because hMutexInProcessT is meaningless to the injecting process.

	getchar();
}

/*!
* \brief
* Leak GDI objects.
*/
void LeakGDIHandle()
{
}

#pragma endregion


#pragma region MemoryLeaks

/*!
* \brief
* Leak memory allocated on heap.
*/
void LeakHeapMemory()
{
	_putts(_T("Press enter to leak the memory"));
	getchar();

	while (TRUE)
	{
		// Allocate the memory on the heap
		_putts(_T("Allocate 500 bytes heap memory"));

		void* p = HeapAlloc(GetProcessHeap(), 0, 500);
		//void* p = malloc(500);

		// Use the memory pointed by p
		strcpy_s((char*)p, 500, "All-In-One Code Framework");

		// Memory was available and pointed to by p, but not saved. After 
		// this iteration, the pointer is destroyed, and the allocated memory 
		// becomes unreachable. To fix the leak problem:

		//HeapFree(GetProcessHeap(), 0, p);
		//free(p);
	}
}

#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>
#include <crtdbg.h>

/*!
* \brief
* Leak memory allocated on CRT heap using CRT APIs.
*/
void LeakCRTHeapMemory()
{
	_putts(_T("Press enter to leak the CRT memory"));
	getchar();

	{
		void* p = malloc(500);
	}

	_CrtDumpMemoryLeaks();
}

#pragma endregion


int _tmain(int argc, _TCHAR* argv[])
{
	// Leak file handles
	LeakFileHandle();

	// Leak injected handles
	LeakInjectedHandle();

	// Leak GDI handles
	LeakGDIHandle();

	// Leak memory allocated on heap
	LeakHeapMemory();

	// Leak memory allocated on CRT heap using CRT APIs
	LeakCRTHeapMemory();

	return 0;
}