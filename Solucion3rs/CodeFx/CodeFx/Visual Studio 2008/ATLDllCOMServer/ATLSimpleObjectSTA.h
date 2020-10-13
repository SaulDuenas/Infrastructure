/****************************** Module Header ******************************\
* Module Name:	ATLSimpleObjectSTA.h
* Project:		ATLDllCOMServer
* Copyright (c) Microsoft Corporation.
* 
* Declare the component's implementation class CATLSimpleObjectSTA
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/21/2009 11:03 PM Jialiang Ge Created
\***************************************************************************/

#pragma once

#pragma region Includes
#include "resource.h"       // main symbols

#include "ATLDllCOMServer_i.h"
#include "_IATLSimpleObjectSTAEvents_CP.h"
#pragma endregion


#if defined(_WIN32_WCE) && !defined(_CE_DCOM) && !defined(_CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA)
#error "Single-threaded COM objects are not properly supported on Windows CE platform, such as the Windows Mobile platforms that do not include full DCOM support. Define _CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA to force ATL to support creating single-thread COM object's and allow use of it's single-threaded COM object implementations. The threading model in your rgs file was set to 'Free' as that is the only threading model supported in non DCOM Windows CE platforms."
#endif



// CATLSimpleObjectSTA

class ATL_NO_VTABLE CATLSimpleObjectSTA :
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CATLSimpleObjectSTA, &CLSID_ATLSimpleObjectSTA>,
	public IConnectionPointContainerImpl<CATLSimpleObjectSTA>,
	public IPersistImpl<CATLSimpleObjectSTA>, 
	public CProxy_IATLSimpleObjectSTAEvents<CATLSimpleObjectSTA>,
	public IDispatchImpl<IATLSimpleObjectSTA, &IID_IATLSimpleObjectSTA, &LIBID_ATLDllCOMServerLib, /*wMajor =*/ 1, /*wMinor =*/ 0>
{
public:
	CATLSimpleObjectSTA() : m_fField(0.0f)
	{
	}

DECLARE_REGISTRY_RESOURCEID(IDR_ATLSIMPLEOBJECTSTA)


BEGIN_COM_MAP(CATLSimpleObjectSTA)
	COM_INTERFACE_ENTRY(IATLSimpleObjectSTA)
	COM_INTERFACE_ENTRY(IDispatch)
	COM_INTERFACE_ENTRY(IConnectionPointContainer)
	COM_INTERFACE_ENTRY(IPersist)
END_COM_MAP()

BEGIN_CONNECTION_POINT_MAP(CATLSimpleObjectSTA)
	CONNECTION_POINT_ENTRY(__uuidof(_IATLSimpleObjectSTAEvents))
END_CONNECTION_POINT_MAP()


	DECLARE_PROTECT_FINAL_CONSTRUCT()

	HRESULT FinalConstruct()
	{
		return S_OK;
	}

	void FinalRelease()
	{
	}

protected:
	// Used by FloatProperty
	float m_fField;

public:

	STDMETHOD(get_FloatProperty)(FLOAT* pVal);
	STDMETHOD(put_FloatProperty)(FLOAT newVal);
	STDMETHOD(HelloWorld)(BSTR* pRet);
	STDMETHOD(GetProcessThreadID)(LONG* pdwProcessId, LONG* pdwThreadId);
};

OBJECT_ENTRY_AUTO(__uuidof(ATLSimpleObjectSTA), CATLSimpleObjectSTA)
