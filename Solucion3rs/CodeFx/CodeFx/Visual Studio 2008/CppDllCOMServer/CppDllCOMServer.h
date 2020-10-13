/****************************** Module Header ******************************\
* Module Name:  CppDllCOMServer.h
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

#ifndef _CPPDLLCOMSERVER_H
#define _CPPDLLCOMSERVER_H

#pragma once

UINT g_uDllRefCount = 0;
HINSTANCE g_hinDll = NULL;

class CppSimpleObjectSTAFactory : public IClassFactory
{
public:
    // Default constructor and distructor.
    CppSimpleObjectSTAFactory();
    virtual ~CppSimpleObjectSTAFactory();

    // IUnknown methods.
    STDMETHODIMP_(ULONG) AddRef();
    STDMETHODIMP_(ULONG) Release();
    STDMETHODIMP QueryInterface(REFIID riid,void** ppv);

    // IClassFactory methods.
    STDMETHODIMP LockServer(BOOL fLock);
    STDMETHODIMP CreateInstance(LPUNKNOWN pUnkOuter,REFIID riid,void** ppv);

private:
    // Reference count of class factory.
    ULONG m_refCount;
};

#endif // End _CPPDLLCOMSERVER_H