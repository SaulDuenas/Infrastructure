/****************************** Module Header ******************************\
* Module Name:	Program.cs
* Project:		CSAutomateExcel
* Copyright (c) Microsoft Corporation.
* 
* The CSAutomateExcel example demonstrates how to use C# codes to create an 
* Microsoft Excel instance, create a workbook, and fill data into the 
* specified range, as well as how to clean up unmanaged COM resources and 
* quit the Excel application properly.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 3/27/2009 1:35 PM Ji Zhou Created
* * 4/18/2009 9:04 PM Jialiang Ge Modified
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Reflection;

using Excel = Microsoft.Office.Interop.Excel;
using System.Runtime.InteropServices;
#endregion


class Program
{
    static void Main(string[] args)
    {
        object missing = Type.Missing;
        Excel.Application oXL = null;
        Excel.Workbooks oWBs = null;
        Excel.Workbook oWB = null;
        Excel.Worksheet oSheet = null;
        Excel.Range oCells = null;
        Excel.Range oRng1 = null;
        Excel.Range oRng2 = null;


        /////////////////////////////////////////////////////////////////////
        // Create an instance of Microsoft Excel and make it invisible.
        // 

        oXL = new Excel.Application();
        oXL.Visible = false;
        Console.WriteLine("Excel.Application is started");


        /////////////////////////////////////////////////////////////////////
        // Create a new Workbook.
        // 

        oWBs = oXL.Workbooks;
        oWB = oWBs.Add(missing);
        Console.WriteLine("A new workbook is created");


        /////////////////////////////////////////////////////////////////////
        // Get the active Worksheet and set its name.
        // 

        oSheet = oWB.ActiveSheet as Excel.Worksheet;
        oSheet.Name = "Report";
        Console.WriteLine("The active worksheet is renamed as Report");


        /////////////////////////////////////////////////////////////////////
        // Fill data into the worksheet's cells.
        // 

        Console.WriteLine("Filling data into the worksheet ...");

        // Set the column header
        oCells = oSheet.Cells;
        oCells[1, 1] = "First Name";
        oCells[1, 2] = "Last Name";
        oCells[1, 3] = "Full Name";

        // Construct an array of user names
        string[,] saNames = new string[,] {
        {"John", "Smith"}, 
        {"Tom", "Brown"}, 
        {"Sue", "Thomas"}, 
        {"Jane", "Jones"}, 
        {"Adam", "Johnson"}};

        // Fill A2:B6 with an array of values (First and Last Names).
        oRng1 = oSheet.get_Range("A2", "B6");
        oRng1.Value2 = saNames;

        // Fill C2:C6 with a relative formula (=A2 & " " & B2).
        oRng2 = oSheet.get_Range("C2", "C6");
        oRng2.Formula = "=A2 & \" \" & B2";


        /////////////////////////////////////////////////////////////////////
        // Save the workbook as a xlsx file and close it.
        // 

        Console.WriteLine("Save and close the workbook");

        string fileName = Path.GetDirectoryName(Assembly.GetExecutingAssembly().
            Location) + "\\MSDN.xlsx";
        oWB.SaveAs(fileName, Excel.XlFileFormat.xlOpenXMLWorkbook,
            missing, missing, missing, missing,
            Excel.XlSaveAsAccessMode.xlNoChange,
            missing, missing, missing, missing, missing);
        oWB.Close(missing, missing, missing);


        /////////////////////////////////////////////////////////////////////
        // Quit the Excel application.
        // 

        Console.WriteLine("Quit the Excel application");

        // Excel will stick around after Quit if it is not under user control 
        // and there are outstanding references. When Excel is started or 
        // attached programmatically and Excel.Application.Visible = false, 
        // Excel.Application.UserControl is false. The UserControl property 
        // can be explicitly set to True which should force the application 
        // to terminate when Quit is called, regardless of outstanding 
        // references.
        oXL.UserControl = true;

        oXL.Quit();


        /////////////////////////////////////////////////////////////////////
        // Clean up the unmanaged COM resources.
        // 

        // Explicitly call Marshal.FinalReleaseComObject on all accessor 
        // objects. See http://support.microsoft.com/kb/317109.
        Marshal.FinalReleaseComObject(oRng2);
        oRng2 = null;
        Marshal.FinalReleaseComObject(oRng1);
        oRng1 = null;
        Marshal.FinalReleaseComObject(oCells);
        oCells = null;
        Marshal.FinalReleaseComObject(oSheet);
        oSheet = null;
        Marshal.FinalReleaseComObject(oWB);
        oWB = null;
        Marshal.FinalReleaseComObject(oWBs);
        oWBs = null;
        Marshal.FinalReleaseComObject(oXL);
        oXL = null;

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