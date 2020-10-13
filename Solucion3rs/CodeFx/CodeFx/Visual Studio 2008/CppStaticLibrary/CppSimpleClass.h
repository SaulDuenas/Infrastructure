/****************************** Module Header ******************************\
* Module Name:	CppSimpleClass.h
* Project:		CppStaticLibrary
* Copyright (c) Microsoft Corporation.
* 
* The header of the class CppSimpleClass in the static library.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 3/22/2009 4:40 PM Jialiang Ge Created
\***************************************************************************/

#pragma once


class CppSimpleClass
{
private:
	float m_fField;

public:
	// Constructor
	CppSimpleClass();

	// Property
	float get_FloatProperty();
	void set_FloatProperty(float newVal);

	// Method
	
};
