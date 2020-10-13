'****************************** Module Header ******************************'
' Module Name:	VBSimpleClass.vb
' Project:		VBClassLibrary
' Copyright (c) Microsoft Corporation.
' 
' The example creates a class library of VB.NET code and builds it as a .NET 
' DLL assembly that we can re-use in other projects. The process is very 
' straight-forward.
' 
' This source is subject to the Microsoft Public License.
' See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
' All other rights reserved.
' 
' History:
' * 4/6/2009 10:12 PM Jialiang Ge Created
'***************************************************************************'


Public Class VBSimpleClass

    ''' <summary>
    ''' Constructor
    ''' </summary>
    ''' <remarks></remarks>
    Sub New()

    End Sub

    ''' <summary>
    ''' Constructor
    ''' </summary>
    ''' <param name="fVal"></param>
    ''' <remarks></remarks>
    Sub New(ByVal fVal As Single)
        Me.fField = fVal
    End Sub


    ''' <summary>
    ''' Private Shared (Static) Field
    ''' </summary>
    ''' <remarks></remarks>
    Private Shared sbField As Boolean

    ''' <summary>
    ''' Shared (Static) Property
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Property StaticBoolProperty() As Boolean
        Get
            Return sbField
        End Get
        Set(ByVal value As Boolean)
            sbField = value
        End Set
    End Property

    ''' <summary>
    ''' Static Method
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function StaticMethod() As String
        Return "HelloWorld"
    End Function

    ''' <summary>
    ''' Private Instance Field
    ''' </summary>
    ''' <remarks></remarks>
    Private fField As Single = 0.0F

    ''' <summary>
    ''' Instance Property
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property FloatProperty() As Single
        Get
            Return Me.fField
        End Get
        Set(ByVal value As Single)
            Dim cancel As Boolean = False
            ' Raise the event FloatPropertyChanging
            RaiseEvent FloatPropertyChanging(value, cancel)
            If Not cancel Then
                Me.fField = value
            End If
        End Set
    End Property

    ''' <summary>
    ''' Public Instance Method
    ''' </summary>
    ''' <param name="fVal"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function Increment(ByVal fVal As Single) As Single
        Me.fField += fVal
        Return Me.fField
    End Function

    ''' <summary>
    ''' Friend (Internal) Instance Method
    ''' </summary>
    ''' <param name="fVal"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Function InternalIncrement(ByVal fVal As Single) As Single
        Me.fField += fVal
        Return Me.fField
    End Function

    ''' <summary>
    ''' Instance Event
    ''' </summary>
    ''' <param name="NewValue"></param>
    ''' <param name="Cancel"></param>
    ''' <remarks></remarks>
    Public Event FloatPropertyChanging(ByVal NewValue As Single, _
                                       ByRef Cancel As Boolean)

End Class
