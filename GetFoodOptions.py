import psycopg2
import requests
import re
from bs4 import BeautifulSoup

# # Set up connection to ElephantSQL
# conn = psycopg2.connect(
#     host = 'rajje.db.elephantsql.com',
#     database = 'syabkhtb',
#     user = 'syabkhtb',
#     port = '5432',
#     password = 'J7LXI5pNQ_UoUP316yEd-yoXnCOZK8HE'
# )

# URL of the menu page
url = "https://menus.sodexomyway.com/BiteMenu/Menu?menuId=16872&locationId=97451005&whereami=http://lehigh.sodexomyway.com/dining-near-me/rathbone"

# Send a GET request to retrieve the HTML content of the page
response = requests.get(url)

# Create a BeautifulSoup object to parse the HTML content
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
                    menu_item_name == "None"
                    calorie_text = None
                print(f"{menu_item_name}: {calorie_text} calories")
            print()

except AttributeError:
    print("No menu found")





# cursor = conn.cursor()
# cursor.execute("""
#     CREATE TABLE IF NOT EXISTS rathboneOptions (
        
#     )
# """)
# conn.commit()








# # Insert data into the table
# cursor.execute("TRUNCATE TABLE rathboneOptions;")

# cursor.executemany("""
#     INSERT INTO rathboneOptions ()
#     VALUES ()
# """, )

# # Commit the changes and close the cursor and connection
# conn.commit()
# cursor.close()
# conn.close()