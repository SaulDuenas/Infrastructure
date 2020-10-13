/****************************** Module Header ******************************\
* Module Name:	Program.cs
* Project:		CSCheckOSVersion
* Copyright (c) Microsoft Corporation.
* 
* The CSCheckOSVersion demonstrates how to detect the current OS version, and 
* how to make application that checks for the minimum operating system 
* version work with later operating system versions.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 8/12/2009 9:04 PM Jialiang Ge Created
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
#endregion


class Program
{
    static void Main(string[] args)
    {
        /////////////////////////////////////////////////////////////////////
        // Detect the current OS version.
        // 

        Console.WriteLine("Current OS: {0}", 
            Environment.OSVersion.VersionString);


        /////////////////////////////////////////////////////////////////////
        // Make application that checks for the minimum operating system 
        // version work with later operating system versions.
        // 

        // Check if the current OS is at least Windows XP
        if (Environment.OSVersion.Version < new Version(5, 1))
        {
            Console.WriteLine("Windows XP or later required.");
            // Quit the application due to incompatible OS
            return;
        }

        Console.WriteLine("Application Running...");
        Console.Read();
    }
}