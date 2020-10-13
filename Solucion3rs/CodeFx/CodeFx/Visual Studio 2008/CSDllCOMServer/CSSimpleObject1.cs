/****************************** Module Header ******************************\
* Module Name:	CSSimpleObject.cs
* Project:		CSDllCOMServer
* Copyright (c) Microsoft Corporation.
* 
* This sample focuses on exposing .NET Framework components to COM, which 
* allows us to write a .NET type and consuming that type from unmanaged code 
* with distinct activities for COM developers.
* 
* CSSimpleObject1 - [Implicitly Define a Class Interface]
* 
* Program ID: CSDllCOMServer.CSSimpleObject1
* CLSID_CSSimpleObject1: B9A5C362-1ED4-39C6-9571-AD789E7C737C
* IID__CSSimpleObject1: <The GUID is generated in compile time>
* LIBID_CSDllCOMServer: F0998D9A-0E79-4F67-B944-9E837F479587
* 
* Properties:
* // With both get and set accessor methods.
* public float FloatProperty
* 
* Methods:
* // HelloWorld returns a string "HelloWorld"
* public string HelloWorld();
* // GetProcessThreadID outputs the running process ID and thread ID
* public void GetProcessThreadID(out uint processId, out uint threadId);
* 
* -------
* The attribute ClassInterface(ClassInterfaceType.AutoDual/AutoDispatch) can 
* be used to export the public members of the .NET component's class into a
* default (implicit) Class Interface in the generated type library.
* 
* Using a Class Interface to expose the public methods of a .NET class is NOT 
* generally recommended because it's creedless to COM versioning. Defining an 
* interface explicitly, deriving your .NET Component class from the interface
* and then implementing the interface's methods in your .NET Component is the 
* recommended way of doing things if you are going to expose your .NET class 
* to COM aware clients. CSSimpleObject2 demonstrates such a component.
* 
* The differences between 
* [ClassInterface(ClassInterfaceType.AutoDual)] and
* [ClassInterface(ClassInterfaceType.AutoDispatch)]:
* 
* ClassInterfaceType.AutoDispatch makes the default interface be an IDispatch
* interface. Neither the DISPIDs nor the method type information is present 
* in the type library. This leaves the COM aware client to consume .NET 
* components using only late-binding. The clients obtain these DISPIDs on 
* demand using IDispatch::GetIDsOfNames. It allows clients to use the newer 
* versions of the components without breaking existing code. In contrast, 
* ClassInterfaceType.AutoDual allows both IDispatch (late binding) and vtable
* binding (early binding). 
* 
* Using ClassInterfaceType.AutoDispatch is much safer than using 
* ClassInterfaceType.AutoDual because it does not break existing client code 
* when newer versions of the component are released, albeit the former allows
* only late binding.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/11/2009 9:20 PM Jialiang Ge Created
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;
#endregion


namespace CSDllCOMServer
{
    [ComVisible(true)]
    [ClassInterface(ClassInterfaceType.AutoDual)]           // Option 1
    //[ClassInterface(ClassInterfaceType.AutoDispatch)]     // Option 2
    [Guid("B9A5C362-1ED4-39C6-9571-AD789E7C737C")]          // CLSID
    //[ProgId("CSCOMServerDll.CustomCSSimpleObject1")]      // ProgID
    public class CSSimpleObject1
    {
        /// <summary>
        /// The private members don't make it into the type-library and are 
        /// hidden from the COM clients.
        /// </summary>
        private float fField = 0;

        /// <summary>
        /// A public property with both get and set accessor methods.
        /// </summary>
        public float FloatProperty
        {
            get { return this.fField; }
            set { this.fField = value; }
        }

        /// <summary>
        /// A public method that returns a string "HelloWorld".
        /// </summary>
        public string HelloWorld()
        {
            return "HelloWorld";
        }

        /// <summary>
        /// A public method with two outputs: the current process Id and the
        /// current thread Id.
        /// </summary>
        /// <param name="processId">[out] The current process Id</param>
        /// <param name="threadId">[out] The current thread Id</param>
        public void GetProcessThreadID(out uint processId, out uint threadId)
        {
            processId = NativeMethod.GetCurrentProcessId();
            threadId = NativeMethod.GetCurrentThreadId();
        }

    }

} // namespace CSDllCOMServer
