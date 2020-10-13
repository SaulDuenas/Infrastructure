'****************************** Module Header ******************************'
' Module Name:	CFDInBCLForm.vb
' Project:		VBShellCommonFileDialog
' Copyright (c) Microsoft Corporation.
' 
' 
' 
' This source is subject to the Microsoft Public License.
' See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
' All other rights reserved.
' 
' History:
' * 10/24/2009 9:42 PM Jialiang Ge Created
'***************************************************************************'

#Region "Imports directives"

Imports Microsoft.WindowsAPICodePack.Shell

#End Region


Public Class CFDInBCLForm

#Region "Common Open File Dialogs"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub btnOpenAFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
    Handles btnOpenAFile.Click

        ' Create a new common open file dialog
        Dim openFileDialog As New OpenFileDialog

        ' (Optional) Set the title of the dialog
        openFileDialog.Title = "Select a File"

        ' (Optional) Control the default folder of the file dialog. 
        ' Here we set it as the Music library knownfolder
        openFileDialog.InitialDirectory = KnownFolders.MusicLibrary.Path

        ' (Optional) Specify file types for the file dialog, and set 
        ' the selected file type index to Word Document.
        openFileDialog.Filter = "Word Files (*.docx)|*.docx|" & _
            "Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
        openFileDialog.FilterIndex = 1

        ' (Optional) Set the default extension to be added as ".docx"
        openFileDialog.DefaultExt = "docx"

        ' Show the dialog
        If openFileDialog.ShowDialog() = DialogResult.OK Then
            ' Get the selection from the user
            MessageBox.Show(openFileDialog.FileName, "The selected file is")
        End If

    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub btnOpenFiles_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
    Handles btnOpenFiles.Click

    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub btnOpenAFolder_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
    Handles btnOpenAFolder.Click

    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub btnAddCustomControls_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
    Handles btnAddCustomControls.Click

    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub btnAddCommonPlaces_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
    Handles btnAddCommonPlaces.Click

    End Sub

#End Region


#Region "Common Save File Dialogs"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub btnSaveAFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) _
    Handles btnSaveAFile.Click

    End Sub

#End Region

End Class