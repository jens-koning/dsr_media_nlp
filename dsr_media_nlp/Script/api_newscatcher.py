####     //      Import/Install packages/REST API       \\       ####
# Default packages
import time
import csv
import os
import json

# Preinstalled packages
import requests
import pandas as pd


# Define desired wd, where you want to save your .csv files
desired_wd = '/Users/jenskoning/Documents/Python_projects/dsr_media_nlp/dsr_media_nlp/Script/'
os.chdir(desired_wd)

# URL of our News API
base_url = 'https://api.newscatcherapi.com/v2/search'

# Your API key
X_API_KEY = 'uPGwd9h_DeqHKvxrDL5z9fu3t1Mc9rroBabtvX0iOuE'


####     //      Query Data       \\       ####
# Put your API key to headers in order to be authorized to perform a call
headers = {'x-api-key': X_API_KEY}

# Define your desired parameters
params = {
    'q': 'Digital Silk Road AND China',
    'lang': 'en',
    'to_rank': 10000,
    'page_size': 100,
    'page': 1
    }

# Make a simple call with both headers and params
response = requests.get(base_url, headers=headers, params=params)

# Encode received results
results = json.loads(response.text.encode())
if response.status_code == 200:
    print('Done')
else:
    print(results)
    print('ERROR: API call failed.')
