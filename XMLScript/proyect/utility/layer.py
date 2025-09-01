import bcrypt
from proyect.db import db
from proyect.backend.Ffilereader import XMLFileList
from proyect.backend.filesent import upload_xml_files
def insert (credencials:dict):
    
    user = credencials["user"]
    password = credencials["password"]
    host = credencials["host"]
    remote_dir = credencials["remote_dir"]
    port = credencials['port']
    
    if not user:
        raise ValueError ( "Please Insert User") 
    if not password:
        raise  ValueError ("Plese insert the Password")
    if not remote_dir:
        raise  ValueError ("Please insert Remote Directory")
    if not host:
        raise ValueError ( "Please Insert Host")    

    print("code runed")
    password_bytes = password.encode('utf-8')
    hashed_password = bcrypt.hashpw(password_bytes, bcrypt.gensalt())
    db.add_sftp_config(host, user, port, hashed_password, remote_dir)

def extractData(credencials:dict):
    config  = db.get_sftp_config(credencials['user'])

    if config:
        db_hashed_password = config["sft_password"]
        if bcrypt.checkpw(credencials['password'].encode('utf-8'),db_hashed_password):
            pathXML = XMLFileList()
            
            if not pathXML:
                raise ValueError ("Local Dir not Found")
            upload_xml_files(credencials, pathXML)
    