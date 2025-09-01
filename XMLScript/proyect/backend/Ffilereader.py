import os.path


def XMLFileList ():
    user_Home = os.path.expanduser('~')
    file_Path = os.path.join(user_Home,'Documents','folderPath.txt')
    XMLFilesList =[]
    try:
        with open(file_Path , 'r',encoding='utf-8') as file:
            file_content = file.read()
            
            
            XMLFilesList =[ f"{file_content}{f}" for f in os.listdir(file_content) if f.endswith('.xml')]
            print(file_content)
            return XMLFilesList
    except FileNotFoundError as FNFError:
        print(f"Error: The file was not Found at {file_Path}")
    except Exception as e :
        print(f"An Error occurred: {e}")
    finally:
        file.close()


