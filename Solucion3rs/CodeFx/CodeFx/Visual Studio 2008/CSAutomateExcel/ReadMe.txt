========================================================================
    CONSOLE APPLICATION : CSAutomateExcel Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

The CSAutomateExcel example demonstrates how to use C# codes to create a  
Microsoft Excel instance, create a workbook, and fill data into the specified 
range, as well as how to clean up unmanaged COM resources and quit the Excel 
application properly.


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CSAutomateExcel - VBAutomateExcel - CppAutomateExcel

These examples automate Microsoft Excel to do the same thing in different 
programming languages.


/////////////////////////////////////////////////////////////////////////////
Creation:

Step1. Create a Console application and reference the Excel Primary Interop 
Assembly (PIA). To reference the Excel PIA, right-click the project file
and click the "Add Reference..." button. In the Add Reference dialog, 
navigate to the .NET tab, find Microsoft.Office.Interop.Excel 12.0.0.0 and 
click OK.

Step2. Import and rename the Excel interop namepace:

	using Excel = Microsoft.Office.Interop.Excel;

Step3. Start up an Excel application by creating an Excel.Application object.

	Excel.Application oXL = new Excel.Application();

Step4. Get the Workbooks collection from Application.Workbooks and call its 
Add function to create a new workbook. The Add function returns a Workbook 
object.

Step5. Get the active worksheet by calling Workbook.ActiveSheet and set the
sheet's Name

Step6. Construct a two-dimensions array and set it to a range's Value2 
property.So the array's content will appear in the range A2 to B6.

Step7. Use formula to generate Full Name column from first and last name
by setting range's Formula property

Step8. Call workbook.SaveAs method to save the workbook to a local place. 
Then, call workbook.Close method to close the workbook and application.Quit
method to quit the application.

Step9. Clean up the unmanaged COM resource. To get Excel terminated rightly,
we need to call Marshal.FinalReleaseComObject() on each COM object we used.
We can either explicitly call Marshal.FinalReleaseComObject on all accessor 
objects:

	// See http://support.microsoft.com/kb/317109.
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

and/or force a garbage collection as soon as the calling function is off the 
stack (at which point these objects are no longer rooted) and then call 
GC.WaitForPendingFinalizers.

	GC.Collect();
	GC.WaitForPendingFinalizers();
	// GC needs to be called twice in order to get the Finalizers called 
	// - the first time in, it simply makes a list of what is to be 
	// finalized, the second time in, it actually the finalizing. Only 
	// then will the object do its automatic ReleaseComObject.
	GC.Collect();
	GC.WaitForPendingFinalizers();


/////////////////////////////////////////////////////////////////////////////
References:

MSDN: Excel 2007 Developer Reference
http://msdn.microsoft.com/en-us/library/bb149067.aspx

How to automate Microsoft Excel from Microsoft Visual C# .NET
http://support.microsoft.com/kb/302084

How to terminate Excel process after automation
http://blogs.msdn.com/geoffda/archive/2007/09/07/the-designer-process-that-would-not-terminate-part-2.aspx

How To Use Automation to Get and to Set Office Document Properties with 
Visual C# .NET
http://support.microsoft.com/kb/303296


/////////////////////////////////////////////////////////////////////////////