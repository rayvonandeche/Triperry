# Restaurant Image Downloader Script
# This script helps download restaurant images from Unsplash for the Tripperry app

# Prerequisites:
# - Install requests module: pip install requests
# - Install tqdm module: pip install tqdm (for progress bar)

import requests
import os
import time
from tqdm import tqdm

# Define the output directory
OUTPUT_DIR = "../assets/images/"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# List of restaurant names from our data
RESTAURANTS = [
    "Junction Villa Restaurant",
    "Red Square Villas",
    "The Peak Restaurant",
    "Lelo Dishes",
    "Westgate Bar Restaurant & Lodge",
    "The Carnivore Restaurant", 
    "About Thyme Restaurant",
    "Talisman Restaurant", 
    "Zen Garden",
    "Sky View Lounge"
]

def download_image(query, output_filename):
    """Download an image from Unsplash API for the given query"""
    # In a real scenario, you'd use the Unsplash API with an API key
    # This is just a simplified example using their source website
    
    # Format the query for the URL
    formatted_query = query.lower().replace(" ", "-")
    search_url = f"https://source.unsplash.com/featured/?restaurant,{formatted_query},kenya"
    
    try:
        print(f"Downloading image for: {query}")
        response = requests.get(search_url, stream=True)
        response.raise_for_status()
        
        # Save the image
        with open(output_filename, 'wb') as f:
            total_size = int(response.headers.get('content-length', 0))
            block_size = 8192
            
            with tqdm(total=total_size, unit='B', unit_scale=True) as pbar:
                for chunk in response.iter_content(chunk_size=block_size):
                    if chunk:
                        f.write(chunk)
                        pbar.update(len(chunk))
        
        print(f"Downloaded image to {output_filename}")
        return True
    except Exception as e:
        print(f"Error downloading image for {query}: {str(e)}")
        return False

def main():
    """Main function to download all restaurant images"""
    print("Starting restaurant image download...")
    
    for idx, restaurant in enumerate(RESTAURANTS, 1):
        output_file = os.path.join(OUTPUT_DIR, f"restaurant{idx}.jpg")
        success = download_image(restaurant, output_file)
        
        if success:
            print(f"Successfully downloaded image {idx}/10")
        else:
            print(f"Failed to download image {idx}/10")
        
        # Be nice to the API with a short delay
        if idx < len(RESTAURANTS):
            time.sleep(1)
    
    print("\nDownload complete! Please check the images and update any that don't match well.")
    print("Remember to add these images to your pubspec.yaml asset entries.")

if __name__ == "__main__":
    main()
