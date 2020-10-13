========================================================================
    CONSOLE APPLICATION : CSAutomatePowerPoint Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

The CSAutomatePowerPoint example demonstrates the use of Visual C# codes to  
create a Microsoft PowerPoint instance, add a new presentation, insert a new 
slide, add some texts and clean up unmanaged COM resources to quit the 
PowerPoint application properly.


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CSAutomatePowerPoint - CppAutomatePowerPoint - VBAutomatePowerPoint

These examples automate Microsoft PowerPoint to do the same thing in  
different programming languages.


/////////////////////////////////////////////////////////////////////////////
Creation:

Step1. Create a Console application and reference the PowerPoint Primary  
Interop Assembly (PIA) and Office 12. To reference the PowerPoint PIA and 
Office 12, right-click the project file and click the "Add Reference..." 
button. In the Add Reference dialog, navigate to the .NET tab, find 
Microsoft.Office.Interop.PowerPoint 12.0.0.0 and Office 12.0.0.0 and click OK.

Step2. Import and rename the Excel interop and the Office namepaces:

	using Word = Microsoft.Office.Interop.Word;
	using Office = Microsoft.Office.Core;

Step3. Start up a PowerPoint application by creating a PowerPoint.Application 
object.

	oPowerPoint = new PowerPoint.Application();

By default PowerPoint is invisible, till you make it visible:

	oPowerPoint.Visible = Office.MsoTriState.msoTrue;

Step4. Get the Presentations collection from Application.Presentations and 
call its Add function to add a new presentation. The Add function returns a 
Presentation object.

Step5. Insert a slide by calling Presentation.Slides.Add, and add some texts 
to the slide (Slide.Shapes[1].TextFrame.TextRange.Text).

Step6. Save the presentation as a pptx file and close it.

Step7. Quit the PowerPoint application.

Step8. Clean up the unmanaged COM resource. To get PowerPoint terminated 
rightly, we need to call Marshal.FinalReleaseComObject() on each COM object 
we used. We can either explicitly call Marshal.FinalReleaseComObject on all 
accessor objects:

	// See http://support.microsoft.com/kb/317109.
	Marshal.FinalReleaseComObject(oTxtRange);
	oTxtRange = null;
	Marshal.FinalReleaseComObject(oTxtFrame);
	oTxtFrame = null;
	Marshal.FinalReleaseComObject(oShape);
	oShape = null;
	Marshal.FinalReleaseComObject(oShapes);
	oShapes = null;
	Marshal.FinalReleaseComObject(oSlide);
	oSlide = null;
	Marshal.FinalReleaseComObject(oSlides);
	oSlides = null;
	Marshal.FinalReleaseComObject(oPre);
	oPre = null;
	Marshal.FinalReleaseComObject(oPres);
	oPres = null;
	Marshal.FinalReleaseComObject(oPowerPoint);
	oPowerPoint = null;

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

MSDN: PowerPoint 2007 Developer Reference
http://msdn.microsoft.com/en-us/library/bb265982.aspx


/////////////////////////////////////////////////////////////////////////////
