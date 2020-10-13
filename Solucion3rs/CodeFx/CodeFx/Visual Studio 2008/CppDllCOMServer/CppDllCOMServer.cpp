/****************************** Module Header ******************************\
* Module Name:  CppDllCOMServer.cpp
* Project:      CppDllCOMServer
* Copyright (c) Microsoft Corporation.
* 
* COM is one of the most popular words in Windows world, there are lots of
* technologies are based on it, such as: ActiveX control, WMI, even the super
* star CLR is also based on the COM. 
* This sample demonstrates how to create an in-process COM component by the
* raw interfaces from Win32 DLL project, describes the fundamental concepts
* involved.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 11/05/2009 02:57 PM Wesley Yao Created
\***************************************************************************/

#include "stdafx.h"
#include "CppSimpleObjectSTA.h"
#include "CppDllCOMServer.h"


/////////////////////////////////////////////////////////////////////////////
// Default constructor and distructor.
//

CppSimpleObjectSTAFactory::CppSimpleObjectSTAFactory()
{
    m_refCount = 0;
    ++g_uDllRefCount;
}

CppSimpleObjectSTAFactory::~CppSimpleObjectSTAFactory()
{
    --g_uDllRefCount;
}


/////////////////////////////////////////////////////////////////////////////
// IUnknown methods.
//

// Increase the reference count for an interface on an object.
STDMETHODIMP_(ULONG) CppSimpleObjectSTAFactory::AddRef()
{
    ++m_refCount;

    return m_refCount;
}

// Decrease the reference count for an interface on an object.
STDMETHODIMP_(ULONG) CppSimpleObjectSTAFactory::Release()
{
    if (--m_refCount == 0)
    {
        delete this;

        return 0;
    }

    return m_refCount;
}

// Query to the interface the component supported.
STDMETHODIMP CppSimpleObjectSTAFactory::QueryInterface(REFIID riid, void** ppv)
{
    // Return the IUnknown interface.
    if (riid == IID_IUnknown)
    {
        *ppv = (IUnknown*)this;
        ((IUnknown*)(*ppv))->AddRef();
    }

    // Return the IClassFactory interface.
    else if (riid == IID_IClassFactory)
    {
        *ppv = (IClassFactory*)this;
        ((IClassFactory*)(*ppv))->AddRef();
    }

    // Doesn't support the interface queried.
    else
    {
        *ppv = NULL;

        return E_NOINTERFACE;
    }

    return S_OK;
}


/////////////////////////////////////////////////////////////////////////////
// IClassFactory methods.
//

// Lock an object opened in the memory.  We don't implement this method in
// the sample.

STDMETHODIMP CppSimpleObjectSTAFactory::LockServer(BOOL fLock)
{
    return E_NOTIMPL;
}

// Create the class factory and query to the specific interface.
STDMETHODIMP CppSimpleObjectSTAFactory::CreateInstance(LPUNKNOWN pUnkOuter,
                                                    REFIID riid,
                                                    void** ppv)
{
    // Parameter pUnkOuter is used for aggregation, we don't support it in
    // the sample.
    if (pUnkOuter != NULL)
    {
        return CLASS_E_NOAGGREGATION;
    }

    CppSimpleObjectSTA *pCppSimpleObjectSTAObj = NULL;
    HRESULT hr;

    // Create the COM component.
    pCppSimpleObjectSTAObj = new CppSimpleObjectSTA();
    // Query to the specific interface of COM component supported.
    hr = pCppSimpleObjectSTAObj->QueryInterface(riid, ppv);

    if (FAILED(hr))
    {
        delete pCppSimpleObjectSTAObj;
    }

    return hr;
}


/////////////////////////////////////////////////////////////////////////////
// Global exposed functions.
//

// Standard self-registration table.
// There are two places we need to specify in the registry:
// 1. HKEY_CLASSES_ROOT\CLSID\{CLSID of Component}
// 2. HKEY_CLASSES_ROOT\ProgID of Component
// ProgID is a easy way to get the CLSID to create the COM component, we can
// get the CLSID from the ProgID through the method GetClsIdFromProgid().
const TCHAR *g_RegTable[][3]={
    {
        TEXT("CLSID\\{3739576F-F27B-4857-9E3E-8BAAA2A030B9}"),
        0,
        TEXT("CppSimpleObjectSTA")
    },
    {
        TEXT("CLSID\\{3739576F-F27B-4857-9E3E-8BAAA2A030B9}\\InprocServer32"),
        0,
        (const TCHAR *)-1
    },
    {
        TEXT("CLSID\\{3739576F-F27B-4857-9E3E-8BAAA2A030B9}\\ProgID"),
        0,
        TEXT("CppDllCOMServer.CppSimpleObjectSTA")
    },
    {
        TEXT("CppDllCOMServer.CppSimpleObjectSTA"),
        0,
        TEXT("CppSimpleObjectSTA")
    },
    {
        TEXT("CppDllCOMServer.CppSimpleObjectSTA\\CLSID"),
        0,
        TEXT("{3739576F-F27B-4857-9E3E-8BAAA2A030B9}")
    },
};

// Create the class factory and query to the specific interface.
EXTERN_C STDMETHODIMP DllGetClassObject(const CLSID&clsid,
                                        const IID& iid,
                                        void **ppv)
{
    if (CLSID_CppSimpleObjectSTA == clsid)
    {
        // Create the class factory.
        CppSimpleObjectSTAFactory *pFactory = new CppSimpleObjectSTAFactory();

        if(NULL == pFactory)
        {
            return E_OUTOFMEMORY;
        }
        // Query to the specific interface, normally it should be the
        // IClassFactory interface.
        HRESULT result = pFactory->QueryInterface(iid, ppv);

        return result;
    }

    else
    {
        return CLASS_E_CLASSNOTAVAILABLE;
    }
}

// Check whether we can unload the component from the memory.
EXTERN_C STDMETHODIMP DllCanUnloadNow(void)
{
    return (g_uDllRefCount > 0) ? S_FALSE : S_OK;
}

// Unegister the component to the registry.
EXTERN_C STDMETHODIMP DllUnregisterServer()
{
    HRESULT hr = S_OK;

    int nEntries = sizeof(g_RegTable) / sizeof(*g_RegTable);
    for(int i = 0; SUCCEEDED(hr) && i < nEntries; i++)
    {
        const TCHAR * pszKeyName=g_RegTable[i][0];
        long err = RegDeleteKey(HKEY_CLASSES_ROOT, pszKeyName);
        if(err != ERROR_SUCCESS)
        {
            hr = S_FALSE;
        }
    }

    return hr;
}

// Register the component to the registry.
EXTERN_C STDMETHODIMP DllRegisterServer()
{
    HRESULT hr = S_OK;
    TCHAR szFileName [MAX_PATH];
    // Get the path of the DLL which contains the component.
    GetModuleFileName(g_hinDll, szFileName, MAX_PATH);

    int nEntries = sizeof(g_RegTable) / sizeof(*g_RegTable);
    for(int i = 0; SUCCEEDED(hr) && i < nEntries; i++)
    {
        const TCHAR *pszKeyName     = g_RegTable[i][0];
        const TCHAR *pszValueName   = g_RegTable[i][1];
        const TCHAR *pszValue       = g_RegTable[i][2];

        if(pszValue == (const TCHAR *)-1)
        {
            pszValue = szFileName;
        }

        HKEY hkey;
        long err = RegCreateKey(HKEY_CLASSES_ROOT, pszKeyName, &hkey);
        if(err == ERROR_SUCCESS)
        {
            err = RegSetValueEx(hkey,
                pszValueName,
                0,
                REG_SZ,
                (const BYTE*)pszValue,
                wcslen(pszValue) * 2 + 1);
            RegCloseKey(hkey);
        }
        if(err != ERROR_SUCCESS)
        {
            DllUnregisterServer();
            hr = E_FAIL;
        }
    }

    return hr;
}


/////////////////////////////////////////////////////////////////////////////
// DLL entry function
//

BOOL APIENTRY DllMain(HMODULE hModule,
                      DWORD  ul_reason_for_call,
                      LPVOID lpReserved
                      )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }

    // Hold the instance of this DLL module, we will use it to get the path
    // of the DLL to register the component.
    g_hinDll = (HINSTANCE)hModule;

    return TRUE;
}