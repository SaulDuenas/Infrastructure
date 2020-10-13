Attribute VB_Name = "TSR_FG"
'*****************************************************************************************************
' TSR_FG - Teseracto (c) 1998
'          Ing. Carlos J. Rivero Moreno.
'          Ing. Miguel A. Torres-Orozco Bermeo.
' Funciones para el manejo de FlexGrids
'
' NUEVAS FUNCIONALIDADES:
' 8/06/2007 GRC: Intefaces para ordenar un FlexGrid a través de una de sus columnas.
'
'
'            Requerido : Agregar la referencia Microsoft ActiveX Data Objects 2.x Library
'
'*****************************************************************************************************

Option Explicit
Option Compare Text

'Coordenadas de selección en el Grid.
Private mRow1 As Integer, mRow2 As Integer   'Intervalo de Renglones Sel.
Private mCol1 As Integer, mCol2 As Integer   'Intervalo de Columnas Sel.
Private mCRow1 As Integer, mCRow2 As Integer 'Intervalo de Renglones a Copiar.
Private mCCol1 As Integer, mCCol2 As Integer 'Intervalo de Columnas a Copiar.

'8/06/2007: Constantes para el Enmascaramiento de la configuración de una columna de un FlexGrid que se ordenará.
Public Const FG_T_TEXTO As Integer = &H0
Public Const FG_T_ENTERO As Integer = &H1
Public Const FG_T_DOBLE   As Integer = &H2
Public Const FG_T_FECHA As Integer = &H3
Public Const FG_T_BOOLEAN As Integer = &H4
Public Const FG_O_ASC As Integer = &H100
Public Const FG_O_DESC As Integer = &H200

Public Const GRID_VACIO As Integer = 1


'10-Feb-2011: Variable para establecer el ancho de las filas en el llenado de grids
Public FGHeightRow As Long

'Inicialización de la clase
Public Sub FG_Initialize()
   FGHeightRow = 0
   FG_Inicializar
End Sub


'Inicializa los valore para manejar herramientas de edición en el Grid
Public Sub FG_Inicializar()
   mRow1 = -1
   mRow2 = -1
   mCRow1 = -1
   mCRow2 = -1
   mCol1 = -1
   mCol2 = -1
   mCCol1 = -1
   mCCol2 = -1
End Sub
 
'Pega, a partir de la celda activa, la copia seleccionada.
Public Sub FG_Pegar(phGrid As Control)
Dim r As Integer, C As Integer
Dim lCopia() As String

   phGrid.Redraw = False
        
   Sub_Pegar phGrid
   'Marca las celdas Pegadas seleccionandolas.
   r = phGrid.Row + mCRow2 - mCRow1
   If r < phGrid.Rows Then
      phGrid.RowSel = r
   Else
      phGrid.RowSel = phGrid.Rows - 1
   End If
   C = phGrid.Col + mCCol2 - mCCol1
   If C < phGrid.Cols Then
      phGrid.ColSel = C
   Else
      phGrid.ColSel = phGrid.Cols - 1
   End If
   
   phGrid.Redraw = True
End Sub

'Devuelve Verdadero si el bloque de celdas seleccionadas es valido.
Private Function Sub_SelValida(phGrid As Control) As Boolean

   Sub_SelValida = False
   
   'Despreciar los Renglones y Columnas Fijas (FixedXXX)
   If phGrid.Rows > phGrid.FixedRows And _
      phGrid.Cols > phGrid.FixedCols _
   Then
      'La selección debe ser de Celdas NO Fijas
      If phGrid.Row >= phGrid.FixedRows And _
         phGrid.RowSel >= phGrid.FixedRows And _
         phGrid.Col >= phGrid.FixedRows And _
         phGrid.ColSel >= phGrid.FixedRows _
      Then
      
         Sub_SelValida = True
         
      End If
   End If
End Function

'Establece el intervalo de Renglones seleccionados.
Private Sub FG_RowInterval(phGrid As Control)
   If phGrid.Row < phGrid.RowSel Then
      mRow1 = phGrid.Row: mRow2 = phGrid.RowSel
   Else
      mRow1 = phGrid.RowSel: mRow2 = phGrid.Row
   End If
End Sub

'Establece el intervalo de Columnas seleccionadas.
Private Sub FG_ColInterval(phGrid As Control)
   If phGrid.Col < phGrid.ColSel Then
      mCol1 = phGrid.Col: mCol2 = phGrid.ColSel
   Else
      mCol1 = phGrid.ColSel: mCol2 = phGrid.Col
   End If
End Sub

'Borra el contenido de las Celdas seleccionadas.
Public Sub FG_Borrar(phGrid As Control)
Dim r As Integer, C As Integer

   'Validar selección.
   If Sub_SelValida(phGrid) Then
      'Cancela procesos pendientes
      FG_Cancelar phGrid
      'Establecer el Renglón Inicial y el Final de la Selección.
      FG_RowInterval phGrid
      'Determinar la Columna Inicial y el Final de la Selección.
      FG_ColInterval phGrid
      
      'Barrer el bloque seleccionado, borrando el contenido.
      For r = mRow1 To mRow2
         For C = mCol1 To mCol2
            phGrid.TextMatrix(r, C) = ""
         Next
      Next
   End If
End Sub

'Interfase para Cancelar todos los procesos pendientes. Ej, cuando
'se editan celdas antes de terminar un Copy-Paste.
Public Sub FG_Cancelar(phGrid As Control)
   Sub_Cancelar phGrid
End Sub

'Procedimiento que ejecuta la cancelación de procesos pendientes.
Private Sub Sub_Cancelar(phGrid As Control)
Dim r As Integer, C As Integer, A As Integer
Dim rs As Integer, cs As Integer, fs As Integer, bcs As OLE_COLOR

   'Reestablecer el fondo de todas las celdas (Blanco)
   '-Respaldar selección actual.
   r = phGrid.Row
   C = phGrid.Col
   rs = phGrid.RowSel
   cs = phGrid.ColSel
   '-Respaldo de la Configuración Actual.
   fs = phGrid.FillStyle
   bcs = phGrid.BackColorSel
   
   '-Seleccionar la Copia anterior para reestablecer su Color de Fondo.
   If mCRow1 >= 0 And mCCol1 >= 0 Then
      'phGrid.Redraw = False
      phGrid.BackColorSel = vbWhite
      phGrid.Row = mCRow1: phGrid.Col = mCCol1
      phGrid.RowSel = mCRow2: phGrid.ColSel = mCCol2
      '-Fondo de color Blanco a todas las celdas.
      phGrid.FillStyle = flexFillRepeat: phGrid.CellBackColor = vbWhite
      'phGrid.Redraw = True
   End If
   
   '-Reestablece la Selección anterior.
   phGrid.Row = r
   phGrid.Col = C
   phGrid.RowSel = rs
   phGrid.ColSel = cs
   
   '-Reestablece la Configuración anterior
   phGrid.FillStyle = fs
   phGrid.BackColorSel = bcs
   
   'Cancela la copia anterior.
   mCRow1 = -1: mCRow2 = -1
   mCCol1 = -1: mCCol2 = -1

End Sub

'Hace una Copia de las Celdas seleccionadas, para pegar posteriormente.
Public Sub FG_Copiar(phGrid As Control)
Dim r As Integer, C As Integer

   phGrid.Redraw = False
   
   'Validar selección.
   If Sub_SelValida(phGrid) Then
   
      'Cancelar Procesos Pendientes.
      Sub_Cancelar phGrid
      
      'Establecer el Renglón Inicial y el Final de la Selección.
      FG_RowInterval phGrid
      'Determinar la Columna Inicial y el Final de la Selección.
      FG_ColInterval phGrid
      
      'Establece el Intervalo de Celdas a Copiar
      mCRow1 = mRow1
      mCRow2 = mRow2
      mCCol1 = mCol1
      mCCol2 = mCol2
      
      'Marcar la selección con diferente color.
      r = phGrid.FillStyle    'Respaldo de la Configuración Actual
      phGrid.FillStyle = flexFillRepeat
      phGrid.CellBackColor = vbYellow
      phGrid.FillStyle = r
      
   End If
   
   phGrid.Redraw = True
End Sub

'Repite de las celdas seleccionadas del primer renglón.
Public Sub FG_RepetirA(phGrid As Control)
   'row y colsel
Dim r As Integer, C As Integer

   phGrid.Redraw = False
   
   'Validar selección.
   If Sub_SelValida(phGrid) Then
      
      'Cancelar Procesos Pendientes.
      Sub_Cancelar phGrid
      
      'Establecer el Renglón Inicial y el Final de la Selección.
      FG_RowInterval phGrid
      'Determinar la Columna Inicial y el Final de la Selección.
      FG_ColInterval phGrid
      
      'Establece el Intervalo de Celdas a Copiar.
      mCRow1 = mRow1
      mCRow2 = mRow1    'Mismo renglón, varias columnas a copiar.
      mCCol1 = mCol1
      mCCol2 = mCol2
      
      'Pegar lo copiado hasta el último renglón seleccionado.
      phGrid.Col = mCCol1
      For r = mCRow1 + 1 To mRow2
         phGrid.Row = r
         Sub_Pegar phGrid
      Next
         
      Sub_Cancelar phGrid
      
      phGrid.Row = mRow1
      phGrid.Col = mCol1
      phGrid.RowSel = mRow2
      phGrid.ColSel = mCol2
      
   End If
   
   phGrid.Redraw = True

End Sub

'Procedimiento que ejecuta el pegado de las celdas copiadas.
Private Sub Sub_Pegar(phGrid As Control)
Dim r As Integer, C As Integer
Dim lCopia() As String

   If mCRow1 >= 0 And mCCol1 >= 0 Then
      With phGrid
         'Existen 2 posibles formas de pegar las celdas.
         If (.Row <= mCRow1 Or .Row > mCRow2) And _
            (.Col <= mCCol1 Or .Col > mCCol2) _
         Then
            '1. Barriendo y traspasando la información Celda a Celda.
            For r = 0 To mCRow2 - mCRow1
               For C = 0 To mCCol2 - mCCol1
                  If (.Row + r) < .Rows And (.Col + C) < .Cols Then
                     .TextMatrix(.Row + r, .Col + C) = .TextMatrix(mCRow1 + r, mCCol1 + C)
                  End If
               Next
            Next
         Else 'El bloque destino está completa o parcialmente inmersa en el bloque origen.
            '2. Se hace una Copia en un arreglo para después trasladar.
            ReDim lCopia(mCRow2 - mCRow1, mCCol2 - mCCol1)
            For r = 0 To UBound(lCopia, 1)
               For C = 0 To UBound(lCopia, 2)
                  lCopia(r, C) = .TextMatrix(mCRow1 + r, mCCol1 + C)
               Next
            Next
            For r = 0 To UBound(lCopia, 1)
               For C = 0 To UBound(lCopia, 2)
                  If (.Row + r) < .Rows And (.Col + C) < .Cols Then
                     .TextMatrix(.Row + r, .Col + C) = lCopia(r, C)
                  End If
               Next
            Next
            
         End If
         
      End With
   End If

End Sub

'Devuelve el contenido de una celda dentro de un grid
Function FGLeeDato(phGrid As Control, pRow%, pCol%) As Variant
   FGLeeDato = phGrid.TextArray(pRow% * phGrid.Cols + pCol%)
End Function

'Devuelve un dato del renglón seleccionado en un Grid
'Parámetros:
'   phGrid= Grid
'     pCol= Número de la columna deseada (base en cero)
'           si se omite, devuelve el contenido de la última columna
Function FGSeleccion(phGrid As Control, Optional ByVal pCol = Null) As Variant
 Dim lRow%
 
   'Si no se pidió una columna devolver la última
   If IsNull(pCol) Then pCol = phGrid.Cols - 1
   
   'Obtenemos el renglón seleccionado
   lRow% = phGrid.Row

   'Regresa el contenido
   FGSeleccion = Trim$(phGrid.TextArray(lRow% * phGrid.Cols + pCol))
End Function

'Busca un dato en un grid y lo selecciona
'Parámetros:
'   phGrid= Grid
'  pClave$= Dato que se está buscando
'     pCol= Número de la columna de búsqueda (base en cero)
'           si se omite, busca en la última columna
Sub FGSeleccionar(phGrid As Control, pClave$, Optional ByVal pCol = Null)
 Dim lRow%
 Dim lRowIni%, lRowFin%, lCols%
 Dim lFound As Boolean
 
   'Obtiene columnas (para no estar leyendo)
   lCols% = phGrid.Cols
   
   'Si no se pidió una columna buscar en la última
   If IsNull(pCol) Then pCol = lCols% - 1
   
   'Obtiene el intervalo de renglones a recorrer (para no estar leyendo)
   lRowIni% = phGrid.FixedRows 'desde el primer renglón no fijo
   lRowFin% = phGrid.Rows - 1  'hasta el último
   
   'Recorre el grid
   lFound = False
   For lRow% = lRowIni% To lRowFin%
      If pClave$ = Trim$(phGrid.TextArray(lRow% * lCols% + pCol)) Then
         'Encontrado!
         lFound = True
         Exit For
      End If
   Next
   
   'Lo encontramos?
   If lFound Then
      'Selecciona el renglón
      FGSelectRow phGrid, lRow%
   Else
   
   'Selecciona el 1er renglon (el fijo (si hay))
   If phGrid.Rows > 1 Then
      phGrid.Row = 1
   End If
   
   'phGrid.Row = 0
   End If
End Sub


'Introduce un dato como contenido de una celda dentro de un grid
Sub FGEscribeDato(phGrid As Control, pRow%, pCol%, pDato As Variant, Optional pAling As AlignmentSettings = flexAlignLeftCenter)
   Dim lCol As Integer
   Dim lRow As Integer


   lCol = phGrid.Col
   lRow = phGrid.Row
   
   phGrid.Col = pCol%
   phGrid.Row = pRow%
   
   phGrid.TextArray(pRow% * phGrid.Cols + pCol%) = pDato
   
   phGrid.ColAlignment(lCol) = pAling
    
   phGrid.Col = lCol
   phGrid.Row = lRow
'

End Sub


'Elimina el renglón deseado de un grid
Sub FGBorrar(phGrid As Control, ByVal pRow%)
   
   'Solo puede borrar renglones no-fijos
   If pRow% < phGrid.FixedRows Or pRow% > (phGrid.Rows - 1) Then Exit Sub
   
   'Borra el renglón
   If phGrid.Rows > phGrid.FixedRows + 1 Then
      phGrid.RemoveItem pRow%
   Else
      'Caso especial para cuando solo queda un elemento
      phGrid.Rows = phGrid.FixedRows
      phGrid.HighLight = flexHighlightNever
   End If
   
End Sub



'Selecciona el renglón deseado de un grid
Sub FGSelectRow(phGrid As Control, ByVal pRow%)

   'Solo puede seleccionar renglones que tiene el grid
   If pRow% < 0 Then pRow% = 0
   If pRow% >= phGrid.Rows Then pRow% = phGrid.Rows - 1
   If pRow% < 0 Then Exit Sub
   
   'Si el renglón no está visible, ponlo hasta arriba
   If Not phGrid.RowIsVisible(pRow%) Then phGrid.TopRow = pRow%
   
   'Selecciona el renglón
   phGrid.Row = pRow%
   phGrid.Col = phGrid.FixedCols
   phGrid.ColSel = phGrid.Cols - 1
End Sub

Sub FGAgregarRenglon(phGrid As Control, ParamArray pData())
'---------------------------------------------------------------------------------------
' Objetivo:     Inserta un renglón en un grid con los datos pasados como parámetros
'
' Autor:        Teseracto - CRM
' Fecha:        29-09-98
'
' USO:
'   phGrid      (IN)   Grid por llenar
'   pData()     (IN)   Lista de datos para llenar: Dato1, Dato2, ...
'
' SALIDA:
'   Ninguna
'
' NOTAS:       -Se debe pasar el mismo número de datos como columnas tenga el grid
'              -Los datos pueden ser de cualquier tipo, menos de usuario o imágenes
'
' EJEMPLO:
'   FGAgregarItem(grdEMpleado, Nombre$, Depto$, Clave%)

 Dim lStr$, k%
 
    'Se sale y avisa si el número de columnas no es igual al número de datos
    If phGrid.Cols <> (UBound(pData) - LBound(pData) + 1) Then
       lStr$ = "ERROR en 'FGAgregarRenglon()': número de columnas diferente al número de datos."
       lStr$ = lStr$ & vbCr & "No se puede insertar el renglón en el grid"
       FNErrorBox lStr$
       Exit Sub
    End If
    
    'Construye el renglón con los datos pasados como parámetros
    lStr$ = pData(LBound(pData))
    For k% = LBound(pData) + 1 To UBound(pData) Step 1
       lStr$ = lStr$ & vbTab & pData(k%)
    Next
        
    'Añade el nuevo renglón
    phGrid.AddItem lStr$
    ' Si tenemos un nuevo ancho para las filas
    If FGHeightRow > 0 Then phGrid.RowHeight(phGrid.Rows - 1) = FGHeightRow
    FGHeightRow = 0
    'Inhibe selección de encabezados si no se pudo insertar el renglón
    If phGrid.Row = 0 Then
       phGrid.HighLight = flexHighlightNever
    Else
       phGrid.HighLight = flexHighlightAlways
    End If
    
     
End Sub


Function FGLlenarPic(phGrid As Control, pQry$, pConnection As ADODB.Connection, phImageList As Control, pIconCol%, pEqual%, ParamArray pKeys()) As Integer
'---------------------------------------------------------------------------------------
' Objetivo:     Llena un grid con el resultado de un query con una imagen
'               en la columna indicada por pIconCol% (base 0)
'
' Autor:        Teseracto - MTB,CRM
' Fecha:        24-11-98
'
' USO:
'   phGrid      (IN)   Grid por llenar
'   pQry$       (IN)   Query con los datos: 1er col. es el campo que definirá
'                      la imagen
'   pConnection (IN)   Conexión a la base de datos (ADODB.Connection)
'                      Si pConnection = Nothing, se usa la base de datos por default
'   phImageList (IN)   Es la fuente de las imágenes
'   pIconCol%   (IN)   Columna (base 0) en que aparece el ícono
'   pEqual%     (IN)   True= Igual, = Diferente
'   pKeys()     (IN)   Lista de parámetros en parejas: Valor, Imagen, Valor, Imagen, ...
'
' SALIDA:
'   True        Se llenó correctamente el grid
'
' NOTAS:       -La 1er columna del query no se depliega sino el dibujo asociado
'              -No pone imagen si no coincide la 1er columna del query con
'               ningun Valor en pKeys()
'              -Hace uso de Cst_dbX.bas e Cst_fn.bas
'              -El resultado del query pQry$ debe coincidir en columnas
'               con el grid
' EJEMPLO:
'   'Identificando las imágenes por su nombre (Key) en el ImageList
'   lOK% = FGLlenarPic(grdEmpleados, "Select Depto, Nombre from Empleados", lhDB%, _
'                      imlIconos, 0, True, "Sistemas", "Computadora", _
'                                          "Manufactura", "Engranes")
'
'   'Identificando las imágenes por su índice (Index) en el ImageList
'   lOK% = FGLlenarPic(grdEmpleados, "Select Depto, Nombre from Empleados", lhDB%, _
'                      imlIconos, 0, True, "Sistemas", 2, _
'                                          "Manufactura", 14)
'
'   'Indica con un tache a los clientes que no han pagado
'   lOK% = FGLlenarPic(grdEmpleados, "Select Status, Nombre from Facturas", lhDB%, _
'                      imlIconos, 0, False, "PAGADO", "Tache")
 Dim lOk%, lhCur%, lStr$, i%, k%
 Dim lDato As Variant

    lOk% = True
    'Inicializar grid
    phGrid.Rows = 1
    phGrid.HighLight = flexHighlightNever
    ' -- Deshabilitar el repintado del control ( Para que la carga sea mas veloz )
    phGrid.Redraw = False
 
    i% = 0 'renglón en el que vamos
    'lAlingCell = phGrid.CellAlignment
    'Abre cursor
    If DBCursorIniciar(lhCur%, pQry$, pConnection) Then
       While DBCursorSiguiente(lhCur%)
          'lleva la cuenta del renglón
          i% = i% + 1
          
          'Construye el renglón
          lStr$ = ""
          For k% = 0 To phGrid.Cols - 1
             If k% = pIconCol% Then
               lStr$ = lStr$ & vbTab
             Else
               lStr$ = lStr$ & DBCursorDato(lhCur%, k%) & vbTab
             End If
          Next
          lStr$ = Left$(lStr$, Len(lStr$) - 1)
          
          'Añade un nuevo renglón
          phGrid.AddItem lStr$

          ' Si tenemos un nuevo ancho para las filas -> Se define el ancho
          If FGHeightRow > 0 Then phGrid.RowHeight(i%) = FGHeightRow
          
          'obtiene el dato de la pIconCol-ésima columna
          lDato = DBCursorDato(lhCur%, pIconCol%)
          
          'Añade imágenes según el resultado del query
          For k% = LBound(pKeys) To UBound(pKeys) Step 2
             'revisa si el 1er campo y pKey(k%) coinciden según la relación pEqual
             If (pEqual And lDato = pKeys(k%)) Or (Not pEqual And lDato <> pKeys(k%)) Then
                'Sí => pone la imagen en la columna pIconCol de este renglon
                phGrid.Row = i%
                phGrid.Col = pIconCol%
                phGrid.CellPicture = phImageList.ListImages(pKeys(k% + 1)).Picture
                phGrid.CellPictureAlignment = flexAlignCenterCenter
             End If
          Next
          
       Wend
       'Cierra Cursor
       DBCursorTerminar lhCur%

       'Inhibe selección de encabezados
       If i% = 0 Then
          phGrid.HighLight = flexHighlightNever
       Else
          phGrid.HighLight = flexHighlightAlways
       End If
    Else
       lOk% = False
    End If
    ' Seleccionamos el primer renglon
    If phGrid.Row > 0 Then phGrid.Row = 1
    
    'regresa
    ' -- Volver a Habilitar el repintado del Grid
    phGrid.Redraw = True

    FGLlenarPic = lOk%

End Function


'******************************************************************************************************************

'  INTERFACES DE ORDENAMIENTO (PUBLICAS) UTILIZADAS POR EL USUARIO FINAL
'
'  Function FG_Ordenar (MSFlexGrid, Integer, Optional Integer = -1) As Boolean
'  Sub FG_ColumnaOrdenada (MSFlexGrid, Integer, Optional Integer = FG_O_ASC)
'  Sub FG_RowSwap (MSFlexGrid, Integer, Integer)
'
'******************************************************************************************************************


'******************************************************************************************************************
'  8-Jun-2007:    FGOrdenar
'  Interfaz de usuario para ordenar el contenido de un FlexGrid a través de su columna <pColumna>.
'
'  DESCRIPCIÓN:
'  La función utiliza la propiedad ColData para identificar el tipo de dato contenido en la columna, y ordenará,
'  bajo la columna pColumna, en forma Ascendente/Descendente de manera alternada según el orden previo de la columna.
'
'     Tipo de Dato:
'           &H00: Texto
'           &H01: Entero   (Integer y Long)
'           &H02: Doble    (Double y Currency)
'           &H03: Fecha    (Date)
'           &H04: Boolean
'
'     Orden Previo de la Columna:
'           &H00xx:  La columna NO está ordenada, se Ordenará Ascendentemente.
'           &H01xx:  Orden Ascendente, se Ordenará Descendentemente.
'           &H02xx:  Orden Descendente, se Ordenará Ascendentemente.
'
'  Se necesita el tipo de dato en la propiedad ColData para cada columna que se pueda ordenar, en caso de que
'  la columna no tenga el tipo de dato, entonces la función tomará los valores como Texto de manera predeterminada.
'
'  PARÁMETROS:
'     pGrid       (I/O)    Apuntador al Grid que se quiere ordenar.
'     pColumna    (I)      Número de Columna sobre la cual se ordenará. Su dominio es de 0 a pGrdi.Cols-1
'     pTipoDato   (I*)     Opcional. Tipo de Dato de la columna. Si se establece, no se toma en cuenta el de ColData
'******************************************************************************************************************
Public Function FGOrdenar(pGrid As MSFlexGrid, ByVal pColumna As Integer, Optional ByVal pTipoDato As Integer = -1) As Boolean
On Error GoTo errOrdenar
   Dim lError As Byte, lArray() As Integer, i As Integer, J As Integer
   Dim lAux() As String
   
   FGOrdenar = False
   With pGrid
      'ESTABLECER SI LA COLUMNA pColumna ESTÁ ORDENADA O NO.
      If .ColData(pColumna) > &HFF Then
         'SÍ. Alternar Orden
         If FG_CambiarOrden(pGrid) Then
            'Mascara para alternar los bits de Ascendente/Descendente.
            .ColData(pColumna) = .ColData(pColumna) Xor &H300
            FGOrdenar = True
         End If
      Else
         'NO. Desmarcar la columna que estaba ordenada.
         J = .Col
         For i = .FixedCols To .Cols - 1
            'Mascara que cancela los bits de Ordenamiento y mantiene los de Tipo de dato.
            If .ColData(i) > &HFF Then
               .Row = 0
               .Col = i
               .CellFontBold = False
            End If
            .ColData(i) = .ColData(i) And &HFF
         Next
         If pTipoDato < 0 Then pTipoDato = .ColData(pColumna) And &HFF
         'Ordenar pColumna y Marcarla como Ascendente.
         If FG_HeapSort(pGrid, pColumna, pTipoDato) Then
            'Marcara para activar el bit de Ascendente.
            .ColData(pColumna) = .ColData(pColumna) Or &H100
            If .FixedRows > 0 Then
               .Col = pColumna
               .Row = 0
               .CellFontBold = True
            End If
            FGOrdenar = True
         End If
         .Col = J
      End If
      
      If .Rows > .FixedRows Then
         .Row = .FixedRows
         .Col = .FixedCols
         .ColSel = .Cols - 1
      End If
   End With
   Exit Function
errOrdenar:
   'Salir
   FGOrdenar = False
End Function

'Establece el pOrden de la columna pColumna del grid pGrid.
Public Sub FGColumnaOrdenada(pGrid As Control, pColumna As Integer, Optional pOrden As Integer = FG_O_ASC)
   If pOrden <> FG_O_ASC And pOrden <> FG_O_DESC Then pOrden = FG_O_ASC
   pGrid.ColData(pColumna) = (pGrid.ColData(pColumna) And &HFF) Or pOrden
   If pGrid.FixedRows > 0 Then
      pGrid.Col = pColumna
      pGrid.Row = 0
      pGrid.CellFontBold = True
   End If
End Sub

'Intercambia los renglones i y j del grid pGrid.
Public Sub FGRowSwap(pGrid As Control, i As Integer, J As Integer)
   Dim k As Integer, lSwap As String
   
   With pGrid
      If i >= .FixedRows And i < .Rows Then
         If J >= .FixedRows And J < .Rows Then
            For k = .FixedCols To .Cols - 1
               lSwap = .TextMatrix(i, k)
               .TextMatrix(i, k) = .TextMatrix(J, k)
               .TextMatrix(J, k) = lSwap
            Next
         End If
      End If
   End With
End Sub

'******************************************************************************************************************
'***********   FUNCIONES AUXILIARES (PRIVADAS) UTILIZADAS POR LA INTERFACE DE ORDENAMIENTO  ***********************
'******************************************************************************************************************

'******************************************************************************************************************
'  8-Jun-2007:    FG_HeapSort
'  Función que ordena, usando el método HeapSort, el contenido de un FlexGrid a través de
'  su columna <pColumna>. Devuelve un valor True si pGrid fue ordenado satisfactoriamente, False si no fue así.
'
'  Parámetros:
'     pGrid       (I/O)    Apuntador al Grid que se quiere ordenar.
'     pColumna    (I)      Número de Columna sobre la cual se ordenará. Su dominio es de 0 a pGrdi.Cols-1
'******************************************************************************************************************
Private Function FG_HeapSort(ByRef pGrid As Control, pColumna As Integer, pTipoDato As Integer) As Boolean
On Error GoTo errHeap
   Dim i As Integer, lOk As Boolean
     
   With pGrid
      DoEvents
      For i = ((.Rows - .FixedRows) / 2) - 1 + .FixedRows To .FixedRows Step -1
         lOk = FG_HeapSort_2(pGrid, i, .Rows - .FixedRows, pColumna, pTipoDato)
      Next
      DoEvents
      
      If lOk Then
         For i = .Rows - .FixedRows To .FixedRows + 1 Step -1
            Call FGRowSwap(pGrid, .FixedRows, i)
            If Not FG_HeapSort_2(pGrid, .FixedRows, i - 1, pColumna, pTipoDato) Then
               GoTo errHeap
            End If
         Next
      End If
      DoEvents
   End With
   FG_HeapSort = True
   Exit Function
errHeap:
   FG_HeapSort = False
End Function

'******************************************************************************************************************
'  8-Jun-2007
'  Función auxiliar usada por FG_HeapSort para establecer el valor Maximo y su posición optima, analizando los
'  elementos desde el índice (pRoot*2) hasta pBottom su columna <pColumna>. Devuelve un valor True si se pudo
'  encontrar el valor Máximo sin error, y devuelve False si hubo un error en el proceso.
'
'  Parámetros:
'     pGrid       (I/O)    Apuntador al Grid que se quiere ordenar.
'     pRoot       (I)      Renglón de pGrid a evaluar como Raíz.
'     pBottom     (I)      Indice del último elemento del monton.
'     pColumna    (I)      Número de Columna sobre la cual se ordenará. Su dominio es de 0 a pGrdi.Cols-1
'     pTipoDato   (I)      Especifíca el tipo de dato contenido en la columna (pues en un Grid todos son texto).
'        Valores: (véanse las constantes FG_T_xxxx)
'******************************************************************************************************************
Private Function FG_HeapSort_2(pGrid As Control, ByVal pRoot As Integer, pBottom As Integer, pColumna As Integer, pTipoDato As Integer) As Boolean
On Error GoTo errHeap2
   Dim lFin As Boolean, maxChild As Integer
   Dim A As Boolean, lFecha1 As Date, lFecha2 As Date
   
   With pGrid
      lFin = False
      While (pRoot * 2) <= pBottom And Not lFin
         If (pRoot * 2) = pBottom Then
            maxChild = pRoot * 2
         Else
            Select Case pTipoDato
               Case FG_T_TEXTO: A = .TextMatrix(pRoot * 2, pColumna) > .TextMatrix(pRoot * 2 + 1, pColumna)
               Case FG_T_ENTERO: A = CInt(.TextMatrix(pRoot * 2, pColumna)) > CInt(.TextMatrix(pRoot * 2 + 1, pColumna))
               Case FG_T_DOBLE: A = CDbl(.TextMatrix(pRoot * 2, pColumna)) > CDbl(.TextMatrix(pRoot * 2 + 1, pColumna))
               Case FG_T_FECHA:
                                 If IsDate(.TextMatrix(pRoot * 2, pColumna)) Then
                                    lFecha1 = CDate(.TextMatrix(pRoot * 2, pColumna))
                                 Else
                                    lFecha1 = CDate(0)
                                 End If
                                 If IsDate(.TextMatrix(pRoot * 2 + 1, pColumna)) Then
                                    lFecha2 = CDate(.TextMatrix(pRoot * 2 + 1, pColumna))
                                 Else
                                    lFecha2 = CDate(0)
                                 End If
                                 A = lFecha1 > lFecha2
               Case FG_T_BOOLEAN: A = .TextMatrix(pRoot * 2, pColumna) > .TextMatrix(pRoot * 2 + 1, pColumna)
            End Select
            
            If A Then
               maxChild = pRoot * 2
            Else
               maxChild = pRoot * 2 + 1
            End If
         End If
         
         Select Case pTipoDato
            Case FG_T_TEXTO: A = .TextMatrix(pRoot, pColumna) < .TextMatrix(maxChild, pColumna)
            Case FG_T_ENTERO: A = CInt(.TextMatrix(pRoot, pColumna)) < CInt(.TextMatrix(maxChild, pColumna))
            Case FG_T_DOBLE: A = CDbl(.TextMatrix(pRoot, pColumna)) < CDbl(.TextMatrix(maxChild, pColumna))
            Case FG_T_FECHA:
                              If IsDate(.TextMatrix(pRoot, pColumna)) Then
                                 lFecha1 = CDate(.TextMatrix(pRoot, pColumna))
                              Else
                                 lFecha1 = CDate(0)
                              End If
                              If IsDate(.TextMatrix(maxChild, pColumna)) Then
                                 lFecha2 = CDate(.TextMatrix(maxChild, pColumna))
                              Else
                                 lFecha2 = CDate(0)
                              End If
                             A = lFecha1 < lFecha2
            Case FG_T_BOOLEAN: A = .TextMatrix(pRoot, pColumna) < .TextMatrix(maxChild, pColumna)
         End Select
            
         If A Then
            Call FGRowSwap(pGrid, pRoot, maxChild)
            pRoot = maxChild
         Else
            lFin = True
         End If
      Wend
   End With
   FG_HeapSort_2 = True
   Exit Function

errHeap2:
   FG_HeapSort_2 = False
End Function

'Este procedimiento intercambia el orden de los renglones de pGrid de ASC->DESC o DESC->ASC,
'lo cual significa que se necesita ordenar el grid bajo la columna deseada antes de llamar a este procedimiento.
Private Function FG_CambiarOrden(ByRef pGrid As Control) As Boolean
   Dim i As Integer, J As Integer
   
On Error GoTo errCambiar
   With pGrid
      i = .FixedRows
      J = .Rows - 1
      While i < J
         Call FGRowSwap(pGrid, i, J)
         i = i + 1
         J = J - 1
      Wend
   End With
   FG_CambiarOrden = True
   Exit Function
errCambiar:
   FG_CambiarOrden = False
End Function

'********************************************************************************
'* Procedimiento: FGBuscarDato.                                                 *
'*      Objetivo: Permite localizar un dato ó parte de este sobre todo el grid ó*
'*                por una columna especifica, cuando el valor de pnColumna es 0 *
'*                realiza la busqueda en todo el grid.                          *
'*    Parámetros:                                                               *
'*               -Entrada-                                                      *
'*                     poGrid: Objeto FlexGrid.                                 *
'*                  pnColumna: Número de Columna a Localizar.                   *
'*                     psDato: Dato a localizar.                                *
'*                  pbOcultos: Establece si la busqueda se va arealizar sobre   *
'*                             datos ocultos (False = No, True = Sí).           *
'*         Autor: TSR-IHS.                                                      *
'*         Fecha: 04/Junio/2007.                                                *
'********************************************************************************

Public Function FGBuscarDato(poGrid As MSFlexGrid, pnColumna As Long, psDato As String, Optional pbOcultos As Boolean = False, Optional pSeleccionar As Boolean = True) As Boolean
 Dim lbOk As Boolean      'Validación de Busqueda.
 Dim lnFila As Long       'Fila anterior.
 Dim lbBuscar As Boolean  'Buscar en datos Ocultos.
 Dim F As Long            'Índice de Filas.
 Dim C As Long            'Índice de Columnas.
 
 Dim lCol As Long
 Dim lRow As Long
    
   '[1]Inicializar.
   lnFila = poGrid.Row
   
   lRow = poGrid.Row
   lCol = poGrid.Col
   
   lbOk = False
   
   ' Tenemos Datos que buscar
   If Not FG_Vacio(poGrid) Then
      
      '[2]Recorrer Grid.
      If pnColumna = 0 Then
         '//Buscar en todas las columnas
         'Barre los renglones de la posición actual hacia abajo
         For F = poGrid.Row + 1 To poGrid.Rows - 1
            'Barre las columnas
            For C = poGrid.FixedCols To poGrid.Cols - 1
               If ((poGrid.ColWidth(C) > 0) Or pbOcultos) And _
                  (InStr(Trim$(UCase$(poGrid.TextMatrix(F, C))), UCase$(psDato)) > 0) Then
                  '//Existe el dato en el grid, seleccionar fila.
                  If pSeleccionar Then FGSelectRow poGrid, F
                  lbOk = True
                  Exit For
               End If
            Next
            If lbOk Then Exit For
         Next
         'No lo encontro hacia abajo?
         If Not lbOk Then
            'Ahora lo busca desde arriba
            'Barre Renglones
            For F = poGrid.FixedRows To poGrid.Row
               'Barre Columnas
               For C = poGrid.FixedCols To poGrid.Cols - 1
                  If ((poGrid.ColWidth(C) > 0) Or pbOcultos) And _
                     (InStr(Trim$(UCase$(poGrid.TextMatrix(F, C))), UCase$(psDato)) > 0) Then
                     '//Existe el dato en el grid, seleccionar fila.
                     If pSeleccionar Then FGSelectRow poGrid, F
                     lbOk = True
                     Exit For
                  End If
               Next
               If lbOk Then Exit For
            Next
         End If
      Else
         '//Buscar en una Columna.
         'poGrid.Col = pnColumna
         C = pnColumna
         For F = poGrid.Row + 1 To poGrid.Rows - 1
             'poGrid.Row = f
             If InStr(Trim$(UCase$(poGrid.TextMatrix(F, C))), UCase$(psDato)) > 0 Then
                '//Existe el dato en el grid, seleccionar fila.
                If pSeleccionar Then FGSelectRow poGrid, F
                lbOk = True
                Exit For
             End If
         Next
         If Not lbOk Then
           For F = poGrid.FixedRows To poGrid.Row
               'poGrid.Row = f
               If InStr(Trim$(UCase$(poGrid.TextMatrix(F, C))), UCase$(psDato)) > 0 Then
                  '//Existe el dato en el grid, seleccionar fila.
                  If pSeleccionar Then FGSelectRow poGrid, F
                  lbOk = True
                  Exit For
               End If
           Next
         End If
      End If
      
      '[3]Validar Existencia.
      If Not lbOk Then
         ' Se deja la seleccion original antes de la busqueda
         If pSeleccionar Then Call FGSelectRow(poGrid, lnFila)
         'Beep
      End If
   
   End If
   
   FGBuscarDato = lbOk
   
End Function

'********************************************************************************
'* Procedimiento: FGSeleccionarTodo.                                            *
'*      Objetivo: Permite elegir todos los renglones de un FlexGrid.            *
'*    Parámetros:                                                               *
'*               -Entrada-                                                      *
'*                     poGrid: Objeto FlexGrid.                                 *
'*         Autor: TSR-IHS.                                                      *
'*         Fecha: 04/Junio/2007.                                                *
'********************************************************************************

Public Sub FGSeleccionarTodo(poGrid As MSFlexGrid)
  
   '[1]Establecer coordenadas Inicales.
   poGrid.Col = 0
   poGrid.Row = 1
   
   '[2]Establecer coordenadas Finales.
   poGrid.ColSel = poGrid.Cols - 1
   poGrid.RowSel = poGrid.Rows - 1
   
   '[3]Pasar Foco al Grid.
   poGrid.SetFocus
   
End Sub

'********************************************************************************
'* Procedimiento: FGCopiarClipBoard.                                            *
'*      Objetivo: Permite copiar los renglones seleccionados de un FlexGrid al  *
'*                portapapeles de Windows.                                      *
'*    Parámetros:                                                               *
'*               -Entrada-                                                      *
'*                     poGrid: Objeto FlexGrid.                                 *
'*                  pbOcultos: Establece que tambien se van a copiar las        *
'*                             columnas Ocultas (False = No, True = Sí).        *
'*         Autor: TSR-IHS.                                                      *
'*         Fecha: 04/Junio/2007.                                                *
'********************************************************************************

Public Sub FGCopiarClipBoard(poGrid As MSFlexGrid, Optional pbOcultos As Boolean = False)
 Dim lnXo As Long           'Fila Inicial.
 Dim lnXf As Long           'Fila Final.
 Dim lnYo As Long           'Columna Inicial.
 Dim lnYf As Long           'Columna Final.
 Dim lsMatriz As String     'Matriz de Datos (Lineal).
 Dim lsRenglon As String    'Renglón de Datos.
 Dim lsHeaders() As String  'Encabezados del Grid.
 Dim pbCopiar As Boolean    'Copiar Elemento.
 Dim F As Long              'Índice de Filas.
 Dim C As Long              'Índice de Columnas.

   '[1]Validación Inicial.
   If poGrid.Rows < 1 Then
      Call FNExclamBox("Selección no Valida")
      Exit Sub
   End If
   
   '[2]Inicializar parámetros.
   lsMatriz = ""
   If poGrid.Row < poGrid.RowSel Then
      lnYo = poGrid.Row
      lnYf = poGrid.RowSel
   Else
      lnYo = poGrid.RowSel
      lnYf = poGrid.Row
   End If
   lnXo = 1
   lnXf = poGrid.Cols
   lsHeaders = Split(poGrid.FormatString, "|")
   
   '[3]Obtener Headers.
   poGrid.Row = 0
   For C = lnXo To lnXf - 1
      If poGrid.ColWidth(C) = 0 Then
         pbCopiar = pbOcultos
      Else
         pbCopiar = True
      End If
      If pbCopiar Then
         If lsMatriz = "" Then
            lsMatriz = Trim$(Replace(lsHeaders(C), "<", ""))
         Else
            lsMatriz = lsMatriz & vbTab & Trim$(Replace(lsHeaders(C), "<", ""))
         End If
      End If
   Next
   
   '[4]Obtener Matriz.
   For F = lnYo To lnYf
      lsRenglon = ""
      For C = lnXo To lnXf - 1
         If poGrid.ColWidth(C) = 0 Then
            pbCopiar = pbOcultos
         Else
            pbCopiar = True
         End If
         If pbCopiar Then
            If lsRenglon = "" Then
               lsRenglon = Trim$(poGrid.TextMatrix(F, C))
            Else
               lsRenglon = lsRenglon & vbTab & Trim$(poGrid.TextMatrix(F, C))
            End If
         End If
      Next
      If lsRenglon <> "" Then lsMatriz = lsMatriz & vbCrLf & lsRenglon
   Next
   
   '[4]Establecer Matriz de datos en el Portapapeles.
   Clipboard.Clear
   Clipboard.SetText lsMatriz
   
   '[5]Recuperar Selección.
   poGrid.Col = 0
   poGrid.Row = lnYo
   poGrid.ColSel = poGrid.Cols - 1
   poGrid.RowSel = lnYf
   
End Sub


'********************************************************************************
'* Función: FGLlenar.                                                           *
'*      Objetivo: Permite Listar un MSFlexGrid con un Query,                    *
'*                permitiendo Merge sobre columnas.                             *
'*    Parámetros:                                                               *
'*               -Entrada-                                                      *
'*                     poGrid: Objeto MSFlexGrid.                               *
'*               psConnection: Conexión a Base de Datos.                        *
'*         Autor: TSR-IHS.                                                      *
'*         Fecha: 12/Junio/2007.                                                *
'* Notas: El resultado del query pQry$ debe coincidir en columnas
'*        con el grid
'********************************************************************************
Function FGLlenar(phGrid As Control, pQry$, Optional pConnection As ADODB.Connection = Nothing) As Boolean
 Dim lOk%, lhCur%, lStr$, i%, k%

    lOk% = True
    'Inicializar grid
    Call FG_Clean(phGrid)
    
    ' -- Deshabilitar el repintado del control ( Para que la carga sea mas veloz )
    phGrid.Redraw = False
    i% = 0 'renglón en el que vamos
    
    'Abre cursor
    If DBCursorIniciar(lhCur%, pQry$, pConnection) Then
      
       While DBCursorSiguiente(lhCur%)
          'lleva la cuenta del renglón
          i% = i% + 1
          
          'Construye el renglón para la primera columna
          lStr$ = DBCursorDato(lhCur%, 0)
          For k% = 1 To phGrid.Cols - 1
              ' continua para las columnas siguientes
             lStr$ = lStr$ & vbTab & DBCursorDato(lhCur%, k%)
          Next
          
          'Añade un nuevo renglón
          phGrid.AddItem lStr$
          ' Si tenemos un nuevo ancho para las filas
          If FGHeightRow > 0 Then phGrid.RowHeight(i%) = FGHeightRow
          
       Wend
       'Cierra Cursor
       DBCursorTerminar lhCur%

       'Inhibe selección de encabezados
       If i% = 0 Then
          phGrid.HighLight = flexHighlightNever
       Else
          phGrid.HighLight = flexHighlightAlways
       End If
    Else
       lOk% = False
    End If
    FGHeightRow = 0
    ' -- Volver a Habilitar el repintado del Grid
    phGrid.Redraw = True
    
    'regresa
    FGLlenar = lOk%

End Function




'* Función: HGLlenar.                                                          *
'*      Objetivo: Permite Listar un Hierarchical Flex Grid con un Query,        *
'*                permitiendo Merge sobre columnas.                             *
'*    Parámetros:                                                               *
'*               -Entrada-                                                      *
'*                     poGrid: Objeto Hierarchical Flex Grid.                   *
'*               psConnection: Conexión a Base de Datos.                        *
'*                 pnColumnas: Parámetros de Columnas a realizar Merge.         *
'*         Autor: TSR-IHS.                                                      *
'*         Fecha: 12/Junio/2007.                                                *
'********************************************************************************

Public Function HGLlenar(poGrid As MSHFlexGrid, psQry As String, psConnection As ADODB.Connection, ParamArray pnColumnas()) As Boolean

 Dim lsFormato As String  'Format String del Grid.
 Dim lhCur As Integer     'Cursor de Datos.
 Dim lbOk As Boolean      'Validación de Función.
 Dim lsCad As String      'Cadena de Datos.
 Dim F As Integer         'Índice de Filas.
 Dim C As Integer         'Índice de Columnas.
 
   '[1]Inicializa.
   lbOk = True
   poGrid.Redraw = False
   lsFormato = poGrid.FormatString
   poGrid.ClearStructure
   poGrid.Rows = 2
   poGrid.FormatString = lsFormato
   F = 0
   
   '[2]Abrir Cursor.
   If DBCursorIniciar(lhCur, psQry, psConnection) Then
      While DBCursorSiguiente(lhCur)
         '//Conteo de Filas.
         F = F + 1
         '//Contruir Renglón
         lsCad = DBCursorDato(lhCur, 0)
         For C = 1 To poGrid.Cols - 1
            lsCad = lsCad & vbTab & DBCursorDato(lhCur, C)
         Next
         '//Añadir Renglón.
         poGrid.AddItem lsCad, F
         ' Si tenemos un nuevo ancho para las filas
          If FGHeightRow > 0 Then poGrid.RowHeight(C) = FGHeightRow
      Wend
      '//Cerrar Cursor.
      DBCursorTerminar lhCur
      '//Delimitar Grid.
      If poGrid.Rows > 2 Then poGrid.Rows = poGrid.Rows - 1
      '//Inhibe selección de encabezados.
      poGrid.HighLight = IIf(F = 0, flexHighlightNever, flexHighlightAlways)
   Else
      lbOk = False
   End If
   
   '[3]Realizar Merge sobre parámetros.
   If lbOk Then
      If UBound(pnColumnas) >= 0 Then
         For C = LBound(pnColumnas) To UBound(pnColumnas)
             poGrid.MergeCol(pnColumnas(C)) = True
             poGrid.ColAlignment(pnColumnas(C)) = flexAlignCenterCenter
         Next
      End If
   End If
   
 poGrid.Redraw = True
 'Return.
 HGLlenar = lbOk
End Function

'********************************************************************************
'* Procedimiento: HGCopiarClipBoard.                                            *
'*      Objetivo: Permite copiar todos los Renglones de un HFlexGrid con Merge  *
'*                al portapapeles de Windows.                                   *
'*    Parámetros:                                                               *
'*               -Entrada-                                                      *
'*                     poGrid: Objeto FlexGrid.                                 *
'*                  pbOcultos: Establece que tambien se van a copiar las        *
'*                             columnas Ocultas (False = No, True = Sí).        *
'*         Autor: TSR-IHS.                                                      *
'*         Fecha: 13/Junio/2007.                                                *
'********************************************************************************

Public Sub HGCopiarClipBoard(poGrid As MSHFlexGrid, Optional pbOcultos As Boolean = False)
 Dim lnXo As Long           'Fila Inicial.
 Dim lnXf As Long           'Fila Final.
 Dim lnYo As Long           'Columna Inicial.
 Dim lnYf As Long           'Columna Final.
 Dim lsMatriz As String     'Matriz de Datos (Lineal).
 Dim lsRenglon As String    'Renglón de Datos.
 Dim lsHeaders() As String  'Encabezados del Grid.
 Dim pbCopiar As Boolean    'Copiar Elemento.
 
   '[1]Validación Inicial.
   If poGrid.Rows < 1 Then
      Call FNExclamBox("Selección no Valida")
      Exit Sub
   End If
   
   '[2]Inicializar parámetros.
   lsMatriz = ""
   lnXf = poGrid.Cols - 1
   lnYf = poGrid.Rows - 1
   lsHeaders = Split(poGrid.FormatString, "|")
   
   '[3]Obtener Headers.
   poGrid.Row = 0
   For lnXo = 0 To lnXf
      If poGrid.ColWidth(lnXo) = 0 Then
         pbCopiar = pbOcultos
      Else
         pbCopiar = True
      End If
      If pbCopiar Then
         If lsMatriz = "" Then
            lsMatriz = Trim$(Replace(lsHeaders(lnXo), "<", ""))
         Else
            lsMatriz = lsMatriz & vbTab & Trim$(Replace(lsHeaders(lnXo), "<", ""))
         End If
      End If
   Next
   
   '[4]Obtener Matriz.
   For lnYo = 1 To lnYf
      lsRenglon = ""
      For lnXo = 0 To lnXf
         If poGrid.ColWidth(lnXo) = 0 Then
            pbCopiar = pbOcultos
         Else
            pbCopiar = True
         End If
         If pbCopiar Then
            poGrid.Row = lnYo
            poGrid.Col = lnXo
            If lsRenglon = "" Then
               lsRenglon = Trim$(poGrid.Text)
            Else
               lsRenglon = lsRenglon & vbTab & Trim$(poGrid.Text)
            End If
         End If
      Next
      If lsRenglon <> "" Then lsMatriz = lsMatriz & vbCrLf & lsRenglon
   Next
   
   '[4]Establecer Matriz de datos en el Portapapeles.
   Clipboard.Clear
   Clipboard.SetText lsMatriz
   
End Sub

'********************************************************************************
'* Procedimiento: HGBuscarDato.                                                 *
'*      Objetivo: Permite localizar un dato ó parte de este sobre todo el grid ó*
'*                por una columna especifica, cuando el valor de pnColumna es 0 *
'*                realiza la busqueda en todo el grid.                          *
'*    Parámetros:                                                               *
'*               -Entrada-                                                      *
'*                     poGrid: Objeto FlexGrid.                                 *
'*                  pnColumna: Número de Columna a Localizar.                   *
'*                     psDato: Dato a localizar.                                *
'*                  pbOcultos: Establece si la busqueda se va arealizar sobre   *
'*                             datos ocultos (False = No, True = Sí).           *
'*         Autor: TSR-IHS.                                                      *
'*         Fecha: 04/Junio/2007.                                                *
'********************************************************************************

Public Sub HGBuscarDato(poGrid As MSHFlexGrid, pnColumna As Long, psDato As String, Optional pbOcultos As Boolean = False)
 Dim lbOk As Boolean      'Validación de Busqueda.
 Dim lnFila As Long       'Fila anterior.
 Dim lCol As Long         'Columna anterior
 Dim lbBuscar As Boolean  'Buscar en datos Ocultos.
 Dim F As Long            'Índice de Filas.
 Dim C As Long            'Índice de Columnas.
 Dim k As Long            'Indice en TextArray
 Dim lCelda As Long       'Indice TextArray Original de la celda seleccionada
 
   '[1]Inicializar.
   lnFila = poGrid.Row
   lCol = poGrid.Col
   lCelda = poGrid.Row * poGrid.Cols + poGrid.Col
   lbOk = False
   
   '[2]Recorrer Grid.
   If pnColumna = -1 Then
      '//Buscar en todas las columnas
      'Barre Las Celdas desde la actual
      For k = lCelda + 1 To poGrid.Cols * poGrid.Rows - 1
         F = (k \ poGrid.Cols)
         C = k Mod poGrid.Cols
         If (F >= poGrid.FixedRows) And _
            ((poGrid.ColWidth(C) > 0) Or pbOcultos) And _
            (InStr(Trim$(UCase$(poGrid.TextArray(k))), UCase$(psDato)) > 0) Then
            '//Existe el dato en el grid, seleccionar fila.
            poGrid.Row = F: poGrid.Col = C
            If Not poGrid.RowIsVisible(F) Then poGrid.TopRow = F
            lbOk = True
            Exit For
         End If
      Next
      'No encontró el dato?
      If Not lbOk Then
         'Busca ahora desde el principio hasta la celda actual
         For k = 0 To lCelda
            F = (k \ poGrid.Cols)
            C = k Mod poGrid.Cols
            If (F >= poGrid.FixedRows) And _
               ((poGrid.ColWidth(C) > 0) Or pbOcultos) And _
               (InStr(Trim$(UCase$(poGrid.TextArray(k))), UCase$(psDato)) > 0) Then
               '//Existe el dato en el grid, seleccionar fila.
               poGrid.Row = F: poGrid.Col = C
               If Not poGrid.RowIsVisible(F) Then poGrid.TopRow = F
               lbOk = True
               Exit For
            End If
         Next
      End If
   Else
      '//Buscar en una Columna.
      'poGrid.Col = pnColumna
      C = pnColumna
      For F = poGrid.Row + 1 To poGrid.Rows - 1
          'poGrid.Row = f
          If InStr(Trim$(UCase$(poGrid.TextMatrix(F, C))), UCase$(psDato)) > 0 Then
             '//Existe el dato en el grid, seleccionar fila.
             FGSelectRow poGrid, F
             lbOk = True
             Exit For
          End If
      Next
      If Not lbOk Then
        For F = poGrid.FixedRows To poGrid.Row
            'poGrid.Row = f
            If InStr(Trim$(UCase$(poGrid.TextMatrix(F, C))), UCase$(psDato)) > 0 Then
               '//Existe el dato en el grid, seleccionar fila.
               FGSelectRow poGrid, F
               lbOk = True
               Exit For
            End If
        Next
      End If
   End If
   
   '[3]Validar Existencia.
   If Not lbOk Then
      poGrid.Row = lnFila: poGrid.Col = lCol
      If Not poGrid.RowIsVisible(lnFila) Then poGrid.TopRow = lnFila
      Beep
   End If
   poGrid.SetFocus
' 'Version Anterior
' Dim lbOk As Boolean      'Validación de Busqueda.
' Dim lnFila As Long       'Fila anterior.
' Dim lnColumna As Long    'ColumnaAnterior.
' Dim lbBuscar As Boolean  'Buscar en datos Ocultos.
' Dim f As Long            'Índice de Filas.
' Dim c As Long            'Índice de Columnas.
'
'
'    '[1]Inicializar.
'    lnFila = poGrid.Row
'    lnColumna = poGrid.Col
'    lbOk = False
'    poGrid.SetFocus
'
'    '[2]Recorrer Grid.
'    If pnColumna = -1 Then
'       '//Buscar en Todo el Grid.
'       For f = 1 To poGrid.Rows - 1
'           poGrid.Row = f
'           For c = 1 To poGrid.Cols - 1
'               If poGrid.ColWidth(c) = 0 Then
'                  lbBuscar = pbOcultos
'               Else
'                  lbBuscar = True
'               End If
'               If lbBuscar Then
'                  poGrid.Col = c
'                  If InStr(Trim$(UCase$(poGrid.Text)), UCase$(psDato)) > 0 Then
'                     '//Existe el dato en el grid, seleccionar Celda.
'                     If Not poGrid.RowIsVisible(f) Then poGrid.TopRow = f
'                     poGrid.Row = f
'                     poGrid.Col = c
'                     lbOk = True
'                     Exit For
'                  End If
'               End If
'           Next
'           If lbOk Then Exit For
'       Next
'    Else
'       '//Buscar en una Columna.
'       poGrid.Col = pnColumna
'       For f = 1 To poGrid.Rows - 1
'           poGrid.Row = f
'           If InStr(Trim$(UCase$(poGrid.Text)), UCase$(psDato)) > 0 Then
'              '//Existe el dato en el grid, seleccionar Celda.
'              If Not poGrid.RowIsVisible(f) Then poGrid.TopRow = f
'              poGrid.Row = f
'              poGrid.Col = pnColumna
'              lbOk = True
'              Exit For
'           End If
'       Next
'    End If
'
'    '[3]Validar Existencia.
'    If Not lbOk Then
'       Beep
'       If Not poGrid.RowIsVisible(lnFila) Then poGrid.TopRow = lnFila
'       poGrid.Row = lnFila
'       poGrid.Col = lnColumna
'    End If
'
End Sub


'*************************************************************************************
'* Procedimiento: FGImageChange.                                                     *
'*      Objetivo: Permite cambiar o ingresar una imagen en un Grid en una fila y     *
'*                por una columna especifica.                                        *
'*    Parámetros:                                                                    *
'*               -Entrada-                                                           *
'*                          phGrid (OUT)  Objeto FlexGrid.                           *
'*                     phImageList (IN)   Es la fuente de las imágenes               *
'*                        pIdImagen (IN)  Id de la Imagen
'*                        pIconCol (IN)   Columna (base 0) en que aparece el ícono   *
'*                        pIconRow (IN)   Fila en que aparece el icono               *
'*                                                                                   *
'*         Autor: TSR-SDB.                                                           *
'*         Fecha: 03/Noviembre/2011.                                                 *
'*************************************************************************************

Public Function FGImageChange(phGrid As Control, phImageList As Control, pIdImagen As String, pIconCol As Integer, pIconRow As Integer)

   phGrid.Row = pIconRow
   phGrid.Col = pIconCol
   phGrid.CellPicture = phImageList.ListImages(pIdImagen).Picture
   phGrid.CellPictureAlignment = flexAlignCenterCenter

End Function

'*************************************************************************************
'* Procedimiento: FGSetImage.                                                        *
'*      Objetivo: Permite cambiar o ingresar una imagen en un Grid en una fila y     *
'*                por una columna especifica.                                        *
'*    Parámetros:                                                                    *
'*               -Entrada-                                                           *
'*                          phGrid (OUT)  Objeto FlexGrid.                           *
'*                     phImageList (IN)   Es la fuente de las imágenes               *
'*                        pIdImagen (IN)  Id de la Imagen
'*                        pIconCol (IN)   Columna (base 0) en que aparece el ícono   *
'*                        pIconRow (IN)   Fila en que aparece el icono               *
'*                                                                                   *
'*         Autor: TSR-SDB.                                                           *
'*         Fecha: 03/Noviembre/2011.                                                 *
'*************************************************************************************

Public Function FGSetImage(phGrid As Control, pImage As Object, pCol As Integer, pRow As Integer, Optional pAling As AlignmentSettings = flexAlignCenterCenter)

   phGrid.Row = pRow
   phGrid.Col = pCol
   
   phGrid.Text = ""
   phGrid.CellPicture = pImage.Picture
   phGrid.CellPictureAlignment = pAling

End Function


'*************************************************************************************
'* Procedimiento: FGImageClean.                                                      *
'*      Objetivo: Elimina una imagen en un Grid de una fila y                        *
'*                por una columna especifica.                                        *
'*    Parámetros:                                                                    *
'*               -Entrada-                                                           *
'*                          phGrid (OUT)  Objeto FlexGrid.                           *
'*                        pIconCol (IN)   Columna (base 0) en que aparece el ícono   *
'*                        pIconRow (IN)   Fila en que aparece el icono               *
'*                                                                                   *
'*         Autor: TSR-SDB.                                                           *
'*         Fecha: 03/Noviembre/2011.                                                 *
'*************************************************************************************

Public Function FGImageClean(phGrid As Control, pIconCol As Integer, pIconRow As Integer)

   phGrid.Row = pIconRow
   phGrid.Col = pIconCol
   phGrid.CellPicture = Nothing
   phGrid.CellPictureAlignment = flexAlignCenterCenter

End Function


'*************************************************************************************
'* Procedimiento: FGIsImage.                                                         *
'*      Objetivo: Permite cambiar o ingresar una imagen en un Grid en una fila y     *
'*                por una columna especifica.                                        *
'*    Parámetros:                                                                    *
'*               -Entrada-                                                           *
'*                          phGrid (OUT)  Objeto FlexGrid.                           *
'*                     phImageList (IN)   Es la fuente de las imágenes               *
'*                        pIdImagen (IN)  Id de la Imagen
'*                        pIconCol (IN)   Columna (base 0) en que aparece el ícono   *
'*                        pIconRow (IN)   Fila en que aparece el icono               *
'*                                                                                   *
'*         Autor: TSR-SDB.                                                           *
'*         Fecha: 03/Noviembre/2011.                                                 *
'*************************************************************************************

Public Function FGIsImage(phGrid As Control, pCol As Integer, Optional pRow As Integer = -1) As Boolean

   Dim lCol As Long
   Dim lRow As Long
   Dim lRetVal As Boolean

   If pRow = -1 Then pRow = phGrid.Row
   
   lCol = phGrid.Col
   lRow = phGrid.Row
      
   phGrid.Row = pRow
   phGrid.Col = pCol
   
   lRetVal = Not (phGrid.CellPicture Is Nothing)
   
   phGrid.Col = lCol
   phGrid.Row = lRow
   
   FGIsImage = lRetVal

End Function






'****************************************************************************************************************
'* Procedimiento: GridColumnatoString.                                                                          *
'*      Objetivo: Permite Obtener la informacion de una columna del grid especifico                             *
'*                devolviendo el resultado en una cadena string delimitado por                                  *
'*                caracter delimitador                                                                          *
'*    Parámetros:                                                                                               *
'*               -Entrada-                                                                                      *
'*                              phGrid (IN)  Objeto FlexGrid.                                                   *
'*                          pSeparador (IN)  Caracter delimitador                                               *
'*                            pColumna (IN)  Columna de los datos a  obtener                                    *
'*                          pFiltros() (IN)  Lista de Filtros en parejas: Columna, Valor, Columna, Valor, ...   *
'*                                                                                                              *
'*                                                                                                              *
'*         Autor: TSR-SDB.                                                                                      *
'*         Fecha: 03/Noviembre/2011.                                                                            *
'****************************************************************************************************************

Public Function FG_ColumToString(phGrid As Control, pSeparador As String, pColumna As Integer, ParamArray pFiltros() As Variant) As String

   Dim RetVal As String
   Dim J As Integer
   Dim k As Integer
   Dim lValida As Boolean
   Dim lFirtsValue As Boolean
   
   lFirtsValue = True
   ' Realizo un barrido en el grid de seleccionados
   With phGrid
   
      ' Recorremos las Filas
      For J = 1 To .Rows - 1
          lValida = True
          ' Verifica los filtros
          For k = LBound(pFiltros) To UBound(pFiltros) Step 2
             'Revisa si el 1er campo y pKey(k) coinciden según la relación Columna
             If (CStr(pFiltros(k + 1)) = .TextMatrix(J, CInt(pFiltros(k)))) Then
                lValida = True
             Else
                 lValida = False
                 'Exit For
             End If
          Next k
          
         If lValida Then
            If Not lFirtsValue Then RetVal = RetVal & pSeparador
            lFirtsValue = False
            RetVal = RetVal & .TextMatrix(J, pColumna)
         End If
         
      Next J
      
   End With
   
   FG_ColumToString = RetVal

End Function


'****************************************************************************************************************
'* Procedimiento: GridColumnatoString.                                                                          *
'*      Objetivo: Cuenta el numero de filas que contiene un grid utilizando filtros                             *
'*                devolviendo el resultado en un entero                                                         *
'*                                                                                                              *
'*    Parámetros:                                                                                               *
'*               -Entrada-                                                                                      *
'*                              phGrid (IN)  Objeto FlexGrid.                                                   *
'*                          pFiltros() (IN)  Lista de Filtros en parejas: Columna, Valor, Columna, Valor, ...   *
'*
'*                                                                                                              *
'*         Autor: TSR-SDB.                                                                                      *
'*         Fecha: 03/Noviembre/2011.                                                                            *
'****************************************************************************************************************

Public Function FGCuentaFilasGrid(phGrid As Control, ParamArray pFiltros()) As Integer

   Dim J As Integer
   Dim k As Integer
   Dim lCount As Integer
   Dim lValida As Boolean
 
   lCount = 0
   
   ' Realizo un barrido en el grid de seleccionados y realizo una copia en memoria de las ordenes
   With phGrid
   
      ' Recorremos las Filas
      For J = 1 To .Rows - 1
          lValida = True
          ' Verifica los filtros
          For k = LBound(pFiltros) To UBound(pFiltros) Step 2
             'Revisa si el 1er campo y pKey(k) coinciden según la relación Columna
             If (CStr(pFiltros(k + 1)) = .TextMatrix(J, CInt(pFiltros(k)))) Then
                lValida = True
             Else
                 lValida = False
                 Exit For
             End If
          Next k
          
         If lValida Then lCount = lCount + 1
                     
      Next J
      
   End With
   
   FGCuentaFilasGrid = lCount

End Function


Public Function FG_EliminarFilasSeleccionadas(phGrid As Control)
   Dim i As Integer
   
   With phGrid
      '(1) Realizo un ciclo en el control grid para determinar las filas que estan seleccionadas
      ' y realizar el respectivo insert en la tabla
      For i = IIf(.Row <= .RowSel, .RowSel, .Row) To IIf(.Row <= .RowSel, .Row, .RowSel) Step -1
      
         ' solo hay una fila en el grid ?
         If .Rows = 2 Then
            ' se elimina el unico que existe
            .Rows = 1
            .HighLight = flexHighlightNever
          Else
            
            .RemoveItem (i)
         End If
         
      Next i
      If .Rows > 1 Then .RowSel = .Row
   End With

End Function


Public Function FG_SelFila(phGrid As Control) As Boolean
    FG_SelFila = phGrid.Row > 0
End Function


Public Function FG_Vacio(phGrid As Control) As Boolean
    FG_Vacio = phGrid.Rows <= GRID_VACIO
End Function


Public Sub FG_Clean(phGrid As Control)

   phGrid.Rows = 1
   phGrid.HighLight = flexHighlightNever
   phGrid.ColSel = 0

End Sub


'Devuelve los datos de las columnas de una fila seleccionada en una matriz
'Parámetros:
'   phGrid= Grid
'   pData de donde devolvera la info de la Fila seleccionada
'

Function FGSeleccionFila(phGrid As Control, ParamArray pData()) As Boolean
   Dim lRow%
   Dim C As Integer
   Dim lRetRow As Boolean
   Dim lRetVal As Boolean
   
   lRetVal = False
   'Obtenemos el renglón seleccionado
   lRow% = phGrid.Row

   '(2) Tenemos filas en el control y hay una seleccionada
   If Not FG_Vacio(phGrid) And lRow% > 0 Then
      ' Recorremos Columnas de la fila seleccionada
      For C = 0 To UBound(pData)
         'Asigna cada dato a la lista de variables
         pData(C) = phGrid.TextMatrix(lRow%, C)
      Next C
      lRetVal = True
   End If
   
   FGSeleccionFila = lRetVal

End Function


'Devuelve los datos de las columnas de una fila seleccionada en una matriz
'Parámetros:
'   phGrid= Grid
'   pData de donde devolvera la info de la Fila seleccionada
'

Function FGFilaSeleccion(phGrid As Control, pRow As Integer, ParamArray pData()) As Boolean
   
   Dim C As Integer
   Dim lRetVal As Boolean
   
   lRetVal = False
   
   '(2) Tenemos filas en el control y hay una seleccionada
   If Not FG_Vacio(phGrid) And pRow > 0 Then
      ' Recorremos Columnas de la fila seleccionada
      For C = 0 To UBound(pData)
         'Asigna cada dato a la lista de variables
         pData(C) = phGrid.TextMatrix(pRow, C)
      Next C
      lRetVal = True
   End If
   
   FGFilaSeleccion = lRetVal

End Function



'****************************************************************************************************************
'* Procedimiento: FG_EliminaFilas.                                                                              *
'*      Objetivo: Elimina una fila en un grid por filtros                                                       *
'*    Parámetros:                                                                                               *
'*               -Entrada-                                                                                      *
'*                              phGrid (IN)  Objeto FlexGrid.                                                   *
'*                            pColumna (IN)  Columna de los datos a  obtener                                    *
'*                          pFiltros() (IN)  Lista de Filtros en parejas: Columna, Valor, Columna, Valor, ...   *
'*                                                                                                              *
'*                                                                                                              *
'*         Autor: TSR-SDB.                                                                                      *
'*         Fecha: 03/Noviembre/2011.                                                                            *
'****************************************************************************************************************

Public Function FG_EliminaFilas(phGrid As Control, pIterGrid As Boolean, ParamArray pFiltros() As Variant)

   Dim RetVal As String
   Dim J As Integer
   Dim k As Integer
   Dim rw As Integer
   
   Dim lRows As Long
   
   lRows = phGrid.Rows
   
   ' Realizo un barrido en el grid
   If Not (FG_Vacio(phGrid)) Then
              
      Do While (J <= (lRows - 1))
      
         ' Validamos la Fila usando los filtros
          For k = LBound(pFiltros) To UBound(pFiltros) Step 2
             'Revisa si el 1er campo y pKey(k) coinciden según la relación Columna
             If (CStr(pFiltros(k + 1)) = phGrid.TextMatrix(J, CInt(pFiltros(k)))) Then
                ' Eliminamos la fila del grid
                Call FGBorrar(phGrid, J)
                lRows = lRows - 1
                ' Salimos al borrar el primer renglon encontrado ?
                If Not pIterGrid Then Exit Function
                ' Recorremos todo el Grid
                If pIterGrid Then Exit For
             Else
                J = J + 1
             End If
          Next k
      
      Loop
      
   End If
   
End Function


'****************************************************************************************************************
'* Procedimiento: FG_BuscaDato.                                                                                 *
'*      Objetivo: Busca un determinado dato en un grid especificando las columnas e info a encontrar            *
'*    Parámetros:                                                                                               *
'*               -Entrada-                                                                                      *
'*                              phGrid (IN)  Objeto FlexGrid.                                                   *
'*                          pFiltros() (IN)  Lista de Filtros en parejas: Columna, Valor, Columna, Valor, ...   *
'*                                                                                                              *
'*                                                                                                              *
'*         Autor: TSR-SDB.                                                                                      *
'*         Fecha: 03/Noviembre/2011.                                                                            *
'****************************************************************************************************************

Public Function FG_BuscaDato(phGrid As Control, ParamArray pFiltros() As Variant) As Boolean

   Dim lEncontrado As Boolean
   Dim J As Integer
   Dim k As Integer
   Dim rw As Integer
   Dim lRows As Long
   
   lEncontrado = False
   lRows = phGrid.Rows
   
   ' Realizo un barrido en el grid
   With phGrid
              
      ' Barremos cada una de las filas
      Do While (J <= (lRows - 1) And Not lEncontrado And Not FG_Vacio(phGrid))
      
         ' Validamos la Fila-Columna usando los filtros
          For k = LBound(pFiltros) To UBound(pFiltros) Step 2
             'Revisa si el 1er campo y pKey(k) coinciden según la relación Columna
               If (CStr(pFiltros(k + 1)) = .TextMatrix(J, CInt(pFiltros(k)))) Then
                ' Lo encontro
                lEncontrado = True
                Exit For
             Else
                J = J + 1
                lEncontrado = False
             End If
          Next k
      
      Loop
      
   End With
   
   FG_BuscaDato = lEncontrado
   
End Function


Public Function FG_OrdenarImg(phGrid As Control, phImageList As Control, pValueCol As Integer, pIconCol As Integer, pEqual As Boolean, ParamArray pKeys() As Variant)

   Dim i As Integer
   Dim k As Integer
   Dim lDato As Variant
   
   phGrid.Redraw = False
   ' Recorremos las filas
   For i = 1 To phGrid.Rows - 1
      ' Obtengo el Valor de la columna
      lDato = phGrid.TextMatrix(i, pValueCol)
      'Añade imágenes según el resultado del query
      For k% = LBound(pKeys) To UBound(pKeys) Step 2
         'revisa si el 1er campo y pKey(k%) coinciden según la relación pEqual
         If (pEqual And lDato = CStr(pKeys(k))) Or (Not pEqual And lDato <> CStr(pKeys(k))) Then
            'Sí => pone la imagen en la columna pIconCol de este renglon
            phGrid.Row = i
            phGrid.Col = pIconCol
            phGrid.CellPicture = Nothing
            phGrid.CellPicture = phImageList.ListImages(pKeys(k + 1)).Picture
            phGrid.CellPictureAlignment = flexAlignCenterCenter
         End If
      Next
      
   Next i
   
   phGrid.Redraw = True

End Function


Public Function fSetColor(phGrid As Object, ByVal pRow As Integer, ByVal pColor As Long)

  ' phGrid.Redraw = False
   Dim J As Integer
   Dim rowBack As Integer
   ' Se Define la Fila definida por la funcion
   rowBack = phGrid.Row
   phGrid.Row = pRow
         
   ' Establece colores por Fila
   For J = 1 To phGrid.Cols - 1
      phGrid.Col = J
      ' Establece  Color al separador
      phGrid.CellBackColor = pColor
      
   Next J
   
   phGrid.Row = rowBack
 
End Function


Public Function FGResaltarSel(phGrid As Control, ByVal pRow As Integer, Optional pResaltar As Boolean = True)
   
  ' phGrid.Redraw = False
   Dim J As Integer
   Dim rowBack As Integer
   
   phGrid.Redraw = False
   ' Se Define la Fila definida por la funcion
   rowBack = phGrid.Row
   phGrid.Row = pRow
         
   ' Establece colores por Fila
   For J = 1 To phGrid.Cols - 1
      phGrid.Col = J
      ' Establece  Color al separador
      phGrid.CellFontBold = pResaltar
      
   Next J
   
   phGrid.Row = rowBack
 
   phGrid.Redraw = True
 
End Function
