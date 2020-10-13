/********************************* Module Header *********************************\
* Module Name:	CppWindowsUserControls.cpp
* Project:		CppWindowsUserControls
* Copyright (c) Microsoft Corporation.
* 
* CppWindowsUserControls contains simple examples of how to create user 
* controls defined in user32.dll. The controls include Buttons, Combo-boxes, 
* Edits, List-boxes, RichEdit(in msftedit.dll or riched20.dll or 
* riched32.dll), Scrollbars, and Statics.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 5/10/2009 8:15 AM Jialiang Ge Created
\*********************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include "CppWindowsUserControls.h"
#include <windowsx.h>
#pragma endregion


#define MAX_LOADSTRING 100

// Global Variables:
HINSTANCE hInst;								// Current instance
HFONT hFont;									// Default font in Windows
TCHAR szTitle[MAX_LOADSTRING];					// The title bar text
TCHAR szWindowClass[MAX_LOADSTRING];			// The main window class name

// Forward declarations of functions included in this code module:
ATOM				MyRegisterClass(HINSTANCE hInstance);
BOOL				InitInstance(HINSTANCE, int);
LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	ButtonDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	ComboBoxDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	EditDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	RichEditDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	ListBoxDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	ScrollBarDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	StaticDlgProc(HWND, UINT, WPARAM, LPARAM);


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
	LoadString(hInstance, IDC_CPPWINDOWSUSERCONTROLS, szWindowClass, MAX_LOADSTRING);
	MyRegisterClass(hInstance);

	// Initialize the default font for Windows.
	hFont = CreateFont(12, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE, DEFAULT_CHARSET, 
		OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, 
		DEFAULT_PITCH | FF_DONTCARE, _T("MS Shell Dlg"));

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

	// Release the font object.
	DeleteObject(hFont);

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
	wcex.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(IDI_CPPWINDOWSUSERCONTROLS));
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
	case IDC_BUTTON_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_BUTTONDIALOG), 
				hWnd, ButtonDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_COMBOBOX_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_COMBOBOXDIALOG), 
				hWnd, ComboBoxDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_EDIT_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_EDITDIALOG), 
				hWnd, EditDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_RICHEDIT_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_RICHEDITDIALOG), 
				hWnd, RichEditDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_LISTBOX_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_LISTBOXDIALOG), 
				hWnd, ListBoxDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_SCROLLBAR_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_SCROLLBARDIALOG), 
				hWnd, ScrollBarDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_STATIC_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_STATICDIALOG), 
				hWnd, StaticDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
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
//   FUNCTION: OnClose(HWND)
//
//   PURPOSE: Process the WM_CLOSE message
//
void OnClose(HWND hWnd)
{
	DestroyWindow(hWnd);
}

//
//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the main window.
//
//  WM_CREATE	- a window is being created
//  WM_COMMAND	- process the application commands
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

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

#pragma endregion


#pragma region Button

#define IDC_DEFPUSHBUTTON		990
#define IDC_PUSHBUTTON			991
#define IDC_AUTOCHECKBOX		992
#define IDC_AUTORADIOBUTTON		993
#define IDC_GROUPBOX			994
#define IDC_ICONBUTTON			995
#define IDC_BITMAPBUTTON		996

//
//   FUNCTION: OnInitButtonDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitButtonDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// The various button types are created by varying the style bits

	RECT rc = { 20, 20, 150, 30 };

	HWND hBtn = CreateWindowEx(0, _T("BUTTON"), _T("Default Push Button"), 
		BS_DEFPUSHBUTTON | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_DEFPUSHBUTTON, hInst, 0);
	SendMessage(hBtn, WM_SETFONT, (WPARAM)hFont, TRUE);

	rc.top += 40;

	hBtn = CreateWindowEx(0, _T("BUTTON"), _T("Push Button"),
		BS_PUSHBUTTON | WS_CHILD | WS_VISIBLE,
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_PUSHBUTTON, hInst, 0);
	SendMessage(hBtn, WM_SETFONT, (WPARAM)hFont, TRUE);

	rc.top += 40;
	
	hBtn = CreateWindowEx(0, _T("BUTTON"), _T("Check Box"),
		BS_AUTOCHECKBOX | WS_CHILD | WS_VISIBLE,
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_AUTOCHECKBOX, hInst, 0);
	SendMessage(hBtn, WM_SETFONT, (WPARAM)hFont, TRUE);
	
	rc.top += 30;
	
	hBtn = CreateWindowEx(0, _T("BUTTON"), _T("Radio Button"),
		BS_AUTORADIOBUTTON | WS_CHILD | WS_VISIBLE,
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_AUTORADIOBUTTON, hInst, 0);
	SendMessage(hBtn, WM_SETFONT, (WPARAM)hFont, TRUE);
   
	rc.top += 40;
	rc.bottom = 50;
	
	hBtn = CreateWindowEx(0, _T("BUTTON"), _T("Group Box"),
		BS_GROUPBOX | WS_CHILD | WS_VISIBLE,
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_GROUPBOX, hInst, 0);
	SendMessage(hBtn, WM_SETFONT, (WPARAM)hFont, TRUE);

	rc.top += 60;
	rc.right = 70;
	rc.bottom = 40;
	
	hBtn = CreateWindowEx(0, _T("BUTTON"), _T("Icon Button - No Text"), 
		BS_ICON | WS_CHILD | WS_VISIBLE,
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_ICONBUTTON, hInst, 0);
	HICON hIcon = (HICON)LoadImage(0, IDI_EXCLAMATION, IMAGE_ICON, 0, 0, LR_SHARED);
	SendMessage(hBtn, BM_SETIMAGE, IMAGE_ICON, (LPARAM)hIcon);

	rc.left += 80;

	hBtn = CreateWindowEx(0, _T("BUTTON"), _T("Bitmap Button - No Text"), 
		BS_BITMAP | WS_CHILD | WS_VISIBLE,
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_BITMAPBUTTON, hInst, 0);
	HBITMAP hBmp = (HBITMAP)LoadImage(hInst, MAKEINTRESOURCE(IDB_BITMAP1),
		IMAGE_BITMAP, 0, 0, LR_SHARED);
	SendMessage(hBtn, BM_SETIMAGE, IMAGE_BITMAP, (LPARAM)hBmp);

	return TRUE;
}

//
//  FUNCTION: ButtonDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Button control dialog.
//
//
INT_PTR CALLBACK ButtonDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitButtonDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitButtonDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region ComboBox

#define IDC_SIMPLECOMBO			1990
#define IDC_DROPDOWNCOMBO		1991
#define IDC_DROPDOWNLISTCOMBO	1992

//
//   FUNCTION: OnInitComboBoxDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitComboBoxDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// The various combobox types are created by varying the style bits

	RECT rc = { 20, 20, 150, 90 };

	HWND hCombo = CreateWindowEx(0, _T("COMBOBOX"), _T("Simple Combobox"), 
		CBS_SIMPLE | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_SIMPLECOMBO, hInst, 0);
	SendMessage(hCombo, CB_ADDSTRING, 0, (LPARAM)_T("Simple Combobox"));
	SendMessage(hCombo, WM_SETFONT, (WPARAM)hFont, TRUE);

	rc.top += 90;

	hCombo = CreateWindowEx(0, _T("COMBOBOX"), _T("Drop Down Combobox"), 
		CBS_DROPDOWN | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_DROPDOWNCOMBO, hInst, 0);
	SendMessage(hCombo, CB_ADDSTRING, 0, (LPARAM)_T("Drop Down Combobox"));
	SendMessage(hCombo, WM_SETFONT, (WPARAM)hFont, TRUE); 

	rc.top += 40;

	hCombo = CreateWindowEx(0, _T("COMBOBOX"), _T("Drop Down List Combobox"), 
		CBS_DROPDOWNLIST | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_DROPDOWNLISTCOMBO, hInst, 0);
	SendMessage(hCombo, CB_ADDSTRING, 0, (LPARAM)_T("Drop Down List Combobox"));
	SendMessage(hCombo, WM_SETFONT, (WPARAM)hFont, TRUE);

	return TRUE;
}

//
//  FUNCTION: ComboBoxDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the ComboBox control dialog.
//
//
INT_PTR CALLBACK ComboBoxDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitComboBoxDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitComboBoxDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Edit

#define IDC_SINGLELINEEDIT		2990
#define IDC_MULTILINEEDIT		2991

//
//   FUNCTION: OnInitEditDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitEditDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// The various edit types are created by varying the style bits

	RECT rc = { 20, 20, 150, 30 };

	HWND hEdit = CreateWindowEx(WS_EX_CLIENTEDGE, _T("EDIT"), _T("Single Line"), 
		WS_CHILD | WS_VISIBLE, rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_SINGLELINEEDIT, hInst, 0);
	SendMessage(hEdit, WM_SETFONT, (WPARAM)hFont, TRUE);

	rc.top += 40;
	rc.bottom += 30;

	hEdit = CreateWindowEx(WS_EX_CLIENTEDGE, _T("EDIT"), _T("Multi\r\nLine"), 
		ES_MULTILINE | WS_VSCROLL | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_MULTILINEEDIT, hInst, 0);
	SendMessage(hEdit, WM_SETFONT, (WPARAM)hFont, TRUE);

	return TRUE;
}

//
//  FUNCTION: EditDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Edit control dialog.
//
//
INT_PTR CALLBACK EditDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitEditDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitEditDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region RichEdit

#include <richedit.h>		// To use richedit control

#pragma region Helpers

//
//   FUNCTION: IsWinXPSp1Min()
//
//   PURPOSE: Return TRUE if operating sytem is Windows XP SP1 or later. 
//   Windows XP SP1 is the minimum system required to use a richedit v4.1 but only 
//   when UNICODE is defined.
//
BOOL IsWinXPSp1Min()
{
	OSVERSIONINFO osvi = {0};
	osvi.dwOSVersionInfoSize = sizeof(osvi);
	
	if (!GetVersionEx(&osvi))
		return FALSE;	// Error

	// Determine if system is Windows XP minimum
	if (osvi.dwMajorVersion >= 5 && osvi.dwMinorVersion >= 1)
	{
		// Now check if system is specifically WinXP and, if so, what service pack 
		// version is installed.
		if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 1)
		{
			// The following test assumes that the szCSDVersion member of the 
			// OSVERSIONINFO struct's format will always be a string like 
			// "Service Pack x", where 'x' is a number >= 1. This is fine for SP1 
			// and SP2 but future service packs may have a different string 
			// descriptor.
			TCHAR* pszCSDVersion = _T("Service Pack 1");
			if (osvi.szCSDVersion < pszCSDVersion)
				return FALSE;
		}
		return TRUE;
	}
	return FALSE;
}

//
//   FUNCTION: GetRichEditClassName()
//
//   PURPOSE: Load the proper version of RichEdit and return the class name.
//
TCHAR* GetRichEditClassName()
{
	HINSTANCE hLib;

	// Try to load latest version of rich edit control. Since v4.1 is available 
	// only as an UNICODE control on a minimum of Windows XP with service pack 1 
	// (sp1) installed, use preprocessor conditional to ensure that an attempt to 
	// load Msftedit.dll is only made if UNICODE is defined.

#if defined UNICODE
	if (IsWinXPSp1Min())
	{
		// Try to get richedit v4.1, explicitly use wide character string as this 
		// is UNICODE only.
		hLib = LoadLibrary(L"msftedit.dll");
		if (hLib)
			return MSFTEDIT_CLASS;
	}
#endif

	// Cannot get latest version (v4.1) so try to get earlier one

	hLib = LoadLibrary(_T("riched20.dll"));	// Rich Edit Version 2.0/3.0
	if (hLib)
		return RICHEDIT_CLASS;	// Version 2.0/3.0 is good

	hLib = LoadLibrary(_T("riched32.dll"));	// Rich Edit Version 1.0
	if (hLib)
		return _T("RichEdit");	// Version 1.0 is good

	// Cannot get any versions of RichEdit control (error)
	return _T("");
}

#pragma endregion


#define IDC_RICHEDIT		3990

//
//   FUNCTION: OnInitRichEditDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitRichEditDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	RECT rc = { 20, 20, 160, 250 };

	HWND hRichEdit = CreateWindowEx(WS_EX_CLIENTEDGE, GetRichEditClassName(), 
		_T("RichEdit Control"), 
		ES_MULTILINE | ES_AUTOHSCROLL | WS_HSCROLL | ES_AUTOVSCROLL | 
		WS_VSCROLL | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_RICHEDIT, hInst, 0);
	SendMessage(hRichEdit, WM_SETFONT, (WPARAM)hFont, TRUE);

	return TRUE;
}

//
//  FUNCTION: RichEditDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the RichEdit control dialog.
//
//
INT_PTR CALLBACK RichEditDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitRichEditDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitRichEditDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region ListBox

#define IDC_LISTBOX		4990

//
//   FUNCTION: OnInitListBoxDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitListBoxDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	RECT rc = { 20, 20, 160, 250 };

	HWND hList = CreateWindowEx(WS_EX_CLIENTEDGE, _T("LISTBOX"), _T(""), 
		WS_CHILD | WS_VISIBLE,
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_LISTBOX, hInst, 0);
	SendMessage(hList, LB_ADDSTRING, 0, (LPARAM)_T("ListBox"));
	SendMessage(hList, WM_SETFONT, (WPARAM)hFont, TRUE);

	return TRUE;
}

//
//  FUNCTION: ListBoxDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the ListBox control dialog.
//
//
INT_PTR CALLBACK ListBoxDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitListBoxDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitListBoxDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region ScrollBar

#define IDC_HORZ_SCROLLBAR		5990
#define IDC_VERT_SCROLLBAR		5991

//
//   FUNCTION: OnInitScrollBarDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitScrollBarDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// The various scrollbar types are created by simply varying the style bits

	RECT rc = { 20, 20, 160, 20 };

	HWND hScroll = CreateWindowEx(0, _T("SCROLLBAR"), NULL, 
		SBS_HORZ | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_HORZ_SCROLLBAR, hInst, 0);
	SendMessage(hScroll, WM_SETFONT, (WPARAM)hFont, TRUE);

	SetRect(&rc, 160, 50, 20, 200);

	hScroll = CreateWindowEx(0, _T("SCROLLBAR"), NULL, 
		SBS_VERT | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_VERT_SCROLLBAR, hInst, 0);
	SendMessage(hScroll, WM_SETFONT, (WPARAM)hFont, TRUE);

	return TRUE;
}

//
//  FUNCTION: ScrollBarDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the ScrollBar control dialog.
//
//
INT_PTR CALLBACK ScrollBarDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitScrollBarDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitScrollBarDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Static

#define IDC_WHITE		6990
#define IDC_TEXT		6991
#define IDC_IMAGE		6992

//
//   FUNCTION: OnInitStaticDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitStaticDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// The various static types are created by simply varying the style bits

	RECT rc = { 20, 20, 150, 20 };

	HWND hStatic = CreateWindowEx(0, _T("STATIC"), _T(""), 
		SS_WHITERECT | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom,
		hWnd, (HMENU)IDC_WHITE, hInst, 0);
	SendMessage(hStatic, WM_SETFONT, (WPARAM)hFont, TRUE);

	rc.top += 40;

	hStatic = CreateWindowEx(0, _T("STATIC"), _T("Text Static Control"), 
		SS_SIMPLE | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom,
		hWnd, (HMENU)IDC_TEXT, hInst, 0);
	SendMessage(hStatic, WM_SETFONT, (WPARAM)hFont, TRUE);

	rc.top += 30;

	hStatic = CreateWindowEx(0, _T("STATIC"), _T(""), 
		SS_ICON | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom,
		hWnd, (HMENU)IDC_IMAGE, hInst, 0);
	SendMessage(hStatic, STM_SETIMAGE, IMAGE_ICON, 
		(LPARAM)LoadImage(0, IDI_APPLICATION, IMAGE_ICON, 0, 0, LR_SHARED));
	SendMessage(hStatic, WM_SETFONT, (WPARAM)hFont, TRUE);

	return TRUE;
}

//
//  FUNCTION: StaticDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Static control dialog.
//
//
INT_PTR CALLBACK StaticDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitStaticDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitStaticDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion