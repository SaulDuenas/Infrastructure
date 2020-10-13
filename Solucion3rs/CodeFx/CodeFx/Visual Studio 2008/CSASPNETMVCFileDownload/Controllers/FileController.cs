/*****************Module header************************
 *  Module Name: FileController.cs
 * 
 * This module contains the FileController class. 
 * FileController is the controller dedicated for file downloading functionality.
 * For request to list file, FileController will call List Action to return the file list and display it via File/List view
 * 
 * File request to download a certain file, FileController will call Download action to return the stream of the requesting file
 * 
 *******************************************************/

using System;
/****************************** Module Header ******************************\
 * Module Name:  FileController.cs
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

using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using System.IO;

namespace CSASPNETMVCFileDownload.Controllers
{
    public class FileController : Controller
    {
        // Action for list all the files in "~/App_Data/download" directory
        public ActionResult List()
        {

            // Retrive file list
            DirectoryInfo dir = new DirectoryInfo(Server.MapPath("~/App_Data/download/"));

            // Filter it via LINQ to Object
            var files = from f in dir.GetFiles("*.*", SearchOption.TopDirectoryOnly)
                        where f.Extension != "exe"
                        select f;
            
            // Call the corresponding View
            return View(files.ToList());
        }

        // Action for return the binary stream of a specified file
        public ActionResult Download(string fn)
        {
            // Check whether requested file is valid
            string pfn = Server.MapPath("~/App_Data/download/" + fn);
            if (!System.IO.File.Exists(pfn))
            {
                throw new ArgumentException("Invalid file name or file not exists!");
            }

            // Use BinaryContentResult to encapsulate the filecontent and return it
            return new BinaryContentResult()
            {
                FileName = fn,
                ContentType = "application/octet-stream",
                Content = System.IO.File.ReadAllBytes(pfn)
            };

        }
    }
}
