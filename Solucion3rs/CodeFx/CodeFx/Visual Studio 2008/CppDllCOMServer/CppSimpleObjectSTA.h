/****************************** Module Header ******************************\
* Module Name:  CppSimpleObjectSTA.h
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

#ifndef _CPPSIMPLEOBJECTSTA_H
#define _CPPSIMPLEOBJECTSTA_H

#pragma once

// This file contains the definition of the interface, after the .idl file
// compiled, it will be available.
#include "CppDllCOMServer_h.h"

class CppSimpleObjectSTA : public ICppSimpleObjectSTA
{
public:
    // Default constructor and distructor.
    CppSimpleObjectSTA();
    virtual ~CppSimpleObjectSTA();

    // IUnknown methods.
    STDMETHODIMP_(DWORD) AddRef();
    STDMETHODIMP_(DWORD) Release();
    STDMETHODIMP QueryInterface(REFIID riid, void** ppv);

    // ICppSimpleObjectSTA methods.
    STDMETHODIMP HelloWorld(BSTR* pRet);
    STDMETHODIMP GetProcessThreadID(LONG* pdwProcessId, LONG* pdwThreadId);

private:
    // Reference count of component.
    DWORD m_refCount;
};

#endif // End _CPPSIMPLEOBJECTSTA_H