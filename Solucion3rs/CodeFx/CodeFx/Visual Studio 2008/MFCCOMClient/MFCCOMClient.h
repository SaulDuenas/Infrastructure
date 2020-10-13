/****************************** Module Header ******************************\
* Module Name:	MFCCOMClient.h
* Project:		MFCCOMClient
* Copyright (c) Microsoft Corporation.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/18/2009 3:31 PM Jialiang Ge Created
\***************************************************************************/

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols


// CMFCCOMClientApp:
// See MFCCOMClient.cpp for the implementation of this class
//

class CMFCCOMClientApp : public CWinAppEx
{
public:
	CMFCCOMClientApp();

// Overrides
	public:
	virtual BOOL InitInstance();

// Implementation

	DECLARE_MESSAGE_MAP()
};

extern CMFCCOMClientApp theApp;