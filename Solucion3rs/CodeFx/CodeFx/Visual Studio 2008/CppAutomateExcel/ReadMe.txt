========================================================================
    CONSOLE APPLICATION : CppAutomateExcel Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

The CppAutomateExcel example demonstrates how to write VC++ codes to create a  
Microsoft Excel instance, create a workbook, and fill data into the specified 
range, as well as how to clean up unmanaged COM resources and quit the Excel 
application properly.

There are three basic ways you can write VC++ automation codes:

1. C/C++

The code in RawAPI.h/cpp demontrates the use of C/C++ and the COM APIs to 
automate Excel. The raw automation is much more difficult, but it is sometimes 
necessary to avoid the overhead with MFC, or problems with #import. Basically, 
you work with such APIs as CoCreateInstance(), and COM interfaces such as 
IDispatch and IUnknown.

2. #import

The code in ImportDirective.h/cpp demonstrates the use of #import to automate
Excel. #import (http://msdn.microsoft.com/en-us/library/8etzzkb6.aspx), a new  
directive that became available with Visual C++ 5.0, creates VC++ "smart 
pointers" from a specified type library. It is very powerful, but often not 
recommended because of reference-counting problems that typically occur when 
used with the Microsoft Office applications. Unlike the direct API approach 
in RawAPI.h/cpp, smart pointers enable us to benefit from the type info to 
early/late bind the object. #import takes care of adding the messy guids to 
the project and the COM APIs are encapsulated in custom classes that the 
#import directive generates.

3. MFC

With MFC, Visual C++ ClassWizard can generate "wrapper classes" from the type
libraries. These classes simplify the use of the COM servers. Please refer to
the sample MFCAutomateExcel.


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CppAutomateExcel - CSAutomateExcel - VBAutomateExcel

These examples automate Microsoft Excel to do the same thing in different 
programming languages.


/////////////////////////////////////////////////////////////////////////////
Creation:

A. Automating Excel using C++ and the COM APIs (RawAPI.h/cpp)

Step1. Add the automation helper function, AutoWrap.

Step2. Initialize COM by calling CoInitializeEx, or CoInitialize.

Step3. Get CLSID of the Excel COM server using the API CLSIDFromProgID.

Step4. Start the Excel COM server and get the IDispatch interface using the 
API CoCreateInstance.

Step5. Automate the Excel COM object with the help of AutoWrap. In this 
example, you can find the basic operations in Excel automation like 

	Create a new Workbook. (i.e. Application.Workbooks.Add)
	Get the active Worksheet.
	Fill data into the worksheet's cells.
	Save the workbook as a xlsx file and close it.

Step6. Quit the Excel application. (i.e. Application.Quit())

Step7. Release the COM objects.

Step8. Uninitialize COM for this thread by calling CoUninitialize.

B. Automating Excel using the #import directive and smart pointers 
(ImportDirecive.h/cpp)

Step1. Import the type library of the target COM server using the #import 
directive. 

	#import "libid:2DF8D04C-5BFA-101B-BDE5-00AA0044DE52" \
		rename("RGB", "MSORGB")
	// [-or-]
	//#import "C:\\Program Files\\Common Files\\Microsoft Shared\\OFFICE12\\MSO.DLL" \
	//	rename("RGB", "MSORGB")

	using namespace Office;

	#import "libid:0002E157-0000-0000-C000-000000000046"
	// [-or-]
	//#import "C:\\Program Files\\Common Files\\Microsoft Shared\\VBA\\VBA6\\VBE6EXT.OLB"

	using namespace VBIDE;

	#import "libid:00020813-0000-0000-C000-000000000046" \
		rename("DialogBox", "ExcelDialogBox") \
		rename("RGB", "ExcelRGB") \
		rename("CopyFile", "ExcelCopyFile") \
		rename("ReplaceText", "ExcelReplaceText")
	// [-or-]
	//#import "C:\\Program Files\\Microsoft Office\\Office12\\EXCEL.EXE" \
	//	rename("DialogBox", "ExcelDialogBox") \
	//	rename("RGB", "ExcelRGB") \
	//	rename("CopyFile", "ExcelCopyFile") \
	//	rename("ReplaceText", "ExcelReplaceText")

Step2. Build the project. If the build is successful, the compiler generates 
the .tlh and .tli files that encapsulate the COM server based on the type 
library specified in the #import directive. It serves as a class wrapper we
can now use to create the COM class and access its properties, methods, etc.

Step3. Create the Excel.Application COM object using the smart pointer. The 
class name is the original interface name (i.e. Excel::_Application) with a 
"Ptr" suffix. We can use either the constructor of the smart pointer class or 
its CreateInstance method to create the COM object.

Step4. Automate the Excel COM object through the smart pointers. In this 
example, you can find the basic operations in Excel automation like 

	Create a new Workbook. (i.e. Application.Workbooks.Add)
	Get the active Worksheet.
	Fill data into the worksheet's cells.
	Save the workbook as a xlsx file and close it.

Step5. Quit the Excel application. (i.e. Application.Quit())

Step6. It is said that the smart pointers are released automatically, so we 
do not need to manually release the COM object.

Step7. It is necessary to catch the COM errors if the type library was  
imported without raw_interfaces_only and when the raw interfaces 
(e.g. raw_Quit) are not used. For example:

	#import "XXXX.tlb"
	try
	{
		spXlApp->Quit();
	}
	catch (_com_error &err)
	{
	}

Step8. Uninitialize COM for this thread by calling CoUninitialize.


/////////////////////////////////////////////////////////////////////////////
References:

MSDN: Excel 2007 Developer Reference
http://msdn.microsoft.com/en-us/library/bb149067.aspx

Office Automation Using Visual C++
http://support.microsoft.com/kb/196776/

How to automate Excel from C++ without using MFC or #import
http://support.microsoft.com/kb/216686

Accessing Excel Spreadsheets via C++
http://www.codeproject.com/KB/wtl/WTLExcel.aspx


/////////////////////////////////////////////////////////////////////////////
