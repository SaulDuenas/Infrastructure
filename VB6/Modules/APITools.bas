Attribute VB_Name = "APITools"
Option Explicit

' Constantes para abrir documentos (Word, Excel, etc.)
Global Const SW_SHOWNORMAL = 1
Global Const SE_ERR_FNF = 2&
Global Const SE_ERR_PNF = 3&
Global Const SE_ERR_ACCESSDENIED = 5&
Global Const SE_ERR_OOM = 8&
Global Const SE_ERR_DLLNOTFOUND = 32&
Global Const SE_ERR_SHARE = 26&
Global Const SE_ERR_ASSOCINCOMPLETE = 27&
Global Const SE_ERR_DDETIMEOUT = 28&
Global Const SE_ERR_DDEFAIL = 29&
Global Const SE_ERR_DDEBUSY = 30&
Global Const SE_ERR_NOASSOC = 31&
Global Const ERROR_BAD_FORMAT = 11&

' ******************************* Constantes para el namejo del scrollbar *******************************************

Private Const GWL_WNDPROC = (-4)
Private Const WM_MOUSEWHEEL = &H20A
Private Const WM_VSCROLL As Integer = &H115

' ******************************* Fin de Constantes para el namejo del scrollbar *************************************

Dim PrevProc As Long

' ****************************** Declares del API de Windows ******************************
Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpszOp As String, ByVal lpszFile As String, ByVal lpszParams As String, ByVal lpszDir As String, ByVal FsShowCmd As Long) As Long
Declare Function GetDesktopWindow Lib "user32" () As Long


' ****************************** Declaraciones de la api para el scrollbar en grids ***********************************

Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" ( _
    ByVal hwnd As Long, _
    ByVal nIndex As Long, _
    ByVal dwNewLong As Long) As Long

Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" ( _
    ByVal lpPrevWndFunc As Long, _
    ByVal hwnd As Long, _
    ByVal Msg As Long, _
    ByVal wParam As Long, _
    ByVal lParam As Long) As Long
    
Private Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" ( _
    ByVal hWnd1 As Long, _
    ByVal hWnd2 As Long, _
    ByVal lpsz1 As String, _
    ByVal lpsz2 As String) As Long

Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" ( _
    ByVal hwnd As Long, _
    ByVal wMsg As Long, _
    ByVal wParam As Long, _
    lParam As Any) As Long

Private Declare Function GetClassName Lib "user32" Alias "GetClassNameA" (ByVal hwnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long


' *********************************** Fin de la api para el scrollbar en grids ***************************************


Public Function IniciarDocumento(pDocumento As String) As Long
' *************************************************************
' * Nombre:     IniciarDocumento
' * Objetivo:   Iniciar el documento con el programa asociado
' * Parámetros:
' *             pDocumento = Nombre del documento con ruta
' * Retorno:    Regresa 0 si todo estuvo bien
' *             si hubo error regresa un código definido en las
' *             constantes SE_ERR_xxxxx
' * Autor:      TSR-MTB
' * Fecha:      2007.01.17
' ************************************************************
 Dim lhWnd As Long
    
   'Call FrmMouseEspera(Me, True)
   lhWnd = GetDesktopWindow()
   IniciarDocumento = ShellExecute(lhWnd, "Open", pDocumento, "", "", SW_SHOWNORMAL)
   'Call FrmMouseEspera(Me, False)

End Function



' ********************************* Funciones para el manejo del scrollbar *********************************

' instala el hook para el control indicado
Public Sub IniciarScroll(ElControl As Object)
    PrevProc = SetWindowLong(ElControl.hwnd, GWL_WNDPROC, AddressOf WindowProc)
End Sub

' Remueve el Hook para el control indicado
Public Sub DetenerScroll(ElControl As Object)
    SetWindowLong ElControl.hwnd, GWL_WNDPROC, PrevProc
End Sub

' Procedimiento para procesar los mensajes de windows
  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function WindowProc(ByVal hwnd As Long, _
                           ByVal uMsg As Long, _
                           ByVal wParam As Long, _
                           ByVal lParam As Long) As Long

    Dim HScroll As Long
        
        
    ' Obtiene el Hwnd de la barra de Scroll vertical del DataGrid
    HScroll = FindWindowEx(hwnd, 0, "ScrollBar", "DataGridSplitVScroll")
    
    If clase(hwnd) = "DataGridWndClass" And HScroll = 0 Then
         WindowProc = CallWindowProc(PrevProc, hwnd, uMsg, wParam, lParam)
        Exit Function
    End If
    
    If uMsg = WM_MOUSEWHEEL Then
        
       If clase(hwnd) = "DataGridWndClass" And HScroll <> 0 Then
            
            If wParam < 0 Then
                ' Scroll hacia abajo
                SendMessage hwnd, WM_VSCROLL, 1, ByVal HScroll
            Else
                ' Mueve el scroll hacia arriba
                SendMessage hwnd, WM_VSCROLL, 0, ByVal HScroll
            End If
        Else
            If wParam < 0 Then
                ' Scroll hacia abajo
                SendMessage hwnd, WM_VSCROLL, 1, ByVal 0
            Else
                ' Mueve el scroll hacia arriba
                SendMessage hwnd, WM_VSCROLL, 0, ByVal 0
            End If
        End If
            
    End If
    
    WindowProc = CallWindowProc(PrevProc, hwnd, uMsg, wParam, lParam)
    
End Function

Private Function clase(handle As Long) As String
    Dim buffer As String * 256
    Dim ret As Long
    ret = GetClassName(handle, buffer, 256)
  
    clase = Left(buffer, ret)
End Function

' ********************************* Fin Funciones para el manejo del scrollbar *********************************
