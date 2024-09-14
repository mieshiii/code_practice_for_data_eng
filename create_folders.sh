#!/bin/bash

# Loop from 6 to 50
for n in {6..50}
do
  # Create the folder with the format qn
  folder_name="q$n"
  mkdir -p $folder_name
  
  # Create the SQL file inside the folder with the format qn.sql
  file_name="$folder_name/q$n.sql"
  touch $file_name
done

echo "Folders and files created successfully!"
