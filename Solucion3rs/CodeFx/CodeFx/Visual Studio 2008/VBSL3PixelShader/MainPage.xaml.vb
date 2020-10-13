'****************************** Module Header ******************************'
' Module Name:	MainPage.xaml.vb
' Project:		VBSL3PixelShader
' Copyright (c) Microsoft Corporation.
' 
' This example demonstrates how to use new pixel shader feature in 
' Silverlight 3. It mainly covers two parts:
' 
' 1. How to use built-in Effect such as DropShadowEffect.
' 2. How to create a custom ShaderEffect and use it in the application.
' 
' This source is subject to the Microsoft Public License.
' See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
' All other rights reserved.
' 
' History:
' * 7/23/2009 01:00 PM Allen Chen Created
' * 7/29/2009 6:00 PM Jialiang Ge Reviewed
'***************************************************************************'

#Region "Imports directives"

Imports System.Windows.Threading
Imports System.Windows.Media.Effects

#End Region


Partial Public Class MainPage
    Inherits UserControl

    ' A timer used to reduce the value of _amplitude gradually.
    Private _timer As DispatcherTimer = New DispatcherTimer()

    ' Amplitude that is used to pass to PixelShaderConstantCallback
    Private _amplitude As Double

    ' Center (mouse position) that is used to pass to PixelShaderConstantCallback
    Private _center As Point


    Public Sub New()

        InitializeComponent()

        'Initialize timer and hook Tick event.
        _timer.Interval = TimeSpan.FromMilliseconds(50)
        AddHandler _timer.Tick, AddressOf _timer_Tick

    End Sub


    ''' <summary>
    ''' This event handler reduce the amplitude and apply a new 
    ''' CycleWateryEffect on each tick.
    ''' </summary>
    Private Sub _timer_Tick(ByVal sender As Object, ByVal e As EventArgs)

        If Me._amplitude > 0.0 Then
            Dim effect As CycleWateryEffect = New CycleWateryEffect( _
            New Uri("/VBSL3PixelShader;component/cyclewatery.ps", UriKind.Relative))
            effect.Center = Me._center
            effect.Amplitude = Me._amplitude
            Me.ImagePixelShader.Effect = effect
            Me._amplitude -= 0.05
        Else
            Me._timer.Stop()
        End If

    End Sub

    ''' <summary>
    ''' This event handler get the current mouse position, assign it to a 
    ''' private field and start the timer to apply new CycleWateryEffect.
    ''' </summary>
    Private Sub UserControl_MouseLeftButtonDown(ByVal sender As Object, _
                                                ByVal e As MouseButtonEventArgs)

        Me._center = New Point(e.GetPosition(Me.ImagePixelShader).X / _
                               Me.ImagePixelShader.ActualWidth, e.GetPosition( _
                               Me.ImagePixelShader).Y / Me.ImagePixelShader.ActualHeight)
        Me._amplitude = 0.5
        _timer.Start()

    End Sub
End Class


''' <summary>
''' CycleWateryEffect class is a custom ShaderEffect class.
''' </summary>
Public Class CycleWateryEffect
    Inherits ShaderEffect

    ''' <summary>
    ''' The following two DependencyProperties are the keys of this custom ShaderEffect.
    ''' They create a bridge between managed code and HLSL(High Level Shader Language).
    ''' The PixelShaderConstantCallback will be triggered when the propery get changed.
    ''' The parameter of the callback represents the register.
    ''' For instance, here the 1 in PixelShaderConstantCallback(1) represents C1 of the
    ''' following HLSL code. In another word, by changing
    ''' the Amplitude property we assign the changed value to the amplitude variable of the
    ''' following HLSL code:
    ''' <code>
    ''' sampler2D input : register(S0);
    ''' float2 center:register(C0);
    ''' float amplitude:register(C1);
    ''' float4 main(float2 uv : TEXCOORD) : COLOR
    ''' {
    ''' if(pow((uv.x-center.x),2)+pow((uv.y-center.y),2)<0.15)
    ''' {
    ''' uv.y = uv.y  + (sin(uv.y*100)*0.1*amplitude);
    ''' }
    ''' return tex2D( input , uv.xy);
    ''' }
    ''' </code>
    ''' </summary>

    Public Shared ReadOnly AmplitudeProperty As DependencyProperty = _
    DependencyProperty.Register("Amplitude", GetType(Double), GetType(CycleWateryEffect), _
                                New PropertyMetadata(0.1, ShaderEffect.PixelShaderConstantCallback(1)))

    Public Shared ReadOnly CenterProperty As DependencyProperty = _
    DependencyProperty.Register("Center", GetType(Point), GetType(CycleWateryEffect), _
                                New PropertyMetadata(New Point(0.5, 0.5), ShaderEffect.PixelShaderConstantCallback(0)))

 
    Public Sub New(ByVal uri As Uri)

        Dim u As Uri = uri
        Dim psCustom As PixelShader = New PixelShader()
        psCustom.UriSource = u
        PixelShader = psCustom

        MyBase.UpdateShaderValue(CenterProperty)
        MyBase.UpdateShaderValue(AmplitudeProperty)

    End Sub


    Public Property Amplitude() As Double
        Get
            Return CDbl(MyBase.GetValue(AmplitudeProperty))
        End Get
        Set(ByVal value As Double)
            MyBase.SetValue(AmplitudeProperty, value)
        End Set
    End Property


    Public Property Center() As Point
        Get
            Return CType(MyBase.GetValue(CenterProperty), Point)
        End Get
        Set(ByVal value As Point)
            MyBase.SetValue(CenterProperty, value)
        End Set
    End Property

End Class