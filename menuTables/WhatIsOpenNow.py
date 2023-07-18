import requests
from bs4 import BeautifulSoup

url = "https://lehigh.sodexomyway.com/can-i-get-in"
response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')

occupancy_div = soup.find(id="occup")
occupancy_item_div = occupancy_div.find(class_="occup-item")
dining_hall_name = occupancy_item_div.find(class_="occup-title").text.strip()
occupancy_percentage = occupancy_item_div.find(class_="occup-value").text.strip()

print(f"Occupancy percentage for {dining_hall_name}: {occupancy_percentage}")
