// stdafx.cpp : source file that includes just the standard includes
// CppAutomateExcel.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"

// TODO: reference any additional headers you need in STDAFX.H
// and not in this file


HRESULT SafeArrayPutNames(SAFEARRAY *psa, LONG index, WCHAR* pwszFirstName, 
						  WCHAR* pwszLastName)
{
	HRESULT hr;

	// Set the first name.
	long indices1[] = {index, 1};
	VARIANT vtFirstName;
	vtFirstName.vt = VT_BSTR;
	vtFirstName.bstrVal = ::SysAllocString(pwszFirstName);
	// copies the VARIANT into the SafeArray
	hr = SafeArrayPutElement(psa, indices1, (void*)&vtFirstName);
	VariantClear(&vtFirstName);

	if (FAILED(hr))
		return 1;

	// Set the last name.
	long indices2[] = {index, 2};
	VARIANT vtLastName;
	vtLastName.vt = VT_BSTR;
	vtLastName.bstrVal = ::SysAllocString(pwszLastName);
	hr = SafeArrayPutElement(psa, indices2, (void*)&vtLastName);
	VariantClear(&vtLastName);

	return hr;
}


HRESULT GetModuleDirectoryW(WCHAR* pwszDir, DWORD nSize)
{
	// Retrieves the path of the executable file of the current process.
	nSize = GetModuleFileNameW(NULL, pwszDir, nSize);
	if (!nSize || GetLastError() == ERROR_INSUFFICIENT_BUFFER)
	{
		*pwszDir = '\0'; // Ensure it's NULL terminated
		return S_FALSE;
	}

	// Run through looking for the last slash in the file path.
    // When we find it, NULL it to truncate the following filename part.

    for (int index = nSize - 1; index >= 0; index --)
	{
        if (pwszDir[index] == '\\' || pwszDir[index] == '/')
		{
			pwszDir[index + 1] = '\0';
            break;
		}
    }
	return S_OK;
}