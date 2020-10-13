/****************************** Module Header ******************************\
* Module Name:	FileDropExt.h
* Project:		ATLShellExtDropHandler
* Copyright (c) Microsoft Corporation.
* 
* 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 7/20/2009 10:43 PM Jialiang Ge Created
\***************************************************************************/

#pragma once
#include "resource.h"       // main symbols

#include "ATLShellExtDropHandler_i.h"


#if defined(_WIN32_WCE) && !defined(_CE_DCOM) && !defined(_CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA)
#error "Single-threaded COM objects are not properly supported on Windows CE platform, such as the Windows Mobile platforms that do not include full DCOM support. Define _CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA to force ATL to support creating single-thread COM object's and allow use of it's single-threaded COM object implementations. The threading model in your rgs file was set to 'Free' as that is the only threading model supported in non DCOM Windows CE platforms."
#endif



// CFileDropExt

class ATL_NO_VTABLE CFileDropExt :
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CFileDropExt, &CLSID_FileDropExt>,
	public IPersistFile,
	public IDropTarget
{
public:
	CFileDropExt()
	{
	}

DECLARE_REGISTRY_RESOURCEID(IDR_FILEDROPEXT)

DECLARE_NOT_AGGREGATABLE(CFileDropExt)

BEGIN_COM_MAP(CFileDropExt)
	COM_INTERFACE_ENTRY(IPersistFile)
	COM_INTERFACE_ENTRY(IDropTarget)
END_COM_MAP()



	DECLARE_PROTECT_FINAL_CONSTRUCT()

	HRESULT FinalConstruct()
	{
		return S_OK;
	}

	void FinalRelease()
	{
	}

public:

	// IPersistFile
	IFACEMETHODIMP GetClassID(LPCLSID)      { return E_NOTIMPL; }
	IFACEMETHODIMP IsDirty()                { return E_NOTIMPL; }
	IFACEMETHODIMP Load(LPCOLESTR, DWORD)   { return S_OK;      }
	IFACEMETHODIMP Save(LPCOLESTR, BOOL)    { return E_NOTIMPL; }
	IFACEMETHODIMP SaveCompleted(LPCOLESTR) { return E_NOTIMPL; }
	IFACEMETHODIMP GetCurFile(LPOLESTR*)    { return E_NOTIMPL; }

    // IDropTarget
	IFACEMETHODIMP DragEnter(IDataObject* pDataObj, DWORD grfKeyState, 
		POINTL pt, DWORD* pdwEffect)
	{ return E_NOTIMPL; }
	IFACEMETHODIMP DragOver(DWORD grfKeyState, POINTL pt, DWORD* pdwEffect)
	{ return E_NOTIMPL; }
	IFACEMETHODIMP DragLeave()
	{ return S_OK; }
	IFACEMETHODIMP Drop(IDataObject* pDataObj, DWORD grfKeyState, POINTL pt, 
		DWORD* pdwEffect)
	{ return E_NOTIMPL; }
};

OBJECT_ENTRY_AUTO(__uuidof(FileDropExt), CFileDropExt)
