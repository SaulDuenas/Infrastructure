/****************************** Module Header ******************************\
* Module Name:	RawAPI.cpp
* Project:		CppAutomateExcel
* Copyright (c) Microsoft Corporation.
* 
* The code in RawAPI.h/cpp demontrates the use of C/C++ and the COM APIs to 
* automate Excel. The raw automation is much more difficult, but it is  
* sometimes necessary to avoid the overhead with MFC, or problems with 
* #import. Basically, you work with such APIs as CoCreateInstance(), and COM 
* interfaces such as IDispatch and IUnknown.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/19/2009 11:01 AM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "StdAfx.h"
#include "RawAPI.h"
#pragma endregion


DWORD WINAPI RawAutomateExcel(LPVOID lpParam)
{
	HRESULT hr;

	// Initializes the COM library on the current thread and identifies 
	// the concurrency model as single-thread apartment (STA). 
	// [-or-] ::CoInitialize(NULL);
	// [-or-] ::CoCreateInstance(NULL);
	::CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
	

	/////////////////////////////////////////////////////////////////////////
	// Create the Excel.Application COM object using C++ and the COM APIs.
	// 

	// Get CLSID of the server
	
	CLSID clsid;
	
	// Option 1. Get CLSID from ProgID using CLSIDFromProgID.
	LPCOLESTR progID = L"Excel.Application";
	hr = ::CLSIDFromProgID(progID, &clsid);
	if (FAILED(hr))
	{
		_tprintf(_T("CLSIDFromProgID(\"%s\") failed w/err 0x%08lx\n"), 
			progID, hr);
		return hr;
	}
	// Option 2. Build the CLSID directly.
	/*const IID CLSID_Application = 
	{0x00024500,0x0000,0x0000,{0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x46}};
	clsid = CLSID_Application;*/

	// Start the server and get the IDispatch interface

	IDispatch *pXlApp;
	hr = ::CoCreateInstance(	// [-or-] CoCreateInstanceEx, CoGetObject
		clsid,					// CLSID of the server
		NULL,
		CLSCTX_LOCAL_SERVER,	// Excel.Application is a local server
		IID_IDispatch,			// Query the IDispatch interface
		(void **)&pXlApp);		// Output

	if (FAILED(hr))
	{
		_tprintf(_T("Excel is not registered properly w/err 0x%08lx\n"), 
			hr);
		return hr;
	}

	_putts(_T("Excel.Application is started"));


	/////////////////////////////////////////////////////////////////////////
	// Make Excel invisible. (i.e. Application.Visible = 0)
	// 

	{
		VARIANT x;
		x.vt = VT_I4;
		x.lVal = 0;
		hr = AutoWrap(DISPATCH_PROPERTYPUT, NULL, pXlApp, L"Visible", 1, x);
	}


	/////////////////////////////////////////////////////////////////////////
	// Create a new Workbook. (i.e. Application.Workbooks.Add)
	// 

	// Get the Workbooks collection
	IDispatch *pXlBooks;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pXlApp, L"Workbooks", 0);
		pXlBooks = result.pdispVal;
	}

	// Call Workbooks.Add() to get a new workbook
	IDispatch *pXlBook;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_METHOD, &result, pXlBooks, L"Add", 0);
		pXlBook = result.pdispVal;
	}

	_putts(_T("A new workbook is created"));


	/////////////////////////////////////////////////////////////////////////
	// Get the active Worksheet.
	// 

	IDispatch *pXlSheet;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pXlApp, L"ActiveSheet", 0);
		pXlSheet = result.pdispVal;
	}


	/////////////////////////////////////////////////////////////////////////
	// Fill data into the worksheet's cells.
	// 

	_putts(_T("Filling data into the worksheet ..."));

	// Construct a 5 x 2 safearray of user names
	VARIANT saNames;
	saNames.vt = VT_ARRAY | VT_VARIANT;
	{
		SAFEARRAYBOUND sab[2];
		sab[0].lLbound = 1; sab[0].cElements = 5;
		sab[1].lLbound = 1; sab[1].cElements = 2;
		saNames.parray = SafeArrayCreate(VT_VARIANT, 2, sab);

		SafeArrayPutNames(saNames.parray, 1, L"John", L"Smith");
		SafeArrayPutNames(saNames.parray, 2, L"Tom", L"Brown");
		SafeArrayPutNames(saNames.parray, 3, L"Sue", L"Thomas");
		SafeArrayPutNames(saNames.parray, 4, L"Jane", L"Jones");
		SafeArrayPutNames(saNames.parray, 5, L"Adam", L"Johnson");
	}
	
	// Fill A2:B6 with the array of values (First and Last Names).

	// Get Range object for the Range A2:B6
	IDispatch *pXlRange;
	{
		VARIANT param;
		param.vt = VT_BSTR;
		param.bstrVal = ::SysAllocString(L"A2:B6");

		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pXlSheet, L"Range", 1, param);
		VariantClear(&param);

		pXlRange = result.pdispVal;
	}

	// Set range with the safearray.
	hr = AutoWrap(DISPATCH_PROPERTYPUT, NULL, pXlRange, L"Value2", 1, saNames);

	// Clear the safearray
	VariantClear(&saNames);


	/////////////////////////////////////////////////////////////////////////
	// Save the workbook as a xlsx file and close it.
	// 

	_putts(_T("Save and close the workbook"));

	// pXlBook->SaveAs
	{
		// Make the file name

		// Get the directory of the current exe.
		WCHAR szFileName[MAX_PATH];
		if (FAILED(GetModuleDirectoryW(szFileName, MAX_PATH)))
			return S_FALSE;

		// Concat "MSDN1.xlsx" to the directory
		wcsncat_s(szFileName, MAX_PATH, L"MSDN1.xlsx", 10);

		// Convert the NULL-terminated string to BSTR
		VARIANT vtFileName;
		vtFileName.vt = VT_BSTR;
		vtFileName.bstrVal = ::SysAllocString(szFileName);
		
		VARIANT vtFormat;
		vtFormat.vt = VT_I4;
		vtFormat.lVal = 51;	// XlFileFormat::xlOpenXMLWorkbook

		// If there are more than 1 parameters passed, they MUST be pass in 
		// reversed order. Otherwise, you may get the error 0x80020009.
		hr = AutoWrap(DISPATCH_METHOD, NULL, pXlBook, L"SaveAs", 2, 
			vtFormat, vtFileName);

		VariantClear(&vtFileName);
	}

	// pXlBook->Close()
	hr = AutoWrap(DISPATCH_METHOD, NULL, pXlBook, L"Close", 0);


	/////////////////////////////////////////////////////////////////////////
	// Quit the Excel application. (i.e. Application.Quit())
	// 

	_putts(_T("Quit the Excel application"));

	// Tell Excel to quit (i.e. Application.Quit)
	hr = AutoWrap(DISPATCH_METHOD, NULL, pXlApp, L"Quit", 0);


	/////////////////////////////////////////////////////////////////////////
	// Release the COM objects.
	// 

	pXlRange->Release();
	pXlSheet->Release();
	pXlBook->Release();
	pXlBooks->Release();
	pXlApp->Release();

	// Uninitialize COM for this thread
	CoUninitialize();

	return hr;
}


/*!
 * \brief
 * The definition of AutoWrap in the header file
 * 
 * \see
 * Separate RawAPI.h | AutoWrap
 */
HRESULT AutoWrap(int autoType, VARIANT *pvResult, IDispatch *pDisp, 
				 LPOLESTR ptName, int cArgs...) 
{
    // Begin variable-argument list
    va_list marker;
    va_start(marker, cArgs);

    if (!pDisp) 
	{
        _putts(_T("NULL IDispatch passed to AutoWrap()"));
        _exit(0);
    }

    // Variables used
    DISPPARAMS dp = { NULL, NULL, 0, 0 };
    DISPID dispidNamed = DISPID_PROPERTYPUT;
    DISPID dispID;
    HRESULT hr;
    char szName[200];
    
    // Convert down to ANSI
    WideCharToMultiByte(CP_ACP, 0, ptName, -1, szName, 256, NULL, NULL);
    
    // Get DISPID for name passed
    hr = pDisp->GetIDsOfNames(IID_NULL, &ptName, 1, LOCALE_USER_DEFAULT,
		&dispID);
    if (FAILED(hr))
	{
        _tprintf(_T(
			"IDispatch::GetIDsOfNames(\"%s\") failed w/err 0x%08lx\n"
			), szName, hr);
        return hr;
    }
    
    // Allocate memory for arguments
    VARIANT *pArgs = new VARIANT[cArgs+1];
    // Extract arguments...
    for(int i=0; i<cArgs; i++) 
	{
        pArgs[i] = va_arg(marker, VARIANT);
    }
    
    // Build DISPPARAMS
    dp.cArgs = cArgs;
    dp.rgvarg = pArgs;
    
    // Handle special-case for property-puts
    if (autoType & DISPATCH_PROPERTYPUT)
	{
        dp.cNamedArgs = 1;
        dp.rgdispidNamedArgs = &dispidNamed;
    }
    
    // Make the call
    hr = pDisp->Invoke(dispID, IID_NULL, LOCALE_SYSTEM_DEFAULT,
		autoType, &dp, pvResult, NULL, NULL);
    if (FAILED(hr)) 
	{
        _tprintf(_T(
			"IDispatch::Invoke(\"%s\"=%08lx) failed w/err 0x%08lx\n"
			), szName, dispID, hr);
        return hr;
    }

    // End variable-argument section
    va_end(marker);
    
    delete[] pArgs;
    
    return hr;
}