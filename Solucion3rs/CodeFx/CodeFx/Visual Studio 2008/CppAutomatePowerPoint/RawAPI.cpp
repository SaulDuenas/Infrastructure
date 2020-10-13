/****************************** Module Header ******************************\
* Module Name:	RawAPI.cpp
* Project:		CppAutomatePowerPoint
* Copyright (c) Microsoft Corporation.
* 
* The code in RawAPI.h/cpp demontrates the use of C/C++ and the COM APIs to 
* automate PowerPoint. The raw automation is much more difficult, but it is 
* sometimes necessary to avoid the overhead with MFC, or problems with 
* #import. Basically, you work with such APIs as CoCreateInstance(), and COM 
* interfaces such as IDispatch and IUnknown.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 6/4/2009 1:54 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "StdAfx.h"
#include "RawAPI.h"
#pragma endregion


DWORD WINAPI RawAutomatePowerPoint(LPVOID lpParam)
{
	HRESULT hr;

	// Initializes the COM library on the current thread and identifies 
	// the concurrency model as single-thread apartment (STA). 
	// [-or-] ::CoInitialize(NULL);
	// [-or-] ::CoCreateInstance(NULL);
	::CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);


	/////////////////////////////////////////////////////////////////////////
	// Create the PowerPoint.Application COM object using C++ and COM APIs, 
	// and make the instance invisible.
	// 

	// Get CLSID of the server
	
	CLSID clsid;
	
	// Option 1. Get CLSID from ProgID using CLSIDFromProgID.
	LPCOLESTR progID = L"PowerPoint.Application";
	hr = ::CLSIDFromProgID(progID, &clsid);
	if (FAILED(hr))
	{
		_tprintf(_T("CLSIDFromProgID(\"%s\") failed w/err 0x%08lx\n"), 
			progID, hr);
		return hr;
	}
	// Option 2. Build the CLSID directly.
	/*const IID CLSID_Application = 
	{0x91493441,0x5A91,0x11CF,{0x87,0x00,0x00,0xAA,0x00,0x60,0x26,0x3B}};
	clsid = CLSID_Application;*/

	// Start the server and get the IDispatch interface

	IDispatch *pPpApp;
	hr = ::CoCreateInstance(	// [-or-] CoCreateInstanceEx, CoGetObject
		clsid,					// CLSID of the server
		NULL,
		CLSCTX_LOCAL_SERVER,	// PowerPoint.Application is a local server
		IID_IDispatch,			// Query the IDispatch interface
		(void **)&pPpApp);		// Output

	if (FAILED(hr))
	{
		_tprintf(_T("PowerPoint is not registered properly w/err 0x%08lx\n"), 
			hr);
		return hr;
	}

	_putts(_T("PowerPoint.Application is started"));

	// Make PowerPoint invisible
	// By default PowerPoint is invisible, till you make it visible:
	//{
	//	VARIANT x;
	//	x.vt = VT_I4;
	//	x.lVal = -1;	// Office::MsoTriState::msoTrue
	//	hr = AutoWrap(DISPATCH_PROPERTYPUT, NULL, pPpApp, L"Visible", 1, x);
	//}


	/////////////////////////////////////////////////////////////////////////
	// Add a new Presentation.
	// 

	// Get the Presentations collection
	IDispatch *pPres;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pPpApp, 
			L"Presentations", 0);
		pPres = result.pdispVal;
	}

	// Call Presentations.Add() to get a new presentation
	IDispatch *pPre;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_METHOD, &result, pPres, L"Add", 0);
		pPre = result.pdispVal;
	}

	_putts(_T("A new presentation is created"));


	/////////////////////////////////////////////////////////////////////////
	// Insert a new Slide and add some text to it.
	// 

	// Get the Slides collection
	IDispatch *pSlides;
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pPre, L"Slides", 0);
		pSlides = result.pdispVal;
	}

	// Insert a new slide
	_putts(_T("Insert a slide"));

	IDispatch *pSlide;
	{
		VARIANT result;
		VariantInit(&result);

		VARIANT vtIndex;
		vtIndex.vt = VT_I4;
		vtIndex.lVal = 1;
		
		VARIANT vtLayout;
		vtLayout.vt = VT_I4;
		vtLayout.lVal = 2;	// PowerPoint::PpSlideLayout::ppLayoutText

		// If there are more than 1 parameters passed, they MUST be pass in 
		// reversed order. Otherwise, you may get the error 0x80020009.
		hr = AutoWrap(DISPATCH_METHOD, &result, pSlides, L"Add", 2, vtLayout, 
			vtIndex);
		
		pSlide = result.pdispVal;
	}

	// Add some texts to the slide
	_putts(_T("Add some texts"));

	IDispatch *pShapes;		// pSlide->Shapes
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pSlide, L"Shapes", 0);
		pShapes = result.pdispVal;
	}

	IDispatch *pShape;		// pShapes->Item(1)
	{
		VARIANT result;
		VariantInit(&result);

		VARIANT vtIndex;
		vtIndex.vt = VT_I4;
		vtIndex.lVal = 1;

		hr = AutoWrap(DISPATCH_METHOD, &result, pShapes, L"Item", 1, vtIndex);

		pShape = result.pdispVal;
	}

	IDispatch *pTxtFrame;	// pShape->TextFrame
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pShape, L"TextFrame", 0);
		pTxtFrame = result.pdispVal;
	}

	IDispatch *pTxtRange;	// pTxtFrame->TextRange
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pTxtFrame, L"TextRange", 0);
		pTxtRange = result.pdispVal;
	}

	{
		VARIANT x;
		x.vt = VT_BSTR;
		x.bstrVal = ::SysAllocString(L"All-In-One Code Framework");
		hr = AutoWrap(DISPATCH_PROPERTYPUT, NULL, pTxtRange, L"Text", 1, x);
		SysFreeString(x.bstrVal);
	}


	/////////////////////////////////////////////////////////////////////////
	// Save the presentation as a pptx file and close it.
	// 

	_putts(_T("Save and close the presentation"));

	{
		// Make the file name

		// Get the directory of the current exe.
		WCHAR szFileName[MAX_PATH];
		if (FAILED(GetModuleDirectoryW(szFileName, MAX_PATH)))
			return S_FALSE;

		// Concat "MSDN1.docx" to the directory
		wcsncat_s(szFileName, MAX_PATH, L"MSDN1.pptx", 10);

		VARIANT vtFileName;
		vtFileName.vt = VT_BSTR;
		vtFileName.bstrVal = ::SysAllocString(szFileName);

		VARIANT vtFormat;
		vtFormat.vt = VT_I4;
		vtFormat.lVal = 24;	// PpSaveAsFileType::ppSaveAsOpenXMLPresentation

		VARIANT vtEmbedFont;
		vtEmbedFont.vt = VT_I4;
		vtEmbedFont.lVal = -2;	// MsoTriState::msoTriStateMixed

		// If there are more than 1 parameters passed, they MUST be pass in 
		// reversed order. Otherwise, you may get the error 0x80020009.
		hr = AutoWrap(DISPATCH_METHOD, NULL, pPre, L"SaveAs", 3, vtEmbedFont, 
			vtFormat, vtFileName);

		VariantClear(&vtFileName);
	}

	// pPre->Close()
	hr = AutoWrap(DISPATCH_METHOD, NULL, pPre, L"Close", 0);


	/////////////////////////////////////////////////////////////////////////
	// Quit the PowerPoint application.
	// 

	_putts(_T("Quit the PowerPoint application"));

	// pPpApp->Quit()
	hr = AutoWrap(DISPATCH_METHOD, NULL, pPpApp, L"Quit", 0);


	/////////////////////////////////////////////////////////////////////////
	// Release the COM objects.
	// 

	pTxtRange->Release();
	pTxtFrame->Release();
	pShape->Release();
	pShapes->Release();
	pSlide->Release();
	pSlides->Release();
	pPre->Release();
	pPres->Release();
	pPpApp->Release();

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