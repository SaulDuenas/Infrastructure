/****************************** Module Header ******************************\
* Module Name:	Program.cs
* Project:		CSReflection
* Copyright (c) Microsoft Corporation.
* 
* Reflection provides objects (of type Type) that encapsulate assemblies, 
* modules and types. It allows us to
* 
* 1. Access attributes in your program's metadata.
* 2. Examine and instantiate types in an assembly.
* 3. Dynamically load and use types.
* 4. Emit new types at runtime.
* 
* This example demonstrates 2 and 3. CSEmitAssembly shows the use of 4.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 1/21/2009 11:04 PM Jialiang Ge Created
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Text;
#endregion


class Program
{
    static void Main(string[] args)
    {
        /////////////////////////////////////////////////////////////////////
        // Dynamically load the assembly.
        // 

        Assembly assembly = Assembly.LoadFrom("CSClassLibrary.dll");
        Debug.Assert(assembly != null);


        /////////////////////////////////////////////////////////////////////
        // Get a type and instantiate the type in the assembly.
        // 

        Type type = assembly.GetType("CSClassLibrary.CSSimpleClass");
        Object obj = Activator.CreateInstance(type, new object[] { 0.0F });


        /////////////////////////////////////////////////////////////////////
        // Examine the type.
        // 

        Console.WriteLine("Listing all the members of {0}", type);
        Console.WriteLine();

        BindingFlags staticAll = BindingFlags.Static | 
            BindingFlags.NonPublic | BindingFlags.Public;
        BindingFlags instanceAll = BindingFlags.Instance |
            BindingFlags.NonPublic | BindingFlags.Public;

        // Lists static fields first.
        FieldInfo[] fi = type.GetFields(staticAll);
        Console.WriteLine("// Static Fields");
        PrintMembers(fi);

        // Static properties.
        PropertyInfo[] pi = type.GetProperties(staticAll);
        Console.WriteLine("// Static Properties");
        PrintMembers(pi);

        // Static events.
        EventInfo[] ei = type.GetEvents(staticAll);
        Console.WriteLine("// Static Events");
        PrintMembers(ei);

        // Static methods.
        MethodInfo[] mi = type.GetMethods(staticAll);
        Console.WriteLine("// Static Methods");
        PrintMembers(mi);

        // Constructors.
        ConstructorInfo[] ci = type.GetConstructors(instanceAll);
        Console.WriteLine("// Constructors");
        PrintMembers(ci);

        // Instance fields.
        fi = type.GetFields(instanceAll);
        Console.WriteLine("// Instance Fields");
        PrintMembers(fi);

        // Instance properites.
        pi = type.GetProperties(instanceAll);
        Console.WriteLine("// Instance Properties");
        PrintMembers(pi);

        // Instance events.
        ei = type.GetEvents(instanceAll);
        Console.WriteLine("// Instance Events");
        PrintMembers(ei);

        // Instance methods.
        mi = type.GetMethods(instanceAll);
        Console.WriteLine("// Instance Methods");
        PrintMembers(mi);


        /////////////////////////////////////////////////////////////////////
        // Use the type (Late Binding).
        // 

        // Call a Public Function
        {
            Console.WriteLine("Call the public method, Increment");

            MethodInfo publicMethod = type.GetMethod("Increment");

            // Examine the method parameters
            ParameterInfo[] Params = publicMethod.GetParameters();
            foreach (ParameterInfo param in Params)
            {
                Console.WriteLine("Param={0}", param.Name);
                Console.WriteLine(" Type={0}", param.ParameterType);
                Console.WriteLine(" Position={0}", param.Position);
            }

            Object result = publicMethod.Invoke(obj, new object[] { 1.2F });
            Console.WriteLine("Result={0}\n", result);
        }

        // Call a Internal Function
        {
            Console.WriteLine("Call the internal method, InternalIncrement");

            Object result = type.InvokeMember("InternalIncrement",
                BindingFlags.InvokeMethod | 
                // These two flags are necessary for internal functions.
                BindingFlags.Instance | BindingFlags.NonPublic,
                null, obj, new object[] { 2.1F });
            Console.WriteLine("Result={0}\n", result);
        }

        // Call a Static Function
        {
            Console.WriteLine("Call the static method, StaticMethod");

            Object result = type.InvokeMember("StaticMethod",
                BindingFlags.InvokeMethod | 
                // These two flags are necessary for static functions.
                BindingFlags.Public | BindingFlags.Static,
                null, obj, new object[0]);
            Console.WriteLine("Result={0}\n", result);
        }


        /////////////////////////////////////////////////////////////////////
        // There is no API to unload an assembly.
        // http://blogs.msdn.com/suzcook/archive/2003/07/08/57211.aspx
        // http://blogs.msdn.com/jasonz/archive/2004/05/31/145105.aspx
        // 

    }

    /// <summary>
    /// Print each member info
    /// </summary>
    /// <param name="members"></param>
    static void PrintMembers(MemberInfo[] members)
    {
        foreach (MemberInfo memberInfo in members)
        {
            Console.WriteLine("{0}", memberInfo);
        }
        Console.WriteLine();
    }
}