/****************************** Module Header ******************************\
* Module Name:	Cathelp.h
* Project:		MFCSafeActiveX
* Copyright (c) Microsoft Corporation.
* 
* A set of helper functions to register (and unregister) a component to be 
* safe for scripting and initialization. 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 2/5/2009 9:44 PM Jialiang Ge Created
\***************************************************************************/

#pragma once

#pragma region Includes
// Include the file that defines the GUID associated with the safety 
// component categories: CATID_SafeForScripting, CATID_SafeForInitializing
#include <objsafe.h>
#pragma endregion


// Helper function to create a component category and associated
// description
HRESULT CreateComponentCategory(CATID catid, WCHAR *catDescription);


// Helper function to register a CLSID as belonging to a component
// category
HRESULT RegisterCLSIDInCategory(REFCLSID clsid, CATID catid);


// Helper function to unregister a CLSID as belonging to a component
// category
HRESULT UnRegisterCLSIDInCategory(REFCLSID clsid, CATID catid);