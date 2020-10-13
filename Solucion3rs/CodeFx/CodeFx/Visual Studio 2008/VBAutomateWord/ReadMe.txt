========================================================================
    CONSOLE APPLICATION : VBAutomateWord Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

The VBAutomateWord example demonstrates the use of Visual Basic.NET codes to 
create a Microsoft Word instance, create a new document, insert a paragraph 
and a table, as well as how to clean up unmanaged COM resources and quit the 
Word application properly.


/////////////////////////////////////////////////////////////////////////////
Project Relation:

VBAutomateWord - CSAutomateWord - CppAutomateWord

These examples automate Microsoft Word to do the same thing in different 
programming languages.


/////////////////////////////////////////////////////////////////////////////
Creation:

Step1. Create a Console application and reference the Word Primary Interop 
Assembly (PIA). To reference the Word PIA, right-click the project file
and click the "Add Reference..." button. In the Add Reference dialog, 
navigate to the .NET tab, find Microsoft.Office.Interop.Word 12.0.0.0 and 
click OK.

Step2. Import and rename the Excel interop namepace:

	Imports Word = Microsoft.Office.Interop.Word

Step3. Start up a Word application by creating a Word.Application object.

	oWord = New Word.Application()

Step4. Get the Documents collection from Application.Documents and call its 
Add function to create a new document. The Add function returns a Document 
object.

Step5. Insert a paragraph.

	oParas = oDoc.Paragraphs
	oPara = oParas.Add()
	oParaRng = oPara.Range
	oParaRng.Text = "Heading 1"
	oParaRng.Font.Bold = 1
	oParaRng.InsertParagraphAfter()

Step6. Insert a table.

The following code has the problem that it invokes accessors which will also 
create RCWs and reference them. For example, calling Document.Bookmarks.Item 
creates an RCW for the Bookmarks object. If you invoke these accessors via 
tunneling as this code does, the RCWs are created on the GC heap, but the 
references are created under the hood on the stack and are then discarded. As 
such, there is no way to call MarshalFinalReleaseComObject on those RCWs. To 
get them to release, you would either need to force a garbage collection as 
soon as the calling function is off the stack (at which point these objects 
are no longer rooted) and then call GC.WaitForPendingFinalizers, or you would 
need to change the syntax to explicitly assign these accessor objects to a 
variable that you would then explicitly call Marshal.FinalReleaseComObject on. 

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

Step7. Save the document as a docx file and close it.

Step8. Quit the Word application.

Step9. Clean up the unmanaged COM resource. To get Word terminated rightly, 
we need to call Marshal.FinalReleaseComObject() on each COM object we used.
We can either explicitly call Marshal.FinalReleaseComObject on all accessor 
objects:

	' See http://support.microsoft.com/kb/317109.
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

and/or force a garbage collection as soon as the calling function is off the 
stack (at which point these objects are no longer rooted) and then call 
GC.WaitForPendingFinalizers.

	GC.Collect()
	GC.WaitForPendingFinalizers()
	' GC needs to be called twice in order to get the Finalizers called 
	' - the first time in, it simply makes a list of what is to be 
	' finalized, the second time in, it actually the finalizing. Only 
	' then will the object do its automatic ReleaseComObject.
	GC.Collect()
	GC.WaitForPendingFinalizers()


/////////////////////////////////////////////////////////////////////////////
References:

MSDN: Word 2007 Developer Reference
http://msdn.microsoft.com/en-us/library/bb244391.aspx

How to automate Word from Visual Basic .NET to create a new document
http://support.microsoft.com/kb/316383/


/////////////////////////////////////////////////////////////////////////////