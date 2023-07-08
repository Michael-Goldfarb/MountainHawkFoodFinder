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

print(response)

# Create a BeautifulSoup object to parse the HTML content
soup = BeautifulSoup(response.content, "html.parser")

# Find the menu items within the specific div
menu_div = soup.find('div', id='menuid-2-day')

# Find the bite-menu-course sections
course_sections = menu_div.find_all('div', class_='bite-menu-course')

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
        print(f"{menu_item_name}: {calorie_text} calories")


    print()  # Add a blank line to separate courses




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