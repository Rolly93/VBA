Option Explicit
Public Sub eventCreator(reference, type_Event, comments, formatdateTime, tipoOperacion, scac)
Dim XMLArchivo As Object
Dim XmlNodo As Object
Dim archivoXML As String, backupArchivoXML As String
Dim archivoLocal As String, backupArchivo As String
Dim clock As String


Dim SaveRoutes As createFile
Set SaveRoutes = New createFile



Set XMLArchivo = CreateObject("MSXML2.DOMDocument")
Set XmlNodo = XMLArchivo.createElement("AvisoEventos")
XMLArchivo.async = False
XMLArchivo.ValidateOnParse = False
XMLArchivo.resolveExternals = False
XMLArchivo.SetProperty "SelectionLanguage", "XPath"

XmlNodo.SetAttribute "ReferenciaExpd", reference
XmlNodo.SetAttribute "TipoOperacion", tipoOperacion
XmlNodo.SetAttribute "CodigoTransportista", scac
XmlNodo.SetAttribute "ReferenciaTransportista", reference
XmlNodo.SetAttribute "CodigoEvento", type_Event
XmlNodo.SetAttribute "FechaHoraEvento", formatdateTime
XmlNodo.SetAttribute "Comentarios", comments
XMLArchivo.appendChild XmlNodo

'Estableciendo el nombre del archivo

archivoLocal = SaveRoutes.OriginalRoute
backupArchivo = SaveRoutes.BackUpRoute
clock = Format(Now, "yyyymmddhhmmss")

archivoXML = archivoLocal & scac & "_" & reference & "_" & type_Event & "_" & clock & ".xml"
backupArchivoXML = backupArchivo & scac & "_" & reference & "_" & type_Event & "_" & clock & ".xml"

If Dir(backupArchivo & scac & "_" & reference & "_" & type_Event & "*.xml") = "" Then
    XMLArchivo.Save archivoXML
    XMLArchivo.Save backupArchivoXML
End If

End Sub
