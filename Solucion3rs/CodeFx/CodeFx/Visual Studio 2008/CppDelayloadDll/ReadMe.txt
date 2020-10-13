========================================================================
    CONSOLE APPLICATION : CppDelayloadDll Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

The support of delayed loading of DLLs in Visual C++ linker relieves us of 
the need to use the API LoadLibrary and GetProcAddress to implement DLL 
delayed loading. DLL is implicitly linked but not actually loaded until the 
code attempts to reference a symbol contained within the DLL. An application 
can delay load a DLL using the /DELAYLOAD (Delay Load Import) linker option 
with a helper function (default implementation provided by Visual C++, see 
http://msdn.microsoft.com/en-us/library/09t6x5ds.aspx). The helper function 
will load the DLL at run time by calling LoadLibrary and GetProcAddress for 
us. 

We should consider delay loading a DLL if the program may not call a function
in the DLL or a function in the DLL may not get called until late in the 
program's execution. Delay loading a DLL saves the initialization time when 
the executable files starts up.

This example demonstrates delay loading CppDllExport.dll, importing and using
its symbols, and unloading the module.


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CppDelayloadDll -> CppDllExport
CppDelayloadDll delay-loads CppDllExport.dll and uses its symbols.


/////////////////////////////////////////////////////////////////////////////
Creation:

Step1. Link the LIB file of the DLL by entering the LIB file name in 
Project Properties / Linker / Input / Additional Dependencies. We can 
configure the search path of the LIB file in Project Properties / Linker / 
General / Additional Library Directories.

Step2. #include the header file that imports the symbols of the DLL.

	#include "CppDllExport.h"

We can configure the search path of the header file in Project Properties / 
C/C++ / General / Additional Include Directories.

Step3. Specify the DLL for delay loading by entering the DLL file name, 
CppDllExport.dll, in Project Properties / Linker / Input / Delay Loaded DLLs.

Step4. Specify to allow explicitly unloading of the delayed load DLLs by 
selecting "Support Unload (/DELAY:UNLOAD) in Project Properties / Linker / 
Advanced / Delay Loaded DLL.

Step5. Use the imported symbols. For example:

	_TCHAR* result;
	HelloWorld1(&result);

Note: Delay-load does not allow accessing/dllimport-ing data symbols.

Step6. Unload the delay-loaded DLL after the use.

	PCSTR pszDll = "CppDllExport.dll";
	__FUnloadDelayLoadedDLL2(pszDll);


/////////////////////////////////////////////////////////////////////////////
References:

Linker Support for Delay-Loaded DLLs
http://msdn.microsoft.com/en-us/library/151kt790.aspx

Delay Loading a DLL
http://www.codeproject.com/KB/DLL/Delay_Loading_Dll.aspx


/////////////////////////////////////////////////////////////////////////////
