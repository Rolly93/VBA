
Private pReference As String '  Validacion de Referencia Listo
Private pInvoice As String ' Pendiente de validar o extraer la factura
Private pFolder As String ' De aqui tengo que extaer los archivos
Private pDocumentType As String ' Preguntar al Usuario que estaria ingresando si 'POD' o "CCP"
Private pKeyType As String ' ya logre validar el "KeyType" atravez de la referencia
Private pFileNameList As Collection
Public batchCommands As Collection

Private Sub InitializeBatch()
    Set batchCommands = New Collection
End Sub


Public Sub Reference(value As String)
    Call Validate_Reference(value)
End Sub

'Validacion of reference si esta ingresando se correctamente , con la condicion que tiene que ser 10 o 9 carateres, dependiendo del tipo de referencia
Private Sub Validate_Reference(value As String)
    Dim upperCap As String
    Dim isValid As Boolean
    isValid = False
    upperCap = UCase(value)

    If (StartsWith(upperCap, "92B") Or StartsWith(upperCap, "82B")) Then
        If Len(upperCap) = 10 Then
            pReference = value
            isValid = True
        End If
    ElseIf StartsWith(upperCap, "H1") Then
        If Len(upperCap) = 9 Then
            pReference = value
            isValid = True
        End If
    ElseIf StartsWith(upperCap, "EL-") Then
        If Len(upperCap) = 10 Then
            pReference = value
            isValid = True
        End If
    End If

    If (isValid) Then
        pKeyType = key_Type(upperCap)
    Else
        pReference = "Referencia no Procesada"
        isValid = False
        pKeyType = "Referencia No asignada"
    End If
End Sub

Public Property Get documentType() As String
    documentType = pDocumentType
End Property

Public Function Document_Type()
    Dim documentTypeForm As New Type_Upload_request
    documentTypeForm.Show

    If documentTypeForm.SelectDocumentType <> "" Then
        pDocumentType = documentTypeForm.SelectDocumentType
        Set pFileNameList = documentTypeForm.FileList
        pFolder = documentTypeForm.FolderName
        MsgBox "Seleccionado: " & pDocumentType, vbInformation, "Selección de Tipo de Documento"
    Else
        MsgBox "No se seleccionó ningún tipo de documento.", vbExclamation
    End If
End Function

Private Function key_Type(Reference As String) As String
    If StartsWith(Reference, "92B") Then
        key_Type = "EDMS"
    ElseIf StartsWith(Reference, "82B") Or StartsWith(Reference, "EL-") Or StartsWith(Reference, "12B") Then
        key_Type = "SHIPLOG"
    ElseIf StartsWith(Reference, "H1") Then
        key_Type = "HOUSE_BILL"
    End If
End Function

Private Function StartsWith(text As String, prefixs As String) As Boolean
    StartsWith = (Left(text, Len(prefixs)) = prefixs)
End Function

Public Sub createBatch(invoice As String, referencia As String, docTpe As String, keyType As String)
    Dim Edocexe As String
    Dim Edoc As String

    Edocexe = 

    Edoc = Chr(34) & Edocexe & Chr(34) & _
           " -c:upload " & Chr(34) & invoice & Chr(34) & _
           " -k:" & Chr(34) & referencia & Chr(34) & _
           " -y:" & Chr(34) & keyType & Chr(34) & _
           " -d:" & Chr(34) & docTpe & Chr(34)

    batchCommands.Add Edoc
End Sub



Public Function selectFolderPDFList(ByRef selectedFolder As String) As Collection
    Dim FileName As String
    Dim fileDialog As fileDialog
    Set pFileNameList = New Collection

    Set fileDialog = Application.fileDialog(msoFileDialogFolderPicker)

    With fileDialog
        .Title = "Selecciona Una Carpeta para Subir a Edoc"
        .AllowMultiSelect = False
        If .Show <> -1 Then
            MsgBox "No has Seleccionado Alguna Carpeta", vbInformation, "Error en Seleccion de Carpeta"
            Exit Function
        End If
        selectedFolder = .SelectedItems(1)
    End With

    If Right(selectedFolder, 1) <> "\" Then
        selectedFolder = selectedFolder & "\"
    End If

    FileName = Dir(selectedFolder & "*.pdf")
    Do While FileName <> ""
        pFileNameList.Add FileName
        FileName = Dir
    Loop

    Set selectFolderPDFList = pFileNameList
End Function

Public Function clearData(ByVal wrong_RefImportation As String) As String
    Dim correctedReference As String

    If InStr(wrong_RefImportation, "-") Then
        If Len(wrong_RefImportation) = 10 Then
            correctedReference = wrong_RefImportation
        End If
    ElseIf Not InStr(wrong_RefImportation, "-") And Len(wrong_RefImportation) = 9 Then
        correctedReference = completeReference(wrong_RefImportation)
    Else
        correctedReference = wrong_RefImportation
    End If
    clearData = correctedReference
End Function

Private Function completeReference(missingmiddledash As String) As String
    Dim fullRefImportation As String
    Dim El As String
    Dim numReference As String

    El = Left(missingmiddledash, 2)
    numReference = Mid(missingmiddledash, 3)
    fullRefImportation = El & "-" & numReference
    completeReference = fullRefImportation
End Function

Public Sub Asignation(exceldataList As Collection, invoice_Sheet As Worksheet)
    Dim row As Long
    Dim exComencialInvoice As String
    Dim exReferenceExportacion As String
    Dim exRefrenceImportation As String
    Document_Type
    InitializeBatch
    For row = 1 To exceldataList.Count
        exComencialInvoice = exceldataList(row)(0)
        exReferenceExportacion = exceldataList(row)(1)
        exRefrenceImportation = exceldataList(row)(2)
        If (pDocumentType = "Proof of Export") Then
            If (InStr(exReferenceExportacion, "92B") > 0 Or InStr(exReferenceExportacion, "82B") > 0) Then
                POD exComencialInvoice, exReferenceExportacion, pDocumentType, row, invoice_Sheet
            ElseIf (InStr(exReferenceExportacion, "12B") > 0 Or InStr(exRefrenceImportation, "EL-") > 0) Then
                If Not (InStr(exRefrenceImportation, "EL-") > 0) Then
                    invoice_Sheet.Cells((row + 10), "C").value = "Sin Referecia EL"
                Else
                    POD exComencialInvoice, exRefrenceImportation, pDocumentType, row, invoice_Sheet
                End If
            ElseIf (InStr(exReferenceExportacion, "H1") > 0) Then
                POD exComencialInvoice, exReferenceExportacion, pDocumentType, row, invoice_Sheet
            Else
                invoice_Sheet.Cells((row + 10), "C").value = "Referencia sin Procesar"
            End If
        ElseIf (pDocumentType = "CCP - Transportista") Then
            If (InStr(exReferenceExportacion, "92B") > 0 Or InStr(exReferenceExportacion, "82B") > 0 Or InStr(exReferenceExportacion, "12B") > 0 Or InStr(exReferenceExportacion, "H1") > 0) Then
                POD exComencialInvoice, exReferenceExportacion, pDocumentType, row, invoice_Sheet
            End If
        End If
    Next row
    ExportBatchCommands
End Sub

Public Sub POD(comercialInvoice, referenceExpeditors, documentType, row, invoice_Sheet)
    Reference (referenceExpeditors)
    SearchFile comercialInvoice, pReference, row, invoice_Sheet
End Sub
Private Sub SearchFile(comercialInvoice, pReference, row, invoice_Sheet)
    Dim cleanedName As String
    Dim cleanedInvoice As String
    Dim i As Integer

    cleanedInvoice = Replace(UCase(Trim(comercialInvoice)), " ", "")

    For i = pFileNameList.Count To 1 Step -1
        cleanedName = Replace(UCase(Trim(pFileNameList(i))), " ", "")

        If cleanedName Like "*" & cleanedInvoice & "*.PDF" Then
            invoice_Sheet.Cells((row + 10), "D").value = pReference
            invoice_Sheet.Cells((row + 10), "E").value = cleanedName
            invoice_Sheet.Cells((row + 10), "F").value = cleanedInvoice
            invoice_Sheet.Cells((row + 10), "G").value = pKeyType

            If (pDocumentType = "Proof of Export" And InStr(pReference, "H1") > 0) Then
                invoice_Sheet.Cells((row + 10), "D").value = "ES referencia H"
                Exit For
            End If

            pInvoice = pFolder & "\" & pFileNameList(i)
            Call createBatch(CStr(pInvoice), CStr(pReference), CStr(pDocumentType), CStr(pKeyType))
            Exit For
        End If
    Next i
End Sub


    Public Sub ExportBatchCommands()
    Dim filePath As String
    Dim fileNum As Integer
    Dim cmd As Variant

    filePath = "C:\Temp\batch_commands.txt" ' Change as needed
    fileNum = FreeFile

    Open filePath For Output As #fileNum
    For Each cmd In batchCommands
        Print #fileNum, cmd
    Next cmd
    Close #fileNum

    MsgBox "Batch file created at: " & filePath, vbInformation
    RunBatchLogicWithPause

    ' Optional: Execute the batch file

End Sub

Sub RunBatchLogicWithPause()
    Dim shell As Object
    Dim cmd As String
    Set shell = CreateObject("WScript.Shell")

    cmd = "cmd.exe /k " & _
          """for /f ""usebackq delims="" %%i in (""C:\Temp\batch_commands.txt"") do (call %%i & timeout /t 2 >nul) & " & _
          "echo All Commands Processed & del ""C:\Temp\batch_commands.txt"" & echo batch_commands.txt has been deleted. & pause"""

    shell.Run cmd, 1, False
End Sub

