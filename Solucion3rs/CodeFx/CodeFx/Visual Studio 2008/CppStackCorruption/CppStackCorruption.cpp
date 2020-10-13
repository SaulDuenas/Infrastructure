/****************************** Module Header ******************************\
* Module Name:	CppStackCorruption.cpp
* Project:		CppStackCorruption
* Copyright (c) Microsoft Corporation.
* 
* CppStackCorruption is designed to show stack corruption and its 
* consequences. It demonstrates the two typical situations of statck 
* corruption: 
* 
* A. Stack Overrun
*    1. Array indexing errors cause the stack overrun.
*    2. Static buffer overrun on the stack.
* 
* B. Calling Convention Mismatch
* 
* You can run the example in either Debug or Release mode. The Release 
* configuration is better because the disassembly is simpler and the asserts 
* are off. In this example, we also disable the optimizations in the Release 
* configuration. It makes sure that the sample functions are run by the 
* processor.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/2/2009 12:28 AM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include <windows.h>
#pragma endregion


#pragma region ArrayIndexingError

__declspec(naked) void MaliciousCodes()
{
	// __declspec(naked) indicates the compiler to not create epilog and 
	// prolog to this function. In MaliciousCodes, we do not need prolog 
	// because we reuse the prolog of _tmain.

	_putts(_T("MaliciousCodes"));

	// Standard epilog
	_asm mov	esp,ebp 
	_asm pop	ebp  
	_asm ret
}

/*!
* \brief
* Array indexing errors are a source of memory overruns. Careful bounds 
* checking and index management will help prevent this type of memory 
* overrun.
*/
void ArrayIndexingError()
{
	int n[2];

	// Valid assignments
	n[0] = 0xBAD1;
	n[1] = 0xBAD2;


	// a) Redirect the processor to malicious codes by setting the return 
	// address of the function to be the address of malicious codes in the 
	// memory.

#ifdef _DEBUG	// Debug Build
	n[4] = (int)&MaliciousCodes;	// [ebp+4] = addr of MaliciousCodes
#else	// Release Build
	n[3] = (int)&MaliciousCodes;	// [ebp+4] = addr of MaliciousCodes
#endif

	// [-or-]

	// b) Cause AV-crash when the function returns by setting the return 
	// address and the saved EBP to be invalid values.

#ifdef _DEBUG	// Debug Build
	//// Stack corruption of saved EBP
	//n[3] = 0xBAD3;	// [ebp] = 0xBAD3
	//// Stack corruption of the return address of the current function
	//n[4] = 0xBAD4;	// [ebp+4] = 0xBAD4
#else	// Release Build
	//// Stack corruption of saved EBP
	//n[2] = 0xBAD3;	// [ebp] = 0xBAD3
	//// Stack corruption of the return address of the current function
	//n[3] = 0xBAD4;	// [ebp+4] = 0xBAD4
#endif
}

#pragma endregion


#pragma region StaticBufferOverrun

/*!
* \brief
* A static buffer overrun occurs when a buffer, which has been declared on 
* the stack, is written to with more data than it was allocated to hold. The 
* less apparent versions of this error occur when unverified user input data 
* is copied directly to a static variable, causing potential stack 
* corruption.
* 
* \param pszSource
* The source string to be copied to the local buffer.
*/
void StaticBufferOverrun(TCHAR* pszSource)
{
	TCHAR szCopy[10];

	// The act of copying this data, using operations such as CopyMemory, 
	// strcat, strcpy, or wcscpy, can create unanticipated results, which 
	// allows for stack corruption, when the size of the source is larger 
	// than that of the declared buffer on the stack.
	_tcscpy(szCopy, pszSource);
}

#pragma endregion


#pragma region CallingConventionMismatch

// The declarations of the functions with the wrong calling convention
typedef void	(_cdecl* LPFNSTDHELLOWORLD1)	(_TCHAR**);

/*!
* \brief
* When the called function takes parameters, the mismatch of the calling 
* convention results in the incorrect cleanup of the stack for parameters:
* 
* 1. The caller uses _cdecl to call a _stdcall function:
* The stack space for the function parameters is double freed.
* 
* 2. The caller uses _stdcall to call a _cdecl function:
* The stack space for the function parameters is not freed by mistake.
* 
* The concequence of the mismatch of the calling convention is unpredictable. 
* It may crash the application soon after the function returns, or it may 
* have no impact on the process's execution at all.
*/
void CallingConventionMismatch()
{
	// Dynamically load the library.
	HINSTANCE hModule = LoadLibrary(_T("CppDllExport"));

	if (hModule != NULL)
	{
		// Call a _stdcall method exported from the DLL with the wrong 
		// calling convention: _cdecl.
		LPFNSTDHELLOWORLD1 lpfnStdHelloWorld1 = (LPFNSTDHELLOWORLD1)
			GetProcAddress(hModule, "StdHelloWorld1");

		_TCHAR* result;
		lpfnStdHelloWorld1(&result);
		_tprintf(_T("Call StdHelloWorld1 => %s\n"), result);
	}
}

#pragma endregion


int _tmain(int argc, _TCHAR* argv[])
{
	// Typical situation 1)
	// Array indexing errors cause the stack overrun.
	ArrayIndexingError();

	// Typical situation 2)
	// Static buffer overrun on the stack.
	TCHAR* pszSource = _T("0123456789A");
	StaticBufferOverrun(pszSource);

	// Typical situation 3)
	// Calling convention mismatch causes the stack corruption.
	CallingConventionMismatch();

	return 0;
}