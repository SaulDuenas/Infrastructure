/****************************** Module Header ******************************\
 * Module Name:  HomeController.cs
 * Project:              CSASPNETMVCFileDownload
 * Copyright (c) Microsoft Corporation.
 * 
 * The CSASPNETMVCFileDownload example demonstrates how to use C# codes to 
 * create an ASP.NET MVC FileDownload application. The applicatino supports
 * basic site navigation, explore files in a certain fileshare and allow 
 * client user to download a selected file among the file list.
 * 
 * 
 * This source is subject to the Microsoft Public License.
 * See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
 * All other rights reserved.
 * 
 * History:
 * * 8/27/2009 1:35 PM Steven Cheng Created
 ***************************************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CSASPNETMVCFileDownload.Controllers
{
    [HandleError]
    public class HomeController : Controller
    {
        // Action for Index request
        public ActionResult Index()
        {
            ViewData["Message"] = "Welcome to ASP.NET MVC File Download Sample!";

            return View();
        }

        // Action for About request
        public ActionResult About()
        {
            return View();
        }
    }
}
