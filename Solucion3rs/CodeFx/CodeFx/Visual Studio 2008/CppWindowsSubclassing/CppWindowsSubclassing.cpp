/****************************** Module Header ******************************\
* Module Name:	CppWindowsSubclassing.cpp
* Project:		CppWindowsSubclassing
* Copyright (c) Microsoft Corporation.
* 
* If a control or a window does almost everything you want, but you need a 
* few more features, you can change or add features to the original control 
* by subclassing it. A subclass can have all the features of an existing 
* class as well as any additional features you want to give it.
* 
* Two subclassing rules apply to subclassing in Win32.
* 
* 1. Subclassing is allowed only within a process. An application cannot 
* subclass a window or class that belongs to another process.
* 
* 2. The subclassing process may not use the original window procedure 
* address directly.
* 
* There are two approaches to window subclassing.
* 
* 1. Subclassing Controls Prior to ComCtl32.dll version 6
* 
* The first is usable by most windows operating systems (Windows 2000, XP 
* and later). You can put a control in a subclass and store user data within 
* a control. You do this when you use versions of ComCtl32.dll prior to 
* version 6 which ships with Microsoft Windows XP. There are some 
* disadvantages in creating subclasses with earlier versions of ComCtl32.dll.
* 
* 	a) The window procedure can only be replaced once.
* 	b) It is difficult to remove a subclass after it is created.
* 	c) Associating private data with a window is inefficient.
* 	d) To call the next procedure in a subclass chain, you cannot cast the 
* 	old window procedure and call it, you must call it using CallWindowProc.
* 
* To make a new control it is best to start with one of the Windows common 
* controls and extend it to fit a particular need. To extend a control, 
* create a control and replace its existing window procedure with a new one. 
* The new procedure intercepts the control's messages and either acts on them 
* or passes them to the original procedure for default processing. Use the 
* SetWindowLong or SetWindowLongPtr function to replace the WNDPROC of the 
* control.
* 
* 2. Subclassing Controls Using ComCtl32.dll version 6
* 
* The second is only usable with a minimum operating system of Windows XP 
* since it relies on ComCtl32.dll version 6. ComCtl32.dll version 6 supplied 
* with Windows XP contains four functions that make creating subclasses 
* easier and eliminate the disadvantages previously discussed. The new 
* functions encapsulate the management involved with multiple sets of 
* reference data, therefore the developer can focus on programming features 
* and not on managing subclasses. The subclassing functions are: 
* 
* 	SetWindowSubclass
* 	GetWindowSubclass
* 	RemoveWindowSubclass
* 	DefSubclassProc
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 5/28/2009 9:10 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include "CppWindowsSubclassing.h"
#include <windowsx.h>

#include <commctrl.h>
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

void OnSubclass(HWND hWnd);
void OnUnsubclass(HWND hWnd);
void OnSafeSubclass(HWND hWnd);
void OnSafeUnsubclass(HWND hWnd);


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
	LoadString(hInstance, IDC_CPPWINDOWSSUBCLASSING, szWindowClass, MAX_LOADSTRING);
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


#pragma region Main Window

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
	wcex.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(IDI_CPPWINDOWSSUBCLASSING));
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground	= (HBRUSH)(COLOR_BTNFACE+1);
	wcex.lpszMenuName	= 0;
	wcex.lpszClassName	= szWindowClass;
	wcex.hIconSm		= LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

	return RegisterClassEx(&wcex);
}

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

	hWnd = CreateDialog(hInst, MAKEINTRESOURCE(IDD_MAINDIALOG), 0, 0);
	if (!hWnd)
	{
		return FALSE;
	}

	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	return TRUE;
}

//
//   FUNCTION: OnCreate(HWND, LPCREATESTRUCT)
//
//   PURPOSE: Process the WM_CREATE message
//
BOOL OnCreate(HWND hWnd, LPCREATESTRUCT lpCreateStruct)
{
	return TRUE;
}

//
//   FUNCTION: OnCommand(HWND, int, HWND, UINT)
//
//   PURPOSE: Process the WM_COMMAND message
//
void OnCommand(HWND hWnd, int id, HWND hWndCtl, UINT codeNotify)
{
	switch (id)
	{
	case IDC_SUBCLASS_BN:
		OnSubclass(hWnd);
		break;

	case IDC_UNSUBCLASS_BN:
		OnUnsubclass(hWnd);
		break;

	case IDC_SAFESUBCLASS_BN:
		OnSafeSubclass(hWnd);
		break;

	case IDC_SAFEUNSUBCLASS_BN:
		OnSafeUnsubclass(hWnd);
		break;

	case IDOK:
		PostQuitMessage(0);
		break;
	}
}

//
//   FUNCTION: OnDestroy(HWND)
//
//   PURPOSE: Process the WM_DESTROY message
//
void OnDestroy(HWND hWnd)
{
	PostQuitMessage(0);
}

//
//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the main window.
//
//  WM_COMMAND	- process the application menu
//  WM_PAINT	- Paint the main window
//  WM_DESTROY	- post a quit message and return
//
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

#pragma endregion


#pragma region Subclassing Controls Prior to ComCtl32.dll version 6

// You can put a control in a subclass and store user data within a control. 
// You do this when you use versions of ComCtl32.dll prior to version 6 which 
// ships with Microsoft Windows XP. There are some disadvantages in creating 
// subclasses with earlier versions of ComCtl32.dll:
// 
// 1. The window procedure can only be replaced once.
// 2. It is difficult to remove a subclass after it is created.
// 3. Associating private data with a window is inefficient.
// 4. To call the next procedure in a subclass chain, you cannot cast the old 
// window procedure and call it, you must call it by using CallWindowProc.
// 
// To make a new control it is best to start with one of the Windows common 
// controls and extend it to fit a particular need. To extend a control, 
// create a control and replace its existing window procedure with a new one. 
// The new procedure intercepts the control's messages and either acts on them 
// or passes them to the original procedure for default processing. Use the 
// SetWindowLong or SetWindowLongPtr function to replace the WNDPROC of the 
// control. 

//
//  FUNCTION: NewBtnProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  The new procedure that processes messages for the button control.
//
LRESULT CALLBACK NewBtnProc(HWND hButton, UINT message, WPARAM wParam, LPARAM lParam)
{
	// Retrieve the previously stored original button window procedure
	WNDPROC OldBtnProc = (WNDPROC)GetWindowLongPtr(hButton, GWLP_USERDATA);

	switch (message)
	{
	case WM_RBUTTONDOWN:

		// Mouse button right-click event handler
		MessageBox(hButton, _T("NewBtnProc / WM_RBUTTONDOWN"), 
			_T("Subclass Example"), MB_OK);

		// Stop the default message handler
		return TRUE;
		// [-or-]
		// Call the default message handler
		//return CallWindowProc(OldBtnProc, hButton, message, wParam, lParam);

	case WM_PAINT: // OwnerDraw
		// http://msdn.microsoft.com/en-us/library/dd145137.aspx
		{
			PAINTSTRUCT ps;
			HDC hDC = BeginPaint(hButton, &ps);

			// Do painting here
			FillRect(hDC, &ps.rcPaint, (HBRUSH)(COLOR_WINDOW+1));
			TextOut(hDC, 0, 0, _T("Rich-click me!"), 11);

			EndPaint(hButton, &ps);
		}
		return TRUE;

	default:
		// Call the default system handler for the control (button)
		return CallWindowProc(OldBtnProc, hButton, message, wParam, lParam);
	}
}

//
//   FUNCTION: OnSubclass(HWND)
//
//   PURPOSE: Subclass the button control. 
//
void OnSubclass(HWND hWnd)
{
	// Get the handle of the control to be subclassed
	HWND hButton = GetDlgItem(hWnd, IDC_BUTTON);

	// Subclass the button control
	WNDPROC OldBtnProc = (WNDPROC)SetWindowLongPtr(hButton, GWLP_WNDPROC, 
		(LONG_PTR)NewBtnProc);

	// Store the original, default window procedure of the button as the 
	// button control's user data
	SetWindowLongPtr(hButton, GWLP_USERDATA, (LONG_PTR)OldBtnProc);

	// Invalidate the button control so that WM_PAINT is sent to it and the 
	// new paint of the button can be shown immediately
	RECT rc;
	GetClientRect(hButton, &rc);
	InvalidateRect(hButton, &rc, TRUE);

	// Update the UI
	EnableWindow(GetDlgItem(hWnd, IDC_SUBCLASS_BN), FALSE);
	EnableWindow(GetDlgItem(hWnd, IDC_UNSUBCLASS_BN), TRUE);
	EnableWindow(GetDlgItem(hWnd, IDC_SAFESUBCLASS_BN), FALSE);
	EnableWindow(GetDlgItem(hWnd, IDC_SAFEUNSUBCLASS_BN), FALSE);
}

//
//   FUNCTION: OnUnsubclass(HWND)
//
//   PURPOSE: Unsubclass the button control. 
//   Do not assume that subclasses are added and removed in a purely 
//   stack-like manner. If you want to unsubclass and find that you are not 
//   the window procedure at the top of the chain you cannot safely 
//   unsubclass. You will have to leave your subclass attached until it 
//   becomes safe to unsubclass. Until that time, you just have to keep 
//   passing the messages through to the previous procedure. 
//
void OnUnsubclass(HWND hWnd)
{
	// Get the handle of the control that was subclassed
	HWND hButton = GetDlgItem(hWnd, IDC_BUTTON);

	// Retrieve the previously stored original button window procedure
	WNDPROC OldBtnProc = (WNDPROC)GetWindowLongPtr(hButton, GWLP_USERDATA);

	// Replace the current handler with the old one
	SetWindowLongPtr(hButton, GWLP_WNDPROC, (LONG_PTR)OldBtnProc);

	// Invalidate the button control so that WM_PAINT is sent to it and the 
	// new paint of the button can be shown immediately
	RECT rc;
	GetClientRect(hButton, &rc);
	InvalidateRect(hButton, &rc, TRUE);

	// Update the UI
	EnableWindow(GetDlgItem(hWnd, IDC_SUBCLASS_BN), TRUE);
	EnableWindow(GetDlgItem(hWnd, IDC_UNSUBCLASS_BN), FALSE);
	EnableWindow(GetDlgItem(hWnd, IDC_SAFESUBCLASS_BN), TRUE);
	EnableWindow(GetDlgItem(hWnd, IDC_SAFEUNSUBCLASS_BN), FALSE);
}

#pragma endregion


#pragma region Subclassing Controls Using ComCtl32.dll version 6

// ComCtl32.dll version 6 supplied with Windows XP contains four functions 
// that make creating subclasses easier and eliminate the disadvantages 
// previously discussed. The new functions encapsulate the management 
// involved with multiple sets of reference data, therefore the developer can 
// focus on programming features and not on managing subclasses. The 
// subclassing functions are: 
// 
// SetWindowSubclass
// GetWindowSubclass
// RemoveWindowSubclass
// DefSubclassProc

//
//  FUNCTION: NewSafeBtnProc(HWND, UINT, WPARAM, LPARAM, UINT_PTR, DWORD_PTR)
//
//  PURPOSE:  The new procedure that processes messages for the button control. 
//  Every time a message is received by the new window procedure, a subclass 
//  ID and reference data are included.
//
LRESULT CALLBACK NewSafeBtnProc(HWND hButton, UINT message, WPARAM wParam, LPARAM lParam, 
								UINT_PTR uIdSubclass, DWORD_PTR dwRefData)
{
	switch (message)
    {
    case WM_RBUTTONDOWN:

		// Mouse button right-click event handler
		MessageBox(hButton, _T("NewSafeBtnProc / WM_RBUTTONDOWN"), 
			_T("Subclass Example"), MB_OK);

		// Stop the default message handler
		return TRUE;
		// [-or-]
		// Call the default message handler
		//return DefSubclassProc(hButton, message, wParam, lParam);

	case WM_PAINT: // OwnerDraw
		// http://msdn.microsoft.com/en-us/library/dd145137.aspx
		{
			PAINTSTRUCT ps;
			HDC hDC = BeginPaint(hButton, &ps);

			// Do painting here
			FillRect(hDC, &ps.rcPaint, (HBRUSH)(COLOR_WINDOW+1));
			TextOut(hDC, 0, 0, _T("Rich-click me!"), 11);
			
			EndPaint(hButton, &ps);
		}
		return TRUE;

	case WM_NCDESTROY:

		// You must remove your window subclass before the window being 
		// subclassed is destroyed. This is typically done either by removing 
		// the subclass once your temporary need has passed, or if you are 
		// installing a permanent subclass, by inserting a call to 
		// RemoveWindowSubclass inside the subclass procedure itself:

		RemoveWindowSubclass(hButton, NewSafeBtnProc, uIdSubclass);
		return DefSubclassProc(hButton, message, wParam, lParam);

	default:
		return DefSubclassProc(hButton, message, wParam, lParam);
    }
}

//
//   FUNCTION: OnSafeSubclass(HWND)
//
//   PURPOSE: Safely subclass the button control. 
//
void OnSafeSubclass(HWND hWnd)
{
	// Get the handle of the control to be subclassed
	HWND hButton = GetDlgItem(hWnd, IDC_BUTTON);

	// Subclass the button control
	UINT_PTR uIdSubclass = 0;
    SetWindowSubclass(hButton, NewSafeBtnProc, uIdSubclass, 0);

	// Invalidate the button control so that WM_PAINT is sent to it and the 
	// new paint of the button can be shown immediately
	RECT rc;
	GetClientRect(hButton, &rc);
	InvalidateRect(hButton, &rc, TRUE);

	// Update the UI
	EnableWindow(GetDlgItem(hWnd, IDC_SUBCLASS_BN), FALSE);
	EnableWindow(GetDlgItem(hWnd, IDC_UNSUBCLASS_BN), FALSE);
	EnableWindow(GetDlgItem(hWnd, IDC_SAFESUBCLASS_BN), FALSE);
	EnableWindow(GetDlgItem(hWnd, IDC_SAFEUNSUBCLASS_BN), TRUE);
}

//
//   FUNCTION: OnSafeUnsubclass(HWND)
//
//   PURPOSE: Safely unsubclass the button control. 
//
void OnSafeUnsubclass(HWND hWnd)
{
	// Get the handle of the control that was subclassed
	HWND hButton = GetDlgItem(hWnd, IDC_BUTTON);

	// Unsubclass the control
	UINT_PTR uIdSubclass = 0;
	RemoveWindowSubclass(hButton, NewSafeBtnProc, uIdSubclass);

	// Invalidate the button control so that WM_PAINT is sent to it and the 
	// new paint of the button can be shown immediately
	RECT rc;
	GetClientRect(hButton, &rc);
	InvalidateRect(hButton, &rc, TRUE);

	// Update the UI
	EnableWindow(GetDlgItem(hWnd, IDC_SUBCLASS_BN), TRUE);
	EnableWindow(GetDlgItem(hWnd, IDC_UNSUBCLASS_BN), FALSE);
	EnableWindow(GetDlgItem(hWnd, IDC_SAFESUBCLASS_BN), TRUE);
	EnableWindow(GetDlgItem(hWnd, IDC_SAFEUNSUBCLASS_BN), FALSE);
}

#pragma endregion