/****************************** Module Header ******************************\
* Module Name:	Program.cs
* Project:		CSAutomateOutlook
* Copyright (c) Microsoft Corporation.
* 
* The CSAutomateOutlook example demonstrates the use of Visual C# codes to  
* automate Microsoft Outlook to send a mail item, and enumerate the contacts 
* of the current user.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/19/2009 7:42 PM Jialiang Ge Created
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Text;

using Outlook = Microsoft.Office.Interop.Outlook;
using System.Runtime.InteropServices;
using System.Reflection;
#endregion


class Program
{
    [STAThread]
    static void Main(string[] args)
    {
        object missing = Type.Missing;

        Outlook.Application oOutlook = null;
        Outlook.NameSpace oNS = null;
        Outlook.MailItem oMail = null;
        Outlook.MAPIFolder oCtFolder = null;
        Outlook.Items oCts = null;


        /////////////////////////////////////////////////////////////////////
        // Start Microsoft Outlook and log on with your profile.
        // 

        // Create an Outlook application.
        oOutlook = new Outlook.Application();
        Console.WriteLine("Outlook.Application is started");

        Console.WriteLine("User logs on");
        // Get the namespace and the logon.
        oNS = oOutlook.GetNamespace("MAPI");
        // Replace the "YourValidProfile" and "YourPassword" with 
        // Missing.Value if you want to log on with the default profile.
        oNS.Logon("YourValidProfile", "YourPassword", true, true);
        

        /////////////////////////////////////////////////////////////////////
        // Create and send a new mail item.
        // 

        Console.WriteLine("Create and send a new mail item");

        oMail = (Outlook.MailItem)oOutlook.CreateItem(Outlook.OlItemType.olMailItem);

        // Set the properties of the email.
        oMail.Subject = "Feedback of All-In-One Code Framework";
        oMail.To = "codefxf@microsoft.com";
        oMail.HTMLBody = "<b>Feedback:</b><br />";
        oMail.Importance = Outlook.OlImportance.olImportanceHigh;

        // Displays a new Inspector object for the item and allows users to 
        // click on the Send button to send the mail manually.
        oMail.Display(true); // Modal=true makes the Inspector window modal

        // [-or-]

        // Automatically send the mail without a new Inspector window.
        //((Outlook._MailItem)oMail).Send();


        /////////////////////////////////////////////////////////////////////
        // Enumerate the contact items.
        // 

        Console.WriteLine("Enumerate the contact items");

        oCtFolder = (Outlook.MAPIFolder)oOutlook.Session.GetDefaultFolder(
            Outlook.OlDefaultFolders.olFolderContacts);
        oCts = oCtFolder.Items;

        // Enumerate the contact items.
        for (int i = 1; i <= oCts.Count; i++)
        {
            object oCt = oCts[i];
            if (oCt is Outlook.ContactItem)
            {
                Console.WriteLine(typeof(Outlook.ContactItem).InvokeMember(
                    "Email1Address", BindingFlags.GetProperty, null, oCt, null));
            }
            else if (oCt is Outlook.DistListItem)
            {
                Console.WriteLine(typeof(Outlook.DistListItem).InvokeMember(
                    "DLName", BindingFlags.GetProperty, null, oCt, null));
            }
            
            // Release the COM object of ContactItem.
            Marshal.FinalReleaseComObject(oCt);
            oCt = null;
        }


        /////////////////////////////////////////////////////////////////////
        // User logs off and quits Outlook.
        // 

        oNS.Logoff();
        Console.WriteLine("Quit the Outlook application");
        ((Outlook._Application)oOutlook).Quit();


        /////////////////////////////////////////////////////////////////////
        // Clean up the unmanaged COM resources.
        // 

        // Explicitly call Marshal.FinalReleaseComObject on all accessor 
        // objects. See http://support.microsoft.com/kb/317109.
        Marshal.FinalReleaseComObject(oCts);
        oCts = null;
        Marshal.FinalReleaseComObject(oCtFolder);
        oCtFolder = null;
        Marshal.FinalReleaseComObject(oMail);
        oMail = null;
        Marshal.FinalReleaseComObject(oNS);
        oNS = null;
        Marshal.FinalReleaseComObject(oOutlook);
        oOutlook = null;

        // [-and/or-]

        // Force a garbage collection as soon as the calling function is off 
        // the stack (at which point these objects are no longer rooted) and 
        // then call GC.WaitForPendingFinalizers.
        GC.Collect();
        GC.WaitForPendingFinalizers();
        // GC needs to be called twice in order to get the Finalizers called 
        // - the first time in, it simply makes a list of what is to be 
        // finalized, the second time in, it actually the finalizing. Only 
        // then will the object do its automatic ReleaseComObject.
        GC.Collect();
        GC.WaitForPendingFinalizers();
    }
}