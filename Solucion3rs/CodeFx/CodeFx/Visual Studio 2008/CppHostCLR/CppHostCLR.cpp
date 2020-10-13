/****************************** Module Header ******************************\
* Module Name:	CppHostCLR.cpp
* Project:		CppHostCLR
* Copyright (c) Microsoft Corporation.
* 
* The Common Language Runtime (CLR) allows a level of integration between 
* itself and a host. This sample native console application uses the API
* CorBindToRuntimeEx to load a specific version of the CLR. Then, it uses the
* ICorRuntimeHost interface and methods exposed in mscorlib.tlb to load some 
* .NET assemblies and types and execute their methods. In the .NET Framework
* version 2.0, the interface ICorRuntimeHost is superceded by ICLRRuntimeHost.
* The CLR allows for a deeper integration in the new hosting APIs. For 
* example, the set of CLR functionality that is configurable by the host is 
* extended. However, this sample still demonstrates ICorRuntimeHost 
* considering that ICorRuntimeHost provides a better backwards compatibility 
* if the host wants to support .NET Framework versions 1.0, 1.1 apart from 
* 2.0, 3.0 and 3.5.
* 
* Examples
*  http://support.microsoft.com/kb/953836 
*  KB 953836 uses ICorRuntimeHost. In the .NET Framework version 2.0, the 
*  interface is superceded by ICLRRuntimeHost. However, ICorRuntimeHost
*  provides better backwards compatibility if the host application wants to
*  support .NET Framework versions: 1.0, 1.1.
*  http://blogs.msdn.com/calvin_hsia/archive/2006/08/07/691467.aspx
*  The blog uses ICLRRuntimeHost that does not support .NET Framework 
*  versions: 1.0, 1.1.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/21/2009 11:04 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes and Imports
#include "stdafx.h"
#include <assert.h>
#include <atlbase.h>


// Include <mscoree.h> for CorBindToRuntimeEx and ICorRuntimeHost.
#include <mscoree.h>
// Link with mscoree.dll import lib.
#pragma comment(lib, "mscoree.lib") 


// Importing mscorlib.tlb for _AppDomain. Used to communicate with the 
// default app domain from unmanaged code.
// see: 
//  http://msdn.microsoft.com/en-us/library/s5628ssw(VS.71).aspx
#import "mscorlib.tlb" raw_interfaces_only				\
	high_property_prefixes("_get","_put","_putref")		\
	rename("ReportEvent", "InteropServices_ReportEvent")
using namespace mscorlib;
#pragma endregion


/*!
 * \brief
 * Check whether or not the specified module is loaded in the current process.
 * 
 * \param pszModuleName
 * The module name
 */
void IsModuleLoaded(PCTSTR pszModuleName) 
{
	// Get the module in the process according to the module name.
	HMODULE hmod = GetModuleHandle(pszModuleName);

	_tprintf(_T("Module \"%s\" is %sloaded.\n"), pszModuleName, 
		(hmod == NULL) ? _T("not ") : _T(""));
}

int _tmain(int argc, _TCHAR* argv[])
{
	// Check whether or not the .NET runtime is already loaded.
	IsModuleLoaded(_T("mscorwks"));


	/////////////////////////////////////////////////////////////////////////
	// Load and start the .NET runtime.
	// 

	LPWSTR pszVer = L"v2.0.50727";	// Or NULL, which loads the latest runtime
	_tprintf(_T("Load and start %s .NET runtime\n"), 
		pszVer == NULL ? _T("the latest") : pszVer);

	LPWSTR pszFlavor = L"wks";		// Valid values are svr and wks

	ICorRuntimeHost *pCorRuntimeHost = NULL; 

	HRESULT hr = CorBindToRuntimeEx(
		pszVer,		/*NULL*/		// Runtime startup flags
		pszFlavor,	/*NULL*/		// Flavor of the runtime to request
		0,							// Runtime startup flags
		CLSID_CorRuntimeHost,		// CLSID of ICorRuntimeHost
		IID_ICorRuntimeHost,		// IID of ICorRuntimeHost
		(PVOID*)&pCorRuntimeHost);	// Returns ICorRuntimeHost

	if (FAILED(hr))
	{
		_tprintf(_T("CorBindToRuntimeEx failed w/err 0x%08lx\n"), hr);
		return 1;
	}

	hr = pCorRuntimeHost->Start();	// Start the CLR

	if (FAILED(hr))
	{
		_tprintf(_T("CLR failed to start w/err 0x%08lx\n"), hr);
		return 1;
	}

	// Check whether or not the .NET runtime is loaded.
	IsModuleLoaded(_T("mscorwks"));


	/////////////////////////////////////////////////////////////////////////
	// Get a pointer to the default AppDomain in the CLR.
	// 

	IUnknownPtr pAppDomainThunk = NULL;
	_AppDomainPtr pDefaultAppDomain = NULL;

	hr = pCorRuntimeHost->GetDefaultDomain(&pAppDomainThunk);
    assert(pAppDomainThunk);

	hr = pAppDomainThunk->QueryInterface(__uuidof(_AppDomain),
		(LPVOID*) &pDefaultAppDomain);
    assert(pDefaultAppDomain);
	
	// Prints the base directory of the default AppDomain.
	// BaseDirectory cannot be changed after the AppDomain is created. While
	// creating a new AppDomain, we can sepecify the base directory in 
	// AppDomainSetup.ApplicationBase.
	BSTR bstrBaseDir;
	pDefaultAppDomain->get_BaseDirectory(&bstrBaseDir);
	_tprintf(_T("Base directory of the default AppDomain:\n%s\n"),
		bstrBaseDir);
	::SysFreeString(bstrBaseDir);

	// Prints the current directory for the current process.
	// CurrentDirectory of a process is used to resolve relative paths. The
	// value can be changed at any time using the SetCurrentDirectory API.
	TCHAR szCurrentDir[MAX_PATH];
	GetCurrentDirectory(MAX_PATH, szCurrentDir);
	_tprintf(_T("Current directory for the current process:\n%s\n"), 
		szCurrentDir);


	/////////////////////////////////////////////////////////////////////////
	// Load an EXE assembly and call its entry function.
	// 

	_bstr_t bstrExeName = L"CSConsole.exe";
	_tprintf(_T("\nLoad and run %s\n"), (LPCTSTR)bstrExeName);

	// Call _AppDomain::ExecuteAssembly to load and run an EXE assembly

	long lRet= 0;
	// _AppDomain::ExecuteAssembly searches for the file in the current 
	// directory of the process (GetCurrentDirectory). 
	// AppDomainSetup.ApplicationBase is not used as the search path.
	hr = pDefaultAppDomain->ExecuteAssembly_2(bstrExeName, &lRet);
	if (FAILED(hr)) 
	{
		// hr contains the errors of _AppDomain::ExecuteAssembly_2 itself  
		// and the unhandled exceptions from the EXE assembly.
		_tprintf(_T("ExecuteAssembly_2 failed w/err 0x%08lx\n"), hr);
	}


	/////////////////////////////////////////////////////////////////////////
	// Load a type from a DLL Assembly and call it.
	// 
	// Doing the same thing from native code as this C# code:
	// System.Runtime.Remoting.ObjectHandle objptr;
	// objptr = AppDomain.CurrentDomain.CreateInstanceFrom(
	//     "CSClassLibrary.dll", "CSClassLibrary.CSSimpleClass");
	// object obj = objptr.Unwrap();
	// Type t = obj.GetType();
	// t.InvokeMember("Add",BindingFlags.InvokeMethod, 
	//     null, obj, new object[] {1, 2});

	_bstr_t bstrAssemName = L"CSClassLibrary.dll";	// Local folder
	_bstr_t bstrClassName = L"CSClassLibrary.CSSimpleClass";
	_tprintf(_T("\nLoad and use %s\n"), (LPCTSTR)bstrAssemName);

	_ObjectHandlePtr pObjectHandle; 
	_ObjectPtr pObject; 
	_TypePtr pType;

	// Create an instance of a type from an assembly
	hr = pDefaultAppDomain->CreateInstanceFrom(
		bstrAssemName, bstrClassName, &pObjectHandle);

	if (FAILED(hr))
	{
		_tprintf(_T("CreateInstanceFrom failed w/err 0x%08lx\n"), hr);
	}
	else
	{
		// Get an _Object (as variant) from the _ObjectHandle
		variant_t vtObj;
		pObjectHandle->Unwrap(&vtObj);	

		// QI the variant for the Object interface
		vtObj.pdispVal->QueryInterface(__uuidof(_Object),(void**)&pObject);

		// Get the _Type interface
		pObject->GetType(&pType);

		// Call the method int Add(int a, int b);

		// Create a safe array with one elements as the arguments.
		// The safe-array must be created as VARTYPE = VT_VARIANT because 
		//.NET reflection expects an array of Object - VT_VARIANT.
		SAFEARRAY* psaArgs = SafeArrayCreateVector(VT_VARIANT, 0, 1);
		LONG index = 0;
		variant_t fVal = 1.2f;
		SafeArrayPutElement(psaArgs, &index, &fVal);

		variant_t vtRet;	
		_bstr_t bstrMethodName = L"Increment";

		// Invoke the "Add" method on pType
		hr = pType->InvokeMember_3(bstrMethodName, BindingFlags_InvokeMethod,
			NULL, vtObj, psaArgs, &vtRet);

		SafeArrayDestroy(psaArgs);			// Destroy the safe-array

		if (SUCCEEDED(hr))
		{
			_tprintf(_T("Call %s.%s(%.2f) => %.2f\n"), (LPCTSTR)bstrClassName, 
				(LPCTSTR)bstrMethodName, fVal.fltVal, vtRet.fltVal);
		}
	}


	/////////////////////////////////////////////////////////////////////////
	// Stop the .NET runtime.
	// 

	_putts(_T("\nStop the .NET runtime"));
	pCorRuntimeHost->Stop();
	pCorRuntimeHost->Release();


	// Check whether or not the .NET runtime module is still loaded.
	IsModuleLoaded(_T("mscorwks"));

	return 0;
}

