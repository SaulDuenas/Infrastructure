/****************************** Module Header ******************************\
* Module Name:	ATLActiveXCtrl.cpp
* Project:		ATLActiveX
* Copyright (c) Microsoft Corporation.
* 
* Define the component's implementation class CATLActiveXCtrl
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 3/21/2009 11:06 AM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include <atlstr.h>

#include "ATLActiveXCtrl.h"
#pragma endregion


STDMETHODIMP CATLActiveXCtrl::get_FloatProperty(FLOAT* pVal)
{
	// TODO: Add your implementation code here

	*pVal = m_fField;
	return S_OK;
}

STDMETHODIMP CATLActiveXCtrl::put_FloatProperty(FLOAT newVal)
{
	// TODO: Add your implementation code here

	// Fire the event, FloatPropertyChanging
	VARIANT_BOOL cancel = VARIANT_FALSE; 
	Fire_FloatPropertyChanging(newVal, &cancel);

	if (cancel == VARIANT_FALSE)
	{
		m_fField = newVal;	// Save the new value

		// Display the new value in the control UI
		CString strFloatProp;
		strFloatProp.Format(_T("%f"), m_fField);
		SetDlgItemText(IDC_FLOATPROP_STATIC, strFloatProp);
	}
	// else, do nothing
	return S_OK;
}

STDMETHODIMP CATLActiveXCtrl::HelloWorld(BSTR* pRet)
{
	// TODO: Add your implementation code here

	// Allocate memory for the string: 
	*pRet = ::SysAllocString(L"HelloWorld");
	if (pRet == NULL)
		return E_OUTOFMEMORY;

	// The client is now responsible for freeing pbstr
	return S_OK;
}

STDMETHODIMP CATLActiveXCtrl::GetProcessThreadID(LONG* pdwProcessId, LONG* pdwThreadId)
{
	// TODO: Add your implementation code here

	*pdwProcessId = GetCurrentProcessId();
	*pdwThreadId = GetCurrentThreadId();
	return S_OK;
}

LRESULT CATLActiveXCtrl::OnInitDialog(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
{
	InPlaceActivate(OLEIVERB_UIACTIVATE);
	// Perform any dialog initialization
	return 0;
}

LRESULT CATLActiveXCtrl::OnBnClickedMsgboxBn(WORD /*wNotifyCode*/, WORD /*wID*/, HWND /*hWndCtl*/, BOOL& /*bHandled*/)
{
	// TODO: Add your control notification handler code here

	TCHAR szMessage[256];
	GetDlgItemText(IDC_MSGBOX_EDIT, szMessage, 256);
	MessageBox(szMessage, _T("HelloWorld"), MB_ICONINFORMATION | MB_OK);

	return 0;
}
