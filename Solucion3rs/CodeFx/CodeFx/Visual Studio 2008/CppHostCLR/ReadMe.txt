========================================================================
    CONSOLE APPLICATION : CppHostCLR Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

The Common Language Runtime (CLR) allows a level of integration between 
itself and a host. This sample native console application uses the API
CorBindToRuntimeEx to load a specific version of the CLR. Then, it uses the
ICorRuntimeHost interface and methods exposed in mscorlib.tlb to load some 
.NET assemblies and types and execute their methods. In the .NET Framework
version 2.0, the interface ICorRuntimeHost is superceded by ICLRRuntimeHost.
The CLR allows for a deeper integration in the new hosting APIs. For example,
the set of CLR functionality that is configurable by the host is extended. 
However, this sample still demonstrates ICorRuntimeHost considering that 
ICorRuntimeHost provides a better backwards compatibility if the host wants 
to support .NET Framework versions 1.0, 1.1 apart from 2.0, 3.0 and 3.5.


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CppHostCLR -> CSConsole
CppHostCLR hosts CLR and execute the CSConsole.exe assembly in its default 
AppDomain.

CppHostCLR -> CSClassLibrary
CppHostCLR hosts CLR, instantiates a type exposed in CSClassLibrary.dll and 
calls its methods.


/////////////////////////////////////////////////////////////////////////////
Code Logic:

1. Load and start the .NET runtime. (CorBindToRuntimeEx)

2. Get a pointer to the default AppDomain in the CLR.
(ICorRuntimeHost::GetDefaultDomain)

3. Load an EXE assembly and call its entry function. 
(_AppDomain::ExecuteAssembly_2)

4. Load a type from a DLL Assembly and call it.
(_AppDomain::CreateInstanceFrom, _Type::InvokeMember_3)

5. Stop the .NET runtime. (ICorRuntimeHost::Stop)


/////////////////////////////////////////////////////////////////////////////
References:

Hosting the Common Language Runtime
http://msdn.microsoft.com/en-us/library/9x0wh2z3.aspx

Calling A .NET Managed Method from Native Code
http://support.microsoft.com/kb/953836

Creating a Host to the .NET Common Language Runtime By Ranjeet Chakraborty
http://www.codeproject.com/KB/COM/simpleclrhost.aspx

CLR Hosting APIs
http://msdn.microsoft.com/en-us/magazine/cc163567.aspx


/////////////////////////////////////////////////////////////////////////////
