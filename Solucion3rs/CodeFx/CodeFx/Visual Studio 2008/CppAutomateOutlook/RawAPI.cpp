/****************************** Module Header ******************************\
* Module Name:	RawAPI.cpp
* Project:		CppAutomateOutlook
* Copyright (c) Microsoft Corporation.
* 
* The code in RawAPI.h/cpp demontrates the use of C/C++ and the COM APIs to 
* automate Outlook. The raw automation is much more difficult, but it is 
* sometimes necessary to avoid the overhead with MFC, or problems with 
* #import. Basically, you work with such APIs as CoCreateInstance(), and COM 
* interfaces such as IDispatch and IUnknown.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/28/2009 11:27 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "StdAfx.h"
#include "RawAPI.h"
#pragma endregion


DWORD WINAPI RawAutomateOutlook(LPVOID lpParam)
{
	HRESULT hr;

	// Initializes the COM library on the current thread and identifies 
	// the concurrency model as single-thread apartment (STA). 
	// [-or-] ::CoInitialize(NULL);
	// [-or-] ::CoCreateInstance(NULL);
	::CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);


	/////////////////////////////////////////////////////////////////////////
	// Start Microsoft Outlook and log on with your profile.
	// 

	// Get CLSID of the server

	CLSID clsid;

	// Option 1. Get CLSID from ProgID using CLSIDFromProgID.
	LPCOLESTR progID = L"Outlook.Application";
	hr = ::CLSIDFromProgID(progID, &clsid);
	if (FAILED(hr))
	{
		_tprintf(_T("CLSIDFromProgID(\"%s\") failed w/err 0x%08lx\n"), 
			progID, hr);
		return hr;
	}
	// Option 2. Build the CLSID directly.
	/*const IID CLSID_Application = 
	{0x0006F03A,0x0000,0x0000,{0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x46}};
	clsid = CLSID_Application;*/

	// Start the server and get the IDispatch interface

	IDispatch *pOutlookApp;
	hr = ::CoCreateInstance(	// [-or-] CoCreateInstanceEx, CoGetObject
		clsid,					// CLSID of the server
		NULL,
		CLSCTX_LOCAL_SERVER,	// Outlook.Application is a local server
		IID_IDispatch,			// Query the IDispatch interface
		(void **)&pOutlookApp);	// Output

	if (FAILED(hr))
	{
		_tprintf(_T("Outlook is not registered properly w/err 0x%08lx\n"), 
			hr);
		return hr;
	}

	_putts(_T("Outlook.Application is started"));

	_putts(_T("User logs on"));

	// Get the namespace and the logon.

	// pNS = pOutlookApp->GetNamespace("MAPI")
	IDispatch *pNS;
	{
		VARIANT result;
		VariantInit(&result);
		VARIANT x;
		x.vt = VT_BSTR;
		x.bstrVal = ::SysAllocString(L"MAPI");
		hr = AutoWrap(DISPATCH_METHOD, &result, pOutlookApp, L"GetNamespace", 
			1, x);
		SysFreeString(x.bstrVal);
		pNS = result.pdispVal;
	}

	// pNS->Logon("YourValidProfile", "YourPassword")
	// Replace "YourValidProfile" and "YourPassword" with vtMissing if you 
	// want to log on with the default profile.
	{
		VARIANT vtProfile;
		vtProfile.vt = VT_BSTR;
		vtProfile.bstrVal = ::SysAllocString(L"YourValidProfile");
		VARIANT vtPassword;
		vtPassword.vt = VT_BSTR;
		vtPassword.bstrVal = ::SysAllocString(L"YourPassword");

		hr = AutoWrap(DISPATCH_METHOD, NULL, pNS, L"Logon", 2, vtProfile, 
			vtPassword);

		SysFreeString(vtProfile.bstrVal);
		SysFreeString(vtPassword.bstrVal);
	}


	/////////////////////////////////////////////////////////////////////////
	// Create and send a new mail item.
	// 

	_putts(_T("Create and send a new mail item"));

	// pMail = spOutlookApp->CreateItem(Outlook::OlItemType::olMailItem);
	IDispatch *pMail;
	{
		VARIANT result;
		VariantInit(&result);
		VARIANT x;
		x.vt = VT_I4;
		x.lVal = 0;	// Outlook::OlItemType::olMailItem
		hr = AutoWrap(DISPATCH_METHOD, &result, pOutlookApp, L"CreateItem",
			1, x);
		SysFreeString(x.bstrVal);
		pMail = result.pdispVal;
	}

	// Set the properties of the email.

	// pMail->Subject = "Feedback of All-In-One Code Framework"
	{
		VARIANT x;
		x.vt = VT_BSTR;
		x.bstrVal = ::SysAllocString(L"Feedback of All-In-One Code Framework");
		hr = AutoWrap(DISPATCH_PROPERTYPUT, NULL, pMail, L"Subject", 1, x);
		SysFreeString(x.bstrVal);
	}

	// pMail->To = "codefxf@microsoft.com"
	{
		VARIANT x;
		x.vt = VT_BSTR;
		x.bstrVal = ::SysAllocString(L"codefxf@microsoft.com");
		hr = AutoWrap(DISPATCH_PROPERTYPUT, NULL, pMail, L"To", 1, x);
		SysFreeString(x.bstrVal);
	}

	// Displays a new Inspector object for the item and allows users to click 
	// on the Send button to send the mail manually.
	// pMail->Display(true)   Modal=true makes the Inspector window modal
	{
		VARIANT vtModal;
		vtModal.vt = VT_I4;
		vtModal.lVal = 1;
		hr = AutoWrap(DISPATCH_METHOD, NULL, pMail, L"Display", 1, vtModal);
	}

	// [-or-]

	// Automatically send the mail without a new Inspector window.
	// pMail->Send()
	/*hr = AutoWrap(DISPATCH_METHOD, NULL, pMail, L"Send", 0);*/


	/////////////////////////////////////////////////////////////////////////
	// User logs off and quits Outlook.
	// 

	// pNS->Logoff()
	hr = AutoWrap(DISPATCH_METHOD, NULL, pNS, L"Logoff", 0);

	_putts(_T("Quit the Outlook application"));
	// pOutlookApp->Quit()
	hr = AutoWrap(DISPATCH_METHOD, NULL, pOutlookApp, L"Quit", 0);


	/////////////////////////////////////////////////////////////////////
	// Release the COM objects.
	// 

	pMail->Release();
	pNS->Release();
	pOutlookApp->Release();

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