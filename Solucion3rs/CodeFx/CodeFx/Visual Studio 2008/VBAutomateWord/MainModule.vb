'****************************** Module Header ******************************'
' Module Name:	MainModule.vb
' Project:		VBAutomateWord
' Copyright (c) Microsoft Corporation.
' 
' The VBAutomateWord example demonstrates the use of Visual Basic.NET codes 
' to create a Microsoft Word instance, create a new document, insert a 
' paragraph and a table, as well as how to clean up unmanaged COM resources 
' and quit the Word application properly.
' 
' This source is subject to the Microsoft Public License.
' See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
' All other rights reserved.
' 
' History:
' * 4/18/2009 11:58 PM Jialiang Ge Created
'***************************************************************************'

#Region "Imports directives"

Imports System.Reflection
Imports System.IO

Imports Word = Microsoft.Office.Interop.Word
Imports System.Runtime.InteropServices

#End Region


Module MainModule

    Sub Main()

        Dim oWord As Word.Application
        Dim oDocs As Word.Documents
        Dim oDoc As Word.Document
        Dim oParas As Word.Paragraphs
        Dim oPara As Word.Paragraph
        Dim oParaRng As Word.Range
        Dim oBookmarkRng As Word.Range
        Dim oTable As Word.Table


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Create an instance of Microsoft Word and make it invisible.
        ' 

        oWord = New Word.Application()
        oWord.Visible = False
        Console.WriteLine("Word.Application is started")


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Create a new Document.
        ' 

        oDocs = oWord.Documents
        oDoc = oDocs.Add()
        Console.WriteLine("A new document is created")


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Insert a paragraph.
        ' 

        Console.WriteLine("Insert a paragraph")

        oParas = oDoc.Paragraphs
        oPara = oParas.Add()
        oParaRng = oPara.Range
        oParaRng.Text = "Heading 1"
        oParaRng.Font.Bold = 1
        oParaRng.InsertParagraphAfter()


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Insert a table.
        ' 

        Console.WriteLine("Insert a table")

        ' The following code has the problem that it invokes accessors which 
        ' will also create RCWs and reference them. For example, calling 
        ' Document.Bookmarks.Item creates an RCW for the Bookmarks object. 
        ' If you invoke these accessors via tunneling as this code does, the 
        ' RCWs are created on the GC heap, but the references are created 
        ' under the hood on the stack and are then discarded. As such, there 
        ' is no way to call MarshalFinalReleaseComObject on those RCWs. To 
        ' get them to release, you would either need to force a garbage 
        ' collection as soon as the calling function is off the stack (at 
        ' which point these objects are no longer rooted) and then call 
        ' GC.WaitForPendingFinalizers, or you would need to change the syntax 
        ' to explicitly assign these accessor objects to a variable that you 
        ' would then explicitly call Marshal.FinalReleaseComObject on. 

        oBookmarkRng = oDoc.Bookmarks.Item("\endofdoc").Range

        oTable = oDoc.Tables.Add(oBookmarkRng, 5, 2)
        oTable.Range.ParagraphFormat.SpaceAfter = 6

        For r As Integer = 1 To 5
            For c As Integer = 1 To 2
                oTable.Cell(r, c).Range.Text = "r" & r & "c" & c
            Next
        Next

        ' Change width of columns 1 & 2
        oTable.Columns(1).Width = oWord.InchesToPoints(2)
        oTable.Columns(2).Width = oWord.InchesToPoints(3)


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Save the document as a docx file and close it.
        ' 

        Console.WriteLine("Save and close the document")

        Dim fileName As String = Path.GetDirectoryName( _
        Assembly.GetExecutingAssembly().Location) & "\MSDN.docx"
        oDoc.SaveAs(fileName, Word.WdSaveFormat.wdFormatXMLDocument)
        oDoc.Close()


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Quit the Word application.
        ' 

        Console.WriteLine("Quit the Word application")
        oWord.Quit(False)


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Clean up the unmanaged COM resources.
        ' 

        ' Explicitly call Marshal.FinalReleaseComObject on all accessor 
        ' objects. See http://support.microsoft.com/kb/317109.
        Marshal.FinalReleaseComObject(oTable)
        oTable = Nothing
        Marshal.FinalReleaseComObject(oBookmarkRng)
        oBookmarkRng = Nothing
        Marshal.FinalReleaseComObject(oParaRng)
        oParaRng = Nothing
        Marshal.FinalReleaseComObject(oPara)
        oPara = Nothing
        Marshal.FinalReleaseComObject(oParas)
        oParas = Nothing
        Marshal.FinalReleaseComObject(oDoc)
        oDoc = Nothing
        Marshal.FinalReleaseComObject(oDocs)
        oDocs = Nothing
        Marshal.FinalReleaseComObject(oWord)
        oWord = Nothing

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
