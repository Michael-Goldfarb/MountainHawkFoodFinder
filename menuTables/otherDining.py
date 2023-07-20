import psycopg2
import requests
import os

# Read database credentials from environment variables
db_host = os.environ.get('DB_HOST')
db_name = os.environ.get('DB_NAME')
db_user = os.environ.get('DB_USER')
db_port = os.environ.get('DB_PORT')
db_password = os.environ.get('DB_PASSWORD')

# Set up connection to ElephantSQL
conn = psycopg2.connect(
    host=db_host,
    database=db_name,
    user=db_user,
    port=db_port,
    password=db_password
)

cursor = conn.cursor()
cursor.execute("""
    CREATE TABLE IF NOT EXISTS otherDining (
        dining_name VARCHAR,
        item_name VARCHAR,
        calories INTEGER,
        price VARCHAR,
        ingredients VARCHAR,
        allergens VARCHAR
    )
""")
conn.commit()
cursor.execute("TRUNCATE TABLE otherDining;")

conn.commit()
# Close the cursor and connection
cursor.close()
conn.close()