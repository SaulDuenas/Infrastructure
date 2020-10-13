'****************************** Module Header ******************************'
' Module Name:	MainModule.vb
' Project:		VBAutomateOutlook
' Copyright (c) Microsoft Corporation.
' 
' The VBAutomateOutlook example demonstrates the use of Visual Basic.NET 
' codes to automate Microsoft Outlook to send a mail item, and enumerate the 
' contacts of the current user.
' 
' This source is subject to the Microsoft Public License.
' See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
' All other rights reserved.
' 
' History:
' * 4/19/2009 7:47 PM Jialiang Ge Created
'***************************************************************************'

#Region "Imports directives"

Imports System.Reflection
Imports System.IO

Imports Outlook = Microsoft.Office.Interop.Outlook
Imports System.Runtime.InteropServices

#End Region


Module MainModule

    <STAThread()> _
    Sub Main()

        Dim oOutlook As Outlook.Application
        Dim oNS As Outlook.NameSpace
        Dim oMail As Outlook.MailItem
        Dim oCtFolder As Outlook.MAPIFolder
        Dim oCts As Outlook.Items


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Start Microsoft Outlook and log on with your profile.
        ' 

        ' Create an Outlook application.
        oOutlook = New Outlook.Application()
        Console.WriteLine("Outlook.Application is started")

        Console.WriteLine("User logs on")
        ' Get the namespace and the logon.
        oNS = oOutlook.GetNamespace("MAPI")
        ' Replace the "YourValidProfile" and "YourPassword" with 
        ' Missing.Value if you want to log on with the default profile.
        oNS.Logon("YourValidProfile", "YourPassword", True, True)


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Create and send a new mail item.
        ' 

        Console.WriteLine("Create and send a new mail item")

        oMail = oOutlook.CreateItem(Outlook.OlItemType.olMailItem)

        ' Set the properties of the email.
        oMail.Subject = "Feedback of All-In-One Code Framework"
        oMail.To = "codefxf@microsoft.com"
        oMail.HTMLBody = "<b>Feedback:</b><br />"
        oMail.Importance = Outlook.OlImportance.olImportanceHigh

        ' Displays a new Inspector object for the item and allows users to 
        ' click on the Send button to send the mail manually.
        oMail.Display(True) ' Modal=true makes the Inspector window modal

        ' [-or-]

        ' Automatically send the mail without a new Inspector window.
        '((Outlook._MailItem)oMail).Send();


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Enumerate the contact items.
        ' 

        Console.WriteLine("Enumerate the contact items")

        oCtFolder = oOutlook.Session.GetDefaultFolder( _
        Outlook.OlDefaultFolders.olFolderContacts)
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


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' User logs off and quits Outlook.
        ' 

        oNS.Logoff()
        Console.WriteLine("Quit the Outlook application")
        oOutlook.Quit()


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Clean up the unmanaged COM resources.
        ' 

        ' Explicitly call Marshal.FinalReleaseComObject on all accessor 
        ' objects. See http://support.microsoft.com/kb/317109.
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

        ' [-and/or-]

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

    End Sub

End Module
