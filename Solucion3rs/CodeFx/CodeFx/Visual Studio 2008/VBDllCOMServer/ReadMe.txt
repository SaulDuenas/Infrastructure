========================================================================
    LIBRARY APPLICATION : VBDllCOMServer Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Summary:

This VB.NET sample focuses on exposing .NET Framework components to COM,  
which allows us to write a .NET type and consuming that type from unmanaged  
code with distinct activities for COM developers. The sample uses the 
Microsoft.VisualBasic.ComClassAttribute attribute to instruct the compiler to 
add metadata that allows a class to be exposed as a COM object. The attribute 
simplifies the process of exposing COM components from Visual Basic. Without 
ComClassAttribute, the developer needs to follow a number of steps to 
generate a COM object from Visual Basic. For classes marked with 
ComClassAttribute, the compiler performs many of these steps automatically. 

VBDllCOMServer exposes the following item:

1. The VBSimpleObject component

Program ID: VBDllCOMServer.VBSimpleObject
CLSID_VBSimpleObject: 805303FE-B5A6-308D-9E4F-BF500978AEEB
IID__VBSimpleObject: 90E0BCEA-7AFA-362A-A75E-6D07C1C6FC4B
DIID___VBSimpleObject: 72D3EFB2-0D88-4BA7-A26B-8FFDB92FEBED (EventID)
LIBID_VBDllCOMServer: A0CB2839-B70C-4035-9B11-2FF27E08B7DF

Properties:
' With both get and set accessor methods
FloatProperty As Single

Methods:
' HelloWorld returns a string "HelloWorld"
Function HelloWorld() As String
' GetProcessThreadID outputs the running process ID and thread ID
Sub GetProcessThreadID(ByRef processId As UInteger, ByRef threadId As UInteger)

Events:
' FloatPropertyChanging is fired before new value is set to the FloatProperty
' property. The Cancel parameter allows the client to cancel the change of
' FloatProperty.
Event FloatPropertyChanging(ByVal NewValue As Single, ByRef Cancel As Boolean)

Please note that COM components or ActiveX controls written in .NET languages
cannot be referenced by .NET applications in the form of interop assemblies. 
If you "add reference" to such a TLB, or drag & drop such an ActiveX control 
to your .NET application, you will get an error "The ActiveX type library 
'XXXXX.tlb' was exported from a .NET assembly and cannot be added as a 
reference.". The correct approach is to add a reference to the .NET assembly 
directly.


/////////////////////////////////////////////////////////////////////////////
Sample Relation:

VBDllCOMServer - CSDllCOMServer
These COM examples expose the same set of properties, methods, and events, 
but they are implemented in different .NET languages.


/////////////////////////////////////////////////////////////////////////////
Build:

To build VBDllCOMServer, please run Visual Studio as administrator because  
the component needs to be registered into HKCR.

Post-build command: regasm VBDllCOMServer.dll /tlb:VBDllCOMServer.tlb


/////////////////////////////////////////////////////////////////////////////
Deployment:

A. Setup

Regasm.exe VBDllCOMServer.dll
It registers the types that are COM-visible in VBDllCOMServer.dll.

B. Cleanup

Regasm.exe /u VBDllCOMServer.dll
It unregisters the types that are COM-visible in VBDllCOMServer.dll.


/////////////////////////////////////////////////////////////////////////////
Creation:

A. Creating the project

Step1. Create a Visual Basic / Class Library project named VBDllCOMServer in 
Visual Studio 2008. Delete the default Class1.vb file.

Step2. In order to make the .NET assembly COM-visible, first, open the 
property of the project. Click the Assembly Information button in the 
Application page, and select the "Make Assembly COM-Visible" box. This 
corresponds to the assembly attribute ComVisible in AssemblyInfo.vb:

	<Assembly: ComVisible(True)> 

The GUID value in the dialog is the libid of the component:

	<Assembly: Guid("A0CB2839-B70C-4035-9B11-2FF27E08B7DF")> 

Second, in the Compile page of the project's property, select the option 
"Register for COM interop". This option specifies whether your managed 
application will expose a COM object (a COM-callable wrapper) that allows a 
COM object to interact with your managed application.

B. Adding the component VBSimpleObject

Step1. Add a public class VBSimpleObject. 

Step2. Inside the VBSimpleObject class, define Class ID, Interface ID, and 
Event ID:

	ClassId As String = "805303FE-B5A6-308D-9E4F-BF500978AEEB"
    InterfaceId As String = "90E0BCEA-7AFA-362A-A75E-6D07C1C6FC4B"
    EventsId As String = "72D3EFB2-0D88-4ba7-A26B-8FFDB92FEBED"

Step3. Attach ComClassAttribute to the class VBSimpleObject, and specify its 
_ClassID, _InterfaceID, and _EventID to be the above const values:

    <ComClass(VBSimpleObject.ClassId, VBSimpleObject.InterfaceId, _
        VBSimpleObject.EventsId), ComVisible(True)> _
    Public Class VBSimpleObject

C. Adding Properties to the component

Step1. Inside the VBSimpleObject class, add a public property. All public 
properties are exposed from the component. For example, 

	Public Property FloatProperty() As Single
		Get
			Return Me.fField
		End Get
		Set(ByVal value As Single)
			Me.fField = value
		End Set
	End Property

D. Adding Methods to the component

Step1. Inside the VBSimpleObject class, add a public method. All public 
methods are exposed from the component. For example, 

	Public Function HelloWorld() As String
		Return "HelloWorld"
	End Function

E. Adding Events to the component

Step1. Inside the VBSimpleObject class, add a public event. For example, 

	Public Event FloatPropertyChanging(ByVal NewValue As Single, _
	                                   ByRef Cancel As Boolean)

Then raise the event in the proper places. For example, 

	Dim cancel As Boolean = False
	RaiseEvent FloatPropertyChanging(value, cancel)


/////////////////////////////////////////////////////////////////////////////
References:

Exposing .NET Framework Components to COM
http://msdn.microsoft.com/en-us/library/zsfww439.aspx

Building COM Servers in .NET 
http://www.codeproject.com/KB/COM/BuildCOMServersInDotNet.aspx

MSDN: ComClassAttribute Class
http://msdn.microsoft.com/en-us/library/microsoft.visualbasic.comclassattribute.aspx

CodeFx KB: How to develop an in-process COM component 
http://support.microsoft.com/kb/976026/en-us


/////////////////////////////////////////////////////////////////////////////