   
    Global xmlDoc As Object
    Global xmlNode As Object
    Global fileName, Backup As String
    Global folderPath, BackupPath As String
    Global ws As Worksheet
    Global rng, Scac As Range
    Global lastRow As Long
    Global cell As Range
    Global fso As Object, bfso As Object
    Global file As Object, bfile As Object
     
        
    Sub Files()
    
    ' Establece la carpeta donde se guardarán los archivos XML
' BackupPath = ""
' folderPath = ""
 Set fso = CreateObject("Scripting.FileSystemObject")

    ' Define la ruta del archivo en el directorio de documentos del usuario
    filePath = Environ("USERPROFILE") & "\Documents\folderPath.txt"
    BackupPath = Environ("USERPROFILE") & "\Documents\BackupPath.txt"
    ' Intenta abrir el archivo de texto
    On Error Resume Next
    Set file = fso.OpenTextFile(filePath, 1)
    On Error GoTo 0

    ' Si el archivo existe, lee la ubicación del directorio
    If Not file Is Nothing Then
        folderPath = file.ReadAll
        file.Close
   End If
    Set bfso = CreateObject("Scripting.FileSystemObject")
   
        ' Intenta abrir el archivo de texto
    On Error Resume Next
    Set bfile = bfso.OpenTextFile(BackupPath, 1)
    On Error GoTo 0

    ' Si el archivo existe, lee la ubicación del directorio
    If Not bfile Is Nothing Then
        BackupPath = bfile.ReadAll
        bfile.Close
        End If
   
    End Sub

Sub SaveFileLocation()
   
    Dim filePath As String, bfilePath As String

    ' Crea un objeto FileSystemObject
    Set fso = CreateObject("Scripting.FileSystemObject")
     If filePath <> "" Then

        MsgBox "Ya has seleccionado una ubicación para guardar. No puedes seleccionar una nueva ubicación.", vbInformation, "Ruta Encontrada", filePath
        Exit Sub
    End If
    ' Define la ruta del archivo en el directorio de documentos del usuario
    filePath = Environ("USERPROFILE") & "\Documents\folderPath.txt"

    ' Intenta abrir el archivo de texto
    On Error Resume Next
    Set file = fso.OpenTextFile(filePath, 1)
    On Error GoTo 0

    ' Si el archivo existe, lee la ubicación del directorio
    If Not file Is Nothing Then
        folderPath = file.ReadAll
        file.Close
    Else
        ' Si el archivo no existe, pide al usuario que seleccione una ubicación para guardar
        With Application.FileDialog(msoFileDialogFolderPicker)
            .Title = "Selecciona una ubicación para guardar"
            .AllowMultiSelect = False

            ' Muestra el cuadro de diálogo y guarda la ubicación seleccionada si el usuario hace clic en Aceptar
            If .Show = -1 Then
                folderPath = .SelectedItems(1) & "\"

                ' Guarda la ubicación del directorio en el archivo de texto
                Set file = fso.CreateTextFile(filePath, True)
                file.Write folderPath
                file.Close

                MsgBox "Has seleccionado: " & folderPath, vbInformation
            End If
        End With
    End If
Set bfso = CreateObject("Scripting.FileSystemObject")
    ' Verifica si el usuario ya ha seleccionado una ubicación para guardar
   If BackupPath <> "" Then
        MsgBox "Ya has seleccionado una ubicación para guardar. No puedes seleccionar una nueva ubicación." & folderPath, vbInformation
        Exit Sub
    End If
 bfilePath = Environ("USERPROFILE") & "\Documents\BackupPath.txt"

    ' Intenta abrir el archivo de texto
    On Error Resume Next
    Set bfile = bfso.OpenTextFile(bfilePath, 1)
    On Error GoTo 0

    ' Si el archivo existe, lee la ubicación del directorio
    If Not bfile Is Nothing Then
        BackupPath = bfile.ReadAll
        bfile.Close
    Else
    ' Crea un cuadro de diálogo para seleccionar la ubicación para guardar El Respaldo
    With Application.FileDialog(msoFileDialogFolderPicker)
        .Title = "Selecciona una ubicación para guardar Tu respaldo"
        .AllowMultiSelect = False

        ' Muestra el cuadro de diálogo y guarda la ubicación seleccionada si el usuario hace clic en Aceptar
        If .Show = -1 Then
            BackupPath = .SelectedItems(1) & "\"
           
            
              ' Guarda la ubicación del directorio en el archivo de texto
                Set bfile = bfso.CreateTextFile(bfilePath, True)
                bfile.Write BackupPath
                bfile.Close
                
                 MsgBox "Has seleccionado: " & BackupPath, vbInformation
        End If
   
    End With
    End If
End Sub

