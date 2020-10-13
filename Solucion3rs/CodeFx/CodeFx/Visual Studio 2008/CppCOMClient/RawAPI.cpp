/****************************** Module Header ******************************\
* Module Name:	RawAPI.cpp
* Project:		CppCOMClient
* Copyright (c) Microsoft Corporation.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/12/2009 10:22 PM Jialiang Ge //Created
\***************************************************************************/

#pragma region Includes
#include "StdAfx.h"
#include "RawAPI.h"
#pragma endregion


/*!
 * \brief
 * The definition of RawConsumeSTAComponent in the header file
 * 
 * \see
 * Separate RawAPI.h | RawConsumeSTAComponent
 */
DWORD WINAPI RawConsumeSTAComponent(LPVOID lpParam)
{
	HRESULT hr;

	// Initializes the COM library on the current thread and identifies 
	// the concurrency model as single-thread apartment (STA). 
	// [-or-] ::CoInitialize(NULL);
	// [-or-] ::CoCreateInstance(NULL);
	::CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
	

	/////////////////////////////////////////////////////////////////////////
	// Create the ATLDllCOMServer.ATLSimpleObjectSTA COM object using C++ and 
	// the COM APIs.
	// 

	// Get CLSID of the server

	CLSID clsid;

	// Option 1. Get CLSID from ProgID using CLSIDFromProgID.
	LPCOLESTR progID = L"ATLDllCOMServer.ATLSimpleObjectSTA";
	hr = ::CLSIDFromProgID(progID, &clsid);
	if (FAILED(hr))
	{
		_tprintf(_T("CLSIDFromProgID(\"%s\") failed w/err 0x%08lx\n"), 
			progID, hr);
		return hr;
	}
	// Option 2. Build the CLSID directly.
	/*const IID CLSID_ATLSimpleObjectSTA = 
	{0x92FCF37F,0xF6C7,0x4F8A,{0xAA,0x09,0x1A,0x14,0xBA,0x11,0x80,0x84}};
	clsid = CLSID_ATLSimpleObjectSTA;*/

	// Start the server and get the IDispatch interface

	IDispatch *pSimpleObj;
	hr = ::CoCreateInstance(	// [-or-] CoCreateInstanceEx, CoGetObject
		clsid,					// CLSID of the server
		NULL,
		CLSCTX_INPROC_SERVER,	// CLSCTX_LOCAL_SERVER for ActiveX EXEs
		IID_IDispatch,			// Query the IDispatch interface
		(void **)&pSimpleObj);	// Output

	if (FAILED(hr))
	{
		_tprintf(_T("The server is not registered properly w/err 0x%08lx\n"), 
			hr);
		return hr;
	}


	/////////////////////////////////////////////////////////////////////////
	// Consume the properties and the methods of the COM object.
	// 

	// Set the property: HRESULT FloatProperty([in] FLOAT newVal);
	{
		VARIANT x;
		x.vt = VT_R4; // 4-byte real. 
		x.fltVal = 1.2f;
		_tprintf(_T("Set FloatProperty = %.2f\n"), x.fltVal);
		hr = AutoWrap(DISPATCH_PROPERTYPUT, NULL, pSimpleObj, 
			L"FloatProperty", 1, x);
	}

	// Get the property: HRESULT FloatProperty([out, retval] FLOAT* pVal);
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_PROPERTYGET, &result, pSimpleObj,
			L"FloatProperty", 0);
		_tprintf(_T("Get FloatProperty = %.2f\n"), result.fltVal);
	}

	// Call the method: HRESULT HelloWorld([out,retval] BSTR* pRet);
	{
		VARIANT result;
		VariantInit(&result);
		hr = AutoWrap(DISPATCH_METHOD, &result, pSimpleObj, L"HelloWorld", 0);
		_tprintf(_T("Call HelloWorld => %s\n"), result.bstrVal);
		
		// Need to manually free the memory of BSTR
		// 
		// @see: Rules for Freeing BSTRs in OLE Automation
		// http://support.microsoft.com/kb/108934
		// 
		// However, ::SysFreeString may not clear the memory immediately due 
		// to the BSTR cache. 
		::SysFreeString(result.bstrVal);
	}

	// Call the method: HRESULT GetProcessThreadID([out] LONG* pdwProcessId, 
	//                                             [out] LONG* pdwThreadId);
	{
		_tprintf(_T("The client process and thread: %ld, %ld\n"), 
			GetCurrentProcessId(), GetCurrentThreadId());

		VARIANT processId, threadId;

		// Step1. Find the proper VT for the parameter based on the table in
		// http://msdn.microsoft.com/en-us/library/ms891678.aspx
		// In this example, the param is long* plVal, so vt = VT_BYREF|VT_I4.
		processId.vt = VT_BYREF | VT_I4;
		threadId.vt = VT_BYREF | VT_I4;

		// Step2. Initialize the parameters and allocate the memory.
		processId.plVal = new long;
		threadId.plVal = new long;

		// Step3. Pass the parameters to the method from right to left.
		hr = AutoWrap(DISPATCH_METHOD, NULL, pSimpleObj, L"GetProcessThreadID", 
			2, threadId, processId);
		_tprintf(_T("Call GetProcessThreadID => %ld, %ld\n"),
			*processId.plVal, *threadId.plVal);
	}

	_putts(_T(""));


	/////////////////////////////////////////////////////////////////////////
	// Release the COM object.
	// 

	// Release references
	pSimpleObj->Release();

	// Uninitialize COM for this thread
	::CoUninitialize();

	return S_OK;
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