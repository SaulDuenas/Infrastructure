/****************************** Module Header ******************************\
* Module Name:	RawAPI.cpp
* Project:		CppAutomateWord
* Copyright (c) Microsoft Corporation.
* 
* The code in RawAPI.h/cpp demontrates the use of C/C++ and the COM APIs to 
* automate Word. The raw automation is much more difficult, but it is 
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


DWORD WINAPI RawAutomateWord(LPVOID lpParam)
{
	HRESULT hr;

	// Initializes the COM library on the current thread and identifies 
	// the concurrency model as single-thread apartment (STA). 
	// [-or-] ::CoInitialize(NULL);
	// [-or-] ::CoCreateInstance(NULL);
	::CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);


	/////////////////////////////////////////////////////////////////////////
	// Create the Word.Application COM object using C++ and the COM APIs.
	// 

	// Get CLSID of the server
	
	CLSID clsid;
	
	// Option 1. Get CLSID from ProgID using CLSIDFromProgID.
	LPCOLESTR progID = L"Word.Application";
	hr = ::CLSIDFromProgID(progID, &clsid);
	if (FAILED(hr))
	{
		_tprintf(_T("CLSIDFromProgID(\"%s\") failed w/err 0x%08lx\n"), 
			progID, hr);
		return hr;
	}
	// Option 2. Build the CLSID directly.
	/*const IID CLSID_Application = 
	{0x000209FF,0x0000,0x0000,{0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x46}};
	clsid = CLSID_Application;*/

	// Start the server and get the IDispatch interface

	IDispatch *pWordApp;
	hr = ::CoCreateInstance(	// [-or-] CoCreateInstanceEx, CoGetObject
		clsid,					// CLSID of the server
		NULL,
		CLSCTX_LOCAL_SERVER,	// Word.Application is a local server
		IID_IDispatch,			// Query the IDispatch interface
		(void **)&pWordApp);	// Output

	if (FAILED(hr))
	{
		_tprintf(_T("Word is not registered properly w/err 0x%08lx\n"), 
			hr);
		return hr;
	}

	_putts(_T("Word.Application is started"));


	/////////////////////////////////////////////////////////////////////////
	// Make Word invisible. (i.e. Application.Visible = 0)
	// 

	{
		VARIANT x;
		x.vt = VT_I4;
		x.lVal = 0;
		hr = AutoWrap(DISPATCH_PROPERTYPUT, NULL, pWordApp, L"Visible", 1, x);
	}


	/////////////////////////////////////////////////////////////////////////
	// Create a new Document. (i.e. Application.Documents.Add)
	// 

	// Get the Documents collection
	IDispatch *pDocs;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pWordApp, L"Documents", 0);
		pDocs = result.pdispVal;
	}

	// Call Documents.Add() to get a new document
	IDispatch *pDoc;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_METHOD, &result, pDocs, L"Add", 0);
		pDoc = result.pdispVal;
	}

	_putts(_T("A new document is created"));


	/////////////////////////////////////////////////////////////////////////
	// Insert a paragraph.
	// 

	_putts(_T("Insert a paragraph"));

	// pParas = pDoc->Paragraphs
	IDispatch *pParas;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pDoc, L"Paragraphs", 0);
		pParas = result.pdispVal;
	}

	// pPara = pParas->Add
	IDispatch *pPara;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_METHOD, &result, pParas, L"Add", 0);
		pPara = result.pdispVal;
	}

	// pParaRng = pPara->Range
	IDispatch *pParaRng;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pPara, L"Range", 0);
		pParaRng = result.pdispVal;
	}

	// pParaRng->Text = "Heading 1"
	{
		VARIANT x;
		x.vt = VT_BSTR;
		x.bstrVal = ::SysAllocString(L"Heading 1");
		hr = AutoWrap(DISPATCH_PROPERTYPUT, NULL, pParaRng, L"Text", 1, x);
		SysFreeString(x.bstrVal);
	}

	// pFont = pParaRng->Font
	IDispatch *pFont;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pParaRng, L"Font", 0);
		pFont = result.pdispVal;
	}

	// pFont->Bold = 1
	{
		VARIANT x;
		x.vt = VT_I4;
		x.lVal = 1;
		hr = AutoWrap(DISPATCH_PROPERTYPUT, NULL, pFont, L"Bold", 1, x);
	}

	// pParaRng->InsertParagraphAfter();
	hr = AutoWrap(DISPATCH_METHOD, NULL, pParaRng, L"InsertParagraphAfter", 0);


	/////////////////////////////////////////////////////////////////////
	// Save the document as a docx file and close it.
	// 

	_putts(_T("Save and close the document"));

	// pDoc->SaveAs
	{
		// Make the file name

		// Get the directory of the current exe.
		WCHAR szFileName[MAX_PATH];
		if (FAILED(GetModuleDirectoryW(szFileName, MAX_PATH)))
			return S_FALSE;

		// Concat "MSDN1.docx" to the directory
		wcsncat_s(szFileName, MAX_PATH, L"MSDN1.docx", 10);

		// Convert the NULL-terminated string to BSTR
		VARIANT vtFileName;
		vtFileName.vt = VT_BSTR;
		vtFileName.bstrVal = ::SysAllocString(szFileName);

		hr = AutoWrap(DISPATCH_METHOD, NULL, pDoc, L"SaveAs", 1, vtFileName);

		VariantClear(&vtFileName);
	}

	// pDoc->Close()
	hr = AutoWrap(DISPATCH_METHOD, NULL, pDoc, L"Close", 0);


	/////////////////////////////////////////////////////////////////////
	// Quit the Word application.
	// 

	_putts(_T("Quit the Word application"));

	// pWordApp->Quit()
	hr = AutoWrap(DISPATCH_METHOD, NULL, pWordApp, L"Quit", 0);


	/////////////////////////////////////////////////////////////////////////
	// Release the COM objects.
	// 

	pFont->Release();
	pParaRng->Release();
	pPara->Release();
	pParas->Release();
	pDoc->Release();
	pDocs->Release();
	pWordApp->Release();

	// Uninitialize COM for this thread
	::CoUninitialize();

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