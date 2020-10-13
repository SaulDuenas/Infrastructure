/****************************** Module Header ******************************\
* Module Name:	CppBasics.cpp
* Project:		CppBasics
* Copyright (c) Microsoft Corporation.
* 
* 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 5/28/2009 9:10 PM Jialiang Ge Created
\***************************************************************************/

#include "stdafx.h"

extern void TypeCasting(void);
extern void FunctionPointer(void);
extern void Array(void);

int _tmain(int argc, _TCHAR* argv[])
{
	TypeCasting();

	FunctionPointer();

	Array();

	return 0;
}