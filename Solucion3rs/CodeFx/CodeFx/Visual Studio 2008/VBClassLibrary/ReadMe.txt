========================================================================
    LIBRARY APPLICATION : CSClassLibrary Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

The example creates a class library of VB.NET code and builds it as a .NET  
DLL assembly that we can reuse in other projects. The process is 
straight-forward.

VBClassLibrary exposes these items:

1. A class named VBSimpleClass

Constructors:
VBSimpleClass()
VBSimpleClass(ByVal fVal As Single)

Shared (static) fields and properties:
Private Shared sbField As Boolean
Public Shared Property StaticBoolProperty() As Boolean

Static methods:
Public Shared Function StaticMethod() As String

Instance fields and properties:
Private fField As Single
Public Property FloatProperty() As Single

Instance methods:
Public Function Increment(ByVal fVal As Single) As Single
Friend Function InternalIncrement(ByVal fVal As Single) As Single

Instance events:
// The event is fired in the set accessor of FloatProperty
Public Event FloatPropertyChanging(ByVal NewValue As Single, _
                                       ByRef Cancel As Boolean)


/////////////////////////////////////////////////////////////////////////////
Project Relation:

VBReflection -> VBClassLibrary
VBReflection dynamically loads the assembly, VBClassLibrary.dll, and 
instantiate, examine and use its types.

VBClassLibrary - CSClassLibrary
They are the same class library implemented in different languages.


/////////////////////////////////////////////////////////////////////////////
Creation:

A. Creating the project

Step1. Create a Visual Basic / Class Library project named VBClassLibrary in 
Visual Studio 2008.

B. Adding a class VBSimpleClass to the project and define its fields, 
properties, methods, and events.

Step1. In Solution Explorer, add a new Class item to the project and name it
as VBSimpleClass.

Step2. Edit the file VBSimpleClass.cs to add the fields, properties, methods,
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


/////////////////////////////////////////////////////////////////////////////