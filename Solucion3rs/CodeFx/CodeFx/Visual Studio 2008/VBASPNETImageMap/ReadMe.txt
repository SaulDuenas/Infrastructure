========================================================================
       ASP.NET APPLICATION : VBASPNETImageMap Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

  The project illustrates how to use ImageMap to create an introduction of 
  the planets in Solar System via VB.NET language. When the planet in the 
  image is clicked, the brief information of this planet will be displayed
  under the image and the iframe will navigate to the corresponding page in
  WikiPedia. 


/////////////////////////////////////////////////////////////////////////////
Code Logical:

Step1. Create a Visual Basic ASP.NET Web Application in Visual Studio 2008 /
Visual Web Developer and name it as VBASPNETImageMap.

Step2. Add an ImageMap control into the page and change its ID property to
imgMapSolarSystem.

[NOTE] ImageMap can contain defined hotspot regions. When a user clicks a 
hot spot region, the control can either generate a post back to the server 
or navigate to a specified URL. This demo is made to generate a post back 
to the server and run specific code based on the hot spot region that was 
clicked from the ImageMap control. For an example illustrating navigating 
to different URLs, please refer to the following code and pay attention to
the NavigateUrl property in the RectangleHotSpot tag:

<asp:ImageMap ID="ImageMap4Navigate" ImageUrl="image.jpg" runat="Server">
    <asp:RectangleHotSpot HotSpotMode="Navigate" 
                          NavigateUrl="navigate1.htm" 
                          AlternateText="Button 1"
                          Top="20" Left="200" 
                          Bottom="100" Right="300">
    </asp:RectangleHotSpot>
</asp:ImageMap> 

Step3: Follow the demo to create the RectangleHotSpots, CircleHotSpots and 
PolygonHotSpot within the ImageMap tag.

[NOTE] There are three kinds of hot spots in the ImageMap control. They are
RectangleHotSpot, CircleHotSpot and PolygonHotSpot. As the name implies, 
the RectangleHotSpot defines rectangular hot spot regions. The CircleHotSpots
defines circle-shaped ones and the PolygonHotSpot is use for irregularly 
shaped hot spot area.
To define the region of the RectangleHotSpot object, use the Left, Top, Right
and Bottom property to represent the coordinate of the region itself. For the
CircleHotSpot object, set the X and the Y property to the coordinate of the 
centre of the circle. Then set the Radius property to the distance from the 
center to the edge. To define the region of a PolygonHotSpot, set the 
Coordinates property to a string that specifies the coordinates of each vertex
of the PolygonHotSpot object. A polygon vertex is a point at which two polygon
edges meet. 
For more information about these three hot spots, please refer to the links in
References part.

Step4: Double-click the ImageMap control in page's Designer View to open the 
Code-Behind page in Visual Basic .NET language.

Step5: Locate the code into the imgMapSolarSystem_Click event handler and use
Select Case to create different behaviors according to the PostBackValue.

[NOTE] To make the hot spot generate postback to the server, set the 
HotSpotMode property to Postback and use the PostBackValue property to specify 
a name for the region. This name will be passed in the ImageMapEventArgs event 
data when postback occurs. 


/////////////////////////////////////////////////////////////////////////////
References:

MSDN: ImageMap Class
http://msdn.microsoft.com/en-us/library/system.web.ui.webcontrols.imagemap.aspx

MSDN: RectangleHotSpot Class
http://msdn.microsoft.com/en-us/library/system.web.ui.webcontrols.rectanglehotspot.aspx

MSDN: CircleHotSpot Class
http://msdn.microsoft.com/en-us/library/system.web.ui.webcontrols.circlehotspot.aspx

MSDN: PolygonHotSpot Class
http://msdn.microsoft.com/en-us/library/system.web.ui.webcontrols.polygonhotspot.aspx


/////////////////////////////////////////////////////////////////////////////