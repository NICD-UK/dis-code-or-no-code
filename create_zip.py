from zipfile import ZipFile

# Create a ZipFile Object
with ZipFile('./infra/upload.zip', 'w') as zip:
   # Adding files that need to be zipped
   zip.write('python.ipynb')
   zip.write('taxi_tripdata.csv')
   zip.write('excel_instructions.md')
   zip.write('trip_data_dictionary.pdf')