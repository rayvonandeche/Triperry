# Restaurant Data Integration

This document explains how restaurant data from Google Maps has been integrated into the Tripperry application.

## Data Source

The restaurant data comes from Google Maps Place Search API. We've integrated real Kenyan restaurants with their:
- Names
- Addresses
- Coordinates (latitude/longitude)
- Ratings
- Place IDs
- Types (restaurant, bar, food, etc.)

## Image Requirements

Since the Google Maps API doesn't provide images in the basic search results, you'll need to download placeholder images for the restaurants. Here are the image files needed:

1. Download 10 restaurant images and save them in the `assets/images/` directory:
   - `restaurant1.jpg` - For Junction Villa Restaurant
   - `restaurant2.jpg` - For Red Square Villas
   - `restaurant3.jpg` - For The Peak Restaurant
   - `restaurant4.jpg` - For Lelo Dishes
   - `restaurant5.jpg` - For Westgate Bar Restaurant & Lodge
   - `restaurant6.jpg` - For The Carnivore Restaurant
   - `restaurant7.jpg` - For About Thyme Restaurant
   - `restaurant8.jpg` - For Talisman Restaurant
   - `restaurant9.jpg` - For Zen Garden
   - `restaurant10.jpg` - For Sky View Lounge

### Image Suggestions

For the best user experience, we recommend:
- High-quality images showing both the interior and food of restaurants
- Images with 16:9 or 4:3 aspect ratios
- Minimum resolution of 800x600 pixels
- Keep file sizes reasonable (under 200KB each) for mobile performance

## Sources for Free Restaurant Images

1. [Unsplash](https://unsplash.com/s/photos/restaurant-kenya) - Free high-resolution photos
2. [Pexels](https://www.pexels.com/search/restaurant/) - Free stock photos
3. [Pixabay](https://pixabay.com/images/search/restaurant/) - Free images

## Getting Additional Data

For a more complete implementation, you would need:
1. Use the Google Maps Places API to fetch detailed information about each restaurant using their Place IDs
2. Use the Google Maps Place Photos API to fetch actual photos of the restaurants

## Update Image References

After downloading the images, ensure they're correctly referenced in:
1. `lib/services/kenya_restaurants_data.dart` - Update the image paths if needed
2. Add the image assets to your pubspec.yaml under assets section if not already included

## Next Steps

1. Consider implementing photo caching for better performance
2. Add restaurant menu integration if data becomes available
3. Consider implementing a real-time rating system for user reviews