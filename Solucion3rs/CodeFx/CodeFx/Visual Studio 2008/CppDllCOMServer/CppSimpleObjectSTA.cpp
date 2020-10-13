/****************************** Module Header ******************************\
* Module Name:  CppSimpleObjectSTA.cpp
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

// This file contains the definition of the GUID, after the .idl file
// compiled, it will be available.
#include "CppDllCOMServer_i.c"


/////////////////////////////////////////////////////////////////////////////
// Default constructor and distructor.
//

CppSimpleObjectSTA::CppSimpleObjectSTA() : m_refCount(0)
{
}

CppSimpleObjectSTA::~CppSimpleObjectSTA()
{
}


/////////////////////////////////////////////////////////////////////////////
// IUnknown methods.
//

// Increase the reference count for an interface on an object.
STDMETHODIMP_(DWORD) CppSimpleObjectSTA::AddRef()
{
    ++m_refCount;

    return m_refCount;
}

// Decrease the reference count for an interface on an object.
STDMETHODIMP_(DWORD) CppSimpleObjectSTA::Release()
{
    if(--m_refCount == 0)
    {
        delete this;

        return 0;
    }

    else
    {
        return m_refCount;
    }
}

// Query to the interface the component supported.
STDMETHODIMP CppSimpleObjectSTA::QueryInterface(REFIID riid, void** ppv)
{
    // Return the IUnknown interface.
    if(riid == IID_IUnknown)
    {
        *ppv = (IUnknown*)this;
        ((IUnknown*)(*ppv))->AddRef();
    }

    // Return the IWelcome interface.
    else if(riid == IID_ICppSimpleObjectSTA)
    {
        *ppv = (ICppSimpleObjectSTA*)this;
        ((ICppSimpleObjectSTA*)(*ppv))->AddRef();
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
// ICppSimpleObjectSTA methods.
//
STDMETHODIMP CppSimpleObjectSTA::HelloWorld(BSTR* pRet)
{
    // Allocate memory for the string: 
    *pRet = ::SysAllocString(L"HelloWorld");
    if (pRet == NULL)
    {
        return E_OUTOFMEMORY;
    }

    // The client is now responsible for freeing pbstr
    return S_OK;
}

STDMETHODIMP CppSimpleObjectSTA::GetProcessThreadID(LONG* pdwProcessId,
                                                    LONG* pdwThreadId)
{
    *pdwProcessId = GetCurrentProcessId();
    *pdwThreadId = GetCurrentThreadId();

    return S_OK;
}