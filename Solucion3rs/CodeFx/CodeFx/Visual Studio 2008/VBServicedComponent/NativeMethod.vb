﻿'****************************** Module Header ******************************'
' Module Name:	NativeMethod.vb
' Project:		VBServicedComponent
' Copyright (c) Microsoft Corporation.
' 
' The P/Invoke signatures of some native APIs.
' 
' This source is subject to the Microsoft Public License.
' See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
' All other rights reserved.
' 
' History:
' * 3/28/2009 4:12 PM Jialiang Ge Created
'***************************************************************************'

#Region "Imports directives"

Imports System.Runtime.InteropServices

#End Region


''' <summary>
''' Native methods
''' </summary>
''' <remarks></remarks>
Friend Class NativeMethod

    ''' <summary>
    ''' Get current process ID.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <DllImport("kernel32.dll", EntryPoint:="GetCurrentProcessId")> _
    Friend Shared Function GetCurrentProcessId() As UInteger
    End Function

    ''' <summary>
    ''' Get current thread ID.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    <DllImport("kernel32.dll", EntryPoint:="GetCurrentThreadId")> _
    Friend Shared Function GetCurrentThreadId() As UInteger
    End Function

End Class