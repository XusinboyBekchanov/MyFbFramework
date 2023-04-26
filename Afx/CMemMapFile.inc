' ########################################################################################
' Microsoft Windows
' File: CMemMapFile.inc
' Contents: Memory Mapped Files
' Based on CMemMapFle, a freeware C++ class written by P.J. Naughter.
' http://www.naughter.com/memmap.html
' Adapted to Free Basic with his kind permission.
' Compiler: FreeBasic 32 & 64-bit
' Copyright (c) 2018 José Roca. Freeware. Use at your own risk.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#pragma once
#include once "windows.bi"
#include once "win/winioctl.bi"
#include once "Afx/AfxWin.inc"

NAMESPACE Afx

' ========================================================================================
' CMemMapFile class
' ========================================================================================
TYPE CMemMapFile

Private:

   DIM m_hFile AS HANDLE      ' // File hande
   DIM m_hMapping AS HANDLE   ' // File mapping handle
   DIM m_pData AS ANY PTR     ' // Pointer to the data
   DIM m_hMutex AS HANDLE     ' // Mutex handle

Public:
   DECLARE CONSTRUCTOR
   DECLARE DESTRUCTOR
   DECLARE FUNCTION MapFile (BYVAL pwszFileName AS WSTRING PTR, BYVAL bReadOnly AS BOOLEAN = FALSE, _
      BYVAL dwShareMode AS DWORD = 0, BYVAL bGrowable AS BOOLEAN = FALSE, _
      BYVAL pwszMappingName AS WSTRING PTR = NULL, BYVAL pwszMutexName AS WSTRING PTR = NULL, _
      BYVAL dwStartOffset  AS CONST LONGINT = 0, BYVAL nNumberOfBytesToMap AS CONST SIZE_T = 0, _
      BYVAL lpSecurityAttributes AS LPSECURITY_ATTRIBUTES = NULL) AS BOOLEAN
   DECLARE FUNCTION MapMemory (BYVAL pwszMappingName AS WSTRING PTR, BYVAL pwszMutexName AS WSTRING PTR, _
      BYVAL nBytesToMap AS SIZE_T, BYVAL bReadOnly AS BOOLEAN = FALSE, _
      BYVAL dwStartOffset AS CONST LONGINT = 0, BYVAL lpSecurityAttributes AS LPSECURITY_ATTRIBUTES = NULL) AS BOOLEAN
   DECLARE FUNCTION MapSharedMemory (BYVAL pwszMappingName AS WSTRING PTR, BYVAL pwszMutexName AS WSTRING PTR, _
      BYVAL nBytesToMap AS SIZE_T, BYVAL bReadOnly AS BOOLEAN = FALSE, _
      BYVAL bInheritHandle AS BOOLEAN = FALSE, BYVAL dwStartOffset AS CONST LONGINT = 0, _
      BYVAL lpSecurityAttributes AS LPSECURITY_ATTRIBUTES = NULL) AS BOOLEAN
   DECLARE SUB Unmap
   DECLARE FUNCTION AccessData (BYVAL dwTimeout AS DWORD = INFINITE) AS ANY PTR
   DECLARE FUNCTION UnaccessData () AS BOOLEAN
   DECLARE FUNCTION Flush () AS BOOLEAN
   DECLARE FUNCTION GetFileHandle () AS HANDLE
   DECLARE FUNCTION GetFileMappingHandle () AS HANDLE
   DECLARE FUNCTION GetFileSize () AS LONGINT

END TYPE
' ========================================================================================

' ========================================================================================
' CMemMapFile constructor
' ========================================================================================
PRIVATE CONSTRUCTOR CMemMapFile
   m_hFile = INVALID_HANDLE_VALUE
END CONSTRUCTOR
' ========================================================================================

' ========================================================================================
' CPrint destructor
' ========================================================================================
PRIVATE DESTRUCTOR CMemMapFile
   this.Unmap
END DESTRUCTOR
' ========================================================================================

' ========================================================================================
' Maps the specified file.
' - pwszFileName : The filename to map.
' - bReadOnly : Set it to TRUE if you don't intend to modify the file.
' - dwShareMode : The sharing mode of the file.
'   0 : Prevents other processes from opening a file or device if they request delete,
'   read, or write access.
'   FILE_SHARE_READ : Enables subsequent open operations on a file to request read access.
'   FILE_SHARE_WRITE : Enables subsequent open operations on a file to request write access.
' - bGrowable : IF TRUE, the underlying file will be set to be a sparse file and you
'   won't get access violations if you write past the end of the file (Windows will grow
'   the file silently).
' - pwszMappingName : The name of the file mapping object. If this parameter is NULL, the
'   file mapping object is created without a name.
' - pwszMutexName : The name of the mutex object. The name is limited to MAX_PATH characters.
'   Name comparison is case sensitive. If pwszMutexName is NULL, the mutex object is created
'   without a name.
' - dwStartOffset : The high-order DWORD is the file offset where the view begins.
'   The low-order DWORD is the file offset where the view is to begin.
'   The combination of the high and low offsets must specify an offset within the file mapping.
'   They must also match the memory allocation granularity of the system. That is, the offset
'   must be a multiple of the allocation granularity. To obtain the memory allocation
'   granularity of the system, use the GetSystemInfo function, which fills in the members
'   of a SYSTEM_INFO structure.
' - nBytesToMap : The number of bytes of a file mapping to map to the view.
'   All bytes must be within the maximum size specified by CreateFileMapping. If this
'   parameter is 0 (zero), the mapping extends from the specified offset to the end of
'   the file mapping.
' - lpSecurityAttributes : A pointer to a SECURITY_ATTRIBUTES structure that
'   determines whether a returned handle can be inherited by child processes.
'   The lpSecurityDescriptor member of the SECURITY_ATTRIBUTES structure specifies a
'   security descriptor for a new file mapping object. If lpAttributes is NULL, the handle
'   cannot be inherited and the file mapping object gets a default security descriptor.
' ========================================================================================
FUNCTION CMemMapFile.MapFile (BYVAL pwszFileName AS WSTRING PTR, BYVAL bReadOnly AS BOOLEAN = FALSE, _
   BYVAL dwShareMode AS DWORD = 0, BYVAL bGrowable AS BOOLEAN = FALSE, _
   BYVAL pwszMappingName AS WSTRING PTR = NULL, BYVAL pwszMutexName AS WSTRING PTR = NULL, _
   BYVAL dwStartOffset  AS CONST LONGINT = 0, BYVAL nBytesToMap AS CONST SIZE_T = 0, _
   BYVAL lpSecurityAttributes AS LPSECURITY_ATTRIBUTES = NULL) AS BOOLEAN

   ' // Validate parameters
   IF m_hFile <> INVALID_HANDLE_VALUE THEN RETURN FALSE
   IF m_hMapping <> NULL THEN RETURN FALSE
   IF m_pData <> NULL THEN RETURN FALSE
   IF m_hMutex <> NULL THEN RETURN FALSE
   
   ' //Open the disk file
   DIM dwDesiredAccess AS DWORD
   IF bReadOnly THEN dwDesiredAccess = GENERIC_READ ELSE dwDesiredAccess = GENERIC_READ OR GENERIC_WRITE
   m_hFile = CreateFileW(pwszFilename, dwDesiredAccess, dwShareMode, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
   IF m_hFile = INVALID_HANDLE_VALUE THEN RETURN FALSE

   ' // Create the file mapping object
   DIM dwFileMappingFlags AS DWORD
   IF bReadOnly THEN dwFileMappingFlags = PAGE_READONLY ELSE dwFileMappingFlags = PAGE_READWRITE
   m_hMapping = CreateFileMapping(m_hFile, lpSecurityAttributes, dwFileMappingFlags, 0, 0, pwszMappingName)
   IF m_hMapping = NULL THEN RETURN FALSE

   ' // Make the file sparse, if requested to make the memory mapped file growable
   IF bGrowable THEN
      DIM dwBytesReturned AS DWORD
      IF DeviceIoControl(m_hFile, FSCTL_SET_SPARSE, NULL, 0, NULL, 0, @dwBytesReturned, NULL) = FALSE THEN RETURN FALSE
   END IF

   ' // Maps a view of a file mapping into the address space of a calling process.
   IF bReadOnly THEN dwDesiredAccess = FILE_MAP_READ ELSE dwDesiredAccess = FILE_MAP_WRITE
   m_pData = MapViewOfFile(m_hMapping, dwDesiredAccess, CAST(DWORD, (dwStartOffset AND &hFFFFFFFF00000000) shr 32), CAST(DWORD, (dwStartOffset AND &hFFFFFFFF)), nBytesToMap)
   IF m_pData = NULL THEN RETURN FALSE

   ' // Create the mutex to synchronize access
   m_hMutex = CreateMutexW(lpSecurityAttributes, FALSE, pwszMutexName)
   IF m_hMutex = NULL THEN RETURN FALSE

   RETURN TRUE

END FUNCTION
' ========================================================================================

' ========================================================================================
' Maps the specified amount of memory.
' - pwszMappingName : The name of the file mapping object. If this parameter is NULL, the
'   file mapping object is created without a name.
' - pwszMutexName : The name of the mutex object. The name is limited to MAX_PATH characters.
'   Name comparison is case sensitive. If pwszMutexName is NULL, the mutex object is created
'   without a name.
' - nBytesToMap : The high-order DWORD is the maximum size of the file mapping object.
'   The low-order DWORD of the maximum size of the file mapping object.
'   If this parameter is 0 (zero), the maximum size of the file mapping object is equal to
'   the current size of the file that hFile identifies.
'   An attempt to map a file with a length of 0 (zero) fails with an error code of
'   ERROR_FILE_INVALID. Applications should test for files with a length of 0 (zero) and
'   reject those files.
' - bReadOnly : Set it to TRUE if you don't intend to modify the memory.
' - dwStartOffset : The high-order DWORD is the file offset where the view begins.
'   The low-order DWORD is the file offset where the view is to begin.
'   The combination of the high and low offsets must specify an offset within the file mapping.
'   They must also match the memory allocation granularity of the system. That is, the offset
'   must be a multiple of the allocation granularity. To obtain the memory allocation
'   granularity of the system, use the GetSystemInfo function, which fills in the members
'   of a SYSTEM_INFO structure.
' - lpSecurityAttributes : A pointer to a SECURITY_ATTRIBUTES structure that
'   determines whether a returned handle can be inherited by child processes.
'   The lpSecurityDescriptor member of the SECURITY_ATTRIBUTES structure specifies a
'   security descriptor for a new file mapping object. If lpAttributes is NULL, the handle
'   cannot be inherited and the file mapping object gets a default security descriptor.
' ========================================================================================
FUNCTION CMemMapFile.MapMemory (BYVAL pwszMappingName AS WSTRING PTR, BYVAL pwszMutexName AS WSTRING PTR, _
   BYVAL nBytesToMap AS SIZE_T, BYVAL bReadOnly AS BOOLEAN = FALSE, BYVAL dwStartOffset AS CONST LONGINT = 0, _
   BYVAL lpSecurityAttributes AS LPSECURITY_ATTRIBUTES = NULL) AS BOOLEAN

   ' // Validate parameters
   IF m_hMapping <> NULL THEN RETURN FALSE
   IF m_pData <> NULL THEN RETURN FALSE
   IF m_hMutex <> NULL THEN RETURN FALSE

   ' // Create the file mapping object
   DIM dwFileMappingFlags AS DWORD
   IF bReadOnly THEN dwFileMappingFlags = PAGE_READONLY ELSE dwFileMappingFlags = PAGE_READWRITE
   m_hMapping = CreateFileMapping(INVALID_HANDLE_VALUE, lpSecurityAttributes, dwFileMappingFlags, _
      CAST(DWORD, ((nBytesToMap AND &hFFFFFFFF00000000) shr 32)), _
      CAST(DWORD, (nBytesToMap & &hFFFFFFFF)), pwszMappingName)
   IF m_hMapping = NULL THEN RETURN FALSE

   ' // Maps a view of a file mapping into the address space of a calling process.
   DIM dwDesiredAccess AS DWORD
   IF bReadOnly THEN dwDesiredAccess = FILE_MAP_READ ELSE dwDesiredAccess = FILE_MAP_WRITE
   m_pData = MapViewOfFile(m_hMapping, dwDesiredAccess, _
      CAST(DWORD, (dwStartOffset AND &hFFFFFFFF00000000) shr 32), _
      CAST(DWORD, (dwStartOffset AND &hFFFFFFFF)), nBytesToMap)
   IF m_pData = NULL THEN RETURN FALSE

   ' // Create the mutex to synchronize access
   m_hMutex = CreateMutexW(lpSecurityAttributes, FALSE, pwszMutexName)
   IF m_hMutex = NULL THEN RETURN FALSE

   RETURN TRUE

END FUNCTION
' ========================================================================================

' ========================================================================================
' Maps shared memory.
' - pwszMappingName : The name of the file mapping object. If this parameter is NULL, the
'   file mapping object is created without a name.
' - pwszMutexName : The name of the mutex object. The name is limited to MAX_PATH characters.
'   Name comparison is case sensitive. If pwszMutexName is NULL, the mutex object is created
'   without a name.
' - nBytesToMap : Number of bytes to map.
' - bReadOnly : Set it to TRUE if you don't intend to modify the memory.
' - bInheritHandle : If this parameter is TRUE, a process created by the CreateProcess
'   function can inherit the handle; otherwise, the handle cannot be inherited.
' - dwStartOffset : The high-order DWORD is the file offset where the view begins.
'   The low-order DWORD is the file offset where the view is to begin.
'   The combination of the high and low offsets must specify an offset within the file mapping.
'   They must also match the memory allocation granularity of the system. That is, the offset
'   must be a multiple of the allocation granularity. To obtain the memory allocation
'   granularity of the system, use the GetSystemInfo function, which fills in the members
'   of a SYSTEM_INFO structure.
' - lpSecurityAttributes : A pointer to a SECURITY_ATTRIBUTES structure that
'   determines whether a returned handle can be inherited by child processes.
'   The lpSecurityDescriptor member of the SECURITY_ATTRIBUTES structure specifies a
'   security descriptor for a new file mapping object. If lpAttributes is NULL, the handle
'   cannot be inherited and the file mapping object gets a default security descriptor.
' ========================================================================================
FUNCTION CMemMapFile.MapSharedMemory (BYVAL pwszMappingName AS WSTRING PTR, BYVAL pwszMutexName AS WSTRING PTR, _
   BYVAL nBytesToMap AS SIZE_T, BYVAL bReadOnly AS BOOLEAN = FALSE, _
   BYVAL bInheritHandle AS BOOLEAN = FALSE, BYVAL dwStartOffset AS CONST LONGINT = 0, _
   BYVAL lpSecurityAttributes AS LPSECURITY_ATTRIBUTES = NULL) AS BOOLEAN

   ' // Validate parameters
   IF m_hMapping <> NULL THEN RETURN FALSE
   IF m_pData <> NULL THEN RETURN FALSE
   IF m_hMutex <> NULL THEN RETURN FALSE

   ' // Open the file mapping object
   DIM dwDesiredAccess AS DWORD
   IF bReadOnly THEN dwDesiredAccess = FILE_MAP_READ ELSE dwDesiredAccess = FILE_MAP_WRITE
   m_hMapping = OpenFileMappingW(dwDesiredAccess, bInheritHandle, pwszMappingName)
   IF m_hMapping = NULL THEN RETURN FALSE

   m_pData = MapViewOfFile(m_hMapping, dwDesiredAccess, _
      CAST(DWORD, (dwStartOffset AND &hFFFFFFFF00000000) shr 32), _
      CAST(DWORD, (dwStartOffset AND &hFFFFFFFF)), nBytesToMap)
   IF m_pData = NULL THEN RETURN FALSE

   ' // Create the mutex to synchronize access
   m_hMutex = CreateMutexW(lpSecurityAttributes, FALSE, pwszMutexName)
   IF m_hMutex = NULL THEN RETURN FALSE

   RETURN TRUE

END FUNCTION
' ========================================================================================

' ========================================================================================
' Unmaps the file or memory and closes handles.
' ========================================================================================
SUB CMemMapFile.Unmap
   ' // Close the mutex
   IF m_hMutex THEN CloseHandle(m_hMutex)
    '// Unmap the view
   IF m_pData THEN
      FlushViewOfFile(m_pData, 0)
      UnmapViewOfFile(m_pData)
   END IF
   ' // Remove the file mapping
   IF m_hMapping THEN CloseHandle(m_hMapping)
   ' // Close the file
   IF m_hFile THEN CloseHandle(m_hFile)
END SUB
' ========================================================================================

' ========================================================================================
' Returns a pointer to access the data in the memory mapped file.
' - dwTimeout - The time in milliseconds to wait if the mapping is already opened by
'   another thread or process.
' This method uses a mutex to synchronise access to the memory.
' If you use the default value (INFINITE), your thread will be suspended indefinitely if 
' another thread is using the file.
' A successful call to AccessData should be matched with a call to UnaccessData when you
' have fnished accessing the data.
' ========================================================================================
FUNCTION CMemMapFile.AccessData (BYVAL dwTimeout AS DWORD = INFINITE) AS ANY PTR
   IF m_pData = NULL THEN SetLastError(ERROR_INVALID_DATA): RETURN NULL
   IF m_hMutex = NULL THEN RETURN NULL   ' // Mutex should be valid
   ' // Synchronise access to the file using the named mutex
   IF WaitForSingleObject(m_hMutex, dwTimeout) = WAIT_OBJECT_0 THEN RETURN m_pData
   RETURN NULL
END FUNCTION
' ========================================================================================

' ========================================================================================
' After a successful call to AccessData you should call this method when you have fnished
' accessing the data. After calling this method you can call AccessData again to get the
' pointer to the data.
' ========================================================================================
FUNCTION CMemMapFile.UnaccessData () AS BOOLEAN
   IF m_hMutex = NULL THEN RETURN FALSE
   RETURN ReleaseMutex(m_hMutex)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Flushes the data to the disk. When modifying a file through a mapped view, the last
' modification timestamp may not be updated automatically. If required, the caller should
' use SetFileTime to set the timestamp.
' ========================================================================================
FUNCTION CMemMapFile.Flush () AS BOOLEAN
   IF m_pData = NULL THEN SetLastError(ERROR_INVALID_DATA) : RETURN FALSE
   RETURN FlushViewOfFile(m_pData, 0)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the handle of the underlying disk file.
' ========================================================================================
FUNCTION CMemMapFile.GetFileHandle () AS HANDLE
   RETURN m_hFile
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the file mapping handle.
' ========================================================================================
FUNCTION CMemMapFile.GetFileMappingHandle () AS HANDLE
   RETURN m_hMapping
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the size of the underlying disk file.
' ========================================================================================
FUNCTION CMemMapFile.GetFileSize () AS LONGINT
   IF m_hFile = INVALID_HANDLE_VALUE THEN RETURN 0
   DIM li AS LARGE_INTEGER
   IF GetFileSizeEx(m_hFile, @li) THEN RETURN li.QuadPart
END FUNCTION
' ========================================================================================

END NAMESPACE
