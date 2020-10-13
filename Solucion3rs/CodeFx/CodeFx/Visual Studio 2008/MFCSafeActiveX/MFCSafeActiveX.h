/****************************** Module Header ******************************\
* Module Name:	MFCSafeActiveX.h
* Project:		MFCSafeActiveX
* Copyright (c) Microsoft Corporation.
* 
* Main header file for MFCSafeActiveX.DLL
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 2/5/2009 9:44 PM Jialiang Ge Created
\***************************************************************************/

#pragma once

#if !defined( __AFXCTL_H__ )
#error "include 'afxctl.h' before including this file"
#endif

#include "resource.h"       // main symbols


class CMFCSafeActiveXApp : public COleControlModule
{
public:
	BOOL InitInstance();
	int ExitInstance();
};

extern const GUID CDECL _tlid;
extern const WORD _wVerMajor;
extern const WORD _wVerMinor;