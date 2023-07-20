import psycopg2
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from flask import Flask, jsonify
from flask_socketio import SocketIO, emit

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins='*')

# # Set up connection to ElephantSQL
# conn = psycopg2.connect(
#     host='mahmud.db.elephantsql.com',
#     database='lengoefb',
#     user='lengoefb',
#     port='5432',
#     password='nJQkL-JFEmmoXtUmDSDZMRhEkzhZlOiL'
# )

# cursor = conn.cursor()

# Set up Chrome WebDriver
webdriver_service = Service('users/michaelgoldfarb/downloads')  
options = Options()
options.add_argument('--headless')
driver = webdriver.Chrome(service=webdriver_service, options=options)

# Load the webpage
url = "https://lehigh.sodexomyway.com/can-i-get-in"
driver.get(url)

# Define a function to emit occupancy percentage updates to connected clients
def emit_occupancy_percentage():
    occupancy_div = driver.find_element(By.ID, "occup")
    occupancy_item_div = occupancy_div.find_element(By.CLASS_NAME, "occup-item")
    dining_hall_name = occupancy_item_div.find_element(By.CLASS_NAME, "occup-title").text.strip()
    occup_perc_div = driver.find_element(By.CLASS_NAME, "occup-perc")
    occupancy_percentage = occup_perc_div.find_element(By.CLASS_NAME, "occup-value").text.strip()
    socketio.emit('occupancy_update', {'dining_hall_name': dining_hall_name, 'occupancy_percentage': occupancy_percentage})

# Define a route to serve the occupancy percentage as JSON
@app.route('/occupancy')
def get_occupancy():
    occupancy_div = driver.find_element(By.ID, "occup")
    occupancy_item_div = occupancy_div.find_element(By.CLASS_NAME, "occup-item")
    dining_hall_name = occupancy_item_div.find_element(By.CLASS_NAME, "occup-title").text.strip()
    occup_perc_div = driver.find_element(By.CLASS_NAME, "occup-perc")
    occupancy_percentage = occup_perc_div.find_element(By.CLASS_NAME, "occup-value").text.strip()
    return jsonify({'dining_hall_name': dining_hall_name, 'occupancy_percentage': occupancy_percentage})

# Define an interval at which the occupancy percentage is checked and emitted to clients
def check_occupancy():
    emit_occupancy_percentage()

# Schedule the occupancy check at a specific interval (e.g., every 5 seconds)
driver.set_window_size(1920, 1080)  # Adjust the window size to your needs
driver.execute_script('window.scrollTo(0, document.body.scrollHeight);')
socketio.start_background_task(target=check_occupancy)

if __name__ == '__main__':
    socketio.run(app)

# Quit the WebDriver
driver.quit()

# conn.commit()
# # Close the cursor and connection
# cursor.close()
# conn.close()