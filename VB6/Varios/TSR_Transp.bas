Attribute VB_Name = "TSR_Transp"
Option Explicit
' *********************************************************************************
' SECCION PARA EL EFECTO DE TRANSPARENCIA - INICIO
' *********************************************************************************
' Variables para efecto de transparencia
Private bgWid As Long
Private bgHgt As Long
Private oldSSTabProc As Long
Private oldBGProc As Long
Private mBrush As Long
Private mBrushBG As Long
Private Const FONDO_RADIOCHECK As Boolean = True

' API Declarations...
Private Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
Private Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function ReleaseDC Lib "user32" (ByVal hwnd As Long, ByVal hdc As Long) As Long
Private Declare Function CreateBitmap Lib "gdi32" (ByVal nWidth As Long, ByVal nHeight As Long, ByVal nPlanes As Long, ByVal nBitCount As Long, lpBits As Any) As Long
Private Declare Function SetBkColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Private Declare Function GetSysColor Lib "user32" (ByVal nIndex As Long) As Long
Public Declare Function CreatePatternBrush Lib "gdi32" (ByVal hBitmap As Long) As Long
Private Declare Function PatBlt Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal dwRop As Long) As Long
Private Declare Function SetBkMode Lib "gdi32" (ByVal hdc As Long, ByVal nBkMode As Long) As Long
Private Declare Function ValidateRect Lib "user32" (ByVal hwnd As Long, ByVal lpRect As Long) As Long
Private Declare Function GetUpdateRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT, ByVal bErase As Long) As Long
Private Const GWL_WNDPROC = (-4)
'
' SECCION PARA EL EFECTO DE TRANSPARENCIA - FIN
' *********************************************************************************

Sub TRANSInicia(phWnd As Long, pBrush As Long, pWidth As Long, pHeight As Long)
   mBrush = pBrush
   bgWid = pWidth
   bgHgt = pHeight
   
   ' Start the subclassing
   oldSSTabProc = SetWindowLong(phWnd, GWL_WNDPROC, AddressOf NewSSTabProc)
   
   
End Sub

Function NewSSTabProc(ByVal sstHwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    On Error Resume Next
    
    Dim aRect       As RECT
    Dim updateRect  As RECT
    Dim destDC      As Long
    Dim tempDC      As Long
    Dim tempBmp     As Long
    Dim origDC      As Long
    Dim origBmp     As Long
    Dim maskDC      As Long
    Dim maskBmp     As Long
    Dim memDC       As Long
    Dim memBmp      As Long
    
    Dim wid         As Long
    Dim hgt         As Long
    Dim X           As Long
    Dim Y           As Long
    Dim aControl    As Control
    
    Dim origBrush As Long
    Dim origColor As Long
    
    On Error Resume Next
    If wMsg = &HF Then  'WM_PAINT
        
        GetUpdateRect sstHwnd, updateRect, False
        
        ' get the SSTab's device context
        destDC = GetDC(sstHwnd)
        
        ' get the SSTab's window dimensions
        GetWindowRect sstHwnd, aRect
        wid = aRect.Right - aRect.Left
        hgt = aRect.Bottom - aRect.Top
        
        ' create our other temporary device contexts.
        maskDC = CreateCompatibleDC(destDC)
        maskBmp = CreateBitmap(wid, hgt, 1, 1, ByVal 0&)
        memDC = CreateCompatibleDC(destDC)
        memBmp = CreateCompatibleBitmap(destDC, wid, hgt)
        tempDC = CreateCompatibleDC(destDC)
        tempBmp = CreateCompatibleBitmap(destDC, wid, hgt)
        origDC = CreateCompatibleDC(destDC)
        origBmp = CreateCompatibleBitmap(destDC, wid, hgt)
        
        ' delete the temporary 1x1 bitmap and put our (wid)x(hgt) ones in
        DeleteObject SelectObject(maskDC, maskBmp)
        DeleteObject SelectObject(memDC, memBmp)
        DeleteObject SelectObject(tempDC, tempBmp)
        DeleteObject SelectObject(origDC, origBmp)
        
        ' Call the control's original handler... paints the control on our back buffer
        CallWindowProc oldSSTabProc, sstHwnd, wMsg, origDC, lParam

        ' This helps our mask to correctly calculate the b & w pixels of
        '  our mask. Only really works in Win98 and greater... and even then
        '  it is sometimes flakey... may need to loop thru x & y and use
        '  GetPixel/SetPixel to create mask if it is not generated properly.
        origColor = SetBkColor(destDC, GetSysColor(15))
        SetBkColor origDC, GetSysColor(15)
        ' create a b&w pixel mask - background color is white, everything else
        '  is black.
        BitBlt maskDC, 0, 0, wid, hgt, origDC, 0, 0, vbSrcCopy
                

        ' select the pattern brush into the DC and pattern blit
        origBrush = SelectObject(tempDC, mBrush)
        PatBlt tempDC, 0, 0, wid, hgt, vbPatCopy
        SelectObject tempDC, origBrush
        
        ' clean up our original image of the control so only the non background
        '  color parts are showing... make everything else white.
        BitBlt memDC, 0, 0, wid, hgt, maskDC, 0, 0, vbSrcCopy
        BitBlt memDC, 0, 0, wid, hgt, origDC, 0, 0, vbSrcPaint
        

        'punch the hole for our control image
        BitBlt tempDC, 0, 0, wid, hgt, maskDC, 0, 0, vbMergePaint
        'put the control images back in
        BitBlt tempDC, 0, 0, wid, hgt, memDC, 0, 0, vbSrcAnd
        'copy our new version back to the control
        BitBlt destDC, 0, 0, wid, hgt, tempDC, 0, 0, vbSrcCopy

        ' clean up all of our used graphical resources (VERY IMPORTANT!!!)
        DeleteDC tempDC
        DeleteObject tempBmp
        DeleteDC maskDC
        DeleteObject maskBmp
        DeleteDC memDC
        DeleteObject memBmp
        DeleteDC origDC
        DeleteObject origBmp
        
        ' Replace the original background color
        SetBkColor destDC, origColor
        ' Release the SSTab's device context back to the system
        ReleaseDC sstHwnd, destDC
        
        ValidateRect sstHwnd, 0
                
        On Error GoTo 0
    ElseIf wMsg = &H2 Then 'WM_DESTROY
        DeleteObject mBrush
        SetWindowLong sstHwnd, GWL_WNDPROC, oldSSTabProc
        NewSSTabProc = CallWindowProc(oldSSTabProc, sstHwnd, wMsg, wParam, lParam)
    ElseIf wMsg = &H138 And FONDO_RADIOCHECK Then               '&H138 = WM_CTLCOLORSTATIC
        SetBkMode wParam, 1     ' make the text draw transparent
        NewSSTabProc = mBrush   ' return the background brush
    Else
        NewSSTabProc = CallWindowProc(oldSSTabProc, sstHwnd, wMsg, wParam, lParam)
    End If
    On Error GoTo 0
End Function



