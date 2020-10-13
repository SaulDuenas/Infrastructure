'****************************** Module Header ******************************'
' Module Name:	MainModule.vb
' Project:		VBAutomateExcel
' Copyright (c) Microsoft Corporation.
' 
' The VBAutomateExcel example demonstrates how to use VB.NET codes to create  
' an Excel instance, create a workbook, and fill data into the specified 
' range, as well as how to clean up unmanaged COM resources and quit the 
' Excel application properly.
' 
' This source is subject to the Microsoft Public License.
' See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
' All other rights reserved.
' 
' History:
' * 4/17/2009 1:25 AM Jialiang Ge Created
'***************************************************************************'

#Region "Imports directives"

Imports System.Reflection
Imports System.IO

Imports Excel = Microsoft.Office.Interop.Excel
Imports System.Runtime.InteropServices

#End Region


Module MainModule

    Sub Main()

        Dim oXL As Excel.Application
        Dim oWBs As Excel.Workbooks
        Dim oWB As Excel.Workbook
        Dim oSheet As Excel.Worksheet
        Dim oCells As Excel.Range
        Dim oRng1 As Excel.Range
        Dim oRng2 As Excel.Range


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Create an instance of Microsoft Excel and make it invisible.
        ' 

        oXL = New Excel.Application
        oXL.Visible = False
        Console.WriteLine("Excel.Application is started")


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Create a new workbook.
        ' 

        oWBs = oXL.Workbooks
        oWB = oWBs.Add()
        Console.WriteLine("A new workbook is created")


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Get the active Worksheet and set its name.
        ' 

        oSheet = oWB.ActiveSheet
        oSheet.Name = "Report"
        Console.WriteLine("The active worksheet is renamed as Report")


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Fill data into the worksheet's cells.
        ' 

        Console.WriteLine("Filling data into the worksheet ...")

        ' Set the column header
        oCells = oSheet.Cells
        oCells(1, 1) = "First Name"
        oCells(1, 2) = "Last Name"
        oCells(1, 3) = "Full Name"

        ' Construct an array of user names
        Dim saNames(,) As String = {{"John", "Smith"}, _
                                    {"Tom", "Brown"}, _
                                    {"Sue", "Thomas"}, _
                                    {"Jane", "Jones"}, _
                                    {"Adam", "Johnson"}}


        ' Fill A2:B6 with an array of values (First and Last Names).
        oRng1 = oSheet.Range("A2", "B6")
        oRng1.Value2 = saNames

        ' Fill C2:C6 with a relative formula (=A2 & " " & B2).
        oRng2 = oSheet.Range("C2", "C6")
        oRng2.Formula = "=A2 & "" "" & B2"


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Save the workbook as a xlsx file and close it.
        ' 

        Console.WriteLine("Save and close the workbook")

        Dim fileName As String = Path.GetDirectoryName( _
        Assembly.GetExecutingAssembly().Location) & "\MSDN.xlsx"
        oWB.SaveAs(fileName, Excel.XlFileFormat.xlOpenXMLWorkbook)
        oWB.Close()


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Close the Excel application.
        ' 

        Console.WriteLine("Quit the Excel application")

        ' Excel will stick around after Quit if it is not under user control 
        ' and there are outstanding references. When Excel is started or 
        ' attached programmatically and Excel.Application.Visible = false, 
        ' Excel.Application.UserControl is false. The UserControl property 
        ' can be explicitly set to True which should force the application 
        ' to terminate when Quit is called, regardless of outstanding 
        ' references.
        oXL.UserControl = True

        oXL.Quit()


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Clean up the unmanaged COM resources.
        ' 

        ' Explicitly call Marshal.FinalReleaseComObject on all accessor 
        ' objects. See http://support.microsoft.com/kb/317109.
        Marshal.FinalReleaseComObject(oRng2)
        oRng2 = Nothing
        Marshal.FinalReleaseComObject(oRng1)
        oRng1 = Nothing
        Marshal.FinalReleaseComObject(oCells)
        oCells = Nothing
        Marshal.FinalReleaseComObject(oSheet)
        oSheet = Nothing
        Marshal.FinalReleaseComObject(oWB)
        oWB = Nothing
        Marshal.FinalReleaseComObject(oWBs)
        oWBs = Nothing
        Marshal.FinalReleaseComObject(oXL)
        oXL = Nothing

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
