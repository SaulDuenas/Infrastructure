/****************************** Module Header ******************************\
 * Module Name:  BinaryContentResult.cs
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

namespace CSASPNETMVCFileDownload
{
   
   

    public class BinaryContentResult : ActionResult
    {
        // Default constructor
        public BinaryContentResult()
        {
        }

        // Properties for encapsulating http headers
        public string ContentType { get; set; }
        public string FileName { get; set; }
        public byte[] Content { get; set; }

        // Underlying code which set the httpheaders and output file content
        public override void ExecuteResult(ControllerContext context)
        {

            context.HttpContext.Response.ClearContent();
            context.HttpContext.Response.ContentType = ContentType;

            context.HttpContext.Response.AddHeader("content-disposition",

            "attachment; filename=" + FileName);

            context.HttpContext.Response.BinaryWrite(Content);
            context.HttpContext.Response.End();
        }
    }

}
