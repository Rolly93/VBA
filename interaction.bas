Sub ExtractData()
    Dim invoice_Sheet As Worksheet
    Dim lastRow As Long

    Dim shipmentList As Collection
    Dim rowShipment As Variant
    Dim upLoader As New uploadFile
    Set shipmentList = New Collection

    Set invoice_Sheet = ThisWorkbook.Sheets("Invoice")
    KeepData rowShipment, shipmentList, invoice_Sheet, upLoader



    upLoader.Asignation shipmentList, invoice_Sheet
End Sub

Sub KeepData(rowShipment, shipmentList, invoice_Sheet, upLoader)
    Dim correctReferenceImportation As String
    Dim i As Long
    Dim invoice_Column As Variant
    Dim RefeExpor_Column As Variant
    Dim RefImport_Column As Variant


    lastRow = invoice_Sheet.Cells(invoice_Sheet.Rows.Count, "A").End(xlUp).row ' que encuentre el ultimo renglon de la columna de facutras
    
    For i = 11 To lastRow
        Ucase(invoice_Column) = invoice_Sheet.Cells(i, "A").value
        UCase(RefeExpor_Column) = invoice_Sheet.Cells(i, "B").value
        UCase(RefImport_Column) = invoice_Sheet.Cells(i, "C").value

        correctReferenceImportation = upLoader.clearData(RefImport_Column)

        rowShipment = Array(invoice_Column, RefeExpor_Column, correctReferenceImportation)
        shipmentList.Add rowShipment
        
        createBatch ()
        
        
    Next i
End Sub


