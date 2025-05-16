# Import pandas for data manipulation
import pandas as pd 

# Read the Walmart dataset from local path
df = pd.read_csv(r"C:\Users\User\Downloads\SQL Project\Walmart.csv")

# Display statistical summary of the dataset
df.describe()

# Show data types of each column
df.dtypes

# Print concise summary of the DataFrame
df.info()

# Display the first 5 rows of the dataset
df.head()

# Show the shape of the dataset (rows, columns)
df.shape

# Count the number of duplicate rows
df.duplicated().sum()

# Count the number of missing values in each column
df.isnull().sum()

# Remove duplicate rows from the dataset
df.drop_duplicates(inplace=True)

# Drop rows with any missing values
df.dropna(inplace=True)

# Remove the '$' symbol from unit_price and convert it to float
df['unit_price'] = df['unit_price'].str.replace('$', '').astype(float)

# Clean column names: remove spaces and strip whitespaces
df.columns = df.columns.str.strip().str.replace(' ', '_')

# Calculate total price for each row (unit_price * quantity)
df["Total"] = df["unit_price"] * df["quantity"]

# Import SQLAlchemy's create_engine to connect to MySQL
from sqlalchemy import create_engine

# NOTE: Make sure mysql-connector-python is installed using:
# pip install mysql-connector-python

# Define MySQL credentials
user = 'root'
password = 'Shruti2324'
host = 'localhost'
database = 'walmartSales'

# Create SQLAlchemy engine for MySQL connection
engine = create_engine(f"mysql+mysqlconnector://{user}:{password}@{host}/{database}")

# Export the cleaned DataFrame to MySQL table named 'walmart'
df.to_sql(name='walmart', con=engine, if_exists='replace', index=False)
