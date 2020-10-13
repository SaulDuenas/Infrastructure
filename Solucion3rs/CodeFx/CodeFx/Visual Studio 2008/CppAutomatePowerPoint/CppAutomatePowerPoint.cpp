/****************************** Module Header ******************************\
* Module Name:	CppAutomatePowerPoint.cpp
* Project:		CppAutomatePowerPoint
* Copyright (c) Microsoft Corporation.
* 
* The CppAutomatePowerPoint example demonstrates how to write VC++ codes to 
* create a Microsoft PowerPoint instance, create a new presentation, insert 
* a slide, some texts, and clean up unmanaged COM resources to quit the 
* PowerPoint application properly.
* 
* There are three basic ways you can write VC++ automation codes:
* 
* 1. C/C++
* 
* The code in RawAPI.h/cpp demontrates the use of C/C++ and the COM APIs to 
* automate PowerPoint. The raw automation is much more difficult, but it is 
* sometimes necessary to avoid the overhead with MFC, or problems with 
* #import. Basically, you work with such APIs as CoCreateInstance(), and COM 
* interfaces such as IDispatch and IUnknown.
* 
* 2. #import
* 
* The code in ImportDirective.h/cpp demonstrates the use of #import to 
* automate PowerPoint. #import 
* (http://msdn.microsoft.com/en-us/library/8etzzkb6.aspx), a new directive 
* that became available with Visual C++ 5.0, creates VC++ "smart pointers" 
* from a specified type library. It is very powerful, but often not 
* recommended because of reference-counting problems that typically occur 
* when used with the Microsoft Office applications. Unlike the direct API 
* approach in RawAPI.h/cpp, smart pointers enable us to benefit from the type 
* info to early/late bind the object. #import takes care of adding the messy 
* guids to the project and the COM APIs are encapsulated in custom classes 
* that the #import directive generates.
* 
* 3. MFC
* 
* With MFC, Visual C++ ClassWizard can generate "wrapper classes" from the 
* type libraries. These classes simplify the use of the COM servers. Please 
* refer to the sample MFCAutomatePowerPoint.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 6/4/2009 1:39 PM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include "RawAPI.h"				// The example of using the raw COM API to  
								// automate PowerPoint
#include "ImportDirective.h"	// The example of using the #import directive 
								// and smart pointers to automate PowerPoint
#pragma endregion


int _tmain(int argc, _TCHAR* argv[])
{
	HANDLE hThread;

	hThread = CreateThread(NULL, 0, RawAutomatePowerPoint, NULL, 0, NULL);
	WaitForSingleObject(hThread, INFINITE);
	CloseHandle(hThread);

	_putts(_T(""));

	hThread = CreateThread(NULL, 0, ImportPowerPoint, NULL, 0, NULL);
	WaitForSingleObject(hThread, INFINITE);	
	CloseHandle(hThread);

	return 0;
}