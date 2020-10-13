========================================================================
    CONSOLE APPLICATION : CppLoadLibrary Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

This is an example of dynamically loading a DLL using the APIs LoadLibrary, 
GetProcAddress and FreeLibrary. In contrast with implicit linking (static 
loading), dynamic loading does not require the LIB file, and the application 
loads the module just before we call a function in the DLL. The API functions 
LoadLibrary and GetProcAddress are used to load the DLL and then retrieve the
address of a function in the export table. Because we explicitly invoke these 
APIs, this kind of loading is also referred to as explicit linking. 


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CppLoadLibrary -> CppDllExport
CppLoadLibrary dynamically loads CppDllExport.dll and uses its symbols.

CppLoadLibrary - CSLoadLibrary
CSLoadLibrary in C# mimics the behavior of CppLoadLibrary to dynamically load
a native DLL, get the address of a function in the export table, and call it.


/////////////////////////////////////////////////////////////////////////////
Code Logic:

1. Type-define the methods exported from the module. For example:

	typedef void (* LPFNHELLOWORLD1) (_TCHAR**);

2. Dynamically load the library. (LoadLibrary)

3. Get the address of the function in the export table of the DLL.
(GetProcAddress)

4. Call the function.

5. Unload the library. (FreeLibrary)


/////////////////////////////////////////////////////////////////////////////
References:

Step by Step: Calling C++ DLLs from VC++ and VB
http://www.codeproject.com/KB/DLL/XDllPt4.aspx


/////////////////////////////////////////////////////////////////////////////