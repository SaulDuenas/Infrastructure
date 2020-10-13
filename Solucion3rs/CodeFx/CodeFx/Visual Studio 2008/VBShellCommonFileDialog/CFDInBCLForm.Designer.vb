<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CFDInBCLForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.btnAddCommonPlaces = New System.Windows.Forms.Button
        Me.grpFileSaveDialogs = New System.Windows.Forms.GroupBox
        Me.btnSaveAFile = New System.Windows.Forms.Button
        Me.btnAddCustomControls = New System.Windows.Forms.Button
        Me.label1 = New System.Windows.Forms.Label
        Me.btnOpenAFolder = New System.Windows.Forms.Button
        Me.btnOpenAFile = New System.Windows.Forms.Button
        Me.grpFileOpenDialogs = New System.Windows.Forms.GroupBox
        Me.btnOpenFiles = New System.Windows.Forms.Button
        Me.grpFileSaveDialogs.SuspendLayout()
        Me.grpFileOpenDialogs.SuspendLayout()
        Me.SuspendLayout()
        '
        'btnAddCommonPlaces
        '
        Me.btnAddCommonPlaces.Location = New System.Drawing.Point(153, 86)
        Me.btnAddCommonPlaces.Name = "btnAddCommonPlaces"
        Me.btnAddCommonPlaces.Size = New System.Drawing.Size(138, 30)
        Me.btnAddCommonPlaces.TabIndex = 6
        Me.btnAddCommonPlaces.Text = "Add Common Places"
        Me.btnAddCommonPlaces.UseVisualStyleBackColor = True
        '
        'grpFileSaveDialogs
        '
        Me.grpFileSaveDialogs.Controls.Add(Me.btnSaveAFile)
        Me.grpFileSaveDialogs.Location = New System.Drawing.Point(12, 157)
        Me.grpFileSaveDialogs.Name = "grpFileSaveDialogs"
        Me.grpFileSaveDialogs.Size = New System.Drawing.Size(303, 106)
        Me.grpFileSaveDialogs.TabIndex = 5
        Me.grpFileSaveDialogs.TabStop = False
        Me.grpFileSaveDialogs.Text = "Common Save File Dialog"
        '
        'btnSaveAFile
        '
        Me.btnSaveAFile.Location = New System.Drawing.Point(9, 23)
        Me.btnSaveAFile.Name = "btnSaveAFile"
        Me.btnSaveAFile.Size = New System.Drawing.Size(90, 30)
        Me.btnSaveAFile.TabIndex = 0
        Me.btnSaveAFile.Text = "Save a File"
        Me.btnSaveAFile.UseVisualStyleBackColor = True
        '
        'btnAddCustomControls
        '
        Me.btnAddCustomControls.Location = New System.Drawing.Point(9, 86)
        Me.btnAddCustomControls.Name = "btnAddCustomControls"
        Me.btnAddCustomControls.Size = New System.Drawing.Size(138, 30)
        Me.btnAddCustomControls.TabIndex = 5
        Me.btnAddCustomControls.Text = "Add Custom Controls"
        Me.btnAddCustomControls.UseVisualStyleBackColor = True
        '
        'label1
        '
        Me.label1.AutoSize = True
        Me.label1.Location = New System.Drawing.Point(6, 63)
        Me.label1.Name = "label1"
        Me.label1.Size = New System.Drawing.Size(142, 13)
        Me.label1.TabIndex = 4
        Me.label1.Text = "Customized Open File Dialog"
        '
        'btnOpenAFolder
        '
        Me.btnOpenAFolder.Location = New System.Drawing.Point(201, 23)
        Me.btnOpenAFolder.Name = "btnOpenAFolder"
        Me.btnOpenAFolder.Size = New System.Drawing.Size(90, 30)
        Me.btnOpenAFolder.TabIndex = 2
        Me.btnOpenAFolder.Text = "Open a Folder"
        Me.btnOpenAFolder.UseVisualStyleBackColor = True
        '
        'btnOpenAFile
        '
        Me.btnOpenAFile.Location = New System.Drawing.Point(9, 23)
        Me.btnOpenAFile.Name = "btnOpenAFile"
        Me.btnOpenAFile.Size = New System.Drawing.Size(90, 30)
        Me.btnOpenAFile.TabIndex = 0
        Me.btnOpenAFile.Text = "Open a File"
        Me.btnOpenAFile.UseVisualStyleBackColor = True
        '
        'grpFileOpenDialogs
        '
        Me.grpFileOpenDialogs.Controls.Add(Me.btnAddCommonPlaces)
        Me.grpFileOpenDialogs.Controls.Add(Me.btnAddCustomControls)
        Me.grpFileOpenDialogs.Controls.Add(Me.label1)
        Me.grpFileOpenDialogs.Controls.Add(Me.btnOpenAFolder)
        Me.grpFileOpenDialogs.Controls.Add(Me.btnOpenFiles)
        Me.grpFileOpenDialogs.Controls.Add(Me.btnOpenAFile)
        Me.grpFileOpenDialogs.Location = New System.Drawing.Point(12, 12)
        Me.grpFileOpenDialogs.Name = "grpFileOpenDialogs"
        Me.grpFileOpenDialogs.Size = New System.Drawing.Size(303, 130)
        Me.grpFileOpenDialogs.TabIndex = 4
        Me.grpFileOpenDialogs.TabStop = False
        Me.grpFileOpenDialogs.Text = "Common Open File Dialog"
        '
        'btnOpenFiles
        '
        Me.btnOpenFiles.Location = New System.Drawing.Point(105, 23)
        Me.btnOpenFiles.Name = "btnOpenFiles"
        Me.btnOpenFiles.Size = New System.Drawing.Size(90, 30)
        Me.btnOpenFiles.TabIndex = 1
        Me.btnOpenFiles.Text = "Open Files"
        Me.btnOpenFiles.UseVisualStyleBackColor = True
        '
        'CFDInBCLForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(327, 275)
        Me.Controls.Add(Me.grpFileSaveDialogs)
        Me.Controls.Add(Me.grpFileOpenDialogs)
        Me.Name = "CFDInBCLForm"
        Me.Text = "Common File Dialog in BCL"
        Me.grpFileSaveDialogs.ResumeLayout(False)
        Me.grpFileOpenDialogs.ResumeLayout(False)
        Me.grpFileOpenDialogs.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Private WithEvents btnAddCommonPlaces As System.Windows.Forms.Button
    Private WithEvents grpFileSaveDialogs As System.Windows.Forms.GroupBox
    Private WithEvents btnSaveAFile As System.Windows.Forms.Button
    Private WithEvents btnAddCustomControls As System.Windows.Forms.Button
    Private WithEvents label1 As System.Windows.Forms.Label
    Private WithEvents btnOpenAFolder As System.Windows.Forms.Button
    Private WithEvents btnOpenAFile As System.Windows.Forms.Button
    Private WithEvents grpFileOpenDialogs As System.Windows.Forms.GroupBox
    Private WithEvents btnOpenFiles As System.Windows.Forms.Button
End Class
