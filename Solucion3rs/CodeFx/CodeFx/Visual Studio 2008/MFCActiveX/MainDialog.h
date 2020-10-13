/****************************** Module Header ******************************\
* Module Name:	MainDialog.h
* Project:		MFCActiveX
* Copyright (c) Microsoft Corporation.
* 
* CMainDialog dialog
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/21/2009 11:04 PM Jialiang Ge Created
\***************************************************************************/

#pragma once
#include "afxwin.h"


class CMainDialog : public CDialog
{
	DECLARE_DYNAMIC(CMainDialog)

public:
	CMainDialog(CWnd* pParent = NULL);   // standard constructor
	virtual ~CMainDialog();

// Dialog Data
	enum { IDD = IDD_MAINDIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedMsgBoxBn();
	CEdit m_EditMessage;
	CStatic m_StaticFloatProperty;
};
