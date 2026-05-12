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
    If EventsWorkSheet.Cells(rowCell, "A").Value = "" Or EventsWorkSheet.Cells(rowCell, "A").Value = "Referencia" Then
        
    Else
        If EventsWorkSheet.Cells(rowCell, "F").Value <> "" Then
            scac = UCase(getDataFromExel(EventsWorkSheet, rowCell, "F"))
            'Extraccion de Referencia
            reference = UCase(Trim(getDataFromExel(EventsWorkSheet, rowCell, "A")))
            'Captura AFS o Ganche de Caja
            If EventsWorkSheet.Cells(rowCell, "G").Value <> "" And EventsWorkSheet.Cells(rowCell, "H").Value <> "" Then
                'Extraccion de Fecha y Hora
                excDate = getDataFromExel(EventsWorkSheet, rowCell, "G")
                excTime = getDataFromExel(EventsWorkSheet, rowCell, "H")
                
                'formato de Fecha para archivo XML
                formatdateTime = formatEvent(excDate, excTime)
                type_Event = "AFS"
                comments = "Llegando a Patio Origen"
                
                'Enviar el Evento a la Clase de Eventos
                
                Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                
                
                '//////////////////////////////////////////////////////////////////////////////////////////////
                
                'Captura DPU / Salida de Patio Origen
                
                If EventsWorkSheet.Cells(rowCell, "I").Value <> "" And EventsWorkSheet.Cells(rowCell, "J").Value <> "" Then
                    'Extraccion de Fecha y Hora
                    excDate = getDataFromExel(EventsWorkSheet, rowCell, "I")
                    excTime = getDataFromExel(EventsWorkSheet, rowCell, "J")
                    
                    'formato de Fecha para archivo XML
                    formatdateTime = formatEvent(excDate, excTime)
                    type_Event = "DPU"
                    comments = "Saliendo de Patio Origen"
                    
                    'Enviar el Evento a la Clase de Eventos
                    Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                    
                    '////////////////////////////////////////////////////////////////
                    
                    'Evento EXR  / Rojo Mex
                    If EventsWorkSheet.Cells(rowCell, "K").Value <> "" And EventsWorkSheet.Cells(rowCell, "L").Value <> "" And EventsWorkSheet.Cells(rowCell, "M").Value <> "" Then
                        'Extraccion de Fecha y Hora
                        excDate = getDataFromExel(EventsWorkSheet, rowCell, "I")
                        excTime = getDataFromExel(EventsWorkSheet, rowCell, "J")
                        comments = getDataFromExel(EventsWorkSheet, rowCell, "M") & "nuevo Sello" & EventsWorkSheet.Cells(rowCell, "M").Value
                        
                        'formato de Fecha para archivo XML
                        formatdateTime = formatEvent(excDate, excTime)
                        type_Event = "EXR"
                        
                        'Enviar el Evento a la Clase de Eventos
                        Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                    End If
                    
                    '/////////////////////////////////////////////////////////////////////////
                    
                    'Evento ECC  / Verde MEx
                    If EventsWorkSheet.Cells(rowCell, "N").Value <> "" And EventsWorkSheet.Cells(rowCell, "O").Value <> "" Then
                        'Extraccion de Fecha y Hora
                        excDate = getDataFromExel(EventsWorkSheet, rowCell, "N")
                        excTime = getDataFromExel(EventsWorkSheet, rowCell, "O")
                        
                        'formato de Fecha para archivo XML
                        type_Event = "ECC"
                        comments = "Modulando Verde MX"
                        formatdateTime = formatEvent(excDate, excTime)
                        
                        'Enviar el Evento a la Clase de Eventos
                        Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                    
                    '////////////////////////////////////////////////////////////////////////////
                    
                    'Evento CLR  / Verde USA
                    If EventsWorkSheet.Cells(rowCell, "T").Value <> "" And EventsWorkSheet.Cells(rowCell, "U").Value <> "" Then
                        'Extraccion de Fecha y Hora
                        excDate = getDataFromExel(EventsWorkSheet, rowCell, "T")
                        excTime = getDataFromExel(EventsWorkSheet, rowCell, "U")
                        
                        'formato de Fecha para archivo XML
                        type_Event = "CLR"
                        comments = "Modulando Verde USA"
                        formatdateTime = formatEvent(excDate, excTime)
                        
                        'Enviar el Evento a la Clase de Eventos
                        Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                        
                     '///////////////////////////////////////////////////////////////////////////
                     
                        'Evento ILR  / Rojo USA
                        If EventsWorkSheet.Cells(rowCell, "P").Value <> "" And EventsWorkSheet.Cells(rowCell, "Q").Value <> "" And EventsWorkSheet.Cells(rowCell, "R").Value <> "" And EventsWorkSheet.Cells(rowCell, "S").Value <> "" Then
                            'Extraccion de Fecha y Hora
                            excDate = getDataFromExel(EventsWorkSheet, rowCell, "P")
                            excTime = getDataFromExel(EventsWorkSheet, rowCell, "Q")
                            comments = EventsWorkSheet.Cells(rowCell, "R").Value & "nuevo Sello" & EventsWorkSheet.Cells(rowCell, "S").Value
                            'formato de Fecha para archivo XML
                            formatdateTime = formatEvent(excDate, excTime)
                            type_Event = "ILR"
                            
                            'Enviar el Evento a la Clase de Eventos
                            Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                            
                        End If
                        '//////////////////////////////////////////////////////////////////////////////
                        
                        'Evento  ST1 / Resguardo USA
                        If EventsWorkSheet.Cells(rowCell, "V").Value <> "" And EventsWorkSheet.Cells(rowCell, "W").Value <> "" And EventsWorkSheet.Cells(rowCell, "X").Value <> "" Then
                            'Extraccion de Fecha y Hora
                            excDate = getDataFromExel(EventsWorkSheet, rowCell, "V")
                            excTime = getDataFromExel(EventsWorkSheet, rowCell, "W")
                            comments = EventsWorkSheet.Cells(rowCell, "X").Value <> ""
                            
                            'formato de Fecha para archivo XML
                            formatdateTime = formatEvent(excDate, excTime)
                            type_Event = "ST1"
                                    
                                    
                            'Enviar el Evento a la Clase de Eventos
                            Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                        End If
                                '////////////////////////////////////////////////////////////////////////
                                'Evento  TSC / Entrega
                                If EventsWorkSheet.Cells(rowCell, "Y").Value <> "" And EventsWorkSheet.Cells(rowCell, "Z").Value <> "" Then
                                    'Extraccion de Fecha y Hora
                                    excDate = getDataFromExel(EventsWorkSheet, rowCell, "Y")
                                    excTime = getDataFromExel(EventsWorkSheet, rowCell, "Z")
                                    comments = getDataFromExel(EventsWorkSheet, rowCell, "AA")
                                    
                                    'formato de Fecha para archivo XML
                                    formatdateTime = formatEvent(excDate, excTime)
                                    type_Event = "TSC"
                                    
                                    If IsEmpty(comments) Then
                                    comments = InputBox("Favor de ingrear quien recibio:" & vbCrLf, "Error Referncia : " & reference)
                                    End If
                                    
                                    'Enviar el Evento a la Clase de Eventos
                                    Eventos.eventCreator reference, type_Event, comments, formatdateTime, tipoOperacion, scac
                                End If
                    End If
                End If
            End If

        Else
            MsgBox "Ingrese el SCAC de Su Linea Transfer:" & reference, vbInformation, "Error SCAC Empty"
            scac = InputBox("Ingrese el SACA de Su linea Transfer", "Error SCAC")
            EventsWorkSheet.Cells(rowCell, "F").Value = scac
        End If
    End If
    End If
Next cell
End Sub
    
Public Function formatEvent(formatdate As Date, formattime As Date) As String

    formatEvent = Format(formatdate, "YYYY-MM-DD") & "T" & Format(formattime, "HH:MM:SS")
   
End Function
        
Public Function getDataFromExel(Excell As Worksheet, cellRow As Integer, column As String) As String

    getDataFromExel = Excell.Cells(cellRow, column).Value
End Function

Public Function validReference(r As String) As Boolean

Valid = True
r = UCase(Trim(r))
isLengthCorrect = (Len(r) = 10)
hasValidPrefix = (Prefix = "92B" Or Prefix = "82B")

If Not hasValidPrefix And Not isLengthCorrect Then
Valid = False
MsgBox "Referencia incorrecta." & vbCrLf & _
               "Debe iniciar con 92B o 82B y tener 10 caracteres.", _
               vbCritical, "Error de Validación"
End If





End Function

 

