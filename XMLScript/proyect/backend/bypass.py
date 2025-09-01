import keyring
from keyring.errors import NoKeyringError 


class KeyringManager:

    
    def __init__(self, service_id):
       
        if not service_id:
            raise ValueError("service_id cannot be empty.")
        self.service_id = service_id

    def save_password(self, username, password):
    
        try:
            keyring.set_password(self.service_id, username, password)
            print(f"Password for user '{username}' saved securely to the keyring.")
        except Exception as e:
            print(f"Error saving password: {e}")

    def get_password(self, username):

        try:
            password = keyring.get_password(self.service_id, username)
            if password is None:
                print(f"No password found for user '{username}' under service '{self.service_id}'.")
            return password
        except Exception as e:
            print(f"Error retrieving password: {e}")
            return None

    def delete_password(self, username):
        
        try:
            # Check if the password exists before trying to delete it
            if keyring.get_password(self.service_id, username) is None:
                print(f"No password found to delete for user '{username}' under service '{self.service_id}'.")
                return
                
            keyring.delete_password(self.service_id, username)
            print(f"Password for user '{username}' deleted successfully from the keyring.")
        except Exception as e:
            print(f"Error deleting password: {e}")
    def getCredencials(self , username = None):
        
        try:
            credentials =  keyring.get_credential(self.service_id ,username)
            
            if credentials:
                return credentials.username, credentials.password
            else:
                print(f"credencial not found for service: {self.service_id} and username: {username}")
                return None ,None
        except NoKeyringError :
            print(f"Erro: No Kering backend is available on this system")
            return None ,None
        except Exception as e:
            print (f"An unexpected error ocurred: {e}")
            return None
            