/************************************ Module Header ************************************\
* Module Name:	CppShellCommonFileDialog.cpp
* Project:		CppShellCommonFileDialog
* Copyright (c) Microsoft Corporation.
* 
* 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 10/5/2009 9:15 AM Jialiang Ge Created
\***************************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include "CppShellCommonFileDialog.h"
#include <windowsx.h>
#include <shlobj.h>
#include <shlwapi.h>
#include <new>
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
void				OnOpenAFile(HWND);
void				OnOpenAFolder(HWND);
void				OnOpenFiles(HWND);
void				OnAddCustomControls(HWND);
void				OnAddCommonPlaces(HWND);
void				OnSaveAFile(HWND);

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
	LoadString(hInstance, IDC_CPPSHELLCOMMONFILEDIALOG, szWindowClass, MAX_LOADSTRING);
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
	wcex.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(IDI_CPPSHELLCOMMONFILEDIALOG));
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
	case IDC_OPENAFILE_BN:
		OnOpenAFile(hWnd);
		break;

	case IDC_OPENAFOLDER_BN:
		OnOpenAFolder(hWnd);
		break;

	case IDC_OPENFILES_BN:
		OnOpenFiles(hWnd);
		break;

	case IDC_ADDCUSTOMCONTROLS_BN:
		OnAddCustomControls(hWnd);
		break;

	case IDC_ADDCOMMONPLACES_BN:
		OnAddCommonPlaces(hWnd);
		break;

	case IDC_SAVEAFILE_BN:
		OnSaveAFile(hWnd);
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


#pragma region Basic Open File Dialogs

const COMDLG_FILTERSPEC c_rgFileTypes[] =
{
	{ L"Word Files (*.docx)",	L"*.docx" },
	{ L"Text Files (*.txt)",	L"*.txt" },
	{ L"All Files (*.*)",		L"*.*" }
};

//
//  FUNCTION: OnOpenAFile(HWND)
//
//  PURPOSE:  
//
//
void OnOpenAFile(HWND hWnd)
{
	HRESULT hr; 

	// Create a new common open file dialog
	IFileDialog* pfd = NULL;
	hr = CoCreateInstance(CLSID_FileOpenDialog, NULL, CLSCTX_INPROC_SERVER, 
		IID_PPV_ARGS(&pfd));
	if (SUCCEEDED(hr))
	{
		// (Optional) Control the default folder of the file dialog
		// Here we set it as the Music library knownfolder
		IShellItem* psiMusic = NULL;
		if (SUCCEEDED(hr = SHCreateItemInKnownFolder(FOLDERID_Music, 0, NULL, 
			IID_PPV_ARGS(&psiMusic))))
		{
			pfd->SetFolder(psiMusic);
			psiMusic->Release();
		}

		// (Optional) Set the title of the dialog
		if (SUCCEEDED(hr))
		{
			hr = pfd->SetTitle(L"Select a File");
		}

		// (Optional) Specify file types for the file dialog
		if (SUCCEEDED(hr) && SUCCEEDED(hr = pfd->SetFileTypes(ARRAYSIZE(c_rgFileTypes), 
			c_rgFileTypes)))
		{
			// Set the selected file type index to Word Document
			hr = pfd->SetFileTypeIndex(1);
		}

		// (Optional) Set the default extension to be added to file names as ".docx"
		if (SUCCEEDED(hr))
		{
			hr = pfd->SetDefaultExtension(L"docx");
		}

		// Show the open file dialog
		if (SUCCEEDED(hr) && SUCCEEDED(hr = pfd->Show(hWnd)))
		{
			// Get the result of the open file dialog
			IShellItem* psiResult = NULL;
			hr = pfd->GetResult(&psiResult);
			if (SUCCEEDED(hr))
			{
				PWSTR pszPath = NULL;
				hr = psiResult->GetDisplayName(SIGDN_FILESYSPATH, &pszPath);
				if (SUCCEEDED(hr))
				{
					MessageBox(hWnd, pszPath, L"The selected file is", MB_OK);
					CoTaskMemFree(pszPath);
				}
				psiResult->Release();
			}
		}

		pfd->Release();
	}

	if (FAILED(hr))
	{
		// User cancelled the dialog?
		if (hr != HRESULT_FROM_WIN32(ERROR_CANCELLED))
		{
			// Report the error for failure
			TCHAR szErrorMessage[260];
			_stprintf_s(szErrorMessage, ARRAYSIZE(szErrorMessage), 
				_T("OnOpenAFile returns w/err 0x%08lx"), hr);
			MessageBox(hWnd, szErrorMessage, _T("Error"), MB_ICONERROR);
		}
	}
}


//
//  FUNCTION: OnOpenAFolder(HWND)
//
//  PURPOSE:  
//
//
void OnOpenAFolder(HWND hWnd)
{
	HRESULT hr; 

	// Create a new common open file dialog
	IFileOpenDialog* pfd = NULL;
	hr = CoCreateInstance(CLSID_FileOpenDialog, NULL, CLSCTX_INPROC_SERVER, 
		IID_PPV_ARGS(&pfd));
	if (SUCCEEDED(hr))
	{
		// Set the dialog as a folder picker
		DWORD dwOptions;
		if (SUCCEEDED(hr = pfd->GetOptions(&dwOptions)))
		{
			hr = pfd->SetOptions(dwOptions | FOS_PICKFOLDERS);
		}

		// (Optional) Set the title of the dialog
		if (SUCCEEDED(hr))
		{
			hr = pfd->SetTitle(L"Select a Folder");
		}

		// Show the open file dialog
		if (SUCCEEDED(hr) && SUCCEEDED(hr = pfd->Show(hWnd)))
		{
			// Get the selection from the user
			IShellItem* psiResult = NULL;
			hr = pfd->GetResult(&psiResult);
			if (SUCCEEDED(hr))
			{
				PWSTR pszPath = NULL;
				hr = psiResult->GetDisplayName(SIGDN_FILESYSPATH, &pszPath);
				if (SUCCEEDED(hr))
				{
					MessageBox(hWnd, pszPath, L"The selected folder is", MB_OK);
					CoTaskMemFree(pszPath);
				}
				psiResult->Release();
			}
		}

		pfd->Release();
	}

	if (FAILED(hr))
	{
		// User cancelled the dialog?
		if (hr != HRESULT_FROM_WIN32(ERROR_CANCELLED))
		{
			// Report the error for failure
			TCHAR szErrorMessage[260];
			_stprintf_s(szErrorMessage, ARRAYSIZE(szErrorMessage), 
				_T("OnOpenAFolder returns w/err 0x%08lx"), hr);
			MessageBox(hWnd, szErrorMessage, _T("Error"), MB_ICONERROR);
		}
	}
}


//
//  FUNCTION: OnOpenFiles(HWND)
//
//  PURPOSE:  
//
//
void OnOpenFiles(HWND hWnd)
{
	HRESULT hr;

	// Create a new common open file dialog
	IFileOpenDialog* pfd = NULL;
	hr = CoCreateInstance(CLSID_FileOpenDialog, NULL, CLSCTX_INPROC_SERVER, 
		IID_PPV_ARGS(&pfd));
	if (SUCCEEDED(hr))
	{
		// Specify multi-select
		DWORD dwOptions;
		if (SUCCEEDED(hr = pfd->GetOptions(&dwOptions)))
		{
			hr = pfd->SetOptions(dwOptions | FOS_ALLOWMULTISELECT);
		}

		// (Optional) Set the title of the dialog
		if (SUCCEEDED(hr))
		{
			hr = pfd->SetTitle(L"Select Files");
		}		

		// Show the open file dialog
		if (SUCCEEDED(hr) && SUCCEEDED(hr = pfd->Show(hWnd)))
		{
			// Obtain the results of the user interaction
			IShellItemArray* psiaResults = NULL;
			hr = pfd->GetResults(&psiaResults);
			if (SUCCEEDED(hr))
			{
				// Get the number of files being selected
				DWORD dwFolderCount;
				hr = psiaResults->GetCount(&dwFolderCount);
				if (SUCCEEDED(hr))
				{
					// Allocate a zero buffer for concatting all file paths
					DWORD dwSizeInWords = dwFolderCount * MAX_PATH;
					PWSTR pszPaths = new WCHAR[dwSizeInWords];
					ZeroMemory(pszPaths, dwSizeInWords * sizeof(WCHAR));

					// Iterate through all selected files
					for (DWORD i = 0; i < dwFolderCount; i++)
					{
						IShellItem* pShellItem = NULL;
						if (SUCCEEDED(psiaResults->GetItemAt(i, &pShellItem)))
						{
							// Retrieve the file path
							PWSTR pszPath = NULL;
							if (SUCCEEDED(pShellItem->GetDisplayName(
								SIGDN_FILESYSPATH, &pszPath)))
							{
								wcscat_s(pszPaths, dwSizeInWords, pszPath);
								wcscat_s(pszPaths, dwSizeInWords, L"\r\n");
								CoTaskMemFree(pszPath);
							}
							pShellItem->Release();
						}
					}

					// Display the results
					MessageBox(hWnd, pszPaths, L"The selected files are", MB_OK);

					delete[] pszPaths;
				}
				psiaResults->Release();
			}
		}

		pfd->Release();
	}

	if (FAILED(hr))
	{
		// User cancelled the dialog?
		if (hr != HRESULT_FROM_WIN32(ERROR_CANCELLED))
		{
			// Report the error for failure
			TCHAR szErrorMessage[260];
			_stprintf_s(szErrorMessage, ARRAYSIZE(szErrorMessage), 
				_T("OnOpenFiles returns w/err 0x%08lx"), hr);
			MessageBox(hWnd, szErrorMessage, _T("Error"), MB_ICONERROR);
		}
	}
}

#pragma endregion


#pragma region Customized Open File Dialogs

// Controls
#define CONTROL_GROUP           2000
#define CONTROL_RADIOBUTTONLIST 2
#define CONTROL_RADIOBUTTON1    1
#define CONTROL_RADIOBUTTON2    2	// It is OK for this to have the same ID as 
// CONTROL_RADIOBUTTONLIST, because it is a child control under CONTROL_RADIOBUTTONLIST.


//
//  CLASS: CFileDialogEventHandler
//
//  PURPOSE:  File Dialog Event Handler that reesponds to Events in Added Controls.
//            The events handler provided by the calling process can implement 
//            IFileDialogControlEvents in addition to IFileDialogEvents. 
//            IFileDialogControlEvents enables the calling process to react to these 
//            events: 1) PushButton clicked. 2) CheckButton state changed. 3) Item 
//            selected from a menu, ComboBox, or RadioButton list. 4) Control 
//            activating. This is sent when a menu is about to display a drop-down 
//            list, in case the calling process wants to change the items in the list.
//
//
class CFileDialogEventHandler : public IFileDialogEvents, public IFileDialogControlEvents
{
public:

	// 
	// IUnknown methods
	// 

	IFACEMETHODIMP QueryInterface(REFIID riid, void** ppv)
	{
		static const QITAB qit[] = 
		{
			QITABENT(CFileDialogEventHandler, IFileDialogEvents),
			QITABENT(CFileDialogEventHandler, IFileDialogControlEvents),
			{ 0 }
		};
		return QISearch(this, qit, riid, ppv);
	}

	IFACEMETHODIMP_(ULONG) AddRef()
	{
		return InterlockedIncrement(&_cRef);
	}

	IFACEMETHODIMP_(ULONG) Release()
	{
		long cRef = InterlockedDecrement(&_cRef);
		if (!cRef)
		{
			delete this;
		}
		return cRef;
	}

	// 
	// IFileDialogEvents methods
	// 

	IFACEMETHODIMP OnFileOk(IFileDialog*)						{ return S_OK; }
	IFACEMETHODIMP OnFolderChange(IFileDialog*)					{ return S_OK; }
	IFACEMETHODIMP OnFolderChanging(IFileDialog*, IShellItem*)	{ return S_OK; }
	IFACEMETHODIMP OnHelp(IFileDialog*)							{ return S_OK; }
	IFACEMETHODIMP OnSelectionChange(IFileDialog*)				{ return S_OK; }
	IFACEMETHODIMP OnTypeChange(IFileDialog*)					{ return S_OK; }
	IFACEMETHODIMP OnShareViolation(IFileDialog*, IShellItem*, 
		FDE_SHAREVIOLATION_RESPONSE*)
	{ return S_OK; }
	IFACEMETHODIMP OnOverwrite(IFileDialog*, IShellItem*, FDE_OVERWRITE_RESPONSE*)
	{ return S_OK; }

	// 
	// IFileDialogControlEvents methods
	// 

	IFACEMETHODIMP OnItemSelected(IFileDialogCustomize*pfdc, DWORD dwIDCtl, 
		DWORD dwIDItem);
	IFACEMETHODIMP OnButtonClicked(IFileDialogCustomize*, DWORD)
	{ return S_OK; }
	IFACEMETHODIMP OnControlActivating(IFileDialogCustomize*, DWORD)
	{ return S_OK; }
	IFACEMETHODIMP OnCheckButtonToggled(IFileDialogCustomize*, DWORD, BOOL)
	{ return S_OK; }

	CFileDialogEventHandler() : _cRef(1) { }

protected:

	~CFileDialogEventHandler() { }
	long _cRef;
};

HRESULT CFileDialogEventHandler::OnItemSelected(IFileDialogCustomize *pfdc, 
												DWORD dwIDCtl, DWORD dwIDItem)
{
	IFileDialog* pfd = NULL;
	HRESULT hr = pfdc->QueryInterface(&pfd);
	if (SUCCEEDED(hr))
	{
		if (dwIDCtl == CONTROL_RADIOBUTTONLIST)
		{
			switch (dwIDItem)
			{
			case CONTROL_RADIOBUTTON1:
				hr = pfd->SetTitle(L"Windows Vista");
				break;

			case CONTROL_RADIOBUTTON2:
				hr = pfd->SetTitle(L"Windows 7");
				break;
			}
		}
		pfd->Release();
	}
	return hr;
}

//
//  FUNCTION: CFileDialogEventHandler_CreateInstance(REFIID, void**)
//
//  PURPOSE:  CFileDialogEventHandler instance creation helper function.
//
//
HRESULT CFileDialogEventHandler_CreateInstance(REFIID riid, void** ppv)
{
	*ppv = NULL;
	CFileDialogEventHandler* pFileDialogEventHandler = 
		new(std::nothrow) CFileDialogEventHandler();
	HRESULT hr = pFileDialogEventHandler ? S_OK : E_OUTOFMEMORY;
	if (SUCCEEDED(hr))
	{
		hr = pFileDialogEventHandler->QueryInterface(riid, ppv);
		pFileDialogEventHandler->Release();
	}
	return hr;
}


//
//  FUNCTION: OnAddCustomControls(HWND)
//
//  PURPOSE:  This code snippet demonstrates how to add custom controls in the Common 
//            File Dialog.
//
//
void OnAddCustomControls(HWND hWnd)
{
	HRESULT hr;

	// Create a new common open file dialog
	IFileDialog* pfd = NULL;
	hr = CoCreateInstance(CLSID_FileOpenDialog, NULL, CLSCTX_INPROC_SERVER, 
		IID_PPV_ARGS(&pfd));
	if (SUCCEEDED(hr))
	{
		// Create an event handling object, and hook it up to the dialog
		IFileDialogEvents* pfde = NULL;
		hr = CFileDialogEventHandler_CreateInstance(IID_PPV_ARGS(&pfde));
		if (SUCCEEDED(hr))
		{
			// Hook up the event handler
			DWORD dwCookie = 0;
			hr = pfd->Advise(pfde, &dwCookie);
			if (SUCCEEDED(hr))
			{
				// Set up the customization
				IFileDialogCustomize* pfdc = NULL;
				hr = pfd->QueryInterface(IID_PPV_ARGS(&pfdc));
				if (SUCCEEDED(hr))
				{
					// Create a visual group
					hr = pfdc->StartVisualGroup(CONTROL_GROUP, L"Change Title to ");
					if (SUCCEEDED(hr))
					{
						// Add a radio-button list
						hr = pfdc->AddRadioButtonList(CONTROL_RADIOBUTTONLIST);
						if (SUCCEEDED(hr))
						{
							// Set the state of the added radio-button list
							hr = pfdc->SetControlState(CONTROL_RADIOBUTTONLIST, 
								CDCS_VISIBLE | CDCS_ENABLED);

							// Add individual buttons to the radio-button list
							hr = pfdc->AddControlItem(CONTROL_RADIOBUTTONLIST, 
								CONTROL_RADIOBUTTON1, L"Windows Vista");
							hr = pfdc->AddControlItem(CONTROL_RADIOBUTTONLIST, 
								CONTROL_RADIOBUTTON2, L"Windows 7");

							// Set the default selection to option 1
							hr = pfdc->SetSelectedControlItem(CONTROL_RADIOBUTTONLIST, 
								CONTROL_RADIOBUTTON1);
						}
						// End the visual group
						pfdc->EndVisualGroup();
					}
					pfdc->Release();
				}

				// Show the open file dialog
				if (SUCCEEDED(hr) && SUCCEEDED(hr = pfd->Show(hWnd)))
				{
					// You can add your own code here to handle the results.
				}

				// Unhook the event handler
				pfd->Unadvise(dwCookie);
			}
			pfde->Release();
		}
		pfd->Release();
	}

	if (FAILED(hr))
	{
		// User cancelled the dialog?
		if (hr != HRESULT_FROM_WIN32(ERROR_CANCELLED))
		{
			// Report the error for failure
			TCHAR szErrorMessage[260];
			_stprintf_s(szErrorMessage, ARRAYSIZE(szErrorMessage), 
				_T("OnAddCustomControls returns w/err 0x%08lx"), hr);
			MessageBox(hWnd, szErrorMessage, _T("Error"), MB_ICONERROR);
		}
	}
}


//
//  FUNCTION: OnAddCommonPlaces(HWND)
//
//  PURPOSE:  The Common Places area in the Common File Dialog is extensible. This code 
//            snippet demonstrates how to extend the Common Places area.
//
//
void OnAddCommonPlaces(HWND hWnd)
{
	HRESULT hr;

	// Create a new common open file dialog
	IFileDialog* pfd = NULL;
	hr = CoCreateInstance(CLSID_FileOpenDialog, NULL, CLSCTX_INPROC_SERVER, 
		IID_PPV_ARGS(&pfd));
	if (SUCCEEDED(hr))
	{
		// Get the shell item of the PublicMusic knownfolder
		IShellItem* psiPublicMusic = NULL;
		hr = SHCreateItemInKnownFolder(FOLDERID_PublicMusic, 0, NULL, 
			IID_PPV_ARGS(&psiPublicMusic));
		if (SUCCEEDED(hr))
		{
			// Add the place to the bottom of default list in Common File Dialog
			hr = pfd->AddPlace(psiPublicMusic, FDAP_BOTTOM);
			psiPublicMusic->Release();
		}

		// Show the open file dialog
		if (SUCCEEDED(hr) && SUCCEEDED(hr = pfd->Show(hWnd)))
		{
			// You can add your own code here to handle the results
		}

		pfd->Release();
	}

	if (FAILED(hr))
	{
		// User cancelled the dialog?
		if (hr != HRESULT_FROM_WIN32(ERROR_CANCELLED))
		{
			// Report the error for failure
			TCHAR szErrorMessage[260];
			_stprintf_s(szErrorMessage, ARRAYSIZE(szErrorMessage), 
				_T("OnAddCustomControls returns w/err 0x%08lx"), hr);
			MessageBox(hWnd, szErrorMessage, _T("Error"), MB_ICONERROR);
		}
	}
}

#pragma endregion


#pragma region Basic Save File Dialogs

const COMDLG_FILTERSPEC c_rgSaveTypes[] =
{
	{ L"Word Files (*.docx)",	L"*.docx" },
	{ L"Text Files (*.txt)",	L"*.txt" }
};

//
//  FUNCTION: OnSaveAFile(HWND)
//
//  PURPOSE:  
//
//
void OnSaveAFile(HWND hWnd)
{
	HRESULT hr; 

	// Create a new common save file dialog
	IFileDialog* pfd = NULL;
	hr = CoCreateInstance(CLSID_FileSaveDialog, NULL, CLSCTX_INPROC_SERVER, 
		IID_PPV_ARGS(&pfd));
	if (SUCCEEDED(hr))
	{
		// (Optional) Set the title of the dialog
		hr = pfd->SetTitle(L"Save a File");

		// (Optional) Specify file types for the file dialog
		if (SUCCEEDED(hr) && SUCCEEDED(hr = pfd->SetFileTypes(ARRAYSIZE(c_rgSaveTypes), 
			c_rgSaveTypes)))
		{
			// Set the selected file type index to Word Document
			hr = pfd->SetFileTypeIndex(1);
		}

		// (Optional) Set the default extension to be added as ".docx"
		if (SUCCEEDED(hr))
		{
			hr = pfd->SetDefaultExtension(L"docx");
		}

		// (Optional) Display a warning if the user specifies a file name that aleady 
		// exists. This is a default value for the Save dialog.
		if (SUCCEEDED(hr))
		{
			DWORD dwOptions;
			if (SUCCEEDED(hr = pfd->GetOptions(&dwOptions)))
			{
				hr = pfd->SetOptions(dwOptions | FOS_OVERWRITEPROMPT);
			}
		}

		// Show the save file dialog
		if (SUCCEEDED(hr) && SUCCEEDED(hr = pfd->Show(hWnd)))
		{
			// Get the result of the save file dialog
			IShellItem* psiResult = NULL;
			hr = pfd->GetResult(&psiResult);
			if (SUCCEEDED(hr))
			{
				PWSTR pszPath = NULL;
				hr = psiResult->GetDisplayName(SIGDN_FILESYSPATH, &pszPath);
				if (SUCCEEDED(hr))
				{
					// Open and save to the file
					HANDLE hFile = CreateFileW(pszPath, GENERIC_WRITE | GENERIC_READ, 0, 
						NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
					if (hFile != INVALID_HANDLE_VALUE)
					{
						// Write to the file stream.
						// ...

						CloseHandle(hFile);

						MessageBox(hWnd, pszPath, L"The saved file is", MB_OK);
					}

					CoTaskMemFree(pszPath);
				}
				psiResult->Release();
			}
		}

		pfd->Release();
	}

	if (FAILED(hr))
	{
		// User cancelled the dialog?
		if (hr != HRESULT_FROM_WIN32(ERROR_CANCELLED))
		{
			// Report the error for failure
			TCHAR szErrorMessage[260];
			_stprintf_s(szErrorMessage, ARRAYSIZE(szErrorMessage), 
				_T("OnSaveAFile returns w/err 0x%08lx"), hr);
			MessageBox(hWnd, szErrorMessage, _T("Error"), MB_ICONERROR);
		}
	}
}

#pragma endregion


#pragma region Customized Save File Dialogs



#pragma endregion