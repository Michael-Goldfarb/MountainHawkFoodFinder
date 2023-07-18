import psycopg2
import requests
from bs4 import BeautifulSoup

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
    CREATE TABLE IF NOT EXISTS hoursOfOperations (
        dining_hall_name VARCHAR,
        day_of_week VARCHAR,
        meal_type VARCHAR,
        hours VARCHAR
    )
""")
conn.commit()
cursor.execute("TRUNCATE TABLE hoursOfOperations;")

url = "https://lehigh.sodexomyway.com/dining-near-me/hours"
response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')

week_of = soup.find(class_="week-of")
start_week_date = week_of.find(class_="startweekdate").text
end_week_date = week_of.find(class_="endweekdate").text

dining_groups = soup.find_all(class_="dining-group")

for group in dining_groups:
    group_name = group.find('h2').text.strip()
    dining_blocks = group.find_all(class_="dining-block")

    for block in dining_blocks:
        dining_hall = block.find('h3').text.strip()
        reghours = block.find(class_="reghours")

        if reghours:
            regular_hours = reghours.find_all(class_="dining-block-hours")
            days = reghours.find_all(class_="dining-block-days")

            for i, day in enumerate(days):
                day_of_week = day['data-arrayregdays']
                hours = regular_hours[i].text.strip()

                # Check if dining-block-note sibling exists
                meal_type_element = day.find_next_sibling(class_="dining-block-note")
                meal_type = meal_type_element.text.strip()[:-1] if meal_type_element else ""

                cursor.execute("""
                    INSERT INTO hoursOfOperations (dining_hall_name, day_of_week, meal_type, hours)
                    VALUES (%s, %s, %s, %s)
                """, (dining_hall, day_of_week, meal_type, hours))

conn.commit()
# Close the cursor and connection
cursor.close()
conn.close()