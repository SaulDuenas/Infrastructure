/****************************** Module Header ******************************\
* Module Name:	Program.cs
* Project:		CSAutomateWord
* Copyright (c) Microsoft Corporation.
* 
* The CSAutomateWord example demonstrates the use of Visual C# codes to  
* create a Microsoft Word instance, create a new document, insert a paragraph 
* and a table, as well as how to clean up unmanaged COM resources and quit 
* the Word application properly.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/18/2009 9:56 PM Jialiang Ge Created
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Reflection;

using Word = Microsoft.Office.Interop.Word;
using System.Runtime.InteropServices;
#endregion


class Program
{
    static void Main(string[] args)
    {
        object missing = Type.Missing;
        object oEndOfDoc = @"\endofdoc";    // A predefined bookmark 
        object notTrue = false;

        Word.Application oWord = null;
        Word.Documents oDocs = null;
        Word.Document oDoc = null;
        Word.Paragraphs oParas = null;
        Word.Paragraph oPara = null;
        Word.Range oParaRng = null;
        Word.Font oFont = null;
        Word.Range oBookmarkRng = null;
        Word.Table oTable = null;


        /////////////////////////////////////////////////////////////////////
        // Create an instance of Microsoft Word and make it invisible.
        // 

        oWord = new Word.Application();
        oWord.Visible = false;
        Console.WriteLine("Word.Application is started");


        /////////////////////////////////////////////////////////////////////
        // Create a new Document.
        // 

        oDocs = oWord.Documents;
        oDoc = oDocs.Add(ref missing, ref missing, ref missing, ref missing);
        Console.WriteLine("A new document is created");


        /////////////////////////////////////////////////////////////////////
        // Insert a paragraph.
        // 

        Console.WriteLine("Insert a paragraph");

        oParas = oDoc.Paragraphs;
        oPara = oParas.Add(ref missing);
        oParaRng = oPara.Range;
        oParaRng.Text = "Heading 1";
        oFont = oParaRng.Font;
        oFont.Bold = 1;
        oParaRng.InsertParagraphAfter();


        /////////////////////////////////////////////////////////////////////
        // Insert a table.
        // 

        Console.WriteLine("Insert a table");

        // The following code has the problem that it invokes accessors which 
        // will also create RCWs and reference them. For example, calling 
        // Document.Bookmarks.Item creates an RCW for the Bookmarks object. 
        // If you invoke these accessors via tunneling as this code does, the 
        // RCWs are created on the GC heap, but the references are created 
        // under the hood on the stack and are then discarded. As such, there 
        // is no way to call MarshalFinalReleaseComObject on those RCWs. To 
        // get them to release, you would either need to force a garbage 
        // collection as soon as the calling function is off the stack (at 
        // which point these objects are no longer rooted) and then call 
        // GC.WaitForPendingFinalizers, or you would need to change the syntax 
        // to explicitly assign these accessor objects to a variable that you 
        // would then explicitly call Marshal.FinalReleaseComObject on. 

        oBookmarkRng = oDoc.Bookmarks.get_Item(ref oEndOfDoc).Range;
        oTable = oDoc.Tables.Add(oBookmarkRng, 5, 2, ref missing, ref missing);
        oTable.Range.ParagraphFormat.SpaceAfter = 6;
        for (int r = 1; r <= 5; r++)
        {
            for (int c = 1; c <= 2; c++)
            {
                oTable.Cell(r, c).Range.Text = "r" + r + "c" + c;
            }
        }

        // Change width of columns 1 & 2
        oTable.Columns[1].Width = oWord.InchesToPoints(2);
        oTable.Columns[2].Width = oWord.InchesToPoints(3);


        /////////////////////////////////////////////////////////////////////
        // Save the document as a docx file and close it.
        // 

        Console.WriteLine("Save and close the document");

        object fileName = Path.GetDirectoryName(Assembly.GetExecutingAssembly().
           Location) + "\\MSDN.docx";
        object fileFormat = Word.WdSaveFormat.wdFormatXMLDocument;
        oDoc.SaveAs(ref fileName, ref fileFormat, ref missing, ref missing, 
            ref missing, ref missing, ref missing, ref missing, ref missing, 
            ref missing, ref missing, ref missing, ref missing, ref missing, 
            ref missing, ref missing);
        ((Word._Document)oDoc).Close(ref missing, ref missing, ref missing);


        /////////////////////////////////////////////////////////////////////
        // Quit the Word application.
        // 

        Console.WriteLine("Quit the Word application");
        ((Word._Application)oWord).Quit(ref notTrue, ref missing, ref missing);


        /////////////////////////////////////////////////////////////////////
        // Clean up the unmanaged COM resources.
        // 

        // Explicitly call Marshal.FinalReleaseComObject on all accessor 
        // objects. See http://support.microsoft.com/kb/317109.
        Marshal.FinalReleaseComObject(oTable);
        oTable = null;
        Marshal.FinalReleaseComObject(oBookmarkRng);
        oBookmarkRng = null;
        Marshal.FinalReleaseComObject(oFont);
        oFont = null;
        Marshal.FinalReleaseComObject(oParaRng);
        oParaRng = null;
        Marshal.FinalReleaseComObject(oPara);
        oPara = null;
        Marshal.FinalReleaseComObject(oParas);
        oParas = null;
        Marshal.FinalReleaseComObject(oDoc);
        oDoc = null;
        Marshal.FinalReleaseComObject(oDocs);
        oDocs = null;
        Marshal.FinalReleaseComObject(oWord);
        oWord = null;

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