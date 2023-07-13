import psycopg2
import requests
import re
from bs4 import BeautifulSoup

# Set up connection to ElephantSQL
conn = psycopg2.connect(
    host='rajje.db.elephantsql.com',
    database='syabkhtb',
    user='syabkhtb',
    port='5432',
    password='J7LXI5pNQ_UoUP316yEd-yoXnCOZK8HE'
)

cursor = conn.cursor()
cursor.execute("""
    CREATE TABLE IF NOT EXISTS rathboneOptions (
        id SERIAL PRIMARY KEY,
        meal_type VARCHAR(100),
        course_name VARCHAR(100),
        menu_item_name VARCHAR(100),
        calorie_text INTEGER,
        allergen_names TEXT
    )
""")
conn.commit()
cursor.execute("TRUNCATE TABLE rathboneOptions;")

url = "https://menus.sodexomyway.com/BiteMenu/Menu?menuId=16872&locationId=97451005&whereami=http://lehigh.sodexomyway.com/dining-near-me/rathbone"
response = requests.get(url)

soup = BeautifulSoup(response.content, "html.parser")

# Find the bite-menu-dates section
menu_dates = soup.find('ul', class_='primary-backgroundcolor')

try:
    menu_date_element = soup.find('li', class_='bite-date current-menu')
    menu_id = menu_date_element.get('id')
    theMenu = menu_id + "-day"
    print(menu_id)
    menu_div = soup.find('div', id=theMenu)

    # Find the meal sections
    meal_sections = menu_div.find_all('div', class_='accordion-block')

    # Prepare the data for insertion
    data_to_insert = []

    # Iterate over the meal sections
    for meal_section in meal_sections:
        # Extract the meal type
        meal_type = meal_section['class'][1]
        print(f"Meal Type: {meal_type}")

        # Find the course sections within the meal section
        course_sections = meal_section.find_all('div', class_='bite-menu-course')

        # Iterate over the course sections and extract menu items with calories
        for course_section in course_sections:
            # Extract the course name
            course_name = course_section.find('h5').text
            print(f"Course: {course_name}")

            # Extract the menu items within the course section
            menu_items = course_section.find_next('ul', class_='bite-menu-item').find_all('a', class_='get-nutritioncalculator')

            # Extract the menu item names and calorie amounts
            for item in menu_items:
                menu_item_name = item['data-fooditemname']
                calorie_element = item.find_next('a', class_='get-nutrition')
                calorie_text = calorie_element.text.strip() if calorie_element else '0'
                calorie_text = calorie_text.replace("cal", "")
                if menu_item_name == "Have A Nice Day!":
                    menu_item_name = "None"
                    calorie_text = None
                print(f"{menu_item_name}: {calorie_text} calories")
                # Extract the allergens
                allergens_div = item.find_next('div', id=lambda x: x and x.startswith('allergens-'))
                allergen_images = allergens_div.find_all('img', class_='icon-allergen')
                allergen_names = [image['alt'] for image in allergen_images]
                allergen_names_text = ', '.join(allergen_names)
                print(f"Allergens: {allergen_names_text}")
                # Prepare the data row for insertion
                data_row = (meal_type, course_name, menu_item_name, calorie_text, allergen_names_text)
                data_to_insert.append(data_row)
                print()

except AttributeError:
    print("No menu found")

# Insert data into the table
insert_query = """
    INSERT INTO rathboneOptions (meal_type, course_name, menu_item_name, calorie_text, allergen_names)
    VALUES (%s, %s, %s, %s, %s);
"""
cursor.executemany(insert_query, data_to_insert)
conn.commit()
# Close the cursor and connection
cursor.close()
conn.close()