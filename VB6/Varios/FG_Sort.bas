Attribute VB_Name = "FG_Sort"
Option Explicit
'Constantes para el Enmascaramiento de la configuraci�n de una columna de un FlexGrid que se ordenar�.
Public Const FG_T_TEXTO As Integer = &H0
Public Const FG_T_ENTERO As Integer = &H1
Public Const FG_T_DOBLE   As Integer = &H2
Public Const FG_T_FECHA As Integer = &H3
Public Const FG_T_BOOLEAN As Integer = &H4
Public Const FG_O_ASC As Integer = &H100
Public Const FG_O_DESC As Integer = &H200

'******************************************************************************************************************

'  FUNCIONES INTERFACES (PUBLICAS) UTILIZADAS POR EL USUARIO FINAL
'
'  Function FG_Ordenar (MSFlexGrid, Integer, Optional Integer = -1) As Boolean
'  Sub FG_ColumnaOrdenada (MSFlexGrid, Integer, Optional Integer = FG_O_ASC)
'  Sub FG_RowSwap (MSFlexGrid, Integer, Integer)
'
'******************************************************************************************************************


'******************************************************************************************************************
'  8-Jun-2007:    FG_Ordenar
'  Interfaz de usuario para ordenar el contenido de un FlexGrid a trav�s de su columna <pColumna>.
'
'  DESCRIPCI�N:
'  La funci�n utiliza la propiedad ColData para identificar el tipo de dato contenido en la columna, y ordenar�,
'  bajo la columna pColumna, en forma Ascendente/Descendente de manera alternada seg�n el orden previo de la columna.
'
'     Tipo de Dato:
'           &H00: Texto
'           &H01: Entero   (Integer y Long)
'           &H02: Doble    (Double y Currency)
'           &H03: Fecha    (Date)
'           &H04: Boolean
'
'     Orden Previo de la Columna:
'           &H00xx:  La columna NO est� ordenada, se Ordenar� Ascendentemente.
'           &H01xx:  Orden Ascendente, se Ordenar� Descendentemente.
'           &H02xx:  Orden Descendente, se Ordenar� Ascendentemente.
'
'  Se necesita el tipo de dato en la propiedad ColData para cada columna que se pueda ordenar, en caso de que
'  la columna no tenga el tipo de dato, entonces la funci�n tomar� los valores como Texto de manera predeterminada.
'
'  PAR�METROS:
'     pGrid       (I/O)    Apuntador al Grid que se quiere ordenar.
'     pColumna    (I)      N�mero de Columna sobre la cual se ordenar�. Su dominio es de 0 a pGrdi.Cols-1
'     pTipoDato   (I*)     Opcional. Tipo de Dato de la columna. Si se establece, no se toma en cuenta el de ColData
'******************************************************************************************************************
Public Function FG_Ordenar(pGrid As MSFlexGrid, ByVal pColumna As Integer, Optional ByVal pTipoDato As Integer = -1) As Boolean
On Error GoTo errOrdenar
   Dim lError As Byte, lArray() As Integer, i As Integer, j As Long
   Dim lAux() As String
   
   FG_Ordenar = False
   With pGrid
      'ESTABLECER SI LA COLUMNA pColumna EST� ORDENADA O NO.
      If .ColData(pColumna) > &HFF Then
         'S�. Alternar Orden
         If FG_CambiarOrden(pGrid) Then
            'Mascara para alternar los bits de Ascendente/Descendente.
            .ColData(pColumna) = .ColData(pColumna) Xor &H300
            FG_Ordenar = True
         End If
      Else
         'NO. Desmarcar la columna que estaba ordenada.
         For i = .FixedCols To .Cols - 1
            'Mascara que cancela los bits de Ordenamiento y mantiene los de Tipo de dato.
            .ColData(i) = .ColData(i) And &HFF
         Next
         If pTipoDato < 0 Then pTipoDato = .ColData(pColumna) And &HFF
         'Ordenar pColumna y Marcarla como Ascendente.
         If FG_HeapSort(pGrid, pColumna, pTipoDato) Then
            'Marcara para activar el bit de Ascendente.
            .ColData(pColumna) = .ColData(pColumna) Or &H100
            FG_Ordenar = True
         End If
      End If
   End With
   Exit Function
errOrdenar:
   'Salir
   FG_Ordenar = False
End Function

'Establece el pOrden de la columna pColumna del grid pGrid.
Public Sub FG_ColumnaOrdenada(pGrid As MSFlexGrid, pColumna As Integer, Optional pOrden As Integer = FG_O_ASC)

   If pOrden <> FG_O_ASC And pOrden <> FG_O_DESC Then pOrden = FG_O_ASC
   pGrid.ColData(pColumna) = (pGrid.ColData(pColumna) And &HFF) Or pOrden
End Sub

'Intercambia los renglones i y j del grid pGrid.
Public Sub FG_RowSwap(pGrid As MSFlexGrid, i As Integer, j As Integer)
   Dim k As Integer, lSwap As String
   
   With pGrid
      If i >= .FixedRows And i < .Rows Then
         If j >= .FixedRows And j < .Rows Then
            For k = .FixedCols To .Cols - 1
               lSwap = .TextMatrix(i, k)
               .TextMatrix(i, k) = .TextMatrix(j, k)
               .TextMatrix(j, k) = lSwap
            Next
         End If
      End If
   End With
End Sub




'******************************************************************************************************************

'***********   FUNCIONES AUXILIARES (PRIVADAS) UTILIZADAS POR LA INTERFACE    *************************************

'******************************************************************************************************************


'******************************************************************************************************************
'  8-Jun-2007:    FG_HeapSort
'  Funci�n que ordena, usando el m�todo HeapSort, el contenido de un FlexGrid a trav�s de
'  su columna <pColumna>. Devuelve un valor True si pGrid fue ordenado satisfactoriamente, False si no fue as�.
'
'  Par�metros:
'     pGrid       (I/O)    Apuntador al Grid que se quiere ordenar.
'     pColumna    (I)      N�mero de Columna sobre la cual se ordenar�. Su dominio es de 0 a pGrdi.Cols-1
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
            Call FG_RowSwap(pGrid, .FixedRows, i)
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
'  Funci�n auxiliar usada por FG_HeapSort para establecer el valor Maximo y su posici�n optima, analizando los
'  elementos desde el �ndice (pRoot*2) hasta pBottom su columna <pColumna>. Devuelve un valor True si se pudo
'  encontrar el valor M�ximo sin error, y devuelve False si hubo un error en el proceso.
'
'  Par�metros:
'     pGrid       (I/O)    Apuntador al Grid que se quiere ordenar.
'     pRoot       (I)      Rengl�n de pGrid a evaluar como Ra�z.
'     pBottom     (I)      Indice del �ltimo elemento del monton.
'     pColumna    (I)      N�mero de Columna sobre la cual se ordenar�. Su dominio es de 0 a pGrdi.Cols-1
'     pTipoDato   (I)      Especif�ca el tipo de dato contenido en la columna (pues en un Grid todos son texto).
'        Valores: (v�anse las constantes FG_T_xxxx)
'******************************************************************************************************************
Private Function FG_HeapSort_2(pGrid As Control, ByVal pRoot As Integer, pBottom As Integer, pColumna As Integer, pTipoDato As Integer) As Boolean
On Error GoTo errHeap2
   Dim lFin As Boolean, maxChild As Integer
   Dim A As Boolean
   
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
               Case FG_T_FECHA: A = CDate(.TextMatrix(pRoot * 2, pColumna)) > CDate(.TextMatrix(pRoot * 2 + 1, pColumna))
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
            Case FG_T_FECHA: A = CDate(.TextMatrix(pRoot, pColumna)) < CDate(.TextMatrix(maxChild, pColumna))
            Case FG_T_BOOLEAN: A = .TextMatrix(pRoot, pColumna) < .TextMatrix(maxChild, pColumna)
         End Select
            
         If A Then
            Call FG_RowSwap(pGrid, pRoot, maxChild)
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
   Dim i As Integer, j As Integer
   
On Error GoTo errCambiar
   With pGrid
      i = .FixedRows
      j = .Rows - 1
      While i < j
         Call FG_RowSwap(pGrid, i, j)
         i = i + 1
         j = j - 1
      Wend
   End With
   FG_CambiarOrden = True
   Exit Function
errCambiar:
   FG_CambiarOrden = False
End Function

