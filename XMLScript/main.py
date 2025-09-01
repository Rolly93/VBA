import os
import json
import proyect
import argparse
import tkinter as tk
from tkinter import ttk
from proyect.utility.layer import insert
from proyect.backend.bypass import KeyringManager
def show_login_ui():
    """
    Creates and displays the login UI window.
    
    Returns:
        tuple: (username, password) entered by the user.
    """
    root = tk.Tk()
    root.title("SFTP Script File Sender")

    # --- Sizing and Centering the Window ---
    # Get the screen's dimensions
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()

    # Calculate the desired window size (half the screen size)
    window_width = screen_width // 2
    window_height = screen_height // 2

    # Calculate the position to center the window
    center_x = (screen_width - window_width) // 2
    center_y = (screen_height - window_height) // 2

    # Set the window geometry: width x height + x_position + y_position
    root.geometry(f'{window_width}x{window_height}+{center_x}+{center_y}')
    root.resizable(False, False) # Prevent window from being resized

    # --- UI Elements ---
    frame = ttk.Frame(root, padding="20")
    frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)

    username_label = ttk.Label(frame, text="Username:")
    username_label.grid(row=0, column=0, pady=5, sticky=tk.W)
    username_entry = ttk.Entry(frame, width=30)
    username_entry.grid(row=0, column=1, pady=5, padx=10)

    password_label = ttk.Label(frame, text="Password:")
    password_label.grid(row=1, column=0, pady=5, sticky=tk.W)
    password_entry = ttk.Entry(frame, show='*', width=30)
    password_entry.grid(row=1, column=1, pady=5, padx=10)

    remote_dir_label = ttk.Label(frame, text="Enviar a Carpeta SFPT:")
    remote_dir_label.grid(row=2, column=0, pady=5 , sticky=tk.W)
    remote_dir_entry = ttk.Entry(frame,width=30)
    remote_dir_entry.grid(row=2, column=1,pady=5, padx=10)
    
    host_label = ttk.Label(frame, text="Servidor:")
    host_label.grid(row=3,column=0, pady=5, sticky=tk.W)
    host_entry = ttk.Entry(frame,width=30)
    host_entry.grid(row=3,column=1,pady=5, padx=10)
    
    port_label = ttk.Label(frame,text="Port: ")
    port_label.grid(row=4,column=0, pady=5, sticky=tk.W)
    port_entry = ttk.Entry(frame,width=30)
    port_entry.grid(row=4,column=1,pady=5,padx=10)    
    
    
    
    credentials_store = {
        "host": "",
        'user':"",
        'port':"",
        'password':"",
        'remote_dir':""} # A list to store the credentials
    
    def login():
        """
        Callback function for the login button.
        Saves the credentials and closes the window.
        """
        try:
            credentials_store["user"] = username_entry.get()
            credentials_store["password"] = password_entry.get()
            credentials_store["host"] = host_entry.get()
            credentials_store["remote_dir"] = remote_dir_entry.get()
            credentials_store['port'] = port_entry.get()
        
            insert( credentials_store)
            bypass.save_password(credentials_store['user'], credentials_store['password'])
            root.destroy()
        except Exception as e:
            messegeError(frame,e ,center_x ,center_y)
            credentials_store["user"] = None
            credentials_store["password"] = None
            credentials_store["host"] = None
            credentials_store["remote_dir"] = None
            credentials_store['port'] = None
        
        
        
        
        
        
    login_button = ttk.Button(frame, text="Login", command=login)
    login_button.grid(row=5, column=0, columnspan=2, pady=20)
    
    
    # Run the main event loop
    root.mainloop()

    return credentials_store['user'], credentials_store["password"]

def messegeError(frame,Error,center_x ,center_y):
    

    pop_up = tk.Toplevel(frame)
    pop_up.title("Error on Input")
    pop_up.geometry(f"250x100+{center_x}+{center_y}")
    pop_up.transient(frame)
    pop_up.grab_set()
    
    msg_label = ttk.Label(pop_up, text=str(Error), padding=10)
    msg_label.pack(expand=True)
    
    ok_button = ttk.Button(pop_up,text="OK", command=pop_up.destroy)
    ok_button.pack(pady=5)
    

# --- Placeholder for your backend code ---
def run_backend_code(username, password):
    """
    This function represents your backend logic.
    Replace this with your actual code that uses the credentials.
    
    Args:
        username (str): The username retrieved from the UI or file.
        password (str): The password retrieved from the UI or file.
    """
    print("\n--- Running Backend Code ---")
    if username and password:
        print(f"Backend process started with username: {username}")
        # Your SFTP logic, API calls, etc. would go here.
        # Example: sftp_client.connect(host=..., user=username, password=password)
    else:
        print("Backend process could not run. Credentials were not provided.")

if __name__ == "__main__":
    SERVICE_ID  = "Border Crossing"
    
    parse = argparse.ArgumentParser(description="Command Line for Script XML sender")
    
    subparser = parse.add_subparsers(dest="command",help="Command available")
    
    run_parser = subparser.add_parser("run", help="Run de Script to send the files via SFTP")
    
    bypass = KeyringManager(SERVICE_ID)
    
    user , pwd = bypass.getCredencials()
    
    args = parse.parse_args()
    
    if args.command == "run":
        run_backend_code(user, pwd )
    else:
        if user:
            print(f"Credencial found Keyring. Procedding with Backend Process.!")
            run_backend_code(user,pwd)

        else:

            print("Credencials no Found on system. Showing Login Form")
            user ,pwd = show_login_ui()

            if user and pwd:
                bypass.save_password(user, pwd)

                run_backend_code(user ,pwd)

            else:
                print("Loging failed. Exiting.")