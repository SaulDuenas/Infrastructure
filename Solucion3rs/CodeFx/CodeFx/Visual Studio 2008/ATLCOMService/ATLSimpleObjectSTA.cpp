/****************************** Module Header ******************************\
* Module Name:	ATLSimpleObjectSTA.cpp
* Project:		ATLCOMService
* Copyright (c) Microsoft Corporation.
* 
* Define the component's implementation class CATLSimpleObjectSTA
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 3/15/2009 1:11 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include "ATLSimpleObjectSTA.h"
#pragma endregion


STDMETHODIMP CATLSimpleObjectSTA::get_FloatProperty(FLOAT* pVal)
{
	// TODO: Add your implementation code here

	*pVal = m_fField;
	return S_OK;
}

STDMETHODIMP CATLSimpleObjectSTA::put_FloatProperty(FLOAT newVal)
{
	// TODO: Add your implementation code here

	// Fire the event, FloatPropertyChanging
	VARIANT_BOOL cancel = VARIANT_FALSE; 
	Fire_FloatPropertyChanging(newVal, &cancel);

	if (cancel == VARIANT_FALSE)
	{
		m_fField = newVal;	// Save the new value
	}
	// else, do nothing
	return S_OK;
}

STDMETHODIMP CATLSimpleObjectSTA::HelloWorld(BSTR* pRet)
{
	// TODO: Add your implementation code here

	// Allocate memory for the string: 
	*pRet = ::SysAllocString(L"HelloWorld");
	if (pRet == NULL)
		return E_OUTOFMEMORY;

	// The client is now responsible for freeing BSTR
	// @see Rules for Freeing BSTRs in OLE Automation
	// http://support.microsoft.com/kb/108934
	return S_OK;
}

STDMETHODIMP CATLSimpleObjectSTA::GetProcessThreadID(LONG* pdwProcessId, LONG* pdwThreadId)
{
	// TODO: Add your implementation code here

	*pdwProcessId = GetCurrentProcessId();
	*pdwThreadId = GetCurrentThreadId();
	return S_OK;
}
