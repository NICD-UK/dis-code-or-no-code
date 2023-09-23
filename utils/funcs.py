import os
import shutil

def reset_directory(directory_path):
    # Remove the directory if it exists
    if os.path.exists(directory_path) and os.path.isdir(directory_path):
        shutil.rmtree(directory_path)

    # Create the directory
    os.makedirs(directory_path)