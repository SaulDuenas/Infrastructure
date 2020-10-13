﻿/****************************** Module Header ******************************\
* Module Name:	Program.cs
* Project:		CSCOMService
* Copyright (c) Microsoft Corporation.
* 
* The main entry point for the application. It is responsible for starting  
* the Windows Services registered in the exectuable.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 3/14/2009 10:57 AM Jialiang Ge Created
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.ServiceProcess;
using System.Text;
#endregion


namespace CSCOMService
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main()
        {
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[] 
			{ 
				new COMService() 
			};
            ServiceBase.Run(ServicesToRun);
        }
    }
}