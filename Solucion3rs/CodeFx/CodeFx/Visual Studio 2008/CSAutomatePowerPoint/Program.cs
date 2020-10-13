/****************************** Module Header ******************************\
* Module Name:	Program.cs
* Project:		CSAutomatePowerPoint
* Copyright (c) Microsoft Corporation.
* 
* The CSAutomatePowerPoint example demonstrates the use of Visual C# codes to  
* create a Microsoft PowerPoint instance, add a new presentation, insert a 
* new slide, add some texts and clean up unmanaged COM resources to quit the 
* PowerPoint application properly.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 6/8/2009 10:59 PM Jialiang Ge Created
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Reflection;

using PowerPoint = Microsoft.Office.Interop.PowerPoint;
using Office = Microsoft.Office.Core;
using System.Runtime.InteropServices;
#endregion


class Program
{
    static void Main(string[] args)
    {
        PowerPoint.Application oPowerPoint = null;
        PowerPoint.Presentations oPres = null;
        PowerPoint.Presentation oPre = null;
        PowerPoint.Slides oSlides = null;
        PowerPoint.Slide oSlide = null;
        PowerPoint.Shapes oShapes = null;
        PowerPoint.Shape oShape = null;
        PowerPoint.TextFrame oTxtFrame = null;
        PowerPoint.TextRange oTxtRange = null;


        /////////////////////////////////////////////////////////////////////
        // Create an instance of Microsoft PowerPoint and make it invisible.
        // 

        oPowerPoint = new PowerPoint.Application();
        // By default PowerPoint is invisible, till you make it visible:
        //oPowerPoint.Visible = Office.MsoTriState.msoTrue;
        Console.WriteLine("PowerPoint.Application is started");


        /////////////////////////////////////////////////////////////////////
        // Add a new Presentation.
        // 

        oPres = oPowerPoint.Presentations;
        oPre = oPres.Add(Office.MsoTriState.msoTrue);
        Console.WriteLine("A new presentation is created");


        /////////////////////////////////////////////////////////////////////
        // Insert a new Slide and add some text to it.
        // 

        oSlides = oPre.Slides;

        Console.WriteLine("The presentation currently has {0} slides", 
            oSlides.Count);

        // Insert a new slide
        Console.WriteLine("Insert a slide");
        oSlide = oSlides.Add(1, PowerPoint.PpSlideLayout.ppLayoutText);

        // Add some texts to the slide
        Console.WriteLine("Add some texts");
        oShapes = oSlide.Shapes;
        oShape = oShapes[1];
        oTxtFrame = oShape.TextFrame;
        oTxtRange = oTxtFrame.TextRange;
        oTxtRange.Text = "All-In-One Code Framework";


        /////////////////////////////////////////////////////////////////////
        // Save the presentation as a pptx file and close it.
        // 

        Console.WriteLine("Save and close the presentation");

        string fileName = Path.GetDirectoryName(Assembly.GetExecutingAssembly().
           Location) + "\\MSDN.pptx";
        oPre.SaveAs(fileName, 
            PowerPoint.PpSaveAsFileType.ppSaveAsOpenXMLPresentation,
            Office.MsoTriState.msoTriStateMixed);
        oPre.Close();


        /////////////////////////////////////////////////////////////////////
        // Quit the PowerPoint application.
        // 

        Console.WriteLine("Quit the PowerPoint application");
        oPowerPoint.Quit();


        /////////////////////////////////////////////////////////////////////
        // Clean up the unmanaged COM resources.
        // 

        // Explicitly call Marshal.FinalReleaseComObject on all accessor 
        // objects. See http://support.microsoft.com/kb/317109.
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