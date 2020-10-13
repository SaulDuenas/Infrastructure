'****************************** Module Header ******************************'
' Module Name:	MainModule.vb
' Project:		VBExeCOMServer
' Copyright (c) Microsoft Corporation.
' 
' The main entry point for the application. It is responsible for starting  
' the out-of-proc COM server registered in the exectuable.
' 
' This source is subject to the Microsoft Public License.
' See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
' All other rights reserved.
' 
' History:
' * 11/12/2009 12:05 AM Jialiang Ge Created
'***************************************************************************'

Module MainModule

    Sub Main()
        ' Run the out-of-process COM server
        ExeCOMServer.Instance.Run()
    End Sub

End Module
