VERSION 5.00
Begin VB.UserControl TSRButton 
   BackStyle       =   0  'Transparent
   ClientHeight    =   1185
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4050
   DefaultCancel   =   -1  'True
   DrawStyle       =   5  'Transparent
   PaletteMode     =   4  'None
   ScaleHeight     =   1185
   ScaleWidth      =   4050
   ToolboxBitmap   =   "TSRButton.ctx":0000
   Begin VB.Label lblCaption 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Command"
      Height          =   195
      Left            =   630
      TabIndex        =   0
      Top             =   0
      Width           =   735
   End
   Begin VB.Shape Recuadro 
      BorderStyle     =   3  'Dot
      Height          =   615
      Left            =   3180
      Top             =   360
      Width           =   615
   End
   Begin VB.Image imgDown 
      Appearance      =   0  'Flat
      Height          =   615
      Left            =   1320
      Top             =   360
      Width           =   555
   End
   Begin VB.Image imgHover 
      Appearance      =   0  'Flat
      Height          =   615
      Left            =   720
      Top             =   360
      Width           =   555
   End
   Begin VB.Image imgDisabled 
      Appearance      =   0  'Flat
      Height          =   615
      Left            =   1920
      Top             =   360
      Width           =   555
   End
   Begin VB.Image imgNormal 
      Appearance      =   0  'Flat
      Height          =   615
      Left            =   60
      Top             =   360
      Width           =   570
   End
End
Attribute VB_Name = "TSRButton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'Declares del API
Private Type POINTAPI
    X As Long
    Y As Long
End Type

Private Declare Function ReleaseCapture Lib "user32" () As Long
Private Declare Function SetCapture Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Private Declare Function ScreenToClient Lib "user32" (ByVal hwnd As Long, lpPoint As POINTAPI) As Long

'Estados del botón
Private Enum EstadoBoton
   Normal
   Hover
   Down
   Disabled
End Enum

'Default Property Values:
Const m_def_TextShadowColor = 0
Const m_def_TextDisabledColor = 0
Const m_def_RightMargin = 0
Const m_def_BottomMargin = 0
Const m_def_TextPressedColor = 0
Const m_def_TopMargin = 0
Const m_def_LeftMargin = 0
Const m_def_TextHoverColor = 0
Const def_Enabled = True
Const def_Caption = "Comando"
Const def_Style = 0
Const def_Default = 0
Const def_Cancel = 0

'Property Variables:
Dim m_TextShadowColor As OLE_COLOR
Dim m_RightMargin As Variant
Dim m_BottomMargin As Long
Dim m_TopMargin As Long
Dim m_LeftMargin As Long
Dim m_ForeColor As OLE_COLOR
Dim m_TextHoverColor As OLE_COLOR
Dim m_TextPressedColor As OLE_COLOR
Dim m_TextDisabledColor As OLE_COLOR
Dim mEnabled As Boolean
Dim mCaption As String
Dim mStyle As Integer
Dim mDefault As Boolean
Dim mCancel As Boolean

'Event Declarations:
Event Click()

'Variables privadas
Private mEstadoBoton As EstadoBoton
Private mMouseIn As Boolean


'Inicializa el control (Gráficamente)
Private Sub UserControl_Initialize()
   mEstadoBoton = Normal
   UserControl.MaskColor = vbButtonFace    'Set the control's mask color to the background color of the drawing area
   UserControl.MaskPicture = UserControl.Image     'Set the mask image from what we created on the drawing area
   UserControl.BackStyle = 0   'Set control's backstyle to Transparent
   SetImage Normal
   
   'Esconde las imágenes
   imgNormal.Top = -10000
   imgHover.Top = -10000
   imgDown.Top = -10000
   imgDisabled.Top = -10000
End Sub

'Inicializar propiedades para control de usuario
Private Sub UserControl_InitProperties()
   'Establece valores default
   mEnabled = def_Enabled
   mDefault = def_Default
   mCancel = def_Cancel
   mEnabled = def_Enabled
   mCaption = def_Caption
   mStyle = def_Style
   m_TextHoverColor = m_def_TextHoverColor
   m_TopMargin = m_def_TopMargin
   m_LeftMargin = m_def_LeftMargin
   m_RightMargin = m_def_RightMargin
   m_BottomMargin = m_def_BottomMargin
   m_TextPressedColor = m_def_TextPressedColor
   m_TextDisabledColor = m_def_TextDisabledColor
   m_TextShadowColor = m_def_TextShadowColor
End Sub


'Actualiza el aspecto gráfico del botón
Private Sub UserControl_Resize()
      
   'Tiempo de ejecución?
   If Ambient.UserMode Then
      Recuadro.Visible = False
   Else
      'Tiempo de diseño
      'Si no tiene imagen muestra un recuadro
      If UserControl.Picture = 0 Then
         'Top
         Recuadro.Visible = True
         Recuadro.Top = 0
         Recuadro.Left = 0
         Recuadro.Width = ScaleWidth
         Recuadro.Height = ScaleHeight
      Else
         Recuadro.Visible = False
      End If
   End If
   
   'Pone el texto en caso de que haya
   If mCaption <> "" Then
      If lblCaption.AutoSize Then
         lblCaption.Top = (ScaleHeight - lblCaption.Height) / 2
         lblCaption.Left = (ScaleWidth - lblCaption.Width) / 2
      Else
         lblCaption.Top = m_TopMargin
         lblCaption.Left = m_LeftMargin
         lblCaption.Width = ScaleWidth - m_LeftMargin - m_RightMargin
         lblCaption.Height = ScaleHeight - m_TopMargin - m_BottomMargin
      End If
   Else
      lblCaption.Top = -10000
   End If
   'Repinta la imagen
   SetImage mEstadoBoton
End Sub


'Establece la imagen a mostrar
Private Sub SetImage(pEstado As EstadoBoton)
   Select Case pEstado
      Case Normal
         Set UserControl.Picture = imgNormal.Picture
         lblCaption.ForeColor = m_ForeColor
      Case Hover
         Set UserControl.Picture = imgHover.Picture
         lblCaption.ForeColor = m_TextHoverColor
      Case Down
         Set UserControl.Picture = imgDown.Picture
         lblCaption.ForeColor = m_TextPressedColor
      Case Disabled
         Set UserControl.Picture = imgDisabled.Picture
         lblCaption.ForeColor = m_TextDisabledColor
   End Select
   UserControl.MaskPicture = UserControl.Image     'Set the mask image from what we created on the drawing area
   mEstadoBoton = pEstado
End Sub

' *********** Eventos del Mouse *********

'Click
Private Sub UserControl_Click()
   If mEnabled Then
      RaiseEvent Click
   End If
End Sub

'Oprimir boton
Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
   If mEnabled And mEstadoBoton <> Down Then
      SetImage Down
   End If
End Sub

'Soltar Botón
Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
   If mEnabled And (mEstadoBoton = Down) Then
      If mMouseIn Then
         SetImage Hover
      Else
         SetImage Normal
      End If
   End If
End Sub
'Mover mouse sobre el control
Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
 Dim xyCursor As POINTAPI
 Dim Xi As Long
 Dim Yi As Long
   
   If mEnabled And imgHover.Picture <> 0 Then
      'Captura movimientos del mouse
      SetCapture UserControl.hwnd
   
      'Obtiene coordenadas del mouse
      GetCursorPos xyCursor
      ScreenToClient UserControl.hwnd, xyCursor
      
      'Pasa las coordenadas a la escala del control
      Xi = xyCursor.X * Screen.TwipsPerPixelX
      Yi = xyCursor.Y * Screen.TwipsPerPixelY
   
      'Está afuera del control?
      If Xi < 0 Or Yi < 0 Or Xi > UserControl.Width Or Yi > UserControl.Height Then
         If mMouseIn Then
            'Ocurrió MouseOut
            SetImage Normal      '<-- Pone la imagen normal (OnMouseOut)
            If Button = 0 Then
               ReleaseCapture
            End If
            mMouseIn = False
         End If
      Else 'Está adentro
         If Not mMouseIn Then
            SetImage Hover       '<-- Pone la imagen Hover (OnMouseEnter)
            mMouseIn = True
         End If
      End If
   End If
End Sub



'Mapea los eventos del mouse, del Label al UserControl
Private Sub lblCaption_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
   UserControl_MouseDown Button, Shift, X, Y
End Sub
Private Sub lblCaption_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
   UserControl_MouseMove Button, Shift, X, Y
End Sub
Private Sub lblCaption_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
   UserControl_MouseUp Button, Shift, X, Y
End Sub
Private Sub lblCaption_Click()
   UserControl_Click
End Sub






'***************************************************************************
'***  P R O P I E D A D E S
'***************************************************************************



'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=0,0,0,0
Public Property Get Enabled() As Boolean
   Enabled = mEnabled
End Property
Public Property Let Enabled(ByVal New_Enabled As Boolean)
   If mEnabled <> New_Enabled Then
      mEnabled = New_Enabled
      If mEnabled Then
         SetImage Normal
      Else
         SetImage Disabled
      End If
      PropertyChanged "Enabled"
   End If
End Property


'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=imgNormal,imgNormal,-1,ToolTipText
Public Property Get ToolTipText() As String
Attribute ToolTipText.VB_Description = "Devuelve o establece el texto mostrado cuando el mouse se sitúa sobre un control."
   ToolTipText = imgNormal.ToolTipText
End Property
Public Property Let ToolTipText(ByVal New_ToolTipText As String)
   imgNormal.ToolTipText() = New_ToolTipText
   PropertyChanged "ToolTipText"
End Property


'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=0,0,0,0
Public Property Get Default() As Boolean
Attribute Default.VB_Description = "Determina si el botón es el predeterminado del formulario. NO SIRVE"
   Default = mDefault
End Property
Public Property Let Default(ByVal New_Default As Boolean)
   mDefault = New_Default
   PropertyChanged "Default"
End Property


'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=imgDisabled,imgDisabled,-1,Picture
Public Property Get DisabledPicture() As Picture
Attribute DisabledPicture.VB_Description = "Imagen del botón cuando está deshabilitado."
   Set DisabledPicture = imgDisabled.Picture
End Property
Public Property Set DisabledPicture(ByVal New_DisabledPicture As Picture)
   Set imgDisabled.Picture = New_DisabledPicture
   PropertyChanged "DisabledPicture"
End Property


'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=imgDown,imgDown,-1,Picture
Public Property Get DownPicture() As Picture
Attribute DownPicture.VB_Description = "Imagen del botón cuando está oprimido."
   Set DownPicture = imgDown.Picture
End Property
Public Property Set DownPicture(ByVal New_DownPicture As Picture)
   Set imgDown.Picture = New_DownPicture
   PropertyChanged "DownPicture"
End Property


'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=imgNormal,imgNormal,-1,Stretch
Public Property Get Stretch() As Boolean
Attribute Stretch.VB_Description = "Devuelve o establece un valor que determina si un gráfico cambia su tamaño para ajustarse al tamaño de un control Image. NO SIRVE"
   Stretch = imgNormal.Stretch
End Property

Public Property Let Stretch(ByVal New_Stretch As Boolean)
   imgNormal.Stretch = New_Stretch
   imgDown.Stretch = New_Stretch
   imgHover.Stretch = New_Stretch
   imgDisabled.Stretch = New_Stretch
   
   PropertyChanged "Stretch"
End Property


'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=imgNormal,imgNormal,-1,Picture
Public Property Get Picture() As Picture
Attribute Picture.VB_Description = "Imagen del botón normal."
   Set Picture = imgNormal.Picture
End Property
Public Property Set Picture(ByVal New_Picture As Picture)
   Set imgNormal.Picture = New_Picture
   UserControl.Width = imgNormal.Width
   UserControl.Height = imgNormal.Height
   SetImage Normal
   Recuadro.Visible = (UserControl.Picture = 0)
   PropertyChanged "Picture"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=0,0,0,0
Public Property Get Cancel() As Boolean
Attribute Cancel.VB_Description = "Indica si es el botón Cancelar de un formulario."
   Cancel = mCancel
End Property
Public Property Let Cancel(ByVal New_Cancel As Boolean)
   mCancel = New_Cancel
   PropertyChanged "Cancel"
End Property


'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=imgHover,imgHover,-1,Picture
Public Property Get HoverPicture() As Picture
Attribute HoverPicture.VB_Description = "Imagen del botón cuando el mouse pasa por encima."
   Set HoverPicture = imgHover.Picture
End Property

Public Property Set HoverPicture(ByVal New_HoverPicture As Picture)
   Set imgHover.Picture = New_HoverPicture
   PropertyChanged "HoverPicture"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=13,0,0,Comando
Public Property Get Caption() As String
Attribute Caption.VB_Description = "Devuelve o establece el texto mostrado en el botón."
   Caption = mCaption
End Property

Public Property Let Caption(ByVal New_Caption As String)
   mCaption = New_Caption
   lblCaption.Caption = mCaption
   UserControl_Resize
   PropertyChanged "Caption"
End Property


'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=lblCaption,lblCaption,0,Alignment
Public Property Get Alignment() As Integer
Attribute Alignment.VB_Description = "Devuelve o establece la alineación del texto del botón."
   Alignment = lblCaption.Alignment
End Property
Public Property Let Alignment(ByVal New_Alignment As Integer)
   lblCaption.Alignment() = New_Alignment
   PropertyChanged "Alignment"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=10,0,0,0
Public Property Get TextHoverColor() As OLE_COLOR
Attribute TextHoverColor.VB_Description = "Devuelve o establece el color de la sombra del texto. NO SIRVE"
   TextHoverColor = m_TextHoverColor
End Property
Public Property Let TextHoverColor(ByVal New_TextHoverColor As OLE_COLOR)
   m_TextHoverColor = New_TextHoverColor
   UserControl_Resize
   PropertyChanged "TextHoverColor"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=lblCaption,lblCaption,-1,ForeColor
Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "Devuelve o establece el color del texto del botón."
   ForeColor = lblCaption.ForeColor
End Property

Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
   m_ForeColor = New_ForeColor
   UserControl_Resize
   PropertyChanged "ForeColor"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=lblCaption,lblCaption,-1,FontName
Public Property Get FontName() As String
Attribute FontName.VB_Description = "Especifica el nombre de la fuente del texto del botón."
   FontName = lblCaption.FontName
End Property

Public Property Let FontName(ByVal New_FontName As String)
   lblCaption.FontName() = New_FontName
   PropertyChanged "FontName"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=lblCaption,lblCaption,-1,FontSize
Public Property Get FontSize() As Single
Attribute FontSize.VB_Description = "Especifica el tamaño (en puntos) de la fuente del texto del botón."
   FontSize = lblCaption.FontSize
End Property

Public Property Let FontSize(ByVal New_FontSize As Single)
   lblCaption.FontSize() = New_FontSize
   PropertyChanged "FontSize"
   UserControl_Resize
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=lblCaption,lblCaption,-1,FontBold
Public Property Get FontBold() As Boolean
Attribute FontBold.VB_Description = "Devuelve o establece el estilo negrita de una fuente."
   FontBold = lblCaption.FontBold
End Property

Public Property Let FontBold(ByVal New_FontBold As Boolean)
   lblCaption.FontBold() = New_FontBold
   PropertyChanged "FontBold"
   UserControl_Resize
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=lblCaption,lblCaption,-1,FontItalic
Public Property Get FontItalic() As Boolean
Attribute FontItalic.VB_Description = "Devuelve o establece el estilo cursiva de una fuente."
   FontItalic = lblCaption.FontItalic
End Property

Public Property Let FontItalic(ByVal New_FontItalic As Boolean)
   lblCaption.FontItalic() = New_FontItalic
   PropertyChanged "FontItalic"
   UserControl_Resize
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=lblCaption,lblCaption,-1,Font
Public Property Get Font() As Font
Attribute Font.VB_Description = "Devuelve un objeto Font."
Attribute Font.VB_UserMemId = -512
   Set Font = lblCaption.Font
End Property
Public Property Set Font(ByVal New_Font As Font)
   Set lblCaption.Font = New_Font
   PropertyChanged "Font"
   UserControl_Resize
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=UserControl,UserControl,-1,BackColor
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Devuelve o establece el color de fondo usado para mostrar texto y gráficos en un objeto."
   BackColor = UserControl.BackColor
End Property

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
   UserControl.BackColor() = New_BackColor
   PropertyChanged "BackColor"
End Property


'Cargar valores de propiedad desde el almacén
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)

   'Varios
   UserControl.BackColor = PropBag.ReadProperty("BackColor", &H8000000F)
   mEnabled = PropBag.ReadProperty("Enabled", def_Enabled)
   imgNormal.ToolTipText = PropBag.ReadProperty("ToolTipText", "")
   imgNormal.Stretch = PropBag.ReadProperty("Stretch", False)
   mDefault = PropBag.ReadProperty("Default", def_Default)
   mCancel = PropBag.ReadProperty("Cancel", def_Cancel)
   mStyle = PropBag.ReadProperty("Style", def_Style)
   m_TextHoverColor = PropBag.ReadProperty("TextHoverColor", m_def_TextHoverColor)
   
   'Imagenes
   Set Picture = PropBag.ReadProperty("Picture", Nothing)
   Set HoverPicture = PropBag.ReadProperty("HoverPicture", Nothing)
   Set DownPicture = PropBag.ReadProperty("DownPicture", Nothing)
   Set DisabledPicture = PropBag.ReadProperty("DisabledPicture", Nothing)
   
   'Caption
   mCaption = PropBag.ReadProperty("Caption", def_Caption)
   lblCaption.Caption = mCaption
   Set lblCaption.Font = PropBag.ReadProperty("Font", Ambient.Font)
   lblCaption.FontBold = PropBag.ReadProperty("FontBold", 0)
   lblCaption.FontItalic = PropBag.ReadProperty("FontItalic", 0)
   
   On Error GoTo Err_FontAlterno
   lblCaption.FontName = PropBag.ReadProperty("FontName", Ambient.Font)
   On Error GoTo 0
   
   lblCaption.FontSize = PropBag.ReadProperty("FontSize", 8.25)
   lblCaption.ForeColor = PropBag.ReadProperty("ForeColor", &H80000012)
   lblCaption.Alignment = PropBag.ReadProperty("Alignment", 2)
   
   lblCaption.AutoSize = PropBag.ReadProperty("AutoSize", True)
   m_TopMargin = PropBag.ReadProperty("TopMargin", m_def_TopMargin)
   m_LeftMargin = PropBag.ReadProperty("LeftMargin", m_def_LeftMargin)
   m_RightMargin = PropBag.ReadProperty("RightMargin", m_def_RightMargin)
   m_BottomMargin = PropBag.ReadProperty("BottomMargin", m_def_BottomMargin)
   m_TextPressedColor = PropBag.ReadProperty("TextPressedColor", m_def_TextPressedColor)
   m_TextDisabledColor = PropBag.ReadProperty("TextDisabledColor", m_def_TextDisabledColor)
   
   
   'Redibuja
   If mEnabled Then
      SetImage Normal
   Else
      SetImage Disabled
   End If
   
   UserControl_Resize
   m_TextShadowColor = PropBag.ReadProperty("TextShadowColor", m_def_TextShadowColor)
   Exit Sub

Err_FontAlterno:
   lblCaption.FontName = Ambient.Font
   Resume Next

End Sub

'Escribir valores de propiedad en el almacén
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)

   'Varios
   Call PropBag.WriteProperty("BackColor", UserControl.BackColor, &H8000000F)
   Call PropBag.WriteProperty("Enabled", mEnabled, def_Enabled)
   Call PropBag.WriteProperty("ToolTipText", imgNormal.ToolTipText, "")
   Call PropBag.WriteProperty("Stretch", imgNormal.Stretch, False)
   Call PropBag.WriteProperty("Default", mDefault, def_Default)
   Call PropBag.WriteProperty("Cancel", mCancel, def_Cancel)
   Call PropBag.WriteProperty("Style", mStyle, def_Style)
   Call PropBag.WriteProperty("TextHoverColor", m_TextHoverColor, m_def_TextHoverColor)
   
   'Imagenes
   Call PropBag.WriteProperty("Picture", Picture, Nothing)
   Call PropBag.WriteProperty("HoverPicture", HoverPicture, Nothing)
   Call PropBag.WriteProperty("DownPicture", DownPicture, Nothing)
   Call PropBag.WriteProperty("DisabledPicture", DisabledPicture, Nothing)
   
   'Caption
   Call PropBag.WriteProperty("Caption", mCaption, def_Caption)
   Call PropBag.WriteProperty("Font", lblCaption.Font, Ambient.Font)
   Call PropBag.WriteProperty("FontBold", lblCaption.FontBold, 0)
   Call PropBag.WriteProperty("FontItalic", lblCaption.FontItalic, 0)
   Call PropBag.WriteProperty("FontName", lblCaption.FontName, Ambient.Font)
   Call PropBag.WriteProperty("FontSize", lblCaption.FontSize, 8.25)
   Call PropBag.WriteProperty("ForeColor", lblCaption.ForeColor, &H80000012)
   Call PropBag.WriteProperty("Alignment", lblCaption.Alignment, 2)
   
   Call PropBag.WriteProperty("AutoSize", lblCaption.AutoSize, True)
   Call PropBag.WriteProperty("TopMargin", m_TopMargin, m_def_TopMargin)
   Call PropBag.WriteProperty("LeftMargin", m_LeftMargin, m_def_LeftMargin)
   Call PropBag.WriteProperty("RightMargin", m_RightMargin, m_def_RightMargin)
   Call PropBag.WriteProperty("BottomMargin", m_BottomMargin, m_def_BottomMargin)
   Call PropBag.WriteProperty("TextPressedColor", m_TextPressedColor, m_def_TextPressedColor)
   Call PropBag.WriteProperty("TextDisabledColor", m_TextDisabledColor, m_def_TextDisabledColor)
   
   'Redibuja
   UserControl_Resize
   Call PropBag.WriteProperty("TextShadowColor", m_TextShadowColor, m_def_TextShadowColor)

End Sub

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MappingInfo=lblCaption,lblCaption,-1,AutoSize
Public Property Get AutoSize() As Boolean
Attribute AutoSize.VB_Description = "Determina si un control cambia de tamaño automáticamente para mostrar todo su contenido."
   AutoSize = lblCaption.AutoSize
End Property

Public Property Let AutoSize(ByVal New_AutoSize As Boolean)
   lblCaption.AutoSize = New_AutoSize
   'Redibuja
   UserControl_Resize
   PropertyChanged "AutoSize"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=8,0,0,0
Public Property Get TopMargin() As Long
Attribute TopMargin.VB_Description = "Margen superior del caption (Cuando AutoSize es falso)"
   TopMargin = m_TopMargin
End Property

Public Property Let TopMargin(ByVal New_TopMargin As Long)
   m_TopMargin = New_TopMargin
   UserControl_Resize
   PropertyChanged "TopMargin"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=8,0,0,0
Public Property Get LeftMargin() As Long
Attribute LeftMargin.VB_Description = "Margen izquierdo del caption (Cuando AutoSize es falso)"
   LeftMargin = m_LeftMargin
End Property

Public Property Let LeftMargin(ByVal New_LeftMargin As Long)
   m_LeftMargin = New_LeftMargin
   UserControl_Resize
   PropertyChanged "LeftMargin"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=14,0,0,0
Public Property Get RightMargin() As Variant
   RightMargin = m_RightMargin
End Property

Public Property Let RightMargin(ByVal New_RightMargin As Variant)
   m_RightMargin = New_RightMargin
   UserControl_Resize
   PropertyChanged "RightMargin"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=8,0,0,0
Public Property Get BottomMargin() As Long
Attribute BottomMargin.VB_Description = "Margen inferior del caption (Cuando AutoSize es falso)"
   BottomMargin = m_BottomMargin
End Property

Public Property Let BottomMargin(ByVal New_BottomMargin As Long)
   m_BottomMargin = New_BottomMargin
   UserControl_Resize
   PropertyChanged "BottomMargin"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=10,0,0,0
Public Property Get TextPressedColor() As OLE_COLOR
Attribute TextPressedColor.VB_Description = "Color del texto cuando el botón está oprimido"
   TextPressedColor = m_TextPressedColor
End Property

Public Property Let TextPressedColor(ByVal New_TextPressedColor As OLE_COLOR)
   m_TextPressedColor = New_TextPressedColor
   UserControl_Resize
   PropertyChanged "TextPressedColor"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=10,0,0,0
Public Property Get TextDisabledColor() As OLE_COLOR
Attribute TextDisabledColor.VB_Description = "Color del texto cuando el botón está deshabilitado"
   TextDisabledColor = m_TextDisabledColor
End Property

Public Property Let TextDisabledColor(ByVal New_TextDisabledColor As OLE_COLOR)
   m_TextDisabledColor = New_TextDisabledColor
   UserControl_Resize
   PropertyChanged "TextDisabledColor"
End Property

'ADVERTENCIA: NO QUITAR NI MODIFICAR LAS SIGUIENTES LINEAS CON COMENTARIOS
'MemberInfo=10,0,0,0
Public Property Get TextShadowColor() As OLE_COLOR
Attribute TextShadowColor.VB_Description = "NO SIRVE"
   TextShadowColor = m_TextShadowColor
End Property

Public Property Let TextShadowColor(ByVal New_TextShadowColor As OLE_COLOR)
   m_TextShadowColor = New_TextShadowColor
   PropertyChanged "TextShadowColor"
End Property

