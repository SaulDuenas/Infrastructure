/****************************** Module Header ******************************\
* Module Name:	FunctionPointer.cpp
* Project:		CppBasics
* Copyright (c) Microsoft Corporation.
* 
* A function pointer is a type of pointer in C, C++. When dereferenced, a 
* function pointer invokes a function, passing it zero or more arguments just 
* like a normal function. In programming languages like C, function pointers 
* can be used to simplify code by providing a simple way to select a function 
* to execute based on run-time values.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 5/28/2009 9:10 PM Jialiang Ge Created
\***************************************************************************/

#include "stdafx.h"

int F1(int i)
{
	_tprintf(_T("F1 is called (%d)\n"), i);
	return i;
}

int F2(int i)
{
	_tprintf(_T("F2 is called (%d)\n"), i);
	return i;
}

void FunctionPointer(void)
{
	/////////////////////////////////////////////////////////////////////////
	// Function pointer.
	// 

	// Define a function pointer to a function that takes an int argument 
	// and returns an integer
	int (*funcPtr)(int);
	funcPtr = F1;

	// Call the function
	int result = (*funcPtr)(1);


	/////////////////////////////////////////////////////////////////////////
	// Array of function pointer.
	// 

	// Define an array of pointers to functions that take an int argument 
	// and return an integer
	int (*funcTable[])(int) = { F1, F2 };

	// Call the functions in the array
	for (int i = 0; i < 2; i++)
		(funcTable[i])(i + 1);
}