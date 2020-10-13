/****************************** Module Header ******************************\
* Module Name:	MFCCreateCOMPage.h
* Project:		MFCCOMClient
* Copyright (c) Microsoft Corporation.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/22/2009 2:34 PM Jialiang Ge Created
\***************************************************************************/

#pragma once


// CMFCCreateCOMPage dialog

class CMFCCreateCOMPage : public CDialog
{
	DECLARE_DYNAMIC(CMFCCreateCOMPage)

public:
	CMFCCreateCOMPage(CWnd* pParent = NULL);   // standard constructor
	virtual ~CMFCCreateCOMPage();

// Dialog Data
	enum { IDD = IDD_CREATECOM_PAGE };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedATLExeCOMServerButton();
};
