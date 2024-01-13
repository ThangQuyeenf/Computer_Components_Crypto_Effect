import os
import pandas as pd
import numpy as np
from enums.data_type import E_DATA_TYPE

WORK_DIR = os.path.dirname(os.path.dirname(__file__))
DATA_DIR = os.path.join(WORK_DIR, 'data')
class DataLoader:
    def __init__(self):
        pass
        # self.file_path = file_path

    def load_data(self, file_path):
        try:
            # Load the CSV file into a pandas DataFrame
            data = pd.read_csv(file_path)
            return data
        except Exception as e:
            print(f"Error loading data: {e}")
            return None
        
    def extract_dtypes(self, df):
        if df is not None:
            cols = np.array(df.keys())
            dt = np.array([E_DATA_TYPE[str(df[col].dtypes)].value for col in cols])
            result =  dict(zip(cols, dt))
            return result
        else: return []
        
def test():
    # Instantiate the DataLoader with the CSV file path
    csv_file_path = os.path.join(DATA_DIR,"DIM_GPU_PROD.csv")
    data_loader = DataLoader()
    list_file = os.listdir(DATA_DIR)
    for file in list_file:
        file_path = os.path.join(DATA_DIR, file)
        # Load the data using the load_data method
        loaded_data = data_loader.load_data(file_path=file_path)
        # Check if data is loaded successfully
        if loaded_data is not None:
            print("Data loaded successfully:\n")
            print(loaded_data.info())
            dt_dict = data_loader.extract_dtypes(loaded_data)
            print(dt_dict)
            print("\n")
            print("=============================")
        else:
            print("Failed to load data.")
        
if __name__ == "__main__":
    print(DATA_DIR)
    print(os.listdir(DATA_DIR))
    test()