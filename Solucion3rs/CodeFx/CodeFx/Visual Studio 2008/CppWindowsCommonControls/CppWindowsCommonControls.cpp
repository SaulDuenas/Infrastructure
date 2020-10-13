/****************************** Module Header ******************************\
* Module Name:	CppWindowsCommonControls.cpp
* Project:		CppWindowsCommonControls
* Copyright (c) Microsoft Corporation.
* 
* CppWindowsCommonControls contains simple examples of how to create common  
* controls defined in comctl32.dll. The controls include Animation, 
* ComboBoxEx, Updown, Header, MonthCal, DateTimePick, ListView, TreeView, 
* Tab, Tooltip, IP Address, Statusbar, Progress Bar, Toolbar, Trackbar, and 
* SysLink.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 5/10/2009 8:15 AM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include "CppWindowsCommonControls.h"
#include <windowsx.h>
#include <commctrl.h>
#include <assert.h>
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
INT_PTR CALLBACK	AnimationDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	ComboBoxExDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	UpdownDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	HeaderDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	MonthCalDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	DateTimePickDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	ListviewDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	TreeviewDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	TabControlDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	TooltipDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	IPAddressDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	StatusbarDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	ProgressDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	ToolbarDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	TrackbarDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	SysLinkDlgProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	RebarDlgProc(HWND, UINT, WPARAM, LPARAM);

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
	LoadString(hInstance, IDC_CPPWINDOWSCOMMONCONTROLS, szWindowClass, MAX_LOADSTRING);
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
	wcex.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(IDI_CPPWINDOWSCOMMONCONTROLS));
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
	case IDC_ANIMATION_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_ANIMATIONDIALOG), 
				hWnd, AnimationDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_COMBOBOXEX_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_COMBOBOXEXDIALOG), 
				hWnd, ComboBoxExDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_DATETIMEPICK_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_DATETIMEPICKDIALOG), 
				hWnd, DateTimePickDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_HEADER_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_HEADERDIALOG), 
				hWnd, HeaderDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_IPADDRESS_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_IPADDRESSDIALOG), 
				hWnd, IPAddressDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_LISTVIEW_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_LISTVIEWDIALOG), 
				hWnd, ListviewDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_MONTHCAL_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_MONTHCALDIALOG), 
				hWnd, MonthCalDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_PROGRESS_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_PROGRESSDIALOG), 
				hWnd, ProgressDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_SYSLINK_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_SYSLINKDIALOG), 
				hWnd, SysLinkDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_STATUS_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_STATUSDIALOG), 
				hWnd, StatusbarDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_TABCONTROL_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_TABCONTROLDIALOG), 
				hWnd, TabControlDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_TOOLBAR_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_TOOLBARDIALOG), 
				hWnd, ToolbarDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_TOOLTIP_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_TOOLTIPDIALOG), 
				hWnd, TooltipDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_TRACKBAR_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_TRACKBARDIALOG), 
				hWnd, TrackbarDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_TREEVIEW_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_TREEVIEWDIALOG), 
				hWnd, TreeviewDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_UPDOWN_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_UPDOWNDIALOG), 
				hWnd, UpdownDlgProc);
			if (hDlg)
				ShowWindow(hDlg, SW_SHOW);
		}
		break;

	case IDC_REBAR_BN:
		{
			HWND hDlg = CreateDialog(hInst, 
				MAKEINTRESOURCE(IDD_REBARDIALOG), 
				hWnd, RebarDlgProc);
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


#pragma region Animation
// MSDN: Animation Control
// http://msdn.microsoft.com/en-us/library/bb761881.aspx

#define IDC_ANIMATION		990

//
//   FUNCTION: OnInitAnimationDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitAnimationDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register animation control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_ANIMATE_CLASS;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the animation control
	RECT rc = { 20, 20, 280, 60 };
	HWND hAnimate = CreateWindowEx(0, ANIMATE_CLASS, 0, 
		ACS_TIMER | ACS_AUTOPLAY | ACS_TRANSPARENT | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_ANIMATION, hInst, 0);

	// Open the AVI clip and display its first frame in the animation control
	SendMessage(hAnimate, ACM_OPEN, (WPARAM)0, 
		(LPARAM)MAKEINTRESOURCE(IDR_UPLOAD_AVI));

	// Plays the AVI clip in the animation control
	SendMessage(hAnimate, ACM_PLAY, (WPARAM)-1, 
		MAKELONG(/*from frame*/0, /*to frame*/-1));

	return TRUE;
}

//
//  FUNCTION: AnimationDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Animation control dialog.
//
//
INT_PTR CALLBACK AnimationDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitAnimationDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitAnimationDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region ComboBoxEx
// MSDN: ComboBoxEx Control Reference
// http://msdn.microsoft.com/en-us/library/bb775740.aspx

#define IDC_COMBOBOXEX		1990

//
//   FUNCTION: OnInitComboBoxExDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitComboBoxExDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register ComboBoxEx control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_USEREX_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the ComboBoxEx control
	RECT rc = { 20, 20, 280, 100 };
	HWND hComboEx = CreateWindowEx(0, WC_COMBOBOXEX, 0, 
		CBS_DROPDOWN | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_COMBOBOXEX, hInst, 0);

	// Create an image list to hold icons for use by the ComboBoxEx control
	LPCTSTR lpszResID[] = { IDI_APPLICATION, IDI_INFORMATION, IDI_QUESTION };
	UINT nIconCount = sizeof(lpszResID) / sizeof(lpszResID[0]);
	HIMAGELIST hImageList = ImageList_Create(16, 16, ILC_MASK | ILC_COLOR32,
		nIconCount, 0);
	for (UINT i = 0; i < nIconCount; i++)
	{
		ImageList_AddIcon(hImageList, 
			(HICON)LoadImage(0, lpszResID[i], IMAGE_ICON, 0, 0, LR_SHARED));
	}

	// Associate the image list with the ComboBoxEx common control
	SendMessage(hComboEx, CBEM_SETIMAGELIST, 0, (LPARAM)hImageList);

	// Add nIconCount items to the ComboBoxEx common control
	TCHAR szText[200];
	for (UINT i = 0; i < nIconCount; i++)
	{
		COMBOBOXEXITEM cbei = {0};
		cbei.mask = CBEIF_IMAGE | CBEIF_TEXT | CBEIF_SELECTEDIMAGE;
		cbei.iItem = -1;
		_stprintf_s(szText, 200, _T("Item  %d"), i);
		cbei.pszText = szText;
		cbei.iImage = i;
		cbei.iSelectedImage = i;
		SendMessage(hComboEx, CBEM_INSERTITEM, 0, (LPARAM)&cbei);
	}

	// Store the image list handle as the user data of the window so that it
	// can be destroyed when the window is destroyed. (See OnComboBoxExClose)
	SetWindowLongPtr(hWnd, GWLP_USERDATA, (LONG_PTR)hImageList);

	return TRUE;
}

//
//   FUNCTION: OnComboBoxExClose(HWND)
//
//   PURPOSE: Process the WM_CLOSE message
//
void OnComboBoxExClose(HWND hWnd)
{
	// Destroy the image list associated with the ComboBoxEx control
	ImageList_Destroy((HIMAGELIST)GetWindowLongPtr(hWnd, GWLP_USERDATA));

	DestroyWindow(hWnd);
}

//
//  FUNCTION: ComboBoxExDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the ComboBoxEx control dialog.
//
//
INT_PTR CALLBACK ComboBoxExDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitComboBoxExDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitComboBoxExDialog);

		// Handle the WM_CLOSE message in OnComboBoxExClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnComboBoxExClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Updown
// MSDN: Up-Down Control
// http://msdn.microsoft.com/en-us/library/bb759880.aspx

#define IDC_EDIT		2990
#define IDC_UPDOWN		2991

//
//   FUNCTION: OnInitUpdownDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitUpdownDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register Updown control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_UPDOWN_CLASS;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create an Edit control
	RECT rc = { 20, 20, 100, 24 };
	HWND hEdit = CreateWindowEx(WS_EX_CLIENTEDGE, _T("EDIT"), 0, 
		WS_CHILD | WS_VISIBLE, rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_EDIT, hInst, 0);

	// Create the ComboBoxEx control
	SetRect(&rc, 20, 60, 180, 20);
	HWND hUpdown = CreateWindowEx(0, UPDOWN_CLASS, 0, 
		UDS_ALIGNRIGHT | UDS_SETBUDDYINT | UDS_WRAP | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_UPDOWN, hInst, 0);

	// Explicitly attach the Updown control to its 'buddy' edit control
	SendMessage(hUpdown, UDM_SETBUDDY, (WPARAM)hEdit, 0);

	return TRUE;
}

//
//  FUNCTION: UpdownDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Updown control dialog.
//
//
INT_PTR CALLBACK UpdownDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitUpdownDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitUpdownDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Header
// MSDN: Header Control
// http://msdn.microsoft.com/en-us/library/bb775239.aspx

#define IDC_HEADER			3990

//
//   FUNCTION: OnHeaderSize(HWND, UINT, int, int)
//
//   PURPOSE: Process the WM_SIZE message
//
void OnHeaderSize(HWND hWnd, UINT state, int cx, int cy)
{
	// Adjust the position and the layout of the Header control
	RECT rc = { 0, 0, cx, cy };
	WINDOWPOS wp = { 0 };
	HDLAYOUT hdl = { &rc, &wp };

	// Get the header control handle which has been previously stored in the 
	// user data associated with the parent window.
	HWND hHeader = (HWND)GetWindowLongPtr(hWnd, GWLP_USERDATA);

	// hdl.wp retrieves information used to set the size and postion of the  
	// header control within the target rectangle of the parent window. 
	SendMessage(hHeader, HDM_LAYOUT, 0, (LPARAM)&hdl);

	// Set the size and position of the header control based on hdl.wp.
	SetWindowPos(hHeader, wp.hwndInsertAfter, 
		wp.x, wp.y, wp.cx, wp.cy + 8, wp.flags);
}

//
//   FUNCTION: OnInitHeaderDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitHeaderDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register Header control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_WIN95_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the Header control
	RECT rc = { 0, 0, 0, 0 };
	HWND hHeader = CreateWindowEx(0, WC_HEADER, 0, 
		HDS_BUTTONS | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_HEADER, hInst, 0);

	// Store the header control handle as the user data associated with the 
	// parent window so that it can be retrieved for later use.
	SetWindowLongPtr(hWnd, GWLP_USERDATA, (LONG_PTR)hHeader);

	// Resize the header control
	GetClientRect(hWnd, &rc);
	OnHeaderSize(hWnd, 0, rc.right, rc.bottom);

	// Set the font for the header common control
	SendMessage(hHeader, WM_SETFONT, (WPARAM)GetStockObject(DEFAULT_GUI_FONT), 0);

	// Add 4 Header items
	TCHAR szText[200];
	for (UINT i = 0; i < 4; i++)
	{
		HDITEM hdi = {0};
		hdi.mask = HDI_WIDTH | HDI_FORMAT | HDI_TEXT;
		hdi.cxy = rc.right / 4;
		hdi.fmt = HDF_CENTER;
		_stprintf_s(szText, 200, _T("Header  %d"), i);
		hdi.pszText = szText;
		hdi.cchTextMax = 200;

		SendMessage(hHeader, HDM_INSERTITEM, i, (LPARAM)&hdi);
	}

	return TRUE;
}

//
//  FUNCTION: HeaderDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Header control dialog.
//
//
INT_PTR CALLBACK HeaderDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitHeaderDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitHeaderDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

		// Handle the WM_SIZE message in OnHeaderSize
		HANDLE_MSG (hWnd, WM_SIZE, OnHeaderSize);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region MonthCal
// MSDN: Month Calendar Control Reference
// http://msdn.microsoft.com/en-us/library/bb760917.aspx

#define IDC_MONTHCAL		4990

//
//   FUNCTION: OnInitMonthCalDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitMonthCalDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register MonthCal control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_DATE_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the Month Calendar control
	RECT rc = { 20, 20, 280, 200 };
	HWND hMonthCal = CreateWindowEx(0, MONTHCAL_CLASS, 0, 
		WS_CHILD | WS_VISIBLE, rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_MONTHCAL, hInst, 0);

	return TRUE;
}

//
//  FUNCTION: MonthCalDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the MonthCal control dialog.
//
//
INT_PTR CALLBACK MonthCalDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitMonthCalDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitMonthCalDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region DateTimePick
// MSDN: Date and Time Picker
// http://msdn.microsoft.com/en-us/library/bb761727.aspx

#define IDC_DATETIMEPICK		5990

//
//   FUNCTION: OnInitDateTimePickDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitDateTimePickDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register DateTimePick control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_DATE_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the DateTimePick control
	RECT rc = { 20, 20, 150, 30 };
	HWND hDateTimePick = CreateWindowEx(0, DATETIMEPICK_CLASS, 0, 
		WS_CHILD | WS_VISIBLE, rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_DATETIMEPICK, hInst, 0);

	return TRUE;
}

//
//  FUNCTION: DateTimePickDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the DateTimePick control dialog.
//
//
INT_PTR CALLBACK DateTimePickDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitDateTimePickDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitDateTimePickDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Listview
// MSDN: List View
// http://msdn.microsoft.com/en-us/library/bb774737.aspx

#define IDC_LISTVIEW		6990

struct LVHandles
{
	HWND hListview;
	HIMAGELIST hLargeIcons;
	HIMAGELIST hSmallIcons;
};

//
//   FUNCTION: OnListviewSize(HWND, UINT, int, int)
//
//   PURPOSE: Process the WM_SIZE message
//
void OnListviewSize(HWND hWnd, UINT state, int cx, int cy)
{
	// Get the pointer to listview information which was previously stored in 
	// the user data associated with the parent window.
	LVHandles* lvh = (LVHandles*)GetWindowLongPtr(hWnd, GWLP_USERDATA);
	
	// Resize the listview control to fill the parent window's client area
	MoveWindow(lvh->hListview, 0, 0, cx, cy, 1);
	
	// Arrange contents of listview along top of control
	SendMessage(lvh->hListview, LVM_ARRANGE, LVA_ALIGNTOP, 0);
}

//
//   FUNCTION: OnInitListviewDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitListviewDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register Listview control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_LISTVIEW_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create storage for struct to contain information about the listview 
	// (window and image list handles).
	LVHandles* lvh = new LVHandles();

	// Store that pointer as the user data associated with the parent window 
	// so that it can be retrieved for later use. 
	SetWindowLongPtr(hWnd, GWLP_USERDATA, (LONG_PTR)lvh);

	// Create the Listview control
	RECT rc;
	GetClientRect(hWnd, &rc);
	lvh->hListview = CreateWindowEx(0, WC_LISTVIEW, 0, 
		LVS_ICON | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_LISTVIEW, hInst, 0);


	/////////////////////////////////////////////////////////////////////////
	// Set up and attach image lists to list view common control.
	// 

	// Create the image lists
	int lx = GetSystemMetrics(SM_CXICON);
	int ly = GetSystemMetrics(SM_CYICON);
	lvh->hLargeIcons = ImageList_Create(lx, ly, ILC_COLOR32 | ILC_MASK, 1, 1); 
	int sx = GetSystemMetrics(SM_CXSMICON);
	int sy = GetSystemMetrics(SM_CYSMICON);
	lvh->hSmallIcons = ImageList_Create(sx, sy, ILC_COLOR32 | ILC_MASK, 1, 1);

	// Add icons to image lists
	HICON hLargeIcon, hSmallIcon;
	for (int rid = IDI_ICON1; rid <= IDI_ICON10; rid++)
	{
		// Load and add the large icon
		hLargeIcon = (HICON)LoadImage(hInst, MAKEINTRESOURCE(rid), 
			IMAGE_ICON, lx, ly, 0);
		ImageList_AddIcon(lvh->hLargeIcons, hLargeIcon);
		DestroyIcon(hLargeIcon);

		// Load and add the small icon
		hSmallIcon = (HICON)LoadImage(hInst, MAKEINTRESOURCE(rid), 
			IMAGE_ICON, sx, sy, 0);
		ImageList_AddIcon(lvh->hSmallIcons, hSmallIcon);
		DestroyIcon(hSmallIcon);
	}

	// Attach image lists to list view common control
	ListView_SetImageList(lvh->hListview, lvh->hLargeIcons, LVSIL_NORMAL); 
	ListView_SetImageList(lvh->hListview, lvh->hSmallIcons, LVSIL_SMALL);


	/////////////////////////////////////////////////////////////////////////
	// Add items to the the list view common control.
	// 

	LVITEM lvi = {0};
	lvi.mask = LVIF_TEXT | LVIF_IMAGE;
	TCHAR szText[200];
	for (int i = 0; i < 10; i++)
	{
		lvi.iItem = i;
		_stprintf_s(szText, 200, _T("Item  %d"), i);
		lvi.pszText = szText;
		lvi.iImage = i;

		SendMessage(lvh->hListview, LVM_INSERTITEM, 0, (LPARAM)&lvi);
	}

	return TRUE;
}

//
//   FUNCTION: OnListviewClose(HWND)
//
//   PURPOSE: Process the WM_CLOSE message
//
void OnListviewClose(HWND hWnd)
{
	// Free up resources
	
	// Get the information which was previously stored as the user data of 
	// the main window
	LVHandles* lvh = (LVHandles*)GetWindowLongPtr(hWnd, GWLP_USERDATA);
	
	// Destroy the image lists
	ImageList_Destroy(lvh->hLargeIcons);
	ImageList_Destroy(lvh->hSmallIcons);
	delete lvh;

	DestroyWindow(hWnd);
}

//
//  FUNCTION: ListviewDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Listview control dialog.
//
//
INT_PTR CALLBACK ListviewDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitListviewDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitListviewDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnListviewClose);

		// Handle the WM_SIZE message in OnListviewSize
		HANDLE_MSG (hWnd, WM_SIZE, OnListviewSize);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Treeview
// MSDN: Tree View
// http://msdn.microsoft.com/en-us/library/bb759988.aspx

#define IDC_TREEVIEW		7990

//
//   FUNCTION: OnTreeviewSize(HWND, UINT, int, int)
//
//   PURPOSE: Process the WM_SIZE message
//
void OnTreeviewSize(HWND hWnd, UINT state, int cx, int cy)
{
	// Get the treeview control handle which was previously stored in the 
	// user data associated with the parent window.
	HWND hTreeview = (HWND)GetWindowLongPtr(hWnd, GWLP_USERDATA);

	// Resize treeview control to fill client area of its parent window
	MoveWindow(hTreeview, 0, 0, cx, cy, TRUE);
}

HTREEITEM InsertTreeviewItem(const HWND hTreeview, const LPTSTR pszText, 
							 HTREEITEM htiParent)
{
	TVITEM tvi = {0};
	tvi.mask = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE;
	tvi.pszText = pszText;
	tvi.cchTextMax = _tcslen(pszText);
	tvi.iImage = 0;

	TVINSERTSTRUCT tvis = {0};
	tvi.iSelectedImage = 1;
	tvis.item = tvi; 
	tvis.hInsertAfter = 0;
	tvis.hParent = htiParent;

	return (HTREEITEM)SendMessage(hTreeview, TVM_INSERTITEM, 0, (LPARAM)&tvis);
}

//
//   FUNCTION: OnInitTreeviewDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitTreeviewDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register Treeview control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_TREEVIEW_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the Treeview control
	RECT rc;
	GetClientRect(hWnd, &rc);
	HWND hTreeview = CreateWindowEx(0, WC_TREEVIEW, 0, 
		TVS_HASLINES | TVS_LINESATROOT | TVS_HASBUTTONS | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_TREEVIEW, hInst, 0);

	// Store the Treeview control handle as the user data associated with the 
	// parent window so that it can be retrieved for later use.
	SetWindowLongPtr(hWnd, GWLP_USERDATA, (LONG_PTR)hTreeview);


	/////////////////////////////////////////////////////////////////////////
	// Set up and attach image lists to tree view common control.
	// 

	// Create an image list
	HIMAGELIST hImages = ImageList_Create(
		GetSystemMetrics(SM_CXSMICON),
		GetSystemMetrics(SM_CYSMICON), 
		ILC_COLOR32 | ILC_MASK, 1, 1);

	// Get an instance handle for a source of icon images
	HINSTANCE hLib = LoadLibrary(_T("shell32.dll"));
	assert(hLib);

	for (int i = 4; i < 6; i++)
	{
		// Because the icons are loaded from system resources (i.e. they are 
		// shared), it is not necessary to free resources with 'DestroyIcon'.
		HICON hIcon = (HICON)LoadImage(hLib, MAKEINTRESOURCE(i), IMAGE_ICON,
			0, 0, LR_SHARED);
		ImageList_AddIcon(hImages, hIcon); 
	}

	FreeLibrary(hLib);

	// Attach image lists to tree view common control
	TreeView_SetImageList(hTreeview, hImages, TVSIL_NORMAL);


	/////////////////////////////////////////////////////////////////////////
	// Add items to the tree view common control.
	// 

	// Insert the first item at root level
	HTREEITEM hPrev = InsertTreeviewItem(hTreeview, _T("First"), TVI_ROOT);

	// Sub item of first item
	hPrev = InsertTreeviewItem(hTreeview, _T("Level01"), hPrev);

	// Sub item of 'level01' item
	hPrev = InsertTreeviewItem(hTreeview, _T("Level02"), hPrev);

	// Insert the second item at root level
	hPrev = InsertTreeviewItem(hTreeview, _T("Second"), TVI_ROOT);

	// Insert the third item at root level
	hPrev = InsertTreeviewItem(hTreeview, _T("Third"), TVI_ROOT);

	return TRUE;
}

//
//   FUNCTION: OnTreeviewClose(HWND)
//
//   PURPOSE: Process the WM_CLOSE message
//
void OnTreeviewClose(HWND hWnd)
{
	// Get the treeview control handle which was previously stored in the 
	// user data associated with the parent window.
	HWND hTreeview = (HWND)GetWindowLongPtr(hWnd, GWLP_USERDATA);

	// Free resources used by the treeview's image list
	HIMAGELIST hImages = TreeView_GetImageList(hTreeview, TVSIL_NORMAL);
	ImageList_Destroy(hImages);

	DestroyWindow(hWnd);
}

//
//  FUNCTION: TreeviewDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Treeview control dialog.
//
//
INT_PTR CALLBACK TreeviewDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitTreeviewDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitTreeviewDialog);

		// Handle the WM_CLOSE message in OnTreeviewClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnTreeviewClose);

		// Handle the WM_SIZE message in OnTreeviewSize
		HANDLE_MSG (hWnd, WM_SIZE, OnTreeviewSize);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region TabControl
// MSDN: Tab
// http://msdn.microsoft.com/en-us/library/bb760548.aspx

#define IDC_TAB			8990

//
//   FUNCTION: OnTabSize(HWND, UINT, int, int)
//
//   PURPOSE: Process the WM_SIZE message
//
void OnTabSize(HWND hWnd, UINT state, int cx, int cy)
{
	// Get the Tab control handle which was previously stored in the 
	// user data associated with the parent window.
	HWND hTab = (HWND)GetWindowLongPtr(hWnd, GWLP_USERDATA);

	// Resize tab control to fill client area of its parent window
	MoveWindow(hTab, 2, 2, cx - 4, cy - 4, TRUE);
}

int InsertTabItem(HWND hTab, LPTSTR pszText, int iid)
{
	TCITEM ti = {0};
	ti.mask = TCIF_TEXT;
	ti.pszText = pszText;
	ti.cchTextMax = _tcslen(pszText);
	
	return (int)SendMessage(hTab, TCM_INSERTITEM, iid, (LPARAM)&ti);
}

//
//   FUNCTION: OnInitTabControlDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitTabControlDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register Tab control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_TAB_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the Tab control 
	RECT rc;
	GetClientRect(hWnd, &rc);
	HWND hTab = CreateWindowEx(0, WC_TABCONTROL, 0, 
		TCS_FIXEDWIDTH | WS_CHILD | WS_VISIBLE, 
		rc.left + 2, rc.top + 2, rc.right - 4, rc.bottom - 4, 
		hWnd, (HMENU)IDC_TAB, hInst, 0);

	// Set the font of the tabs to a more typical system GUI font
	SendMessage(hTab, WM_SETFONT, (WPARAM)GetStockObject(DEFAULT_GUI_FONT), 0);

	// Store the Tab control handle as the user data associated with the 
	// parent window so that it can be retrieved for later use.
	SetWindowLongPtr(hWnd, GWLP_USERDATA, (LONG_PTR)hTab);


	/////////////////////////////////////////////////////////////////////////
	// Add items to the tab common control.
	// 

	InsertTabItem(hTab, _T("First Page"), 0);
	InsertTabItem(hTab, _T("Second Page"), 1);
	InsertTabItem(hTab, _T("Third Page"), 2);
	InsertTabItem(hTab, _T("Fourth Page"), 3);
	InsertTabItem(hTab, _T("Fifth Page"), 4);

	return TRUE;
}

//
//  FUNCTION: TabControlDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the TabControl control dialog.
//
//
INT_PTR CALLBACK TabControlDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitTabControlDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitTabControlDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

		// Handle the WM_SIZE message in OnTabSize
		HANDLE_MSG (hWnd, WM_SIZE, OnTabSize);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Tooltip
// MSDN: ToolTip
// http://msdn.microsoft.com/en-us/library/bb760246.aspx

#define IDC_BUTTON1		9990

//
//   FUNCTION: OnInitTooltipDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitTooltipDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register Tooltip control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_WIN95_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create a button control
	RECT rc = { 20, 20, 120, 40 };
	HWND hBtn = CreateWindowEx(0, _T("BUTTON"), _T("Tooltip Target"), 
		WS_CHILD | WS_VISIBLE, rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_BUTTON1, hInst, 0); 

	// Create a tooltip
	// A tooltip control should not have the WS_CHILD style, nor should it 
	// have an id, otherwise its behavior will be adversely affected.
	HWND hTooltip = CreateWindowEx(0, TOOLTIPS_CLASS, _T(""), TTS_ALWAYSTIP, 
		0, 0, 0, 0, hWnd, 0, hInst, 0);

	// Associate the tooltip with the button control
	TOOLINFO ti = {0};
	ti.cbSize = sizeof(ti);
	ti.uFlags = TTF_IDISHWND | TTF_SUBCLASS;
	ti.uId = (UINT_PTR)hBtn;
	ti.lpszText = _T("This is a button.");
	ti.hwnd = hWnd;
	SendMessage(hTooltip, TTM_ADDTOOL, 0, (LPARAM)&ti);

	return TRUE;
}

//
//  FUNCTION: TooltipDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Tooltip control dialog.
//
//
INT_PTR CALLBACK TooltipDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitTooltipDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitTooltipDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region IPAddress
// MSDN: IP Address Control
// http://msdn.microsoft.com/en-us/library/bb761374.aspx

#define IDC_IPADDRESS		10990

//
//   FUNCTION: OnInitIPAddressDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitIPAddressDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register IPAddress control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_INTERNET_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the IPAddress control
	RECT rc = { 20, 20, 180, 24 };
	HWND hIPAddress = CreateWindowEx(0, WC_IPADDRESS, 0, 
		WS_CHILD | WS_VISIBLE, rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_IPADDRESS, hInst, 0);

	return TRUE;
}

//
//  FUNCTION: IPAddressDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the IPAddress control dialog.
//
//
INT_PTR CALLBACK IPAddressDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitIPAddressDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitIPAddressDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Statusbar
// MSDN: Status Bar
// http://msdn.microsoft.com/en-us/library/bb760726.aspx

#define IDC_STATUSBAR		11990

//
//   FUNCTION: OnStatusbarSize(HWND, UINT, int, int)
//
//   PURPOSE: Process the WM_SIZE message
//
void OnStatusbarSize(HWND hWnd, UINT state, int cx, int cy)
{
	// Get the Statusbar control handle which was previously stored in the 
	// user data associated with the parent window.
	HWND hStatusbar = (HWND)GetWindowLongPtr(hWnd, GWLP_USERDATA);

	// Partition the statusbar here to keep the ratio of the sizes of its 
	// parts constant. Each part is set by specifing the coordinates of the 
	// right edge of each part. -1 signifies the rightmost part of the parent.
	int nHalf = cx / 2;
	int nParts[] = { nHalf, nHalf + nHalf / 3, nHalf + nHalf * 2 / 3, -1 };
	SendMessage(hStatusbar, SB_SETPARTS, 4, (LPARAM)&nParts);

	// Resize statusbar so it's always same width as parent's client area
	SendMessage(hStatusbar, WM_SIZE, 0, 0);
}

//
//   FUNCTION: OnInitStatusbarDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitStatusbarDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register IPAddress control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_BAR_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the status bar control
	RECT rc = { 0, 0, 0, 0 };
	HWND hStatusbar = CreateWindowEx(0, STATUSCLASSNAME, 0, 
		SBARS_SIZEGRIP | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_STATUSBAR, hInst, 0);

	// Store the statusbar control handle as the user data associated with 
	// the parent window so that it can be retrieved for later use.
	SetWindowLongPtr(hWnd, GWLP_USERDATA, (LONG_PTR)hStatusbar);

	// Establish the number of partitions or 'parts' the status bar will 
	// have, their actual dimensions will be set in the parent window's 
	// WM_SIZE handler.
	GetClientRect(hWnd, &rc);
	int nHalf = rc.right / 2;
	int nParts[4] = { nHalf, nHalf + nHalf / 3, nHalf + nHalf * 2 / 3, -1 };
	SendMessage(hStatusbar, SB_SETPARTS, 4, (LPARAM)&nParts);

	// Put some texts into each part of the status bar and setup each part
	SendMessage(hStatusbar, SB_SETTEXT, 0, (LPARAM)_T("Status Bar: Part 1"));
	SendMessage(hStatusbar, SB_SETTEXT, 1| SBT_POPOUT, (LPARAM)_T("Part 2"));
	SendMessage(hStatusbar, SB_SETTEXT, 2| SBT_POPOUT, (LPARAM)_T("Part 3"));
	SendMessage(hStatusbar, SB_SETTEXT, 3| SBT_POPOUT, (LPARAM)_T("Part 4"));

	return TRUE;
}

//
//  FUNCTION: StatusbarDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Statusbar control dialog.
//
//
INT_PTR CALLBACK StatusbarDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitStatusbarDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitStatusbarDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

		// Handle the WM_SIZE message in OnStatusbarSize
		HANDLE_MSG (hWnd, WM_SIZE, OnStatusbarSize);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Progress
// MSDN: Progress Bar
// http://msdn.microsoft.com/en-us/library/bb760818.aspx

#define IDC_PROGRESSBAR		12990

//
//   FUNCTION: OnInitProgressDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitProgressDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register Progress control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_PROGRESS_CLASS;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the progress bar control
	RECT rc = { 20, 20, 250, 20 };
	HWND hProgress = CreateWindowEx(0, PROGRESS_CLASS, 0, 
		WS_CHILD | WS_VISIBLE, rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_PROGRESSBAR, hInst, 0);

	// Set the progress bar position to half-way
	SendMessage(hProgress, PBM_SETPOS, 50, 0);

	return TRUE;
}

//
//  FUNCTION: ProgressDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Progress control dialog.
//
//
INT_PTR CALLBACK ProgressDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitProgressDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitProgressDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Toolbar
// MSDN: Toolbar
// http://msdn.microsoft.com/en-us/library/bb760435.aspx

#define IDC_TOOLBAR			13990

//
//   FUNCTION: OnInitToolbarDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitToolbarDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register Toolbar control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_BAR_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the Toolbar control
	RECT rc = { 0, 0, 0, 0 };
	HWND hToolbar = CreateWindowEx(0, TOOLBARCLASSNAME, 0, 
		TBSTYLE_FLAT | CCS_ADJUSTABLE | CCS_NODIVIDER | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_TOOLBAR, hInst, 0);


	/////////////////////////////////////////////////////////////////////////
	// Setup and add buttons to Toolbar.
	// 

	// If an application uses the CreateWindowEx function to create the 
	// toolbar, the application must send this message to the toolbar before 
	// sending the TB_ADDBITMAP or TB_ADDBUTTONS message. The CreateToolbarEx 
	// function automatically sends TB_BUTTONSTRUCTSIZE, and the size of the 
	// TBBUTTON structure is a parameter of the function.
	SendMessage(hToolbar, TB_BUTTONSTRUCTSIZE, (WPARAM)sizeof(TBBUTTON), 0);

	// Add images

	TBADDBITMAP tbAddBmp = {0};
	tbAddBmp.hInst = HINST_COMMCTRL;
	tbAddBmp.nID = IDB_STD_SMALL_COLOR;

	SendMessage(hToolbar, TB_ADDBITMAP, 0, (WPARAM)&tbAddBmp);

	// Add buttons

	const int numButtons = 7;
	TBBUTTON tbButtons[numButtons] = 
    {
		{ MAKELONG(STD_FILENEW, 0), NULL, TBSTATE_ENABLED, 
		BTNS_AUTOSIZE, {0}, 0, (INT_PTR)_T("New") },
		{ MAKELONG(STD_FILEOPEN, 0), NULL, TBSTATE_ENABLED, 
		BTNS_AUTOSIZE, {0}, 0, (INT_PTR)_T("Open") },
		{ MAKELONG(STD_FILESAVE, 0), NULL, 0, 
		BTNS_AUTOSIZE, {0}, 0, (INT_PTR)_T("Save") }, 
		{ MAKELONG(0, 0), NULL, 0, 
		TBSTYLE_SEP, {0}, 0, (INT_PTR)_T("") }, // Separator
		{ MAKELONG(STD_COPY, 0), NULL, TBSTATE_ENABLED, 
		BTNS_AUTOSIZE, {0}, 0, (INT_PTR)_T("Copy") }, 
		{ MAKELONG(STD_CUT, 0), NULL, TBSTATE_ENABLED, 
		BTNS_AUTOSIZE, {0}, 0, (INT_PTR)_T("Cut") }, 
		{ MAKELONG(STD_PASTE, 0), NULL, TBSTATE_ENABLED, 
		BTNS_AUTOSIZE, {0}, 0, (INT_PTR)_T("Paste") }
    };

	SendMessage(hToolbar, TB_ADDBUTTONS, numButtons, (LPARAM)tbButtons);

	// Tell the toolbar to resize itself, and show it.
	SendMessage(hToolbar, TB_AUTOSIZE, 0, 0); 

	return TRUE;
}

//
//  FUNCTION: ToolbarDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Toolbar control dialog.
//
//
INT_PTR CALLBACK ToolbarDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitToolbarDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitToolbarDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Trackbar
// MSDN: Trackbar
// http://msdn.microsoft.com/en-us/library/bb760145.aspx

#define IDC_TRACKBAR			14990

//
//   FUNCTION: OnInitTrackbarDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitTrackbarDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register Trackbar control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_WIN95_CLASSES; // Or ICC_PROGRESS_CLASS
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the Trackbar control
	RECT rc = { 20, 20, 250, 20 };
	HWND hTrackbar = CreateWindowEx(0, TRACKBAR_CLASS, 0, 
		TBS_AUTOTICKS | WS_CHILD | WS_VISIBLE, 
		rc.left, rc.top, rc.right, rc.bottom, 
		hWnd, (HMENU)IDC_TRACKBAR, hInst, 0);

	// Set Trackbar range
	SendMessage(hTrackbar, TBM_SETRANGE, 0, MAKELONG(0, 20));

	return TRUE;
}

//
//  FUNCTION: TrackbarDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Trackbar control dialog.
//
//
INT_PTR CALLBACK TrackbarDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitTrackbarDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitTrackbarDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region SysLink
// MSDN: SysLink
// http://msdn.microsoft.com/en-us/library/bb760704.aspx

#define IDC_SYSLINK			15990

//
//   FUNCTION: OnInitSysLinkDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitSysLinkDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register SysLink control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_LINK_CLASS;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the SysLink control
	// The SysLink control supports the anchor tag(<a>) along with the 
	// attributes HREF and ID. 
	RECT rc = { 20, 20, 500, 100 };
	HWND hLink = CreateWindowEx(0, WC_LINK, 
		_T("All-In-One Code Framework\n") \
		_T("<A HREF=\"http://cfx.codeplex.com\">Home</A> ") \
		_T("and <A ID=\"idBlog\">Blog</A>"), 
        WS_VISIBLE | WS_CHILD | WS_TABSTOP, 
		rc.left, rc.top, rc.right, rc.bottom, 
        hWnd, (HMENU)IDC_SYSLINK, hInst, NULL);

	return TRUE;
}

//
//   FUNCTION: OnSysLinkNotify(HWND, int, PNMLINK)
//
//   PURPOSE: Process the WM_NOTIFY message
//
LRESULT OnSysLinkNotify(HWND hWnd, int idCtrl, LPNMHDR pNMHdr)
{
	if (idCtrl != IDC_SYSLINK)	// Make sure that it is the SysLink control
		return 0;

	// The notifications associated with SysLink controls are NM_CLICK 
	// (syslink) and (for links that can be activated by the Enter key) 
	// NM_RETURN.
	switch (pNMHdr->code)
	{
	case NM_CLICK:
	case NM_RETURN:
		{
			PNMLINK pNMLink = (PNMLINK)pNMHdr;
			LITEM item = pNMLink->item;

			// Judging by the index of the link
			if (item.iLink == 0) // If it is the first link
			{
                ShellExecute(NULL, L"open", item.szUrl, NULL, NULL, SW_SHOW);
            }
			// Judging by the ID of the link
            else if (_tcscmp(item.szID, _T("idBlog")) == 0)
            {
				MessageBox(hWnd, _T("http://blogs.msdn.com/codefx"), 
					_T("CodeFx Blog"), MB_OK);
            }
			break;
		}
	}
	return 0;
}

//
//  FUNCTION: SysLinkDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the SysLink control dialog.
//
//
INT_PTR CALLBACK SysLinkDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitSysLinkDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitSysLinkDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

		// Handle the WM_NOTIFY message in OnNotify
		HANDLE_MSG (hWnd, WM_NOTIFY, OnSysLinkNotify);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion


#pragma region Rebar
// MSDN: Rebar
// http://msdn.microsoft.com/en-us/library/bb774375.aspx

#define IDC_REBAR			16990

//
//   FUNCTION: OnInitRebarDialog(HWND, HWND, LPARAM)
//
//   PURPOSE: Process the WM_INITDIALOG message
//
BOOL OnInitRebarDialog(HWND hWnd, HWND hWndFocus, LPARAM lParam)
{
	// Load and register Rebar control class
	INITCOMMONCONTROLSEX iccx;
	iccx.dwSize = sizeof(INITCOMMONCONTROLSEX);
	iccx.dwICC = ICC_COOL_CLASSES;
	if (!InitCommonControlsEx(&iccx))
		return FALSE;

	// Create the Rebar control
	RECT rc = { 0, 0, 0, 0 };
	HWND hRebar = CreateWindowEx(0, REBARCLASSNAME, _T(""), 
		WS_VISIBLE | WS_CHILD | RBS_AUTOSIZE, 
		rc.left, rc.top, rc.right, rc.bottom, 
        hWnd, (HMENU)IDC_REBAR, hInst, NULL);

	REBARINFO ri = {0};
	ri.cbSize = sizeof(REBARINFO);
	SendMessage(hRebar, RB_SETBARINFO, 0, (LPARAM)&ri);

	// Insert a image
	HICON hImg = (HICON)LoadImage(0, IDI_QUESTION, IMAGE_ICON, 0, 0, LR_SHARED);
	HWND hwndImg = CreateWindow(_T("STATIC"), NULL, 
		WS_CHILD | WS_VISIBLE | SS_ICON | SS_REALSIZEIMAGE | SS_NOTIFY,
		0, 0, 0, 0, hRebar, (HMENU)NULL, hInst,	NULL);

	// Set static control image
	SendMessage(hwndImg, STM_SETICON, (WPARAM)hImg, NULL);

	REBARBANDINFO rbBand;
	rbBand.cbSize = sizeof(REBARBANDINFO);
	rbBand.fMask = RBBIM_STYLE | RBBIM_CHILDSIZE | RBBIM_CHILD | RBBIM_SIZE;
	rbBand.fStyle = RBBS_CHILDEDGE | RBBS_NOGRIPPER;
	rbBand.hwndChild = hwndImg;
	rbBand.cxMinChild = 0;
	rbBand.cyMinChild = 20;
	rbBand.cx = 20;

	// Insert the img into the rebar
	SendMessage(hRebar, RB_INSERTBAND, (WPARAM)-1, (LPARAM)&rbBand);

	// Insert a blank band
	rbBand.cbSize = sizeof(REBARBANDINFO);
	rbBand.fMask =  RBBIM_STYLE | RBBIM_SIZE;
	rbBand.fStyle = RBBS_CHILDEDGE | RBBS_HIDETITLE | RBBS_NOGRIPPER;
	rbBand.cx = 1;

	// Insert the blank band into the rebar
	SendMessage(hRebar, RB_INSERTBAND, (WPARAM)-1, (LPARAM)&rbBand);

	return TRUE;
}

//
//  FUNCTION: RebarDlgProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the Rebar control dialog.
//
//
INT_PTR CALLBACK RebarDlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		// Handle the WM_INITDIALOG message in OnInitRebarDialog
		HANDLE_MSG (hWnd, WM_INITDIALOG, OnInitRebarDialog);

		// Handle the WM_CLOSE message in OnClose
		HANDLE_MSG (hWnd, WM_CLOSE, OnClose);

	default:
		return FALSE;	// Let system deal with msg
	}
	return 0;
}

#pragma endregion