/****************************** Module Header ******************************\
* Module Name:	CppSparseFile.cpp
* Project:		CppSparseFile
* Copyright (c) Microsoft Corporation.
* 
* CppSparseFile demonstrates the common operations on sparse files. A sparse 
* file is a type of computer file that attempts to use file system space more 
* efficiently when blocks allocated to the file are mostly empty. This is 
* achieved by writing brief information (metadata) representing the empty 
* blocks to disk instead of the actual "empty" space which makes up the 
* block, using less disk space. You can find in this example the creation of 
* sparse file, the detection of sparse attribute, the retrieval of sparse 
* file size, and the query of sparse file layout.
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 7/4/2009 12:21 AM Jialiang Ge Created
\***************************************************************************/

#pragma region Includes
#include "stdafx.h"
#include <windows.h>
#include <assert.h>
#pragma endregion


/*!
* VolumeSupportsSparseFiles determines if the volume supports sparse streams.
* 
* \param lpRootPathName
* Volume root path e.g. C:\
*/
BOOL VolumeSupportsSparseFiles(LPCTSTR lpRootPathName)
{
	DWORD dwVolFlags;
	GetVolumeInformation(lpRootPathName, NULL, MAX_PATH, NULL, NULL, 
		&dwVolFlags, NULL, MAX_PATH);

	return (dwVolFlags & FILE_SUPPORTS_SPARSE_FILES) ? TRUE : FALSE;
}


/*!
* IsSparseFile determines if a file is sparse.
* 
* \param lpFileName
* File name
*/
BOOL IsSparseFile(LPCTSTR lpFileName)
{
	// Open the file for read
	HANDLE hFile = CreateFile(lpFileName, GENERIC_READ, 0, NULL, 
		OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE)
		return FALSE;

	// Get file information
	BY_HANDLE_FILE_INFORMATION bhfi;
	GetFileInformationByHandle(hFile, &bhfi);
	CloseHandle(hFile);

	return (bhfi.dwFileAttributes & FILE_ATTRIBUTE_SPARSE_FILE) 
		? TRUE : FALSE;
}


/*!
* Get sparse file sizes.
* 
* \param lpFileName
* File name
* 
* \see
* http://msdn.microsoft.com/en-us/library/aa365276.aspx
*/
BOOL GetSparseFileSize(LPCTSTR lpFileName)
{
	// Retrieves the size of the specified file, in bytes. The size includes 
	// both allocated ranges and sparse ranges.
	HANDLE hFile = CreateFile(lpFileName, GENERIC_READ, 0, NULL, 
		OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE)
		return FALSE;	
	LARGE_INTEGER liSparseFileSize;
	GetFileSizeEx(hFile, &liSparseFileSize);
	
	// Retrieves the file's actual size on disk, in bytes. The size does not 
	// include the sparse ranges.
	LARGE_INTEGER liSparseFileCompressedSize;
	liSparseFileCompressedSize.LowPart = GetCompressedFileSize(lpFileName, 
		(LPDWORD)&liSparseFileCompressedSize.HighPart);

	// Print the result
	_tprintf(_T("\nFile total size: %I64uKB\nActual size on disk: %I64uKB\n"), 
		liSparseFileSize.QuadPart / 1024, 
		liSparseFileCompressedSize.QuadPart / 1024);

	CloseHandle(hFile);
	return TRUE;
}


/*!
* Create a sparse file.
* 
* \param lpFileName
* The name of the sparse file
*/
HANDLE CreateSparseFile(LPCTSTR lpFileName)
{
	// Create a normal file
	HANDLE hSparseFile = CreateFile(lpFileName, GENERIC_WRITE, 0, NULL, 
		CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);

	if (hSparseFile == INVALID_HANDLE_VALUE)
		return hSparseFile;

	// Use the DeviceIoControl function with the FSCTL_SET_SPARSE control 
	// code to mark the file as sparse. If you don't mark the file as sparse, 
	// the FSCTL_SET_ZERO_DATA control code will actually write zero bytes to 
	// the file instead of marking the region as sparse zero area.
	DWORD dwTemp;
	DeviceIoControl(hSparseFile, FSCTL_SET_SPARSE, NULL, 0, NULL, 0, &dwTemp, 
		NULL);

	return hSparseFile;
}


/*!
* Converting a file region to A sparse zero area.
* 
* \param hSparseFile
* Handle of the sparse file
* 
* \param start
* Start address of the sparse zero area
* 
* \param size
* Size of the sparse zero block. The minimum sparse size is 64KB.
* 
* \remarks
* Note that SetSparseRange does not perform actual file I/O, and unlike the 
* WriteFile function, it does not move the current file I/O pointer or sets 
* the end-of-file pointer. That is, if you want to place a sparse zero block 
* in the end of the file, you must move the file pointer accordingly using 
* the FileStream.Seek function, otherwise DeviceIoControl will have no effect
*/
void SetSparseRange(HANDLE hSparseFile, LONGLONG start, LONGLONG size)
{
	// Specify the starting and the ending address (not the size) of the 
	// sparse zero block
	FILE_ZERO_DATA_INFORMATION fzdi;
	fzdi.FileOffset.QuadPart = start;
	fzdi.BeyondFinalZero.QuadPart = start + size;
	
	// Mark the range as sparse zero block
	DWORD dwTemp;
	SetLastError(0);
	BOOL R = DeviceIoControl(hSparseFile, FSCTL_SET_ZERO_DATA, &fzdi, sizeof(fzdi), 
		NULL, 0, &dwTemp, NULL);
	DWORD e = GetLastError();
}


/*!
* Query the sparse file layout.
* 
* \param lpFileName
* File name
*/
BOOL GetSparseRanges(LPCTSTR lpFileName)
{
	// Open the file for read
	HANDLE hFile = CreateFile(lpFileName, GENERIC_READ, 0, NULL, 
		OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE)
		return FALSE;

	LARGE_INTEGER liFileSize;
	GetFileSizeEx(hFile, &liFileSize);

	// Range to be examined (the whole file)
	FILE_ALLOCATED_RANGE_BUFFER queryRange;
	queryRange.FileOffset.QuadPart = 0;
	queryRange.Length = liFileSize;

	// Allocated areas info
	FILE_ALLOCATED_RANGE_BUFFER allocRanges[1024];

	DWORD nbytes;
	BOOL bFinished;
	_putts(_T("\nAllocated ranges in the file:"));
	do
	{
		bFinished = DeviceIoControl(hFile, FSCTL_QUERY_ALLOCATED_RANGES, 
			&queryRange, sizeof(queryRange), allocRanges, 
			sizeof(allocRanges), &nbytes, NULL);

		if (!bFinished)
		{
			DWORD dwError = GetLastError();

			// ERROR_MORE_DATA is the only error that is normal
			if (dwError != ERROR_MORE_DATA)
			{
				_tprintf(_T("DeviceIoControl failed w/err 0x%08lx\n"), dwError);
				CloseHandle(hFile);
				return FALSE;
			}
		}

		// Calculate the number of records returned
		DWORD dwAllocRangeCount = nbytes / 
			sizeof(FILE_ALLOCATED_RANGE_BUFFER);

		// Print each allocated range
		for (DWORD i = 0; i < dwAllocRangeCount; i++)
		{
			_tprintf(_T("allocated range: [%I64u] [%I64u]\n"), 
				allocRanges[i].FileOffset.QuadPart, 
				allocRanges[i].Length.QuadPart);
		}

		// Set starting address and size for the next query
		if (!bFinished && dwAllocRangeCount > 0)
		{
			queryRange.FileOffset.QuadPart = 
				allocRanges[dwAllocRangeCount - 1].FileOffset.QuadPart + 
				allocRanges[dwAllocRangeCount - 1].Length.QuadPart;
			
			queryRange.Length.QuadPart = liFileSize.QuadPart - 
				queryRange.FileOffset.QuadPart;
		}

	} while (!bFinished);

	CloseHandle(hFile);
	return TRUE;
}


int _tmain(int argc, _TCHAR* argv[])
{
	/////////////////////////////////////////////////////////////////////////
	// Determine if the volume support sparse streams.
	// 

	if (!VolumeSupportsSparseFiles(_T("C:\\")))
	{
		_tprintf(_T("Volume %s does not support sparse streams\n"), 
			_T("C:\\"));
		return 1;
	}


	/////////////////////////////////////////////////////////////////////////
	// Create a sparse file.
	// 

	LPCTSTR lpFileName = _T("SparseFile.tmp");
	_tprintf(_T("Create sparse file: %s\n"), lpFileName);

	HANDLE hSparseFile = CreateSparseFile(lpFileName);
	if (hSparseFile == INVALID_HANDLE_VALUE)
	{
		_tprintf(_T("CreateFile failed w/err 0x%08lx\n"), GetLastError());
		return 1;
	}

	// Write a large block of data

	const DWORD dwBlockLength = 512 * 1024; // 512KB
	BYTE* lpBlock = new BYTE[dwBlockLength];
	for (DWORD i = 0; i < dwBlockLength; i++)
		lpBlock[i] = 0xFF;
	DWORD dwBytesWritten;
	WriteFile(hSparseFile, lpBlock, dwBlockLength, &dwBytesWritten, NULL);
	delete[] lpBlock;

	// Set some sparse ranges in the block

	SetSparseRange(hSparseFile, 0, 64 * 1024 /*64KB*/);
	SetSparseRange(hSparseFile, 128 * 1024, 128 * 1024);

	// Set sparse block at the end of the file

	// 1GB sparse zeros are extended to the end of the file
	SetFilePointer(hSparseFile, 0x40000000 /*1GB*/, NULL, FILE_END);
	SetEndOfFile(hSparseFile);

	// Flush and close the file
	CloseHandle(hSparseFile);


	/////////////////////////////////////////////////////////////////////////
	// Determine if a file is sparse.
	// 

	BOOL bIsSparse = IsSparseFile(lpFileName);
	_tprintf(_T("The file is%s sparse\n"), bIsSparse ? _T("") : _T(" not"));


	/////////////////////////////////////////////////////////////////////////
	// Get file size.
	// 

	GetSparseFileSize(lpFileName);


	/////////////////////////////////////////////////////////////////////////
	// Query the sparse file layout.
	// 

	GetSparseRanges(lpFileName);


	return 0;
}