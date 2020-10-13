/****************************** Module Header ******************************\
* Module Name:	MFCActiveX.h
* Project:		MFCActiveX
* Copyright (c) Microsoft Corporation.
* 
* The main header file for MFCActiveX.DLL
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/21/2009 11:04 PM Jialiang Ge Created
\***************************************************************************/

#pragma once


#if !defined( __AFXCTL_H__ )
#error "include 'afxctl.h' before including this file"
#endif

#include "resource.h"       // main symbols


// CMFCActiveXApp : See MFCActiveX.cpp for implementation.

class CMFCActiveXApp : public COleControlModule
{
public:
	BOOL InitInstance();
	int ExitInstance();
};

extern const GUID CDECL _tlid;
extern const WORD _wVerMajor;
extern const WORD _wVerMinor;

