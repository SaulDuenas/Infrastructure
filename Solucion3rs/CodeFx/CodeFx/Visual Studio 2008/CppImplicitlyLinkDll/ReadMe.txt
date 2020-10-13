========================================================================
    CONSOLE APPLICATION : CppImplicitlyLinkDll Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

Normally, when we link to a DLL via a LIB file, the DLL is loaded when the  
application starts up. This kind of loading is kwown as implicit linking,  
because the system takes care of loading the DLL for us - all we need to do 
is link with the LIB file.

After the configuration of linking, we can import symbols of a DLL into the 
application using the keyword __declspec(dllimport) no matter whether the 
symbols were exported with __declspec(dllexport) or with a .def file.

This sample demonstrates implicitly linking CppDllExport.dll and importing 
and using its symbols.


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CppImplicitlyLinkDll -> CppDllExport
CppImplicitlyLinkDll implicitly links (staticly loads) the CppDllExport.dll 
and uses its symbols.


/////////////////////////////////////////////////////////////////////////////
Creation:

A. Referencing the Dynamic Link Library

Option1. Link the LIB file of the DLL by entering the LIB file name in 
Project Properties / Linker / Input / Additional Dependencies. We can 
configure the search path of the LIB file in Project Properties / Linker / 
General / Additional Library Directories.

Option2. Select References from the Project's shortcut menu. On the Property 
Pages dialog box, expand the Common Properties node, select References, and 
then select the Add New Reference... button. The Add Reference dialog box is 
displayed. This dialog lists all the libraries that you can reference. The 
Project tab lists all the projects in the current solution and any libraries 
they contain. On the Projects tab, select CppDllExport. Then click OK. 

B. Including the header file

#include the header file that imports the symbols of the DLL.

	#include "CppDllExport.h"

We can configure the search path of the header file in Project Properties / 
C/C++ / General / Additional Include Directories.

C. Using the imported symbols

For example:

	_TCHAR* result;
	HelloWorld1(&result);


/////////////////////////////////////////////////////////////////////////////
References:

Importing into an Application
http://msdn.microsoft.com/en-us/library/kh1zw7z7.aspx

Creating and Using a Dynamic Link Library (C++)
http://msdn.microsoft.com/en-us/library/ms235636.aspx

Step by Step: Calling C++ DLLs from VC++ and VB - Part 1 By Hans Dietrich
http://www.codeproject.com/KB/DLL/XDllPt1.aspx


/////////////////////////////////////////////////////////////////////////////