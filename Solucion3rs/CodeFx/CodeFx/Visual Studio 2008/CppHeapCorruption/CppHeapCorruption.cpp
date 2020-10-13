/****************************** Module Header ******************************\
* Module Name:	CppHeapCorruption.cpp
* Project:		CppHeapCorruption
* Copyright (c) Microsoft Corporation.
* 
* CppHeapCorruption is designed to show heap corruption and its consequences.
* It demonstrates four typical situations of heap corruption: 
* 
* A. Using Uninitialied State
* 
* B. Heap Overrun and Underrun
* 
* C. Heap Handle Mismatch
* 
* D. Heap Reuse After Deletion
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 4/20/2009 12:21 AM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include <windows.h>
#pragma endregion


#pragma region UseUninitializedMemory

/*!
* \brief
* Uninitialized state is a common programming mistake that can lead to 
* numerous hours of debugging to track down. Fundamentally, uninitialized 
* state refers to a block of memory that has been successfully allocated but 
* not yet initialized to a state in which it is considered valid for use. The 
* memory block can range from simple native data types, such as integers, to 
* complex data blobs. Using an uninitialized memory block results in 
* unpredictable behavior.
*/
void UseUninitializedMemory()
{
	// Allocate an array of integer pointers in the process heap.
	int** pPtrArray = (int** )HeapAlloc(GetProcessHeap(), 0, sizeof(int* [10]));
	if (pPtrArray == NULL)
	{
		_tprintf(_T("HeapAlloc failed w/err 0x%08lx\n"), GetLastError());
		return;
	}

	// After the successful allocation of memory for the pointer array, the  
	// memory contains random pointers that are not valid for use. Heap 
	// corruption may happen without the following initialization of the 
	// pointers. The application might experience an access violation if the 
	// address pointed by the pointer is invalid (in the sense that it is not 
	// accessible memory), or it might succeed and gives unpredictable result 
	// if the pointer is pointing to a valid address used elsewhere.
	/*
	// Initialize all elements in the array with valid integer pointers.
	for (int i = 0; i < 10; i++)
	{
		// Allocate memory for the integer.
		pPtrArray[i] = (int* )HeapAlloc(GetProcessHeap(), 0, sizeof(int));
	}
	*/

	// Dereference the first pointer and set its value to 10.
	*(pPtrArray[0]) = 10;

	/*
	// Uninitialize all elements in the array.
	for (int i = 0; i < 10; i++)
	{
		HeapFree(GetProcessHeap(), 0, pPtrArray[i]);
	}
	*/

	// Free the allocated memory of the array.
	HeapFree(GetProcessHeap(), 0, pPtrArray);
}

#pragma endregion


#pragma region HeapOverrun

/*!
* \brief
* Heap overruns, like static buffer overruns, can lead to memory and stack 
* corruption. Because heap overruns occur in heap memory rather than on the 
* stack, some people consider them to be less able to cause serious problems; 
* nevertheless, heap overruns require real programming care and are just as 
* able to allow system risks as static buffer overruns.
*/
void HeapOverrun()
{
	/////////////////////////////////////////////////////////////////////////
	// Build the heap environment for the example.
	// 

	// Create a private heap.
	HANDLE hHeap = HeapCreate(0, 0, 0);
	if (hHeap == NULL)
	{
		_tprintf(_T("HeapCreate failed w/err 0x%08lx\n"), GetLastError());
		return;
	}
	else
		_tprintf(_T("Create private heap at %08lx\n"), hHeap);

	// Allocate 16 bytes + 8 bytes(block header) in the heap.
	char* p1 = (char* )HeapAlloc(hHeap, 0, 16);
	_tprintf(_T("Allocate heap block at %p\n"), p1);

	// Allocate 24 bytes + 8 bytes(block header) next to the above allocation.
	char* p2 = (char* )HeapAlloc(hHeap, 0, 24);
	_tprintf(_T("Allocate heap block at %p\n"), p2);

	// Free the first 16 + 8 bytes heap block.
	_tprintf(_T("Free heap block at %p\n"), p1);
	HeapFree(hHeap, 0, p1);


	/////////////////////////////////////////////////////////////////////////
	// Overrun the heap by overwriting data to the adjacent blocks.
	// 

	// Allocate 16 bytes + 8 bytes(block header) in the heap. The previously 
	// freed block of 16 bytes will be reused.
	char* p = (char* )HeapAlloc(hHeap, 0, 16);
	_tprintf(_T("Allocate heap block at %p\n"), p);

	_putts(_T("Heap overrun ..."));

	// a) Heap overrun caused by the incorrect size
	//ZeroMemory(p, 24);		// Overwrite to the next block pointed by p2

	// [-or-]

	// b) Heap overrun when a buffer is written to with more data than it was 
	// allocated to hold, using operations such as CopyMemory, strcat, strcpy, 
	// or wcscpy.
	// The source string can be user's input or the argument of the process.
	CHAR* pszSource = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	strcpy(p, pszSource);	// Overwrite to the next block pointed by p2

	// So far, no crash happens ...

	// Free the allocated memory. It may trigger Access Violation.
	_tprintf(_T("Free heap block at %p\n"), p);
	HeapFree(hHeap, 0, p);


	/////////////////////////////////////////////////////////////////////////
	// Clean up the heap environment.
	// 

	// Free the block that has been overrun. It may trigger Access Violation.
	_tprintf(_T("Free heap block at %p\n"), p2);
	HeapFree(hHeap, 0, p2);

	// Destroy the private heap.
	_tprintf(_T("Destroy private heap at %08lx\n"), hHeap);
	HeapDestroy(hHeap);
}

#pragma endregion


#pragma region HeapHandleMismatch

/*!
* \brief
* The heap manager keeps a list of active heaps in a process. The heaps are 
* considered separate entities in the sense that the internal per-heap state 
* is only valid within the context of that particular heap. Developers 
* working with the heap manager must take great care to respect this 
* separation by ensuring that the correct heaps are used when allocating and 
* freeing heap memory. The separation is exposed to the developer by using 
* heap handles in the heap API calls. Each heap handle uniquely represents a
* particular heap in the list of heaps for the process. If the uniqueness is 
* broken, heap corruption will ensue.
*/
void HeapHandleMismatch()
{
	// Allocate 16 bytes + 8 bytes(block header) in the process heap.
	char* p = (char* )HeapAlloc(GetProcessHeap(), 0, 16);
	_tprintf(_T("Allocate heap block at %p\n"), p);

	// Free the memory in the CRT heap that mismatches the heap of the 
	// allocation.
	_tprintf(_T("Free heap block at %p\n"), p);
	free(p);
}

#pragma endregion


#pragma region HeapReuseAfterDeletion

/*!
* \brief
* Next to heap overruns, heap reuse after deletion is the second most common 
* source of heap corruptions. After a heap block has been freed, it is put on 
* the free lists (or look aside list) by the heap manager. From there on, it 
* is considered invalid for use by the application. If an application uses 
* the free block in any way, e.g. free the block again, the state of the 
* block on the free list will most likely be corrupted.
*/
void HeapReuseAfterDeletion()
{
	/////////////////////////////////////////////////////////////////////////
	// Build the heap environment for the example.
	// 

	// Create a private heap.
	HANDLE hHeap = HeapCreate(0, 0, 0);
	if (hHeap == NULL)
	{
		_tprintf(_T("HeapCreate failed w/err 0x%08lx\n"), GetLastError());
		return;
	}
	else
		_tprintf(_T("Create private heap at %08lx\n"), hHeap);

	// Allocate three blocks of 24 bytes + 8 bytes(block header) in the heap.
	char* p1 = (char* )HeapAlloc(hHeap, 0, 24);
	_tprintf(_T("Allocate heap block 1 at %p\n"), p1);
	char* p2 = (char* )HeapAlloc(hHeap, 0, 24);
	_tprintf(_T("Allocate heap block 2 at %p\n"), p2);
	char* p3 = (char* )HeapAlloc(hHeap, 0, 24);
	_tprintf(_T("Allocate heap block 3 at %p\n"), p3);


	/////////////////////////////////////////////////////////////////////////
	// Reuse the heap block after freeing.
	// 

	// Free the heap block 1.
	_tprintf(_T("Free heap block 1 at %p\n"), p1);
	HeapFree(hHeap, 0, p1);

	// After the free, the first two DWORDs of the block body becomes FLINK 
	// and BLINK pointers. The heap manager uses the links to walk the free 
	// entries. 

	// a) Corrupt the FLINK and BLINK pointers
	*((DWORD* )p1) = 0xA;
	*((DWORD* )p1 + 1) = 0xB;

	// [-or-]

	// b) Double free the heap block.
	//HeapFree(hHeap, 0, p1);


	/////////////////////////////////////////////////////////////////////////
	// Clean up the heap environment.
	// 

	// Free the heap block 3. It may cause Access Violation.
	_tprintf(_T("Free heap block 3 at %p\n"), p3);
	HeapFree(hHeap, 0, p3);

	// Free the heap block 2.
	_tprintf(_T("Free heap block 2 at %p\n"), p2);
	HeapFree(hHeap, 0, p2);

	// Destroy the private heap.
	_tprintf(_T("Destroy private heap at %08lx\n"), hHeap);
	HeapDestroy(hHeap);
}

#pragma endregion


int _tmain(int argc, _TCHAR* argv[])
{
	// Attach a debugger to the process.
	__asm int 3

	// Typical situation 1)
	// Using uninitialized memory allocated on the heap.
	UseUninitializedMemory();

	// Typical situation 2)
	// Heap overrun.
	HeapOverrun();

	// Typical situation 3)
	// Heap handle mismatches.
	HeapHandleMismatch();

	// Typical situation 4)
	// Heap reuse after deletion.
	HeapReuseAfterDeletion();

	return 0;
}