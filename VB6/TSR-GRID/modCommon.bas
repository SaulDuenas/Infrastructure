Attribute VB_Name = "modCommon"
Public Sub NumKeyDown(KeyCode As Integer, ByRef oText As Object, InputMask As String)
    Dim iSelStart As Integer
    Dim iDecPos As Integer
    Dim sSelected As String
    Dim iSelectLength As Integer
    Dim sData As String
    Dim iDecSize As Integer
    Dim iIntSize As Integer
    Dim iLenText As Integer
    Dim i As Integer
    'Decimal position in inputmask

    iDecPos = InStr(1, InputMask, ".", vbTextCompare)
    If iDecPos = 0 Then                                    ' No decimal point
        iDecSize = 0
        iIntSize = Len(InputMask)
    Else
        iDecSize = Len(InputMask) - iDecPos
        iIntSize = iDecPos - 1
    End If

    'Actual Decimal Postion
    iDecPos = InStr(1, oText.Text, ".", vbTextCompare)
    'Current Position of cursor
    iSelStart = oText.SelStart
    Select Case KeyCode
        Case Is = 37                                       ' Left Arrow
            If iDecPos = iSelStart And iSelStart > 0 Then
                oText.SelStart = iSelStart - 1
            End If
        Case Is = 39                                       ' Right Arrow
            If iDecPos = iSelStart + 2 Then
                oText.SelStart = iSelStart + 1
            End If
        Case Is = 46                                       ' Delete key
            If iDecPos = iSelStart + 1 Then
                oText.SelText = "."
            End If
            sSelected = oText.SelText
            iSelectLength = oText.SelLength
            If InStr(1, sSelected, ".", vbBinaryCompare) > 0 Then
                sData = VBA.Left$(oText.Text, iSelStart) & Mid(oText.Text, iSelStart + iSelectLength)
                If Len(sData) > iIntSize Then
                    oText.SelStart = iIntSize + iSelectLength
                    oText.SelText = "."
                    oText.SelStart = iSelStart
                    oText.SelLength = iSelectLength
                End If
            Else
            End If
    End Select

End Sub

Public Sub NumKeyPress(KeyAscii As Integer, ByRef oText As Object, InputMask As String)
    Dim iSelStart As Integer
    Dim iDecPos As Integer
    Dim iDecSize As Integer
    Dim iIntSize As Integer
    Dim iLenText As Integer
    'Decimal position in inputmask

    iDecPos = InStr(1, InputMask, ".", vbTextCompare)
    If iDecPos = 0 Then                                    ' No decimal point
        iDecSize = 0
        iIntSize = Len(InputMask)
    Else
        iDecSize = Len(InputMask) - iDecPos
        iIntSize = iDecPos - 1
    End If
    'Actual Decimal Postion
    iDecPos = InStr(1, oText.Text, ".", vbTextCompare)
    'Current Position of cursor
    iSelStart = oText.SelStart + 1
    iLenText = Len(oText)

    Select Case KeyAscii
        Case Asc("-")
            If Not oText.SelStart = 0 Then
               KeyAscii = 0
            End If
        Case 13
            Dim sPrevText As String
            sPrevText = Left$(oText, iSelStart - 1)
            If sPrevText <> Space$(Len(sPrevText)) Then
                oText.Text = sPrevText
            End If
            KeyAscii = 0
            '           ExitNumBox oText, InputMask
            FormatBox oText, InputMask
        Case 8                                             'BkSpc - split string at cursor
            On Error Resume Next
            If oText.Text <> "" Then
                If Mid(oText.Text, oText.SelStart, 1) = "." Then
                    oText.SelStart = Abs(oText.SelStart - 1)
                End If
            End If
            On Error GoTo 0
        Case 27, 37 To 40
            KeyAscii = 0
        Case Else
            If (KeyAscii >= vbKey0 And KeyAscii <= vbKey9) Or KeyAscii = vbKeyDelete Then
                ' Check Current position of cursor
                If KeyAscii = vbKeyDelete Then             'Decimal point then check it existance
                    'If no decimal point allowed then
                    'wipe out key stroke
                    If iDecSize = 0 Then
                        KeyAscii = 0
                    Else
                        'if decimal point already exists then
                        'place cursor to right of decimal point
                        If iDecPos <> 0 Then
                            If iSelStart < iDecPos Then
                                If iSelStart > 1 Then
                                    oText.Text = Left$(oText, iSelStart - 1) & Mid(oText, InStr(oText, "."))
                                End If
                            End If
                            oText.SelStart = InStr(oText.Text, ".")
                            KeyAscii = 0
                        Else
                            'put decimal point
                            oText.SelText = "."
                            KeyAscii = 0
                        End If
                    End If
                Else                                       ' Numeric entry checking
                    Dim mAddDec As Boolean
                    Dim mAtEnd As Boolean
                    Dim mJump As Boolean
                    If iDecPos = 0 Or iSelStart <= iDecPos Then
                        'Editing in integer area
                        Dim iLenInt As Integer
                        If iLenText > 0 Then
                            iLenInt = Len(Mid(oText, 1, IIf(iDecPos > 0, iDecPos - 1, iIntSize)))
                        Else
                            iLenInt = 0
                        End If
                        If iLenInt + 1 >= iIntSize Then
                            If iLenInt + 1 = iIntSize Then
                                If iSelStart = iIntSize Then
                                    If iDecPos = 0 And iDecSize <> 0 Then
                                        mAddDec = True
                                    ElseIf iDecSize = 0 Then
                                        mJump = True
                                    End If
                                Else
                                End If
                            Else
                                If iSelStart >= iIntSize Then
                                    mAtEnd = True
                                    If iSelStart > iIntSize Then
                                        If iDecSize > 0 Then
                                            If InStr(oText.SelText, ".") <> 0 Or iSelStart = iDecPos Then
                                                If InStr(oText.SelText, ".") Then
                                                    oText.SelText = "."
                                                End If
                                                If iSelStart = iDecPos Then
                                                    'iSelStart = iSelStart + 1
                                                    oText.SelStart = oText.SelStart + 1
                                                    oText.SelLength = 1
                                                    oText.SelText = Chr(KeyAscii)
                                                    mAddDec = False
                                                    KeyAscii = 0
                                                    'oText.SelLength = 0
                                                    oText.SelStart = oText.SelStart - 1
                                                End If
                                            End If
                                        Else
                                            KeyAscii = 0
                                        End If
                                    Else
                                        If InStr(oText.SelText, ".") <> 0 Then
                                            If iDecSize <> 0 Then
                                                oText.SelText = Chr(KeyAscii) & "."
                                                oText.SelStart = oText.SelStart - 1
                                                KeyAscii = 0
                                            End If
                                        End If
                                        If iDecSize <> 0 And InStr(oText.Text, ".") = 0 Then
                                            oText.SelText = Chr(KeyAscii) & "."
                                            KeyAscii = 0
                                        End If
                                    End If
                                Else
                                    If oText.SelLength > 0 Then
                                        Dim sSelected As String
                                        sSelected = oText.SelText
                                        oText.SelText = Chr(KeyAscii)
                                        If InStr(sSelected, ".") > 0 Then
                                            If Len(oText.Text) > iIntSize Then
                                                oText.SelStart = iIntSize
                                                oText.SelText = "."
                                                oText.SelStart = iSelStart
                                            End If
                                        Else
                                        End If
                                        KeyAscii = 0
                                    End If
                                End If
                                If oText.SelLength = 0 Then
                                    If KeyAscii <> 0 Then
                                        oText.SelLength = oText.SelLength + 1
                                    End If
                                End If
                            End If
                            If KeyAscii <> 0 Then
                                oText.SelText = Chr(KeyAscii) & IIf(mAddDec, ".", "")
                            End If
                            If mAtEnd Then
                                oText.SelStart = oText.SelStart + 1
                                mAtEnd = False
                                If iDecSize = 0 Then
                                  '  ExitNumBox oText, InputMask
                                End If
                            End If
                            If mJump Then
                                'ExitNumBox oText, InputMask
                            End If
                            KeyAscii = 0
                        End If

                    Else
                        'editing in decimal area
                        'Cursor is at last or higher position
                        If iSelStart - iDecPos >= iDecSize Then
                            ' if cursor at last position
                            If iSelStart - iDecPos = iDecSize Then
                                If Len(Mid(oText, InStr(oText, ".") + 1)) = iDecSize Then
                                    oText.SelLength = 1
                                End If
                                oText.SelText = Chr(KeyAscii)
                                KeyAscii = 0
                                oText.Text = Replace(oText.Text, " ", "")
                                On Error Resume Next
                                oText.Text = Space$(Len(InputMask) - Len(oText.Text)) & oText.Text
                                On Error GoTo 0
                                'End If
                            Else
                                'Cursor is higher position just
                                'remove the entered character
                                KeyAscii = 0
                            End If
                            'ExitNumBox oText, InputMask
                        Else
                            If oText.SelLength = 0 Then
                                oText.SelLength = 1
                            End If
                            oText.SelText = Chr(KeyAscii)
                            KeyAscii = 0
                            oText.SelStart = iSelStart
                        End If
                    End If
                End If
            Else
                KeyAscii = 0
            End If
            ' FormatBox oText, InputMask
    End Select
End Sub

Private Sub ExitNumBox(ByRef oText As Object, InputMask As String)
    FormatBox oText, InputMask
    'oText.SelStart = 0
    SendKeys "{ENTER}"
End Sub

Private Sub FormatBox(ByRef oText As Object, InputMask As String)
    Dim i As Integer
    oText.Text = Replace(oText.Text, " ", "")
    oText = Format(oText, InputMask)
    'remove extra 0's from text
    If Len(oText.Text) > 0 Then
        For i = 1 To Len(oText.Text)
            If Mid(oText.Text, i, 1) <> "0" Or Mid(oText, i, 2) = "0." Then
                Exit For
            End If
            oText.Text = Left$(oText.Text, i - 1) & Space$(1) & Mid(oText.Text, i + 1)
        Next
    End If
    oText.Text = Replace(oText.Text, " ", "")
End Sub

