import os

path = os.path.abspath("FileScript.py")
path = path[:-(len('FileScript.py') + 1 )]
flieName = []
def file_name(file_dir):

    for root, dirs, files in os.walk(file_dir):

        for file in files :

            if "+" in file:
             flieName.append(file)


    print(flieName)

