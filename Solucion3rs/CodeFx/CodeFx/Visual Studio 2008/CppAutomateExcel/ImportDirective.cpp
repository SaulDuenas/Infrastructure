/****************************** Module Header ******************************\
* Module Name:	ImportDirective.cpp
* Project:		CppAutomateExcel
* Copyright (c) Microsoft Corporation.
* 
* The code in ImportDirective.h/cpp demonstrates the use of #import to 
* automate Excel. #import (http://msdn.microsoft.com/en-us/library/8etzzkb6.aspx), 
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

#import "libid:00020813-0000-0000-C000-000000000046" \
	rename("DialogBox", "ExcelDialogBox") \
	rename("RGB", "ExcelRGB") \
	rename("CopyFile", "ExcelCopyFile") \
	rename("ReplaceText", "ExcelReplaceText")
// [-or-]
//#import "C:\\Program Files\\Microsoft Office\\Office12\\EXCEL.EXE" \
//	rename("DialogBox", "ExcelDialogBox") \
//	rename("RGB", "ExcelRGB") \
//	rename("CopyFile", "ExcelCopyFile") \
//	rename("ReplaceText", "ExcelReplaceText")

#pragma endregion


DWORD WINAPI ImportExcel(LPVOID lpParam)
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
		// Create the Excel.Application COM object using the #import 
		// directive and smart pointers.
		// 

		// Option 1) Create the object using the smart pointer's constructor
		// 
		// _ApplicationPtr is the original interface name, _Application, with a 
		// "Ptr" suffix.
		//Excel::_ApplicationPtr spXlApp(
		//	__uuidof(Excel::Application)	// CLSID of the component
		//	);

		// Option 2) Create the object using the smart pointer's function,
		// CreateInstance
		Excel::_ApplicationPtr spXlApp;
		hr = spXlApp.CreateInstance(__uuidof(Excel::Application));
		if (FAILED(hr))
		{
			_tprintf(_T(
				"Excel::_ApplicationPtr.CreateInstance failed w/err 0x%08lx\n"
				), hr);
			return hr;
		}

		_putts(_T("Excel.Application is started"));


		/////////////////////////////////////////////////////////////////////
		// Make Excel invisible. (i.e. Application.Visible = 0)
		// 

		spXlApp->Visible[0] = VARIANT_FALSE;


		/////////////////////////////////////////////////////////////////////
		// Create a new Workbook. (i.e. Application.Workbooks.Add)
		// 

		Excel::WorkbooksPtr spXlBooks = spXlApp->Workbooks;
		Excel::_WorkbookPtr spXlBook = spXlBooks->Add();

		_putts(_T("A new workbook is created"));


		/////////////////////////////////////////////////////////////////////
		// Get the active Worksheet and set its name.
		// 

		Excel::_WorksheetPtr spXlSheet = spXlBook->ActiveSheet;
		spXlSheet->Name = _bstr_t(_T("Report"));
		_putts(_T("The active worksheet is renamed as Report"));


		/////////////////////////////////////////////////////////////////////
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
		VARIANT param;
		param.vt = VT_BSTR;
		param.bstrVal = ::SysAllocString(L"A2:B6");
		Excel::RangePtr spXlRange = spXlSheet->Range[param];

		spXlRange->Value2 = saNames;

		// Clear the safearray
		VariantClear(&saNames);


		/////////////////////////////////////////////////////////////////////
		// Save the workbook as a xlsx file and close it.
		// 

		_putts(_T("Save and close the workbook"));

		// Make the file name

		// Get the directory of the current exe.
		WCHAR szFileName[MAX_PATH];
		if (FAILED(GetModuleDirectoryW(szFileName, MAX_PATH)))
			return S_FALSE;

		// Concat "MSDN2.xlsx" to the directory
		wcsncat_s(szFileName, MAX_PATH, L"MSDN2.xlsx", 10);

		// Convert the NULL-terminated string to BSTR
		variant_t vtFileName(szFileName);

		hr = spXlBook->SaveAs(vtFileName, Excel::XlFileFormat::xlOpenXMLWorkbook,
			vtMissing, vtMissing, vtMissing, vtMissing, 
			Excel::XlSaveAsAccessMode::xlNoChange);

		hr = spXlBook->Close();


		/////////////////////////////////////////////////////////////////////
		// Quit the Excel application.
		// 

		_putts(_T("Quit the Excel application"));

		// Tell Excel to quit (i.e. Application.Quit)
		hr = spXlApp->Quit();


		/////////////////////////////////////////////////////////////////////
		// Release the COM objects.
		// 

		// Releasing the references is not necessary for the smart pointers
		// spXlApp.Release();

	}
	catch (_com_error &err)
	{
		_tprintf(_T("Excel throws the error: %s\n"), err.ErrorMessage());
		_tprintf(_T("Description: %s\n"), (LPCTSTR) err.Description());
	}

	// Uninitialize COM for this thread
	CoUninitialize();

	return hr;
}