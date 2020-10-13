========================================================================
    DYNAMIC LINK LIBRARY : CppCLIWrapLib Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

This sample shows how to wrap a native C++ class so it can be consumed by 
code authored in C#, or other .NET language. 


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CppCLIWrapLib -> CppStaticLibrary
CppCLIWrapLib wraps the native class in CppStaticLibrary so it can be 
consumed by code authored in C#, or other .NET language.


/////////////////////////////////////////////////////////////////////////////
Creation:

A. Creating the project

Step1. Create a Visual C++ / CLR / Class Library project named CppCLIWrapLib 
in Visual Studio 2008.

B. Referencing the target library

This example references the static library CppStaticLibrary. You can also 
choose to link to any dynamically-linked-libraries.

Option1. Link the LIB file of CppStaticLibrary by entering the LIB file name  
in Project Properties / Linker / Input / Additional Dependencies. We can 
configure the search path of the LIB file in Project Properties / Linker / 
General / Additional Library Directories.

Option2. Select References... from the Project's shortcut menu. From the 
Property Pages dialog box, expand the Common Properties node and select 
References. Then select the Add New Reference... button. The Add Reference 
dialog box is displayed. This dialog box lists all the libraries that you can 
reference. The Project tab lists all the projects in the current solution and 
any libraries they contain. On the Projects tab, select CppStaticLibrary. 
Then select OK.

C. Including the header file

To reference the header files of the static library, you can modify the 
include directories path. To do this, in the Property Pages dialog box, 
expand the Configuration Properties node, expand the C/C++ node, and then 
select General. Next to Additional Include Directories, type the path of the 
location of the CppSimpleClass.h header file.

In the source code file, include header with the statement:

	#include "CppSimpleClass.h"

D. Wrapping the native C++ class in a C++/CLI class

Step1. Add a C++/CLI class CppSimpleClassWrapper.

Step2. Add a member variable CppSimpleClass* m_Impl. m_Impl points to the 
instance of the native class. Instantiate m_Impl in the constructor of the 
wrapper class.

	CppSimpleClassWrapper()
	{
		m_Impl = new CppSimpleClass();
	}

Step3. Redirect all calls of CppSimpleClassWrapper to m_Impl.

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

Step4. Handle the desctruction of m_Impl: 

	// Deallocate the native object on a destructor
	~CppSimpleClassWrapper() {
		delete m_Impl;
	}
		
	protected:
	// Deallocate the native object on the finalizer just in case no 
	// destructor is called
	!CppSimpleClassWrapper() {
		delete m_Impl;
	}


/////////////////////////////////////////////////////////////////////////////
References:

How to: Wrap Native Class for Use by C#
http://msdn.microsoft.com/en-us/library/ms235281.aspx

.NET to C++ Bridge
http://blogs.microsoft.co.il/blogs/sasha/archive/2008/02/16/net-to-c-bridge.aspx


/////////////////////////////////////////////////////////////////////////////
