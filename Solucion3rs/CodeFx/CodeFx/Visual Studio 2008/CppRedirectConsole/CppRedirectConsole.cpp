/****************************** Module Header ******************************\
* Module Name:	CppRedirectConsole.cpp
* Project:		CppRedirectConsole
* Copyright (c) Microsoft Corporation.
* 
* CppRedirectConsole demostrates redirecting stdin and stdout put from a 
* console application to a windows form application. The sample uses 
* named pipes to communicate between different processes.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/6/2009 9:44 PM Hongye Sun Created
\***************************************************************************/


#pragma region Includes
#include "stdafx.h"
#include "ConsoleRedirection.h"
#include "CppRedirectConsole.h"
#include <windowsx.h>
#pragma endregion


#define BUFSIZE 4096 

// Forward declarations of functions included in this code module:
INT_PTR CALLBACK	DialogProc(HWND, UINT, WPARAM, LPARAM);

void CreateMonitorThread(void);
void WriteStdOut(LPCWSTR szOutput);

LPCWSTR ConvertToW(LPCSTR lpaszString);

CppConsoleRedirection g_redirect;

HWND g_hDialogWnd = NULL; 
HWND g_hEditProcessWnd = NULL; 
HWND g_hEditStdinWnd = NULL; 
HWND g_hEditStdoutWnd = NULL; 

int APIENTRY _tWinMain(HINSTANCE hInstance,
					   HINSTANCE hPrevInstance,
					   LPTSTR    lpCmdLine,
					   int       nCmdShow)
{
	return DialogBox(hInstance, MAKEINTRESOURCE(IDD_MAINDIALOG), NULL, 
		DialogProc);
}

//
//   FUNCTION: OnInitDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitDialog(HWND hWnd, HWND hwndFocus, LPARAM lParam)
{
	////////////////////////////////////////////////////////////////////
	// 1. Windows form process initializes and shows a windows dialog

	// Set the small icon for the dialog
	SendMessage(hWnd, WM_SETICON, ICON_SMALL, (LPARAM)LoadImage(
		GetModuleHandle(0), MAKEINTRESOURCE(IDI_SMALL), IMAGE_ICON, 0, 0, 
		LR_DEFAULTCOLOR));

	g_hDialogWnd = hWnd;
	g_hEditProcessWnd = GetDlgItem(hWnd, IDC_EDIT_PROCESS);
	g_hEditStdinWnd = GetDlgItem(hWnd, IDC_EDIT_STDIN); 
	g_hEditStdoutWnd = GetDlgItem(hWnd, IDC_EDIT_STDOUT); 

	Edit_SetText(g_hEditProcessWnd, L"cmd");
	
	return TRUE;
}

//
//   FUNCTION: OnClose(HWND)
//
//   PURPOSE: Process the WM_CLOSE message
//
void OnClose(HWND hWnd)
{
	EndDialog(hWnd, 0);
}

void OnStartButtonClick(HWND hWnd)
{
	char szProcessText[256];
	UINT len = GetWindowTextA(g_hEditProcessWnd, szProcessText, 512);

	if (!len)
	{
		return;
	}

	g_redirect.StartSubProcess(szProcessText);

	///////////////////////////////////////////////////////////////////
	// 4. Windows form process creates a thread to monitoring the sub 
	// process

	CreateMonitorThread();
}

void OnInputButtonClick(HWND hWnd)
{
	char szInput[256];
	UINT len = GetWindowTextA(g_hEditStdinWnd, szInput, 512);
	if (!len)
	{
		return;
	}

	strcat(szInput, "\r\n");

	g_redirect.WriteStdIn(szInput);

}

//
//  FUNCTION: DialogProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the main dialog.
//
INT_PTR CALLBACK DialogProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	int wmId, wmEvent;
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

		case WM_COMMAND:
			wmId    = LOWORD(wParam);
			wmEvent = HIWORD(wParam);
			// Parse the menu selections:
			switch (wmId)
			{
				case IDC_BUTTON_START:
					OnStartButtonClick(hWnd);
					break;
				case IDC_BUTTON_STDIN:
					OnInputButtonClick(hWnd);
					break;
			}
			break;


	default:
		return FALSE;
	}
	return 0;
}

DWORD WINAPI RedirectStdOut(LPVOID lpvThreadParam)
{
	///////////////////////////////////////////////////////////////////
	// 5. In the monitor process, it redirects initial output to 
	// windows form

	HANDLE handles[1];
	handles[0] = g_redirect.hChildProcess;

	for (;;)
	{
		for (;;)
		{
			char szOutput[256];
			if (!g_redirect.ReadStdOut(szOutput))
			{
				break;
			}
			else
			{
				WriteStdOut(ConvertToW(szOutput));
			}
		}

		DWORD dwRc = ::WaitForMultipleObjects(
			1, handles, FALSE, 100);
		if (WAIT_OBJECT_0 == dwRc)		// the child process ended
		{
			break;
		}
	}

	return 0;
}

void CreateMonitorThread()
{
	DWORD dwThreadId = NULL;
	HANDLE hThread = NULL;

	hThread = ::CreateThread(
		NULL, 
		0,
		RedirectStdOut,
		NULL,
		0,
		&dwThreadId);
	if (!hThread)
		return;
}

void WriteStdOut(LPCWSTR szOutput)
{
	if (g_hEditStdoutWnd != NULL)
	{
		int nSize = Edit_GetTextLength(g_hEditStdoutWnd);
		Edit_SetSel(g_hEditStdoutWnd, nSize, nSize);
		Edit_ReplaceSel(g_hEditStdoutWnd, szOutput);		// add the message to the end of Edit control
	}
}

// Constructs object and convert lpaszString to Unicode
LPCWSTR ConvertToW(LPCSTR lpaszString)
{
	int nLen = ::lstrlenA(lpaszString) + 1;
	WCHAR* lpwszString = new WCHAR[nLen];
	if (lpwszString == NULL)
	{
		return NULL;
	}

	memset(lpwszString, 0, nLen * sizeof(WCHAR));

	if (::MultiByteToWideChar(CP_ACP, 0, lpaszString, nLen, lpwszString, nLen) == 0)
	{
		// Conversation failed
		return NULL;
	}

	return lpwszString;
}