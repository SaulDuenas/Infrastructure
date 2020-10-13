/****************************** Module Header ******************************\
* Module Name:	MFCActiveXPropPage.h
* Project:		MFCActiveX
* Copyright (c) Microsoft Corporation.
* 
* Declaration of the CMFCActiveXPropPage property page class.
* See MFCActiveXPropPage.cpp for implementation.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/21/2009 11:04 PM Jialiang Ge Created
\***************************************************************************/

#pragma once


class CMFCActiveXPropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CMFCActiveXPropPage)
	DECLARE_OLECREATE_EX(CMFCActiveXPropPage)

// Constructor
public:
	CMFCActiveXPropPage();

// Dialog Data
	enum { IDD = IDD_PROPPAGE_MFCACTIVEX };

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Message maps
protected:
	DECLARE_MESSAGE_MAP()
};

