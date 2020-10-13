/****************************** Module Header ******************************\
* Module Name:	CppShellGetSetFolderCustomSettings.cpp
* Project:		CppShellGetSetFolderCustomSettings
* Copyright (c) Microsoft Corporation.
* 
* 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 11/13/2009 09:00 PM Jialiang Ge Created
\***************************************************************************/

#include "stdafx.h"
#include <shlobj.h>
#include <shlwapi.h>


HRESULT SetFolderIcon(LPCWSTR wszPath, LPWSTR wszExpandedIconPath, int iIcon)
{
	HRESULT hr;

	SHFOLDERCUSTOMSETTINGS fcs = {0};
	fcs.dwSize = sizeof(fcs);
	fcs.dwMask = FCSM_ICONFILE;
	fcs.pszIconFile = wszExpandedIconPath;
	fcs.cchIconFile = 0;
	fcs.iIconIndex = iIcon;

	// Set the folder icon
	hr = SHGetSetFolderCustomSettings(&fcs, wszPath, FCS_FORCEWRITE);

	if (SUCCEEDED(hr))
	{
		// Update the icon cache
		SHFILEINFO sfi;
		hr = SHGetFileInfo(wszPath, 0, &sfi, sizeof(sfi), SHGFI_ICONLOCATION);
		if (SUCCEEDED(hr))
		{
			int iIconIndex = Shell_GetCachedImageIndex(sfi.szDisplayName, sfi.iIcon, 0);
			SHUpdateImage(PathFindFileName(sfi.szDisplayName), sfi.iIcon, 0, iIconIndex);
		}
	}

	return hr;
}


int _tmain(int argc, _TCHAR* argv[])
{
	
	return 0;
}

