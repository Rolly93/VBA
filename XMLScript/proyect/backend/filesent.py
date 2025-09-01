import os
import paramiko
import Ffilereader





def upload_xml_files(config:dict,LOCAL_DIRECTORY:str):
    """
    credentials_store["user"]
    credentials_store["password"]
    credentials_store["host"]
    credentials_store["remote_dir"]
    credentials_store['port']"""
    SFTP_HOST = config['host']
    SFTP_USER= config["user"]
    SFTP_PASSWORD = config["password"]
    SFTP_HOST = config["host"]
    REMOTE_DIRECTORY = config["remote_dir"]
    SFTP_PORT =config['port']
    LOCAL_DIRECTORY = Ffilereader.XMLFileList()

    xml_files =LOCAL_DIRECTORY
    """
    Connects to an SFTP server and uploads all .xml files from a local directory.
    """
    ssh_client = paramiko.SSHClient()
    # WARNING: AutoAddPolicy() is for convenience/testing. In production,
    # manually add the host key to ~/.ssh/known_hosts for better security.
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    sftp_client = None

    try:
        print(f"Connecting to SFTP server at {SFTP_HOST}...")
        ssh_client.connect(hostname=SFTP_HOST, port=SFTP_PORT, username=SFTP_USER, password=SFTP_PASSWORD)
        sftp_client = ssh_client.open_sftp()
        print("Connection successful.")

        # Ensure the remote directory exists
        try:
            sftp_client.stat(REMOTE_DIRECTORY)
        except IOError:
            print(f"Remote directory '{REMOTE_DIRECTORY}' not found. Creating it...")
            sftp_client.mkdir(REMOTE_DIRECTORY)

        
        if not xml_files:
            print("No XML files found in the local directory. Exiting.")
            return

        print(f"Found {len(xml_files)} XML files to upload.")
        
        for filename in xml_files:
            local_path = filename
            remote_path = os.path.join(REMOTE_DIRECTORY, filename).replace("\\", "/") # Handles OS path differences
            
            print(f"Uploading '{local_path}' to '{remote_path}'...")
            sftp_client.put(local_path, remote_path)
            print("Upload complete.")

        print("All XML files have been uploaded successfully.")
        
    except paramiko.AuthenticationException:
        print("Authentication failed. Please check your username and password.")
    except paramiko.SSHException as e:
        print(f"SSH connection error: {e}")
    except FileNotFoundError:
        print(f"Local directory or file not found. Check the path: {LOCAL_DIRECTORY}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        
    finally:
        if sftp_client:
            sftp_client.close()
            print("SFTP connection closed.")
        if ssh_client:
            ssh_client.close()
            print("SSH connection closed.")

