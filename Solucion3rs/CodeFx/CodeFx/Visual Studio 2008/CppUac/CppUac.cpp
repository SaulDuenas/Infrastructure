/************************************* Module Header ****************************\
* Module Name:	CppUac.cpp
* Project:		CppUac
* Copyright © 2009 Microsoft Corporation.
* 
* The example demonstrates how to perform User Account Control (UAC) security 
* elevation in Windows application.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 6/09/2009 9:04 PM Rong-Chun Zhang Created
* * 6/14/2009 1:20 PM Jialiang Ge Reviewed
\********************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include "CppUac.h"
#include <windowsx.h>
#include <commctrl.h>
#include <shlobj.h>
#include <shellapi.h>
#pragma endregion


#define MAX_LOADSTRING 100

// Global Variables:
HINSTANCE hInst;								// Current instance
TCHAR szTitle[MAX_LOADSTRING];					// The title bar text
TCHAR szWindowClass[MAX_LOADSTRING];			// The main window class name

// Forward declarations of functions included in this code module:
ATOM				MyRegisterClass(HINSTANCE hInstance);
BOOL				InitInstance(HINSTANCE, int);
LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);
BOOL				GetProcessElevation(TOKEN_ELEVATION_TYPE*, BOOL*);


int APIENTRY _tWinMain(HINSTANCE hInstance,
					   HINSTANCE hPrevInstance,
					   LPTSTR    lpCmdLine,
					   int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

	// TODO: Place code here.
	MSG msg;

	// Initialize global strings
	LoadString(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadString(hInstance, IDC_CPPUAC, szWindowClass, MAX_LOADSTRING);
	MyRegisterClass(hInstance);

	// Perform application initialization:
	if (!InitInstance (hInstance, nCmdShow))
	{
		return FALSE;
	}

	// Main message loop:
	while (GetMessage(&msg, NULL, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return (int) msg.wParam;
}


//
//  FUNCTION: MyRegisterClass()
//
//  PURPOSE: Registers the window class.
//
//  COMMENTS:
//
//    This function and its usage are only necessary if you want this code
//    to be compatible with Win32 systems prior to the 'RegisterClassEx'
//    function that was added to Windows 95. It is important to call this function
//    so that the application will get 'well formed' small icons associated
//    with it.
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);

	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= WndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= DLGWINDOWEXTRA;
	wcex.hInstance		= hInstance;
	wcex.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(IDI_CPPUAC));
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground	= (HBRUSH)(COLOR_BTNFACE+1);
	wcex.lpszMenuName	= 0;
	wcex.lpszClassName	= szWindowClass;
	wcex.hIconSm		= LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

	return RegisterClassEx(&wcex);
}

BOOL g_fIsElevated = FALSE;
BOOL g_fIsAdmin = FALSE;

//
//   FUNCTION: InitInstance(HINSTANCE, int)
//
//   PURPOSE: Saves instance handle and creates main window
//
//   COMMENTS:
//
//        In this function, we save the instance handle in a global variable and
//        create and display the main program window.
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
	HWND hWnd;

	hInst = hInstance; // Store instance handle in our global variable
	hWnd = CreateDialog(hInst, MAKEINTRESOURCE(IDD_UACDIALOG), 0, 0);

	if (!hWnd)
	{
		return FALSE;
	}


	/////////////////////////////////////////////////////////////////////////
	// Check the current process's integrity level.
	// NOTE: There is no method to detect whether UAC is turned on or off on 
	// the computer!
	// 

	TOKEN_ELEVATION_TYPE elevationType;
	if (GetProcessElevation(&elevationType, &g_fIsAdmin))
	{
		if (elevationType == TokenElevationTypeFull)
			g_fIsElevated = TRUE;
	}

	// Update the "Is Administrator" label
	HWND hIsAdminLabel = GetDlgItem(hWnd, IDC_ISADMIN_STATIC);
	SetWindowText(hIsAdminLabel, g_fIsAdmin ? _T("TRUE") : _T("FALSE"));

	// Update the "Integrity level" label
	HWND hIntegrityLabel = GetDlgItem(hWnd, IDC_INTEGRITY_STATIC);
	SetWindowText(hIntegrityLabel, g_fIsElevated ? _T("High") : _T("Default"));

	// Update the "Elevate" button to show the UAC shield icon
	HWND hElevateBtn = GetDlgItem(hWnd, IDC_ELEVATE_BN);
	// Button_SetElevationRequiredState macro (defined in Comm-Ctrl.h) is 
	// used to show or hide the shield icon in a button. You can also get 
	// the shield directly as an icon by calling SHGetStockIconInfo with 
	// SIID_SHIELD as a parameter.
	Button_SetElevationRequiredState(hElevateBtn, !g_fIsElevated);
	//SendMessage(hElevateBtn, BCM_SETSHIELD, 0, 0xFFFFFFFF);


	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	return TRUE;
}

//   FUNCTION: OnCreate(HWND, LPCREATESTRUCT)
//
//   PURPOSE: Process the WM_CREATE message
//
BOOL OnCreate(HWND hWnd, LPCREATESTRUCT lpCreateStruct)
{
	return TRUE;
}

//   FUNCTION: OnCommand(HWND, int, HWND, UINT)
//
//   PURPOSE: Process the WM_COMMAND message
//
void OnCommand(HWND hWnd, int id, HWND hWndCtl, UINT codeNotify)
{
	switch (id)
	{
	case IDC_ELEVATE_BN:

		// If the process is no run as administrator, elevate it. 
		if(!g_fIsElevated)
		{
			TCHAR szPath[MAX_PATH];
			if(GetModuleFileName(NULL, szPath, MAX_PATH))
			{
				// Launch itself as administrator
				SHELLEXECUTEINFO sei = {0};

				sei.cbSize = sizeof(SHELLEXECUTEINFOA);
				sei.fMask = 0;
				sei.hwnd = NULL;
				sei.lpVerb = _T("runas");
				sei.lpFile = szPath;
				sei.lpParameters = L"";
				sei.nShow = SW_NORMAL;

				if (!ShellExecuteEx(&sei))
				{
					if (GetLastError() == ERROR_CANCELLED)
					{
						// The user refused to allow privileges elevation.
					}
				}
				else
					// Quit itself
					PostQuitMessage(0);
			}
		}
		else
		{
			MessageBox(NULL, _T("The process is running as administrator"), 
				_T("UAC"), MB_OK);
		}
		break;

	case IDOK:
		PostQuitMessage(0);
		break;
	}
}

//   FUNCTION: OnDestroy(HWND)
//
//   PURPOSE: Process the WM_DESTROY message
//
void OnDestroy(HWND hWnd)
{
	PostQuitMessage(0);
}

//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the main window.
//
//  WM_COMMAND	- process the application menu
//  WM_PAINT	- Paint the main window
//  WM_DESTROY	- post a quit message and return
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_CREATE message in OnCreate
		// Because it is a window based on a dialog resource but NOT a dialog 
		// box it receives a WM_CREATE message and NOT a WM_INITDIALOG message.
		HANDLE_MSG (hWnd, WM_CREATE, OnCreate);

		// Handle the WM_COMMAND message in OnCommand
		HANDLE_MSG (hWnd, WM_COMMAND, OnCommand);

		// Handle the WM_DESTROY message in OnDestroy
		HANDLE_MSG (hWnd, WM_DESTROY, OnDestroy);

	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

//  FUNCTION: GetProcessElevation(TOKEN_ELEVATION_TYPE*, BOOL*)
//
//  PURPOSE:  The helper function returns both the elevation type and a Boolean 
//  value indicating whether you are running as Administrator or not.
//
//  CASES:
//  
//  1. Logged-on user is an admin; UAC is on; run the app without elevation
//  => ElevationType = TokenElevationTypeLimited, IsAdmin = TRUE
//  
//  2. Logged-on user is a standard user; UAC is on; run the app without elevation
//  => ElevationType = TokenElevationTypeDefault, IsAdmin = FALSE
//  
//  3. UAC is on, and run the app with elevation
//  => ElevationType = TokenElevationTypeFull, IsAdmin = TRUE
//  
//  4. UAC is off
//  => ElevationType = TokenElevationTypeDefault, IsAdmin = the app's runas user.
//
BOOL GetProcessElevation(TOKEN_ELEVATION_TYPE* pElevationType, BOOL* pIsAdmin)
{
	HANDLE hToken = NULL;
	DWORD dwSize;

	// Get current process token
	if (!OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &hToken))
		return(FALSE);

	BOOL bResult = FALSE;

	// Retrieve elevation type information
	if (GetTokenInformation(hToken, TokenElevationType,
		pElevationType, sizeof(TOKEN_ELEVATION_TYPE), &dwSize)) 
	{
		// Create the SID corresponding to the Administrators group
		BYTE adminSID[SECURITY_MAX_SID_SIZE];
		dwSize = sizeof(adminSID);
		CreateWellKnownSid(WinBuiltinAdministratorsSid, NULL, &adminSID, &dwSize);

		// When elevation type is limited, IsUserAnAdmin always returns FALSE.
		// TokenElevationTypeLimited means that UAC is on and the current user is 
		// an admin, so the admin's privilege is limited without elevation.
		if (*pElevationType == TokenElevationTypeLimited) 
		{
			// Get handle to linked token (will have one if we are lua)
			HANDLE hUnfilteredToken = NULL;
			GetTokenInformation(hToken, TokenLinkedToken, (VOID*)
				&hUnfilteredToken, sizeof(HANDLE), &dwSize);

			// Check if this original token contains admin SID
			if (CheckTokenMembership(hUnfilteredToken, &adminSID, pIsAdmin)) 
			{
				bResult = TRUE;
			}

			// Don't forget to close the unfiltered token
			CloseHandle(hUnfilteredToken);
		}
		else
		{
			*pIsAdmin = IsUserAnAdmin();
			bResult = TRUE;
		}
	}

	// Don't forget to close the process token
	CloseHandle(hToken);

	return(bResult);
}
