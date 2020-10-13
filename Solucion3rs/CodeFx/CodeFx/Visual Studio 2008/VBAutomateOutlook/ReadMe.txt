========================================================================
    CONSOLE APPLICATION : VBAutomateOutlook Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

The VBAutomateOutlook example demonstrates the use of Visual Basic.NET codes  
to automate Microsoft Outlook to send a mail item, and enumerate the contacts 
of the current user.


/////////////////////////////////////////////////////////////////////////////
Creation:

VBAutomateOutlook - CSAutomateOutlook - CppAutomateOutlook

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

	Imports Outlook = Microsoft.Office.Interop.Outlook

Step3. Initialize the current thread as STA

	<STAThread()> _
	Sub Main()

	End Sub

Step4. Start up an Outlook application by creating an Outlook.Application 
object.

	oOutlook = New Outlook.Application()

In Vista with UAC enabled, if the automation client is run as administrator, 
the application may throw the error 0x80010001. Akash well explained the  
problem in the blog:
http://blogs.msdn.com/akashb/archive/2008/11/03/unable-to-instantiate-outlook-object-from-visual-studio-2008-on-vista-with-uac-on.aspx

Step5. Get the namespace and the logon.

	' Get the namespace and the logon.
	oNS = oOutlook.GetNamespace("MAPI")
	' Replace the "YourValidProfile" and "YourPassword" with 
	' Missing.Value if you want to log on with the default profile.
	oNS.Logon("YourValidProfile", "YourPassword", True, True)

Step6. Create and send a new mail item. 
(Outlook._Application.CreateItem(Outlook.OlItemType.olMailItem))

Step7. Enumerate the contact items.

	' Retrieve the contacts folder of the current user.
	oCtFolder = oOutlook.Session.GetDefaultFolder( _
	Outlook.OlDefaultFolders.olFolderContacts)
	' Get the contact items in the folder.
	oCts = oCtFolder.Items

	' Enumerate the contact items. Be careful with foreach loops. See: 
	' http://blogs.msdn.com/mstehle/archive/2007/12/07/oom-net-part-2-outlook-item-leaks.aspx
	For i As Integer = 1 To oCts.Count

		Dim oCt As Object = oCts(i)
		If (TypeOf oCt Is Outlook.ContactItem) Then
			Console.WriteLine(oCt.Email1Address)
		ElseIf (TypeOf oCt Is Outlook.DistListItem) Then
			Console.WriteLine(oCt.DLName)
		End If

		' Release the COM object of ContactItem.
		Marshal.FinalReleaseComObject(oCt)
		oCt = Nothing
	Next

Be careful with foreach loops. See:
http://blogs.msdn.com/mstehle/archive/2007/12/07/oom-net-part-2-outlook-item-leaks.aspx

Step8. User logs off and quits Outlook.

Step9. Clean up the unmanaged COM resources. To get Outlook terminated 
rightly, we need to call Marshal.FinalReleaseComObject() on each COM object 
we used. We can either explicitly call Marshal.FinalReleaseComObject on all 
accessor objects:

	' See http://support.microsoft.com/kb/317109.
	Marshal.FinalReleaseComObject(oCts)
	oCts = Nothing
	Marshal.FinalReleaseComObject(oCtFolder)
	oCtFolder = Nothing
	Marshal.FinalReleaseComObject(oMail)
	oMail = Nothing
	Marshal.FinalReleaseComObject(oNS)
	oNS = Nothing
	Marshal.FinalReleaseComObject(oOutlook)
	oOutlook = Nothing

and/or force a garbage collection as soon as the calling function is off the 
stack (at which point these objects are no longer rooted) and then call 
GC.WaitForPendingFinalizers.

	' Force a garbage collection as soon as the calling function is off 
	' the stack (at which point these objects are no longer rooted) and 
	' then call GC.WaitForPendingFinalizers.
	GC.Collect()
	GC.WaitForPendingFinalizers()
	' GC needs to be called twice in order to get the Finalizers called 
	' - the first time in, it simply makes a list of what is to be 
	' finalized, the second time in, it actually the finalizing. Only 
	' then will the object do its automatic ReleaseComObject.
	GC.Collect()
	GC.WaitForPendingFinalizers()

For more readings, please refer to this blog:

Outlook Item Leaks
http://blogs.msdn.com/mstehle/archive/2007/12/07/oom-net-part-2-outlook-item-leaks.aspx


/////////////////////////////////////////////////////////////////////////////
References:

MSDN: Outlook 2007 Developer Reference
http://msdn.microsoft.com/en-us/library/bb177050.aspx

How to use the Microsoft Outlook Object Library to create an Outlook contact 
in Visual Basic .NET
http://support.microsoft.com/kb/313787

How to use the Microsoft Outlook Object Library to force a Send/Receive 
action by using Visual Basic .NET
http://support.microsoft.com/kb/313793

Programming samples that can reference items and folders in Outlook by using 
Visual Basic .NET
http://support.microsoft.com/kb/313800

Writing .NET Code for Outlook
http://www.outlookcode.com/article.aspx?ID=43


/////////////////////////////////////////////////////////////////////////////