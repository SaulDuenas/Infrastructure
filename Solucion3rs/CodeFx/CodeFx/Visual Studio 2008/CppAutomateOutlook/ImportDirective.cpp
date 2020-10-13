/****************************** Module Header ******************************\
* Module Name:	ImportDirective.cpp
* Project:		CppAutomateOutlook
* Copyright (c) Microsoft Corporation.
* 
* The code in ImportDirective.h/cpp demonstrates the use of #import to 
* automate Outlook. #import (http://msdn.microsoft.com/en-us/library/8etzzkb6.aspx),
* a new directive that became available with Visual C++ 5.0, creates VC++ 
* "smart pointers" from a specified type library. It is very powerful, but 
* often not recommended because of reference-counting problems that typically 
* occur when used with the Microsoft Office applications. Unlike the direct 
* API approach in RawAPI.h/cpp, smart pointers enable us to benefit from the 
* type info to early/late bind the object. #import takes care of adding the 
* messy guids to the project and the COM APIs are encapsulated in custom 
* classes that the #import directive generates.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/28/2009 11:30 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "StdAfx.h"
#include "ImportDirective.h"
#pragma endregion


#pragma region Import the type libraries

#import "libid:2DF8D04C-5BFA-101B-BDE5-00AA0044DE52" \
	rename("RGB", "MSORGB")
// [-or-]
//#import "C:\\Program Files\\Common Files\\Microsoft Shared\\OFFICE12\\MSO.DLL" \
//	rename("RGB", "MSORGB")

using namespace Office;

#import "libid:00062FFF-0000-0000-C000-000000000046"
// [-or-]
//#import "C:\\Program Files\\Microsoft Office\\Office12\\MSOUTL.OLB"

#pragma endregion


DWORD WINAPI ImportOutlook(LPVOID lpParam)
{
	HRESULT hr;

	// Initializes the COM library on the current thread and identifies the
	// concurrency model as single-thread apartment (STA). 
	// [-or-] ::CoInitialize(NULL);
	// [-or-] ::CoCreateInstance(NULL);
	::CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

	try
	{

		/////////////////////////////////////////////////////////////////////
		// Start Microsoft Outlook and log on with your profile.
		// 

		// Option 1) Create the object using the smart pointer's constructor
		// 
		// _ApplicationPtr is the original interface name, _Application, with a 
		// "Ptr" suffix.
		//Outlook::_ApplicationPtr spOutlookApp(
		//	__uuidof(Outlook::Application)	// CLSID of the component
		//	);

		// Option 2) Create the object using the smart pointer's function,
		// CreateInstance
		Outlook::_ApplicationPtr spOutlookApp;
		hr = spOutlookApp.CreateInstance(__uuidof(Outlook::Application));
		if (FAILED(hr))
		{
			_tprintf(_T(
				"Outlook::_ApplicationPtr.CreateInstance failed w/err 0x%08lx\n"
				), hr);
			return hr;
		}

		_putts(_T("Outlook.Application is started"));

		_putts(_T("User logs on"));

		// Get the namespace and the logon.
		Outlook::_NameSpacePtr spNS = spOutlookApp->GetNamespace(
			_bstr_t(_T("MAPI")));
		// Replace "YourValidProfile" and "YourPassword" with vtMissing if  
		// you want to log on with the default profile.
		hr = spNS->Logon("YourValidProfile", "YourPassword", true, true);


		/////////////////////////////////////////////////////////////////////
        // Create and send a new mail item.
        // 

		_putts(_T("Create and send a new mail item"));

		Outlook::_MailItemPtr spMail = spOutlookApp->CreateItem(
			Outlook::OlItemType::olMailItem);

		// Set the properties of the email.
		spMail->Subject = _bstr_t(_T("Feedback of All-In-One Code Framework"));
		spMail->To = _bstr_t(_T("codefxf@microsoft.com"));
		spMail->HTMLBody = _bstr_t(_T("<b>Feedback:</b><br />"));
		spMail->Importance = Outlook::OlImportance::olImportanceHigh;

		// Displays a new Inspector object for the item and allows users to 
		// click on the Send button to send the mail manually.
		// Modal = true makes the Inspector window modal
		hr = spMail->Display(true);

        // [-or-]

        // Automatically send the mail without a new Inspector window.
        //spMail->Send();


		/////////////////////////////////////////////////////////////////////
		// Enumerate the contact items.
		// 

		_putts(_T("Enumerate the contact items"));

		Outlook::MAPIFolderPtr spCtFolder = spOutlookApp->Session->
			GetDefaultFolder(Outlook::OlDefaultFolders::olFolderContacts);
		Outlook::_ItemsPtr spCts = spCtFolder->Items;

		// Enumerate the contact items.
		for (long i = 1; i <= spCts->Count; i++)
		{
			IDispatchPtr spItem = spCts->Item(i);
			
			// QI _ContactItem
			Outlook::_ContactItemPtr spCt;
			hr = spItem->QueryInterface(__uuidof(Outlook::_ContactItem), 
				(void **)&spCt);
			if (SUCCEEDED(hr)) // If the item is a Contact item
			{
				_tprintf(_T("%s\n"), (LPCTSTR)spCt->Email1Address);
				continue;	// Next item
			}
			
			// QI _DistListItem
			Outlook::_DistListItemPtr spDL;
			hr = spItem->QueryInterface(__uuidof(Outlook::_DistListItem), 
				(void **)&spDL);
			if (SUCCEEDED(hr)) // If the item is a DistList item
			{
				_tprintf(_T("%s\n"), (LPCTSTR)spDL->DLName);
				continue;	// Next item
			}
		}


		/////////////////////////////////////////////////////////////////////
        // User logs off and quits Outlook.
        // 

        spNS->Logoff();
        _putts(_T("Quit the Outlook application"));
        spOutlookApp->Quit();


		/////////////////////////////////////////////////////////////////////
		// Release the COM objects.
		// 

		// Releasing the references is not necessary for the smart pointers
		// spOutlookApp.Release();

	}
	catch (_com_error &err)
	{
		_tprintf(_T("Outlook throws the error: %s\n"), err.ErrorMessage());
		_tprintf(_T("Description: %s\n"), (LPCTSTR) err.Description());
	}

	// Uninitialize COM for this thread
	CoUninitialize();

	return hr;
}