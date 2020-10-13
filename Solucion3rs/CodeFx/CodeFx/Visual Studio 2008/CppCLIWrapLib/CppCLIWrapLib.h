/****************************** Module Header ******************************\
* Module Name:	CppCLIWrapLib.cpp
* Project:		CppCLIWrapLib
* Copyright (c) Microsoft Corporation.
* 
* This sample shows how to wrap a native C++ class so it can be consumed by 
* code authored in C#, or other .NET language. 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/24/2009 2:13 PM Jialiang Ge Created
\***************************************************************************/

#pragma once

using namespace System;

// The header file of the LIB to be linked
#include "CppSimpleClass.h"


namespace CppCLIWrapLib {

	public ref class CppSimpleClassWrapper
	{
	private:
		CppSimpleClass* m_Impl;

	public:

		// Allocate the native object on the C++ Heap via a constructor
		CppSimpleClassWrapper()
		{
			m_Impl = new CppSimpleClass();
		}

		// Deallocate the native object on a destructor
		~CppSimpleClassWrapper() {
			delete m_Impl;
		}

		// Wrap the get_FloatProperty and set_FloatProperty methods
		property float FloatProperty 
		{
			float get()
			{
				return m_Impl->get_FloatProperty();
			}
			void set(float value)
			{
				m_Impl->set_FloatProperty(value);
			}
		}

	protected:
		// Deallocate the native object on the finalizer just in case no 
		// destructor is called
		!CppSimpleClassWrapper() {
			delete m_Impl;
		}
	};
}
