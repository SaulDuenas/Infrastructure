/****************************** Module Header ******************************\
* Module Name:	ImportDirective.h
* Project:		CppAutomatePowerPoint
* Copyright (c) Microsoft Corporation.
* 
* The code in ImportDirective.h/cpp demonstrates the use of #import to 
* automate PowerPoint. #import 
* (http://msdn.microsoft.com/en-us/library/8etzzkb6.aspx), a new directive 
* that became available with Visual C++ 5.0, creates VC++ "smart pointers"  
* from a specified type library. It is very powerful, but often not 
* recommended because of reference-counting problems that typically occur 
* when used with the Microsoft Office applications. Unlike the direct API 
* approach in RawAPI.h/cpp, smart pointers enable us to benefit from the 
* type info to early/late bind the object. #import takes care of adding the 
* messy guids to the project and the COM APIs are encapsulated in custom 
* classes that the #import directive generates.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 6/4/2009 1:44 PM Jialiang Ge Created
\***************************************************************************/

#pragma once


/*!
 * \brief
 * Automate Microsoft PowerPoint using the #import directive and smart 
 * pointers.
 * 
 * \param lpParam
 * \returns
 * The prototype of a function that serves as the starting address for a 
 * thread
 */
DWORD WINAPI ImportPowerPoint(LPVOID lpParam);