import os
import sys
import shutil

import pandas as pd

from funcs import reset_directory

output_path = './output'
user_files_path = os.path.join(output_path, 'user_files')
source_csv = "../taxi_tripdata.csv"
sessions = ["D2 1pm To Code", "D2 3pm To Code 1"]
# Delegate spreasheet here: https://newcastle.sharepoint.com/:x:/r/sites/DigitalInstitute581/_layouts/15/Doc.aspx?sourcedoc=%7B78D3ED5C-7AB9-4A68-A3F3-115B43924113%7D&file=Day%202_DIS_Session%20v%20Delegates%20Breakdown.xlsx&action=default&mobileredirect=true
file_path = 'delegates.xlsx'

# Check that the files exist that we need
if os.path.exists(source_csv) and os.path.exists("./delegates.xlsx"):
    print("Key files exists.")
else:
    sys.exit("Missing key files") 

if not os.path.exists(user_files_path):
    os.makedirs(user_files_path)

# Empty user_files path as we are about to recreate it
reset_directory(user_files_path)


for sess_name in sessions:
    df = pd.read_excel(file_path, sheet_name=sess_name, engine='openpyxl')

    session_path = os.path.join(user_files_path, sess_name)

    if not os.path.exists(session_path):
        os.makedirs(session_path)
    
    df['Full Name'] = df['First Name'] + " " + df['Surname']

    full_names = df['Full Name'].tolist()

    for person in full_names:
        shutil.copyfile(source_csv, os.path.join(session_path, f'{person}.csv'))