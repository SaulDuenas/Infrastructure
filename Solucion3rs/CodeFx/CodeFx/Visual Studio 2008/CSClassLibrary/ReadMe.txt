========================================================================
    LIBRARY APPLICATION : CSClassLibrary Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

The example creates a class library of C# code and builds it as a .NET DLL 
assembly that we can reuse in other projects. The process is straight-forward.

CSClassLibrary exposes these items:

1. A class named CSSimpleClass

Constructors:
public CSSimpleClass();
public CSSimpleClass(float fVal);

Static fields and properties:
private static bool sbField;
public static bool StaticBoolProperty

Static methods:
public static string StaticMethod();

Instance fields and properties:
private float fField;
public float FloatProperty

Instance methods:
public float Increment(float fVal);
internal float InternalIncrement(float fVal);

Instance events:
// The event is fired in the set accessor of FloatProperty
public event PropertyChangingEventHandler FloatPropertyChanging; 


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CSReflection -> CSClassLibrary
CSReflection dynamically loads the assembly, CSClassLibrary.dll, and 
instantiate, examine and use its types.

CppHostCLR -> CSClassLibrary
CppHostCLR hosts CLR, instantiates a type exposed in CSClassLibrary.dll and 
calls its methods.

CSClassLibrary - VBClassLibrary
They are the same class library implemented in different languages.


/////////////////////////////////////////////////////////////////////////////
Creation:

A. Creating the project

Step1. Create a Visual C# / Class Library project named CSClassLibrary in 
Visual Studio 2008.

B. Adding a class CSSimpleClass to the project and define its fields, 
properties, methods, and events.

Step1. In Solution Explorer, add a new Class item to the project and name it
as CSSimpleClass.

Step2. Edit the file CSSimpleClass.cs to add the fields, properties, methods,
and events.

C. Signing the assembly with a strong name (Optional)

Strong names are required to store shared assemblies in Global Assembly Cache
(GAC). This helps avoid DLL Hell. Strong names also protects the assembly 
from being hacked (replaced or injected). A strong name consists of the 
assembly's identity—its simple text name, version number, and culture info
(if provided)—plus a public key and a digital signature. It is generated 
from an assembly file using the corresponding private key. 

Step1. Right-click the project and open its Properties page.

Step2. Turn to the Signing tab, and check the Sign the assembly checkbox. 

Step3. In the Choose a strong name key file drop-down, select New. The 
"Create Strong Name Key" dialog appears. In the Key file name text box, type
the desired key name. If necessary, we can protect the strong name key file 
with a password. Click the OK button.


/////////////////////////////////////////////////////////////////////////////
References:

Creating Assemblies
http://msdn.microsoft.com/en-us/library/b0b8dk77.aspx

How to: Sign an Assembly with a Strong Name
http://msdn.microsoft.com/en-us/library/xc31ft41.aspx

How to: Create and Use C# DLLs (C# Programming Guide)
http://msdn.microsoft.com/en-us/library/3707x96z.aspx


/////////////////////////////////////////////////////////////////////////////
