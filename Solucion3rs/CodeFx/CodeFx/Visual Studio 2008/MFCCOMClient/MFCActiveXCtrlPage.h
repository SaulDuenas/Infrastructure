/****************************** Module Header ******************************\
* Module Name:	MFCActiveXCtrlPage.h
* Project:		MFCCOMClient
* Copyright (c) Microsoft Corporation.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/22/2009 2:39 PM Jialiang Ge Created
\***************************************************************************/

#pragma once
#include "mfcactivexctrl.h"
#include "afxwin.h"


// CMFCActiveXCtrlPage dialog

class CMFCActiveXCtrlPage : public CDialog
{
	DECLARE_DYNAMIC(CMFCActiveXCtrlPage)

public:
	CMFCActiveXCtrlPage(CWnd* pParent = NULL);   // standard constructor
	virtual ~CMFCActiveXCtrlPage();

// Dialog Data
	enum { IDD = IDD_ACTIVEXCTRL_PAGE };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	CMFCActiveXCtrl m_ocxActiveXCtrl;
	float m_fEditFloatProperty;
	DECLARE_EVENTSINK_MAP()
	void FloatPropertyChangingMFCActiveXCtrl(float NewValue, BOOL* Cancel);
	afx_msg void OnBnClickedSetFloatPropBn();
	afx_msg void OnBnClickedGetFloatPropBn();
};
