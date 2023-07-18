import psycopg2
import requests

# Set up connection to ElephantSQL
conn = psycopg2.connect(
    host='mahmud.db.elephantsql.com',
    database='lengoefb',
    user='lengoefb',
    port='5432',
    password='nJQkL-JFEmmoXtUmDSDZMRhEkzhZlOiL'
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