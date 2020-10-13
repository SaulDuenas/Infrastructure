========================================================================
    CONSOLE APPLICATION : CSAutomateOutlook Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

The CSAutomateOutlook example demonstrates the use of Visual C# codes to  
automate Microsoft Outlook to send a mail item, and enumerate the contacts of 
the current user.


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CSAutomateOutlook - VBAutomateOutlook - CppAutomateOutlook

These examples automate Microsoft Outlook to do the same thing in different 
programming languages.


/////////////////////////////////////////////////////////////////////////////
Creation:

Step1. Create a Console application and reference the Outlook Primary Interop 
Assembly (PIA). To reference the Outlook PIA, right-click the project file
and click the "Add Reference..." button. In the Add Reference dialog, 
navigate to the .NET tab, find Microsoft.Office.Interop.Outlook 12.0.0.0 and 
click OK.

Step2. Import and rename the Outlook interop namepace:

	using Outlook = Microsoft.Office.Interop.Outlook;

Step3. Initialize the current thread as STA

	[STAThread]
	static void Main(string[] args)
	{
	}

Step4. Start up an Outlook application by creating an Outlook.Application 
object.

	oOutlook = new Outlook.Application();

In Vista with UAC enabled, if the automation client is run as administrator, 
the application may throw the error 0x80010001. Akash well explained the  
problem in the blog:
http://blogs.msdn.com/akashb/archive/2008/11/03/unable-to-instantiate-outlook-object-from-visual-studio-2008-on-vista-with-uac-on.aspx

Step5. Get the namespace and the logon.

	oNS = oOutlook.GetNamespace("MAPI");
	// Replace the "YourValidProfile" and "YourPassword" with 
	// Missing.Value if you want to log on with the default profile.
	//oNS.Logon("YourValidProfile", "YourPassword", true, true);
	oNS.Logon(missing, missing, true, true);

Step6. Create and send a new mail item. 
(Outlook._Application.CreateItem(Outlook.OlItemType.olMailItem))

Step7. Enumerate the contact items.

	// Retrieve the contacts folder of the current user.
	oCtFolder = (Outlook.MAPIFolder)oOutlook.Session.GetDefaultFolder(
		Outlook.OlDefaultFolders.olFolderContacts);
	// Get the contact items in the folder.
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

Be careful with foreach loops. See:
http://blogs.msdn.com/mstehle/archive/2007/12/07/oom-net-part-2-outlook-item-leaks.aspx

Step8. User logs off and quits Outlook.

Step9. Clean up the unmanaged COM resources. To get Outlook terminated 
rightly, we need to call Marshal.FinalReleaseComObject() on each COM object 
we used. We can either explicitly call Marshal.FinalReleaseComObject on all 
accessor objects:

	// See http://support.microsoft.com/kb/317109.
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

and/or force a garbage collection as soon as the calling function is off the 
stack (at which point these objects are no longer rooted) and then call 
GC.WaitForPendingFinalizers.

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

For more readings, please refer to this blog:

Outlook Item Leaks
http://blogs.msdn.com/mstehle/archive/2007/12/07/oom-net-part-2-outlook-item-leaks.aspx


/////////////////////////////////////////////////////////////////////////////
References:

MSDN: Outlook 2007 Developer Reference
http://msdn.microsoft.com/en-us/library/bb177050.aspx

How to automate Outlook and Word by using Visual C# .NET to create a 
pre-populated e-mail message that can be edited
http://support.microsoft.com/kb/819398

Writing .NET Code for Outlook
http://www.outlookcode.com/article.aspx?ID=43


/////////////////////////////////////////////////////////////////////////////