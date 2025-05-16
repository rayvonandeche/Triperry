# Tripperry Scripts

This directory contains utility scripts for the Tripperry application.

## Available Scripts

### 1. fetch_restaurant_data.ps1
- PowerShell script to fetch restaurant data from Google Maps API
- Requires Google Maps API key
- Automatically formats and saves data in the required format

### 2. download_restaurant_images.py
- Python script to download restaurant images from Unsplash
- Helps get placeholder images for the restaurants in our app
- Requirements:
  - Python 3.6+ installed
  - Install dependencies with `pip install requests tqdm`
- Usage:
  ```
  python download_restaurant_images.py
  ```

## Setting Up Images

After running the download script, you will have 10 restaurant images in the `assets/images/` directory:

1. `restaurant1.jpg` - Junction Villa Restaurant
2. `restaurant2.jpg` - Red Square Villas
3. `restaurant3.jpg` - The Peak Restaurant
4. `restaurant4.jpg` - Lelo Dishes
5. `restaurant5.jpg` - Westgate Bar Restaurant & Lodge
6. `restaurant6.jpg` - The Carnivore Restaurant
7. `restaurant7.jpg` - About Thyme Restaurant
8. `restaurant8.jpg` - Talisman Restaurant
9. `restaurant9.jpg` - Zen Garden
10. `restaurant10.jpg` - Sky View Lounge

Ensure these images are referenced correctly in the `pubspec.yaml` file under the assets section.