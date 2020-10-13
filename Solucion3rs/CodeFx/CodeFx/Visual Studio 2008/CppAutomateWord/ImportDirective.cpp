/****************************** Module Header ******************************\
* Module Name:	ImportDirective.cpp
* Project:		CppAutomateWord
* Copyright (c) Microsoft Corporation.
* 
* The code in ImportDirective.h/cpp demonstrates the use of #import to 
* automate Word. #import (http://msdn.microsoft.com/en-us/library/8etzzkb6.aspx),
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
* * 4/19/2009 11:01 AM Jialiang Ge Created
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

#import "libid:0002E157-0000-0000-C000-000000000046"
// [-or-]
//#import "C:\\Program Files\\Common Files\\Microsoft Shared\\VBA\\VBA6\\VBE6EXT.OLB"

using namespace VBIDE;

#import "libid:00020905-0000-0000-C000-000000000046" \
	rename("ExitWindows", "WordExitWindows")
// [-or-]
//#import "C:\\Program Files\\Microsoft Office\\Office12\\MSWORD.OLB" \
//	rename("ExitWindows", "WordExitWindows")

#pragma endregion


DWORD WINAPI ImportWord(LPVOID lpParam)
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
		// Create the Word.Application COM object using the #import directive
		// and smart pointers.
		// 

		// Option 1) Create the object using the smart pointer's constructor
		// 
		// _ApplicationPtr is the original interface name, _Application, with a 
		// "Ptr" suffix.
		//Word::_ApplicationPtr spWordApp(
		//	__uuidof(Word::Application)	// CLSID of the component
		//	);

		// Option 2) Create the object using the smart pointer's function,
		// CreateInstance
		Word::_ApplicationPtr spWordApp;
		hr = spWordApp.CreateInstance(__uuidof(Word::Application));
		if (FAILED(hr))
		{
			_tprintf(_T(
				"Word::_ApplicationPtr.CreateInstance failed w/err 0x%08lx\n"
				), hr);
			return hr;
		}

		_putts(_T("Word.Application is started"));


		/////////////////////////////////////////////////////////////////////
		// Make Word invisible. (i.e. Application.Visible = 0)
		// 

		spWordApp->Visible = VARIANT_FALSE;


		/////////////////////////////////////////////////////////////////////
		// Create a new Document. (i.e. Application.Documents.Add)
		// 

		Word::DocumentsPtr spDocs = spWordApp->Documents;
		Word::_DocumentPtr spDoc = spDocs->Add();

		_putts(_T("A new document is created"));


		/////////////////////////////////////////////////////////////////////
		// Insert a paragraph.
		// 

		_putts(_T("Insert a paragraph"));

		Word::ParagraphsPtr spParas = spDoc->Paragraphs;
		Word::ParagraphPtr spPara = spParas->Add();
		Word::RangePtr spParaRng = spPara->Range;
		spParaRng->Text = _bstr_t(_T("Heading 1"));
		Word::_FontPtr spFont = spParaRng->Font;
		spFont->Bold = 1;
		hr = spParaRng->InsertParagraphAfter();


		/////////////////////////////////////////////////////////////////////
		// Save the document as a docx file and close it.
		// 

		_putts(_T("Save and close the document"));

		// Make the file name

		// Get the directory of the current exe.
		WCHAR szFileName[MAX_PATH];
		if (FAILED(GetModuleDirectoryW(szFileName, MAX_PATH)))
			return S_FALSE;

		// Concat "MSDN2.docx" to the directory
		wcsncat_s(szFileName, MAX_PATH, L"MSDN2.docx", 10);

		// Convert the NULL-terminated string to BSTR
		variant_t vtFileName(szFileName);

		hr = spDoc->SaveAs(&vtFileName);

		hr = spDoc->Close();


		/////////////////////////////////////////////////////////////////////
		// Quit the Word application.
		// 

		_putts(_T("Quit the Word application"));
		hr = spWordApp->Quit();


		/////////////////////////////////////////////////////////////////////
		// Release the COM objects.
		// 

		// Releasing the references is not necessary for the smart pointers
		// spWordApp.Release();

	}
	catch (_com_error &err)
	{
		_tprintf(_T("Word throws the error: %s\n"), err.ErrorMessage());
		_tprintf(_T("Description: %s\n"), (LPCTSTR) err.Description());
	}

	// Uninitialize COM for this thread
	CoUninitialize();

	return hr;
}