/****************************** Module Header ******************************\
* Module Name:	ImportDirective.cpp
* Project:		CppCOMClient
* Copyright (c) Microsoft Corporation.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/12/2009 10:23 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "StdAfx.h"
#include "ImportDirective.h"
#pragma endregion


#pragma region Import the type library

// Importing mscorlib.tlb is necessary for .NET components
// see: 
//  http://msdn.microsoft.com/en-us/library/s5628ssw(VS.71).aspx
#import "mscorlib.tlb" raw_interfaces_only				\
	high_property_prefixes("_get","_put","_putref")		\
	rename("ReportEvent", "InteropServices_ReportEvent")
using namespace mscorlib;

// Option 1) #import the name of a file that contains a type library 
// 
// We can either specify the full path of the tlb/dll/ocx/exe file or add 
// the path of the file to the project's Additional Include Directories 
// setting.
// 
// For .NET components, importing the assembly file (dll/exe) fails because 
// the type library is not embedded in the .NET assemblies. There is a 
// stand-alone tlb file. For native components, the type library is embedded 
// into the executable by default, and we can #import the dll/ocx/exe module 
// directly.

//#import "CSDllCOMServer.tlb" no_namespace named_guids

// Option 2) #import the progid of the component in the type library
// 
// #import-ing the progid only works for native components because .NET 
// components do not register the typelib for its ProgID by default. As an
// evidence, please open the CLSID registry node and check the TypeLib key: 
// HKCR\CLSID\{xxxx}\TypeLib, which is lacked by .NET components.

//#import "progid:CSDllCOMServer.CSSimpleObject2" \
//	no_namespace \
//	named_guids

// Option 3) #import the libid of the type library
// 
// In the type library of CSDllCOMServer, the library ID is
// F0998D9A-0E79-4F67-B944-9E837F479587
// 
//  [uuid(F0998D9A-0E79-4F67-B944-9E837F479587), version(1.0),
//  custom(90883F05-3D28-11D2-8F17-00A0C9A6186D,"CSDllCOMServer,...)] 
//  library CSDllCOMServer { ... } 
// 
// #importing the library ID works for both native an .NET components.

#import "libid:F0998D9A-0E79-4F67-B944-9E837F479587" \
	no_namespace \
	named_guids

#pragma endregion


/*!
 * \brief
 * The definition of ImportCSharpComponent in the header file
 * 
 * \see
 * Separate ImportDirective.h | ImportCSharpComponent
 */
DWORD WINAPI ImportCSharpComponent(LPVOID lpParam)
{
	HRESULT hr;

	// Initializes the COM library on the current thread and identifies the
	// concurrency model as single-thread apartment (STA). 
	// [-or-] ::CoInitialize(NULL);
	// [-or-] ::CoCreateInstance(NULL);
	::CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);


	/////////////////////////////////////////////////////////////////////////
	// Create the CSDllCOMServer.CSSimpleObject2 COM object using the #import 
	// directive and smart pointers.
	// 

	// Option 1) Create the object using the smart pointer's constructor
	// 
	// ICSSimpleObject2Ptr is the original interface name, ICSSimpleObject2,
	// with a "Ptr" suffix.
	//ICSSimpleObject2Ptr spSimpleObj(
	//	__uuidof(CSSimpleObject2)	// CLSID of the component
	//	);

	// Option 2) Create the object using the smart pointer's function,
	// CreateInstance
	ICSSimpleObject2Ptr spSimpleObj;
	hr = spSimpleObj.CreateInstance(__uuidof(CSSimpleObject2));
	if (FAILED(hr))
	{
		_tprintf(_T(
			"ICSSimpleObject2Ptr.CreateInstance failed w/err 0x%08lx\n"
			), hr);
		return hr;
	}


	/////////////////////////////////////////////////////////////////////////
	// Consume the properties and the methods of the COM object.
	// 

	try
	{
		// Set the property: FloatProperty.
		{
			_tprintf(_T("Set FloatProperty = %.2f\n"), 1.2f);
			spSimpleObj->FloatProperty = 1.2f;
		}

		// Get the property: FloatProperty.
		{
			_tprintf(_T("Get FloatProperty = %.2f\n"),
				spSimpleObj->FloatProperty);
		}

		// Call the method: HelloWorld, that returns a BSTR.
		{
			// the _bstr_t object and the underlying BSTR will be cleared 
			// automatically in the destructor when the object is out of 
			// the scope.
			_bstr_t bstrResult = spSimpleObj->HelloWorld();
			_tprintf(_T("Call HelloWorld => %s\n"), (LPCTSTR)bstrResult);
		}

		// Call the method: GetProcessThreadID, that outputs two DWORDs.
		{
			_tprintf(_T("The client process and thread: %ld, %ld\n"),
				GetCurrentProcessId(), GetCurrentThreadId());
			
			DWORD dwProcessId, dwThreadId;
			spSimpleObj->GetProcessThreadID(&dwProcessId, &dwThreadId);
			_tprintf(_T("Call GetProcessThreadID => %ld, %ld\n"), 
				dwProcessId, dwThreadId);
		}

		_putts(_T(""));
	}
	catch (_com_error &err)
	{
		_tprintf(_T("The server throws the error: %s\n"), err.ErrorMessage());
		_tprintf(_T("Description: %s\n"), (LPCTSTR) err.Description());
	}


	/////////////////////////////////////////////////////////////////////////
	// Release the COM object.
	// 

	// Releasing the references is not necessary for the smart pointers
	// spSimpleObj.Release();

	// Uninitialize COM for this thread
	::CoUninitialize();

	return S_OK;
}