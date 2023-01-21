import pandas as pd
from requests import request
import json, os
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

current_date = datetime.utcnow()
year = current_date.year
month = current_date.month
year_month = f'{year}-{month}'

api_key = os.getenv('api_key')


def download_data():
    base_url = "https://api.eia.gov/v2/total-energy/data/"
    query = f"frequency=monthly&data[0]=value&start={year_month}&end={year_month}&api_key={api_key}"
    url = f'{base_url}?{query}'

    r = request("GET", url=url)
    return r

def extract_json(r):
    data = r.text
    json_data = json.loads(data).get('response').get('data')

    return json_data

def convert_json_to_parquet(json_data, parquet_file_name):
    df = pd.DataFrame(json_data)
    df.to_parquet('file.parquet')
    return