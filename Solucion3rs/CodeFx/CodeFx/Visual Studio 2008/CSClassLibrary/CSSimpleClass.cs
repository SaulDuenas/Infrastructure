/****************************** Module Header ******************************\
* Module Name:	CSSimpleClass.cs
* Project:		CSClassLibrary
* Copyright (c) Microsoft Corporation.
* 
* The example creates a class library of C# code and builds it as a .NET DLL 
* assembly that we can re-use in other projects. The process is very 
* straight-forward.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/10/2009 10:33 PM Jialiang Ge Created
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
#endregion


namespace CSClassLibrary
{
    public delegate 
    void PropertyChangingEventHandler(object NewValue, out bool Cancel);

    /// <summary>
    /// CSSimpleClass
    /// </summary>
    public class CSSimpleClass
    {
        /// <summary>
        /// Constructor
        /// </summary>
        public CSSimpleClass()
        {
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public CSSimpleClass(float fVal)
        {
            this.fField = fVal;
        }

        /// <summary>
        /// Private Static Field
        /// </summary>
        private static bool sbField;

        /// <summary>
        /// Static Property
        /// </summary>
        public static bool StaticBoolProperty
        {
            get { return sbField; }
            set { sbField = value; }
        }

        /// <summary>
        /// Static Method
        /// </summary>
        /// <returns></returns>
        public static string StaticMethod()
        {
            return "HelloWorld";
        }

        /// <summary>
        /// Private Instance Field
        /// </summary>
        private float fField = 0F;

        /// <summary>
        /// Instance Property
        /// </summary>
        public float FloatProperty
        {
            get { return fField; }
            set
            {
                // Fire the event FloatPropertyChanging
                bool cancel = false;
                if (FloatPropertyChanging != null)
                    FloatPropertyChanging(value, out cancel);

                if (!cancel) // If the change is not canceled
                    fField = value;
            }
        }

        /// <summary>
        /// Public Instance Method
        /// </summary>
        /// <param name="fVal"></param>
        /// <returns></returns>
        public float Increment(float fVal)
        {
            return this.fField += fVal;
        }

        /// <summary>
        /// Internal Instance Method
        /// </summary>
        /// <param name="fVal"></param>
        /// <returns></returns>
        internal float InternalIncrement(float fVal)
        {
            return this.fField += fVal;
        }

        /// <summary>
        /// Instance Event
        /// </summary>
        public event PropertyChangingEventHandler FloatPropertyChanging; 

    }
}
