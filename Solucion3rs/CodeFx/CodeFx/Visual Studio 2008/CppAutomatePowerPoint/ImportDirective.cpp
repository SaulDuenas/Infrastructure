/****************************** Module Header ******************************\
* Module Name:	ImportDirective.cpp
* Project:		CppAutomatePowerPoint
* Copyright (c) Microsoft Corporation.
* 
* The code in ImportDirective.h/cpp demonstrates the use of #import to 
* automate PowerPoint. #import 
* (http://msdn.microsoft.com/en-us/library/8etzzkb6.aspx), a new directive 
* that became available with Visual C++ 5.0, creates VC++ "smart pointers"  
* from a specified type library. It is very powerful, but often not 
* recommended because of reference-counting problems that typically occur 
* when used with the Microsoft Office applications. Unlike the direct API 
* approach in RawAPI.h/cpp, smart pointers enable us to benefit from the 
* type info to early/late bind the object. #import takes care of adding the 
* messy guids to the project and the COM APIs are encapsulated in custom 
* classes that the #import directive generates.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 6/4/2009 1:44 PM Jialiang Ge Created
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

#import "libid:91493440-5A91-11CF-8700-00AA0060263B"
// [-or-]
//#import "C:\\Program Files\\Microsoft Office\\Office12\\MSPPT.OLB"

#pragma endregion


DWORD WINAPI ImportPowerPoint(LPVOID lpParam)
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
		// Create the PowerPoint.Application COM object using the #import 
		// directive and smart pointers, and make the instance invisible.
		// 

		// Option 1) Create the object using the smart pointer's constructor
		// 
		// _ApplicationPtr is the original interface name, _Application, with a 
		// "Ptr" suffix.
		//PowerPoint::_ApplicationPtr spPpApp(
		//	__uuidof(PowerPoint::Application)	// CLSID of the component
		//	);

		// Option 2) Create the object using the smart pointer's function,
		// CreateInstance
		PowerPoint::_ApplicationPtr spPpApp;
		hr = spPpApp.CreateInstance(__uuidof(PowerPoint::Application));
		if (FAILED(hr))
		{
			_tprintf(_T(
				"PowerPoint::_ApplicationPtr.CreateInstance failed w/err 0x%08lx\n"
				), hr);
			return hr;
		}

		_putts(_T("PowerPoint.Application is started"));

		// Make PowerPoint invisible
		// By default PowerPoint is invisible, till you make it visible:
		//spPpApp->put_Visible(Office::MsoTriState::msoTrue);


		/////////////////////////////////////////////////////////////////////
		// Add a new Presentation.
		// 

		PowerPoint::PresentationsPtr spPres = spPpApp->Presentations;
		PowerPoint::_PresentationPtr spPre = spPres->Add(
			Office::MsoTriState::msoTrue);

		_putts(_T("A new presentation is created"));


		/////////////////////////////////////////////////////////////////////
		// Insert a new Slide and add some text to it.
		// 

		PowerPoint::SlidesPtr spSlides = spPre->Slides;

		_tprintf(_T("The presentation currently has %ld slides\n"), 
			spSlides->Count);

        // Insert a new slide
		_putts(_T("Insert a slide"));
		PowerPoint::_SlidePtr spSlide = spSlides->Add(1, 
			PowerPoint::PpSlideLayout::ppLayoutText);

		// Add some texts to the slide
        _putts(_T("Add some texts"));
		PowerPoint::ShapesPtr spShapes = spSlide->Shapes;
		PowerPoint::ShapePtr spShape = spShapes->Item(1);
		PowerPoint::TextFramePtr spTxtFrame = spShape->TextFrame;
		PowerPoint::TextRangePtr spTxtRange = spTxtFrame->TextRange;
        spTxtRange->Text = _bstr_t("All-In-One Code Framework");


		/////////////////////////////////////////////////////////////////////
		// Save the presentation as a pptx file and close it.
		// 

        _putts(_T("Save and close the presentation"));

		// Make the file name

		// Get the directory of the current exe.
		WCHAR szFileName[MAX_PATH];
		if (FAILED(GetModuleDirectoryW(szFileName, MAX_PATH)))
			return S_FALSE;

		// Concat "MSDN2.docx" to the directory
		wcsncat_s(szFileName, MAX_PATH, L"MSDN2.pptx", 10);

		hr = spPre->SaveAs(_bstr_t(szFileName), 
			PowerPoint::PpSaveAsFileType::ppSaveAsOpenXMLPresentation, 
			Office::MsoTriState::msoTriStateMixed);

        hr = spPre->Close();


		/////////////////////////////////////////////////////////////////////
		// Quit the PowerPoint application.
		// 

		_putts(_T("Quit the PowerPoint application"));
		hr = spPpApp->Quit();


		/////////////////////////////////////////////////////////////////////
		// Release the COM objects.
		// 

		// Releasing the references is not necessary for the smart pointers
		// spPowerPointApp.Release();

	}
	catch (_com_error &err)
	{
		_tprintf(_T("PowerPoint throws the error: %s\n"), err.ErrorMessage());
		_tprintf(_T("Description: %s\n"), (LPCTSTR) err.Description());
	}

	// Uninitialize COM for this thread
	::CoUninitialize();

	return hr;
}