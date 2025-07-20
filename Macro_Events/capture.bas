Option Explicit
Sub Main()
Dim scac As String
Dim tipoOperacion As String
Dim lastRow As Long
Dim rango As Range
Dim reference As String
Dim type_Event As String
Dim comments As String
Dim excTime As Date, excDate As Date
Dim formatdateTime As String
Dim rowCell As Integer
Dim EventsWorkSheet As Worksheet

Dim cell As Range
Dim Eventos As xmlEventos
tipoOperacion = 2
Set Eventos = New xmlEventos


Set EventsWorkSheet = ThisWorkbook.Sheets("Proyecto")
lastRow = EventsWorkSheet.Cells(EventsWorkSheet.Rows.Count, "A").End(xlUp).Row
Set rango = EventsWorkSheet.Range("A2:A" & lastRow)
For Each cell In rango
    rowCell = cell.Row
    If EventsWorkSheet.Cells(rowCell, "A").value = "" Or EventsWorkSheet.Cells(rowCell, "A").value = "Referencia" Then
        
    Else
        If EventsWorkSheet.Cells(rowCell, "F").value <> "" Then
            scac = getDataFromExel(EventsWorkSheet, rowCell, "F")
            'Extraccion de Referencia
            reference = Trim(getDataFromExel(EventsWorkSheet, rowCell, "A"))
            'Captura AFS o Ganche de Caja
            If EventsWorkSheet.Cells(rowCell, "G").value <> "" And EventsWorkSheet.Cells(rowCell, "H").value <> "" Then
                'Extraccion de Fecha y Hora
                excDate = getDataFromExel(EventsWorkSheet, rowCell, "G")
                excTime = getDataFromExel(EventsWorkSheet, rowCell, "H")
                
                'formato de Fecha para archivo XML
                formatdateTime = formatEvent(excDate, excTime)
                type_Event = "AFS"
                comments = "Llegando a Patio Origen"
                
                'Enviar el Evento a la Clase de Eventos
                
                Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                
                'Captura DPU / Salida de Patio Origen
                
                If EventsWorkSheet.Cells(rowCell, "I").value <> "" And EventsWorkSheet.Cells(rowCell, "J").value <> "" Then
                    'Extraccion de Fecha y Hora
                    excDate = getDataFromExel(EventsWorkSheet, rowCell, "I")
                    excTime = getDataFromExel(EventsWorkSheet, rowCell, "J")
                    
                    'formato de Fecha para archivo XML
                    formatdateTime = formatEvent(excDate, excTime)
                    type_Event = "DPU"
                    comments = "Saliendo de Patio Origen"
                    
                    'Enviar el Evento a la Clase de Eventos
                    Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                    
                    'Evento EXR  / Rojo Mex
                    If EventsWorkSheet.Cells(rowCell, "K").value <> "" And EventsWorkSheet.Cells(rowCell, "L").value <> "" And EventsWorkSheet.Cells(rowCell, "M").value Then
                        'Extraccion de Fecha y Hora
                        excDate = getDataFromExel(EventsWorkSheet, rowCell, "I")
                        excTime = getDataFromExel(EventsWorkSheet, rowCell, "J")
                        comments = getDataFromExel(EventsWorkSheet, rowCell, "M")
                        
                        'formato de Fecha para archivo XML
                        formatdateTime = formatEvent(excDate, excTime)
                        type_Event = "EXR"
                        
                        'Enviar el Evento a la Clase de Eventos
                        Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                    End If
                    
                    'Evento CLR  / Verde MEx
                    If EventsWorkSheet.Cells(rowCell, "N").value <> "" And EventsWorkSheet.Cells(rowCell, "O").value <> "" Then
                        'Extraccion de Fecha y Hora
                        excDate = getDataFromExel(EventsWorkSheet, rowCell, "N")
                        excTime = getDataFromExel(EventsWorkSheet, rowCell, "O")
                        
                        'formato de Fecha para archivo XML
                        type_Event = "CLR"
                        comments = "Modulando Verde MX"
                        formatdateTime = formatEvent(excDate, excTime)
                        
                        'Enviar el Evento a la Clase de Eventos
                        Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                        
                        'Evento ILR  / Rojo USA
                        If EventsWorkSheet.Cells(rowCell, "P").value <> "" And EventsWorkSheet.Cells(rowCell, "Q").value <> "" And EventsWorkSheet.Cells(rowCell, "R").value <> "" And EventsWorkSheet.Cells(rowCell, "S").value <> "" Then
                            'Extraccion de Fecha y Hora
                            excDate = getDataFromExel(EventsWorkSheet, rowCell, "P")
                            excTime = getDataFromExel(EventsWorkSheet, rowCell, "Q")
                            comments = EventsWorkSheet.Cells(rowCell, "R").value & "nuevo Sello" & EventsWorkSheet.Cells(rowCell, "S").value
                            'formato de Fecha para archivo XML
                            formatdateTime = formatEvent(excDate, excTime)
                            type_Event = "ILR"
                            
                            'Enviar el Evento a la Clase de Eventos
                            Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                            
                        End If
                        'Evento  ST1 / Resguardo USA
                        If EventsWorkSheet.Cells(rowCell, "V").value <> "" And EventsWorkSheet.Cells(rowCell, "W").value <> "" And EventsWorkSheet.Cells(rowCell, "X").value <> "" Then
                            'Extraccion de Fecha y Hora
                            excDate = getDataFromExel(EventsWorkSheet, rowCell, "V")
                            excTime = getDataFromExel(EventsWorkSheet, rowCell, "W")
                            comments = EventsWorkSheet.Cells(rowCell, "X").value <> ""
                            
                            'formato de Fecha para archivo XML
                            formatdateTime = formatEvent(excDate, excTime)
                            type_Event = "ST1"
                                    
                                    
                            'Enviar el Evento a la Clase de Eventos
                            Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                        End If
                                
                                'Evento  TSC / Entrega
                                If EventsWorkSheet.Cells(rowCell, "Y").value <> "" And EventsWorkSheet.Cells(rowCell, "Z").value <> "" Then
                                    'Extraccion de Fecha y Hora
                                    excDate = getDataFromExel(EventsWorkSheet, rowCell, "Y")
                                    excTime = getDataFromExel(EventsWorkSheet, rowCell, "Z")
                                    comments = getDataFromExel(EventsWorkSheet, rowCell, "AA")
                                    
                                    'formato de Fecha para archivo XML
                                    formatdateTime = formatEvent(excDate, excTime)
                                    type_Event = "TSC"
                                    
                                    'Enviar el Evento a la Clase de Eventos
                                    Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                                End If
                    End If
                End If
            End If

        Else
            MsgBox "Ingrese el SCAC de Su Linea Transfer:" & reference, vbInformation, "Error SCAC Empty"
            scac = InputBox("Ingrese el SACA de Su linea Transfer", "Error SCAC")
            EventsWorkSheet.Cells(rowCell, "F").value = scac
        End If
    End If
Next cell
End Sub
    
Public Function formatEvent(formatdate As Date, formattime As Date) As String

    formatEvent = Format(formatdate, "YYYY-MM-DD") & "T" & Format(formattime, "HH:MM:SS")
   
End Function
        
Public Function getDataFromExel(Excell As Worksheet, cellRow As Integer, column As String) As String

    getDataFromExel = Excell.Cells(cellRow, column).value
End Function



