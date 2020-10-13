Attribute VB_Name = "TSR_WEB"
Option Explicit
Private Const SEGUNDO As Date = 1# / 24# / 60# / 60# 'Un segundo

'--------------------------------------------------------
' Objetivo:     Obtener una referencia al objeto Document de un WebBrowser
'               Sustituye a la instrucción:
'                   Set miDoc= WebBrowser1.Document
'               ya que no funciona bien
' Parámetros:   phWeb: Control WebBrowser a utilizar
' Salida:       Devuelve una referencia al objeto Document
' Autor:        Teseracto - MTB
' Fecha:        30-10-2001
'
' Ejemplo:
'     'Obtiene objeto doc
'     Set mDoc = WEBGetObjetoDoc(webImagen)
'     'Quita scrollbars
'     mDoc.body.setAttribute "scroll", "no"
'--------------------------------------------------------
Function WEBGetObjetoDoc(phWeb As WebBrowser, Optional pTimeout = 10) As HTMLDocument
 Dim lCad$, lVeces%
 Dim lhDoc As HTMLDocument
 Dim lTime As Date
 
   'Inicia
   lVeces = 100
   
Reintenta:
   'Espera a que esté listo
   Do: DoEvents: Loop While phWeb.ReadyState <> READYSTATE_COMPLETE
   
   'Establece el objeto Doc
   Set lhDoc = phWeb.Document
   
   'Espera a que esté listo
   lTime = Now() + pTimeout * SEGUNDO
   Do: DoEvents: Loop While (lhDoc.ReadyState <> "complete") And (Now() < lTime)
   
   'Intenta leer el control web desde el objeto Doc
   On Error GoTo ErrorDoc
   lCad$ = lhDoc.body.innerHTML
   On Error GoTo 0

Salida:
   'Termina
   Set WEBGetObjetoDoc = lhDoc
   Exit Function
   

ErrorDoc:
   'Todavía no ha podido establecer la variable mDoc
   lVeces = lVeces - 1
   'Esperamos un poco
   DoEvents
   'Intentamos nuevamente
   If lVeces > 0 Then
      Resume Reintenta
   Else
      'De plano no pudo
      'Beep
      Resume Salida
   End If
End Function

'--------------------------------------------------------
' Objetivo:     Espera hasta que el navegador haya terminado
' Parametros:   phWeb: Control WebBrowser a utilizar
' Autor:        Teseracto - MTB
' Fecha:        30-10-2001
'
' Ejemplo:
'     WEBEspera(webImagen)
'--------------------------------------------------------
Sub WEBEspera(phWeb As WebBrowser)
 Dim lhDoc As HTMLDocument
   'Espera a que el objeto document esté totalmente cargado
   Set lhDoc = WEBGetObjetoDoc(phWeb)
End Sub

'--------------------------------------------------------
' Objetivo:     Navegar a un URL, en forma síncrona
'               (se espera hasta que haya completado la descarga)
'               Si no se encuentra el URL, aparece en blanco
' Parametros:   phWeb: Control WebBrowser a utilizar
'               pURL$: URL al cual se va a navegar
' Salida:       Devuelve True si se navegó sin problemas
' Autor:        Teseracto - MTB
' Fecha:        30-10-2001
'
' Ejemplo:
'     If Not WEBNavegar(webImagen,"http://www.Teseracto.com") Then
'        MsgBox "No se encontró el URL"
'     End If
'--------------------------------------------------------
Function WEBNavegar(phWeb As WebBrowser, pURL$) As Boolean
 Dim lhDoc As HTMLDocument
   
   
   'Navega
   phWeb.Navigate2 CStr(pURL), 14   'No usa caché ni historia
   WEBEspera phWeb
   
   'Refresca
   phWeb.Refresh: WEBEspera phWeb
   
   'Obtiene objeto Doc
   Set lhDoc = WEBGetObjetoDoc(phWeb)
   
   'Si no encuentra el URL el título vale "No se pudo bla bla bla..."
   ' asi sabemos que no lo encontró y limpiamos el control
   If lhDoc.Title <> "" Then
      lhDoc.body.innerHTML = ""
   End If
End Function


'--------------------------------------------------------
' Objetivo:     Limpiar un control WebBrowser
' Parametros:   phWeb: Control WebBrowser a limpiar
' Autor:        Teseracto - MTB
' Fecha:        30-10-2001
'
' Ejemplo:
'     WEBLimpiar(webImagen)
'--------------------------------------------------------
Sub WEBLimpiar(phWeb As WebBrowser)
   phWeb.Navigate2 "about:blank"
   WEBEspera phWeb
' Dim lhDoc As HTMLDocument
'
'   On Error Resume Next
'   'Obtiene objeto Doc
'   Set lhDoc = WEBGetObjetoDoc(phWeb)
'   'Limpia
'   lhDoc.body.innerHTML = ""
End Sub
