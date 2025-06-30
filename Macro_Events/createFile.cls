Option Explicit

Private pBackup_File As String, pOrigen_File As String
Private pSaveRouteFile As String, pBackUpRouteFile As String
Private pfileName As Object, pBackUpFileName As Object
Private fileSystemObject As Object, backupFilsSystemObject As Object


        
Public Property Get OriginalRoute() As String
    
    Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
    pOrigen_File = Environ("USERPROFILE") & "\Documents\folderPath.txt"
    
    Set pfileName = fileSystemObject.OpenTextFile(pOrigen_File, 1)
    
    pSaveRouteFile = pfileName.ReadAll
    
    OriginalRoute = pSaveRouteFile
End Property

Public Property Get BackUpRoute() As String

    Set backupFilsSystemObject = CreateObject("Scripting.FileSystemObject")
    pBackup_File = Environ("USERPROFILE") & "\Documents\backupPath.txt"
    
    Set pBackUpFileName = backupFilsSystemObject.OpenTextFile(pBackup_File, 1)
    
    pBackUpRouteFile = pBackUpFileName.ReadAll
    
    BackUpRoute = pBackUpRouteFile

End Property

Public Sub Read_Files()
  
pBackup_File = Environ("USERPROFILE") & "\Documents\backupPath.txt"
pOrigen_File = Environ("USERPROFILE") & "\Documents\folderPath.txt"
Set fileSystemObject = CreateObject("Scripting.FileSystemObject")
Set backupFilsSystemObject = CreateObject("Scripting.FileSystemObject")

    On Error GoTo OrigenCreated
    Set pfileName = fileSystemObject.OpenTextFile(pOrigen_File, 1)
    GoTo OrigenCreated



    If Not pfileName Is Nothing Then
        pSaveRouteFile = pfileName.ReadAll
        pfileName.Close
    End If
    
OrigenCreated:
OrigenCreated
Err.Clear
    
        On Error GoTo BackHandler
    Set pBackUpFileName = backupFilsSystemObject.OpenTextFile(pBackup_File, 1)
        GoTo BackHandler
    

    If Not pBackUpFileName Is Nothing Then
        pBackUpRouteFile = pBackUpFileName.ReadAll
        pBackUpFileName.Close
    End If
    


BackHandler:
BackupCreate
Err.Clear

    End Sub
    

  Public Sub OrigenCreated()
'Dim  pBackup_File , pOrigen_File As String
'Private pfileName , pBackUpFileName As String
'Private pOrigenRouteFile , pArchivoBackUp As Object Creados
'Private fileSystemObject , backupFilsSystemObject As Object  Creados
'Private pSaveRouteFile , pBackUpRouteFile As String

pOrigen_File = Environ("USERPROFILE") & "\Documents\folderPath.txt"
Set fileSystemObject = CreateObject("Scripting.FileSystemObject")

On Error Resume Next
pSaveRouteFile = OriginalRoute
    On Error GoTo 0
    If pSaveRouteFile <> "" Then
        MsgBox "Ya has Seleccinado Una ubicacion para guardar. Esta es La ruta" & pSaveRouteFile, vbInformation, "RUTA PRESELECCIONADA EXISTENTE"
        Exit Sub
        End If


    On Error Resume Next
    Set pfileName = fileSystemObject.OpenTextFile(pOrigen_File, 1)
    On Error GoTo 0


    If Not pfileName Is Nothing Then
        pSaveRouteFile = pfileName.ReadAll
        pfileName.Close
    Else
        With Application.FileDialog(msoFileDialogFolderPicker)
        .Title = "Selecciona Una Ubicacion para Guardar tus Archivos"
        .AllowMultiSelect = False

        If .Show = -1 Then
        pSaveRouteFile = .SelectedItems(1) & "\"
        
        Set pfileName = fileSystemObject.CreateTextFile(pOrigen_File, True)
        pfileName.Write pSaveRouteFile
        pfileName.Close

        MsgBox "Has seleccionado: " & pSaveRouteFile, vbInformation, "DIRECCION PARA ENVIO ES"
        End If
    End With
End If
    End Sub
    
Public Sub BackupCreate()

pBackup_File = Environ("USERPROFILE") & "\Documents\backupPath.txt"


On Error Resume Next
pBackUpRouteFile = BackUpRoute
    On Error GoTo 0


Set backupFilsSystemObject = CreateObject("Scripting.FileSystemObject")

    
If (pBackUpRouteFile <> "") Then
    MsgBox "Ya has Seleccionado una Ubicacions para el Respado" & pBackUpRouteFile, vbInformation, "UBICACION PARA RESPALDO YA PRESELECCIONADA"
    Exit Sub
    End If
        On Error Resume Next
       Set pBackUpFileName = backupFilsSystemObject.OpenTextFile(pBackup_File, 1)
        On Error GoTo 0

        If Not pBackUpFileName Is Nothing Then
        pBackUpRouteFile = pBackUpFileName.ReadAll
        pBackUpFileName.Close
        Else
            With Application.FileDialog(msoFileDialogFolderPicker)
            .Title = "Seleccion de ubicacion para respaldo"
            .AllowMultiSelect = False

            If .Show Then
                pBackUpRouteFile = .SelectedItems(1) & "\"

                Set pBackUpFileName = backupFilsSystemObject.CreateTextFile(pBackup_File, True)
                pBackUpFileName.Write pBackUpRouteFile
                pBackUpFileName.Close
                MsgBox "Has seleccionado: " & pBackUpRouteFile, vbInformation, "DIRECCION PARA RESPALDO ES"
            End If
        End With
    End If

    End Sub




