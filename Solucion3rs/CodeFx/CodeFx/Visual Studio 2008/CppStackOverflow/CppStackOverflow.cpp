/****************************** Module Header ******************************\
* Module Name:	CppStackOverflow.cpp
* Project:		CppStackOverflow
* Copyright (c) Microsoft Corporation.
* 
* StackOverflow is designed to show how stack overflow happens. When a thread 
* is created, 1MB of virtual memory is reserved for use by the thread as a 
* stack. Unlike the heap, it does not expand as needed. Its initial size can 
* be changed via /STACK linker switch (See Project Property Pages / Linker / 
* System / Stack Reserve Size). In the example, we allocate 100K each time 
* through so on the 10th time it will cause a stack overflow exception.
* 
* You can run the example in either Debug or Release mode. In this example, 
* we disable the optimizations in the Release configuration. It makes sure  
* that the sample functions and the memory allocations are processed.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/2/2009 12:30 AM Jialiang Ge Created
\***************************************************************************/

#include "stdafx.h"


void StackOverflow(int level)
{
	// Stack is 1MB by default and unlike the heap, it does not expand as 
	// needed. Its initial size can be changed via /STACK linker switch. 
	// Here we allocate 100K each time through so on the 10th time it will
	// cause a stack overflow exception.

	const int ALLOC_SIZE = 100000;
	char hugeAllocBlock[ALLOC_SIZE];

	// Initialize block with unique characters so you can see each 100K 
	// allocation on the stack.
	for (int i = 0; i < ALLOC_SIZE; i++)
		hugeAllocBlock[i] = (char)level;

	_tprintf(_T("StackOverflow call #: %d\n"), level);

	// Recursively make the call to allocation another ALLOC_SIZE bytes.
	StackOverflow(level + 1);
}

int _tmain(int argc, _TCHAR* argv[])
{
	StackOverflow(0);

	return 0;
}