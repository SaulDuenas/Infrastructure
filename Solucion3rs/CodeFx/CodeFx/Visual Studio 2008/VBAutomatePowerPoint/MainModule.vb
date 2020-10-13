'****************************** Module Header ******************************'
' Module Name:	MainModule.vb
' Project:		VBAutomatePowerPoint
' Copyright (c) Microsoft Corporation.
' 
' The VBAutomatePowerPoint example demonstrates the use of VB.NET codes to  
' create a Microsoft PowerPoint instance, add a new presentation, insert a 
' new slide, add some texts and clean up unmanaged COM resources to quit the 
' PowerPoint application properly.
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

Imports PowerPoint = Microsoft.Office.Interop.PowerPoint
Imports Office = Microsoft.Office.Core
Imports System.Runtime.InteropServices

#End Region


Module MainModule

    Sub Main()

        Dim oPowerPoint As PowerPoint.Application
        Dim oPres As PowerPoint.Presentations
        Dim oPre As PowerPoint.Presentation
        Dim oSlides As PowerPoint.Slides
        Dim oSlide As PowerPoint.Slide
        Dim oShapes As PowerPoint.Shapes
        Dim oShape As PowerPoint.Shape
        Dim oTxtFrame As PowerPoint.TextFrame
        Dim oTxtRange As PowerPoint.TextRange


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Create an instance of Microsoft PowerPoint and make it invisible.
        ' 

        oPowerPoint = New PowerPoint.Application()
        ' By default PowerPoint is invisible, till you make it visible:
        'oPowerPoint.Visible = Office.MsoTriState.msoTrue
        Console.WriteLine("PowerPoint.Application is started")


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Add a new Presentation.
        ' 

        oPres = oPowerPoint.Presentations
        oPre = oPres.Add(Office.MsoTriState.msoTrue)
        Console.WriteLine("A new presentation is created")


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Insert a new Slide and add some text to it.
        ' 

        oSlides = oPre.Slides

        Console.WriteLine("The presentation currently has {0} slides", _
            oSlides.Count)

        ' Insert a new slide
        Console.WriteLine("Insert a slide")
        oSlide = oSlides.Add(1, PowerPoint.PpSlideLayout.ppLayoutText)

        ' Add some texts to the slide
        Console.WriteLine("Add some texts")
        oShapes = oSlide.Shapes
        oShape = oShapes(1)
        oTxtFrame = oShape.TextFrame
        oTxtRange = oTxtFrame.TextRange
        oTxtRange.Text = "All-In-One Code Framework"


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Save the presentation as a pptx file and close it.
        ' 

        Console.WriteLine("Save and close the presentation")

        Dim fileName As String = Path.GetDirectoryName( _
        Assembly.GetExecutingAssembly().Location) & "\\MSDN.pptx"
        oPre.SaveAs(fileName, _
            PowerPoint.PpSaveAsFileType.ppSaveAsOpenXMLPresentation, _
            Office.MsoTriState.msoTriStateMixed)
        oPre.Close()


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Quit the PowerPoint application.
        ' 

        Console.WriteLine("Quit the PowerPoint application")
        oPowerPoint.Quit()


        '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
        ' Clean up the unmanaged COM resources.
        ' 

        ' Explicitly call Marshal.FinalReleaseComObject on all accessor 
        ' objects. See http://support.microsoft.com/kb/317109.
        Marshal.FinalReleaseComObject(oTxtRange)
        oTxtRange = Nothing
        Marshal.FinalReleaseComObject(oTxtFrame)
        oTxtFrame = Nothing
        Marshal.FinalReleaseComObject(oShape)
        oShape = Nothing
        Marshal.FinalReleaseComObject(oShapes)
        oShapes = Nothing
        Marshal.FinalReleaseComObject(oSlide)
        oSlide = Nothing
        Marshal.FinalReleaseComObject(oSlides)
        oSlides = Nothing
        Marshal.FinalReleaseComObject(oPre)
        oPre = Nothing
        Marshal.FinalReleaseComObject(oPres)
        oPres = Nothing
        Marshal.FinalReleaseComObject(oPowerPoint)
        oPowerPoint = Nothing

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
