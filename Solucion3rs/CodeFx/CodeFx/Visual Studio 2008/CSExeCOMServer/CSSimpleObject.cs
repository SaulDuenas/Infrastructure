﻿/****************************** Module Header ******************************\
* Module Name:	CSSimpleObject.cs
* Project:		CSExeCOMServer
* Copyright (c) Microsoft Corporation.
* 
* The definition of the COM class, CSSimpleObject, and its ClassFactory, 
* CSSimpleObjectClassFactory.
* 
* Program ID: CSExeCOMServer.CSSimpleObject
* CLSID_CSSimpleObject: DB9935C1-19C5-4ed2-ADD2-9A57E19F53A3
* IID_ICSSimpleObject: 941D219B-7601-4375-B68A-61E23A4C8425
* DIID_ICSSimpleObjectEvents: 014C067E-660D-4d20-9952-CD973CE50436
* 
* Properties:
* // With both get and set accessor methods
* float FloatProperty
* 
* Methods:
* // HelloWorld returns a string "HelloWorld"
* string HelloWorld();
* // GetProcessThreadID outputs the running process ID and thread ID
* void GetProcessThreadID(out uint processId, out uint threadId);
* 
* Events:
* // FloatPropertyChanging is fired before new value is set to the 
* // FloatProperty property. The Cancel parameter allows the client to cancel 
* // the change of FloatProperty.
* void FloatPropertyChanging(float NewValue, ref bool Cancel);
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 3/25/2009 3:45 PM Jialiang Ge Created
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.ComponentModel;
#endregion


namespace CSExeCOMServer
{
    #region Interfaces

    [Guid(CSSimpleObject.InterfaceId), ComVisible(true)]
    public interface ICSSimpleObject
    {
        #region Properties

        float FloatProperty { get; set; }

        #endregion

        #region Methods

        string HelloWorld();

        void GetProcessThreadID(out uint processId, out uint threadId);

        #endregion
    }

    [Guid(CSSimpleObject.EventsId), ComVisible(true)]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface ICSSimpleObjectEvents
    {
        #region Events

        [DispId(1)]
        void FloatPropertyChanging(float NewValue, ref bool Cancel);

        #endregion
    }

    #endregion

    [ClassInterface(ClassInterfaceType.None)]           // No ClassInterface
    [ComSourceInterfaces(typeof(ICSSimpleObjectEvents))]
    [Guid(CSSimpleObject.ClassId), ComVisible(true)]
    public class CSSimpleObject : ReferenceCountedObject, ICSSimpleObject
    {
        #region COM Component Registration

        internal const string ClassId =
            "DB9935C1-19C5-4ed2-ADD2-9A57E19F53A3";
        internal const string InterfaceId =
            "941D219B-7601-4375-B68A-61E23A4C8425";
        internal const string EventsId =
            "014C067E-660D-4d20-9952-CD973CE50436";
        
        // These routines perform the additional COM registration needed by 
        // the service.

        [EditorBrowsable(EditorBrowsableState.Never)]
        [ComRegisterFunction()]
        public static void Register(Type t)
        {
            try
            {
                COMHelper.RegasmRegisterLocalServer(t);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message); // Log the error
                throw ex; // Re-throw the exception
            }
        }

        [EditorBrowsable(EditorBrowsableState.Never)]
        [ComUnregisterFunction()]
        public static void Unregister(Type t)
        {
            try
            {
                COMHelper.RegasmUnregisterLocalServer(t);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message); // Log the error
                throw ex; // Re-throw the exception
            }
        }

        #endregion

        #region Properties

        private float fField = 0;

        public float FloatProperty
        {
            get { return this.fField; }
            set
            {
                bool cancel = false;
                // Raise the event FloatPropertyChanging
                if (null != FloatPropertyChanging)
                    FloatPropertyChanging(value, ref cancel);
                if (!cancel)
                    this.fField = value;
            }
        }

        #endregion

        #region Methods

        public string HelloWorld()
        {
            return "HelloWorld";
        }

        public void GetProcessThreadID(out uint processId, out uint threadId)
        {
            processId = NativeMethod.GetCurrentProcessId();
            threadId = NativeMethod.GetCurrentThreadId();
        }

        #endregion

        #region Events

        [ComVisible(false)]
        public delegate void FloatPropertyChangingEventHandler(float NewValue, ref bool Cancel);
        public event FloatPropertyChangingEventHandler FloatPropertyChanging;

        #endregion
    }

    /// <summary>
    /// Class factory for the class CSSimpleObject.
    /// </summary>
    internal class CSSimpleObjectClassFactory : IClassFactory
    {
        public int CreateInstance(
            IntPtr pUnkOuter, ref Guid riid, out IntPtr ppvObject)
        {
            ppvObject = IntPtr.Zero;

            if (pUnkOuter != IntPtr.Zero)
            {
                // The pUnkOuter parameter was non-NULL and the object does 
                // not support aggregation.
                Marshal.ThrowExceptionForHR(COMNative.CLASS_E_NOAGGREGATION);
            }

            if (riid == new Guid(CSSimpleObject.ClassId) ||
                riid == new Guid(COMNative.GuidIUnknown))
            {
                // Create the instance of the .NET object
                ppvObject = Marshal.GetComInterfaceForObject(
                    new CSSimpleObject(), typeof(ICSSimpleObject));
            }
            else
            {
                // The object that ppvObject points to does not support the 
                // interface identified by riid.
                Marshal.ThrowExceptionForHR(COMNative.E_NOINTERFACE);
            }

            return 0;   // S_OK
        }

        public int LockServer(bool fLock)
        {
            return 0;   // S_OK
        }
    }

    /// <summary>
    /// Reference counted object base.
    /// </summary>
    [ComVisible(false)]
    public class ReferenceCountedObject
    {
        public ReferenceCountedObject()
        {
            // Increment the lock count of objects in the COM server.
            ExeCOMServer.Instance.Lock();
        }

        ~ReferenceCountedObject()
        {
            // Decrement the lock count of objects in the COM server.
            ExeCOMServer.Instance.Unlock();
        }
    }
}
