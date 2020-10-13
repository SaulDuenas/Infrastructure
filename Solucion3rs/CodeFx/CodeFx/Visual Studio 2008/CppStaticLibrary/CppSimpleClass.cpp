/****************************** Module Header ******************************\
* Module Name:	CppSimpleClass.cpp
* Project:		CppStaticLibrary
* Copyright (c) Microsoft Corporation.
* 
* The implementation of the class CppSimpleClass in the static library.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 3/22/2009 4:40 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include "CppSimpleClass.h"
#pragma endregion


CppSimpleClass::CppSimpleClass() : m_fField(0.0f)
{
}

float CppSimpleClass::get_FloatProperty()
{
	return this->m_fField;
}

void CppSimpleClass::set_FloatProperty(float newVal)
{
	this->m_fField = newVal;
}
