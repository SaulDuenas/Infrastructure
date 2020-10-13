VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImageButton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'------------------------------------------------------------------------------------
'Name:          cImageButton
'Autor:         Leandro I Ascierto
'Fecha:         22/08/08
'Revición       1
'Descripcion:   agrega imagens a los botnes cuando se encuentran los temas de XP presnete
'-------------------------------------------------------------------------------------
Option Explicit


Private Declare Function ImageList_Create Lib "comctl32.dll" (ByVal cx As Long, ByVal cy As Long, ByVal flags As Long, ByVal cInitial As Long, ByVal cGrow As Long) As Long
Private Declare Function ImageList_Destroy Lib "comctl32.dll" (ByVal himl As Long) As Long
Private Declare Function ImageList_ReplaceIcon Lib "comctl32.dll" (ByVal himl As Long, ByVal i As Long, ByVal hIcon As Long) As Long
Private Declare Function ImageList_AddIcon Lib "comctl32.dll" (ByVal hImagelist As Long, ByVal hIcon As Long) As Long
Private Declare Function ImageList_GetImageCount Lib "comctl32.dll" (ByVal himl As Long) As Long
Private Declare Function ImageList_SetImageCount Lib "comctl32.dll" (ByVal himl As Long, ByVal uNewCount As Long) As Long
Private Declare Function DestroyIcon Lib "user32" (ByVal hIcon As Long) As Long
Private Declare Function LoadImage Lib "user32" Alias "LoadImageA" (ByVal hInst As Long, ByVal lpsz As String, ByVal dwImageType As Long, ByVal dwDesiredWidth As Long, ByVal dwDesiredHeight As Long, ByVal dwFlags As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32.dll" (ByVal hdc As Long) As Long
Private Declare Function GetClientRect Lib "user32.dll" (ByVal hwnd As Long, ByRef lpRect As RECT) As Long
Private Declare Function CreateBitmap Lib "gdi32.dll" (ByVal nWidth As Long, ByVal nHeight As Long, ByVal nPlanes As Long, ByVal nBitCount As Long, ByRef lpBits As Any) As Long
Private Declare Function DeleteObject Lib "gdi32.dll" (ByVal hObject As Long) As Long
Private Declare Function SelectObject Lib "gdi32.dll" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function FillRect Lib "user32.dll" (ByVal hdc As Long, ByRef lpRect As RECT, ByVal hBrush As Long) As Long
Private Declare Function GetSysColorBrush Lib "user32.dll" (ByVal nIndex As Long) As Long
Private Declare Function DrawText Lib "user32.dll" Alias "DrawTextA" (ByVal hdc As Long, ByVal lpStr As String, ByVal nCount As Long, ByRef lpRect As RECT, ByVal wFormat As Long) As Long
Private Declare Function SetBkMode Lib "gdi32.dll" (ByVal hdc As Long, ByVal nBkMode As Long) As Long
Private Declare Function DeleteDC Lib "gdi32.dll" (ByVal hdc As Long) As Long
Private Declare Function DrawIconEx Lib "user32.dll" (ByVal hdc As Long, ByVal xLeft As Long, ByVal yTop As Long, ByVal hIcon As Long, ByVal cxWidth As Long, ByVal cyWidth As Long, ByVal istepIfAniCur As Long, ByVal hbrFlickerFreeDraw As Long, ByVal diFlags As Long) As Long
Private Declare Function SetRect Lib "user32.dll" (ByRef lpRect As RECT, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long

' dibujar íconos en dc
Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function OleTranslateColor Lib "oleaut32.dll" (ByVal lOleColor As Long, ByVal lHPalette As Long, lColorRef As Long) As Long
Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long

'LoadImage constantes
Private Const LR_LOADFROMFILE               As Long = &H10
Private Const LR_LOADMAP3DCOLORS            As Long = &H1000
Private Const LR_SHARED                     As Long = &H8000&
Private Const IMAGE_ICON                    As Long = 1
Private Const IMAGE_BITMAP                  As Long = 0

'Button constantes
Private Const BM_SETIMAGE       As Long = &HF7&
Private Const BS_ICON           As Long = &H40
Private Const BS_BITMAP         As Long = &H80
Private Const BCM_SETIMAGELIST  As Long = &H1602&

'DrawIconEx constantes
Private Const DI_MASK           As Long = &H1
Private Const DI_IMAGE          As Long = &H2
Private Const DI_NORMAL         As Long = DI_MASK Or DI_IMAGE

'Window Constates
Private Const WM_GETFONT        As Long = &H31
Private Const WM_GETTEXT        As Long = &HD

'ImageList constantes
Private Const ILC_MASK          As Long = &H1
Private Const ILC_COLOR         As Long = &H0
Private Const ILC_COLORDDB      As Long = &HFE
Private Const ILC_COLOR4        As Long = &H4
Private Const ILC_COLOR8        As Long = &H8
Private Const ILC_COLOR16       As Long = &H10
Private Const ILC_COLOR24       As Long = &H18
Private Const ILC_COLOR32       As Long = &H20

'DrawText constantes
Private Const DT_CENTER         As Long = &H1
Private Const DT_CALCRECT       As Long = &H400
'
Private Const GWL_STYLE         As Long = -16&
Private Const COLOR_BTNFACE     As Long = 15

Private Type RECT
   Left As Long
   Top As Long
   Right As Long
   Bottom As Long
End Type

Private Type BUTTON_IMAGELIST
   himl As Long
   rc As RECT
   uAlign As Long
End Type

Public Enum Align
    Icon_Left = 0
    Icon_Right = 1
    Icon_Top = 2
    Icon_Bottom = 3
    Icon_Center = 4
End Enum

Private hwIL        As Long
Private m_Width     As Long
Private m_Height    As Long
Private hBmp        As Long

Public Function Init(Optional ByVal Width As Long = 16, Optional ByVal Height As Long = 16) As Long
    m_Width = Width: m_Height = Height
    hwIL = ImageList_Create(Width, Height, ILC_COLOR32 Or ILC_MASK, 1, 1)
    Init = hwIL
End Function


Private Sub Class_Terminate()
    If hwIL Then ImageList_Destroy (hwIL)
    If hBmp Then DeleteObject hBmp
End Sub



Private Sub LoadIcon(Address As String, FromRes As Boolean)
    Dim hIcon As Long
    hIcon = LoadImage(App.hInstance, Address, IMAGE_ICON, m_Width, m_Height, IIf(FromRes, LR_SHARED Or LR_LOADMAP3DCOLORS, LR_LOADFROMFILE))
    ImageList_AddIcon hwIL, hIcon
    DestroyIcon hIcon
End Sub

Private Sub ReplaceIcon(Address As String, Index As Long, FromRes As Boolean)
    Dim hIcon As Long
    hIcon = LoadImage(App.hInstance, Address, IMAGE_ICON, m_Width, m_Height, IIf(FromRes, LR_SHARED Or LR_LOADMAP3DCOLORS, LR_LOADFROMFILE))
    Call ImageList_ReplaceIcon(hwIL, Index, hIcon)
    DestroyIcon hIcon
End Sub

'------------------------------------------------------------------------------------
'Funcion para implementar Iconos a los Botones cuando se encuentran los temas de xp
'no le e añado para bitmap, pero si alguien tiene la nesisdad esta en sus ganas
'solo es cuention de pasa IMAGE_BITMAP a la funcin LoadImage , despues asignarle el color de mascara al ImageList
'---------------------------------------------------------------------------------
Public Function Implement(hButton As Long, Normal As String, _
                                Optional Hover As String, _
                                Optional Pressed As String, _
                                Optional Disabled As String, _
                                Optional Focused As String, _
                                Optional imgAlign As Align, _
                                Optional LeftMargin As Long = 0, _
                                Optional TopMargin As Long = 0, _
                                Optional RightMargin As Long = 0, _
                                Optional BottomMargin As Long = 0, _
                                Optional FromRes As Boolean) As Boolean
                                

    Dim bi As BUTTON_IMAGELIST
    Dim hIcon As Long
    Dim i As Integer
    
    ImageList_SetImageCount hwIL, 0
    
    If Len(Hover & Pressed & Disabled & Focused) = 0 Then
        LoadIcon Normal, FromRes
    Else
        For i = 1 To 5
            LoadIcon Normal, FromRes
        Next
    End If
    
    If Len(Hover) Then ReplaceIcon Hover, 1, FromRes
    If Len(Pressed) Then ReplaceIcon Pressed, 2, FromRes
    If Len(Disabled) Then ReplaceIcon Disabled, 3, FromRes
    If Len(Focused) Then ReplaceIcon Focused, 4, FromRes
    
    With bi
        .rc.Left = LeftMargin
        .rc.Top = TopMargin
        .rc.Right = RightMargin
        .rc.Bottom = BottomMargin
        .uAlign = imgAlign
        .himl = hwIL
    End With
    
    If SendMessage(hButton, BCM_SETIMAGELIST, 0, bi) <> 0 Then
        Implement = True
    Else
        'no se encuentran presente los temas de xp
        Call DrawBitmap(hButton, Normal, FromRes)
    End If
End Function

'--------------------------------------------------------------------------------------
'Subrutina que asigna un BITMAP al boton del  icono y el texto en caso que no esten presente los temas de xp
'la funcion esta simple no incluye alineacion, por defecto el icono se situa a la derecha
'y el texto a la isquierda, tampoco esta jutificado en caso de que el texto sea muy largo
'queda a nesesidad de cada uno modificarla. (yo no tengo ganas :) )
'------------------------------------------------------------------------------------
Private Sub DrawBitmap(hButton As Long, Normal As String, FromRes As Boolean)
    Dim BtnRec As RECT
    Dim TextRec As RECT
    Dim hFont As Long
    Dim mText As String
    Dim mDC As Long
    Dim hIcon As Long
    Dim TextTop As Long
    Dim TextLeft As Long
    Dim IconLeft As Long
    
    If hBmp Then DeleteObject hBmp
    
    mText = String(100, Chr$(0))
    SendMessage hButton, WM_GETTEXT, 100, ByVal mText
    mText = Left(mText, InStr(mText, Chr$(0)) - 1)
        
    GetClientRect hButton, BtnRec
    
    mDC = CreateCompatibleDC(0)
    hBmp = CreateBitmap(BtnRec.Right, BtnRec.Bottom, 1, 32, ByVal 0&)
    DeleteObject SelectObject(mDC, hBmp)
    
    hFont = SendMessage(hButton, WM_GETFONT, 0, ByVal 0)
    DeleteObject SelectObject(mDC, hFont)
    
    FillRect mDC, BtnRec, GetSysColorBrush(COLOR_BTNFACE)
    SetBkMode mDC, 1
    
    DrawText mDC, mText, Len(mText), TextRec, DT_CALCRECT
    
        
    hIcon = LoadImage(App.hInstance, Normal, IMAGE_ICON, m_Width, m_Height, IIf(FromRes, LR_SHARED Or LR_LOADMAP3DCOLORS, LR_LOADFROMFILE))
    
    If Len(mText) Then
        IconLeft = (BtnRec.Right / 2) - (m_Width + TextRec.Right + 6) / 2
    Else
        IconLeft = (BtnRec.Right / 2) - (m_Width / 2)
    End If
    
    Dim lRet As Long
    
    lRet = DrawIconEx(mDC, IconLeft, (BtnRec.Bottom / 2) - (m_Height / 2), hIcon, 0, 0, 0, 0, DI_NORMAL)
    DestroyIcon hIcon
    
    TextTop = (BtnRec.Bottom / 2) - (TextRec.Bottom / 2)
    TextLeft = IconLeft + m_Width + 6
    SetRect TextRec, TextLeft, TextTop, BtnRec.Right, TextTop + TextRec.Bottom
    DrawText mDC, mText, Len(mText), TextRec, 0
    
    DeleteDC mDC
          
    SetWindowLong hButton, GWL_STYLE, GetWindowLong(hButton, GWL_STYLE) Or BS_BITMAP
            
    SendMessage hButton, BM_SETIMAGE, 0, ByVal hBmp
         

End Sub


Function DrawBitmapDC(sIconPath As String, lHdc As Long, x As Long, Y As Long, lWidth As Long, lHeight As Long, Optional lBackColorImage As Long = vbButtonFace) As Boolean
    Dim dcRect As RECT
    Dim mDC As Long
    Dim hIcon As Long
    
    If hBmp Then DeleteObject hBmp
    
    mDC = CreateCompatibleDC(0)
    hBmp = CreateBitmap(lWidth, lHeight, 1, 32, ByVal 0&)
    DeleteObject SelectObject(mDC, hBmp)
    
    With dcRect
        .Bottom = lHeight
        .Right = lWidth
    End With
    
    Dim lRet As Long
    
    hIcon = LoadImage(App.hInstance, sIconPath, IMAGE_ICON, lWidth, lHeight, LR_LOADFROMFILE)
    
    If hIcon Then
        lRet = FillRect(mDC, dcRect, CreateSolidBrush(TranslateColor(lBackColorImage)))
        lRet = DrawIconEx(mDC, 0, 0, hIcon, 0, 0, 0, 0, DI_NORMAL)
        Call DestroyIcon(hIcon)
    
        lRet = BitBlt(lHdc, x, Y, lWidth, lHeight, mDC, 0, 0, vbSrcCopy)
        Call DeleteDC(mDC)
        
        DrawBitmapDC = True
    End If
    
End Function
Private Function TranslateColor(ByVal clr As OLE_COLOR, Optional hPal As Long = 0) As Long
    If OleTranslateColor(clr, hPal, TranslateColor) Then
        TranslateColor = -1
    End If
End Function



