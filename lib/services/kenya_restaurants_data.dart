// Contains real restaurant data from Google Maps search
// This file provides restaurant information for the Tripperry application

class KenyaRestaurantsData {
  static final List<Map<String, dynamic>> restaurants = [
    {
      "name": "Junction Villa Restaurant",
      "address": "PWVF+8PR, Nairobi, Kenya",
      "location": {
        "lat": -1.2565499,
        "lng": 36.9242697
      },
      "placeId": "ChIJb7vwVO4ULxgRiLmxxFp_asA",
      "rating": 3.9,
      "types": ["restaurant", "food"],
      "image": "assets/images/restaurant1.jpg", // Placeholder - need to download
      "cuisineType": "Local",
      "priceRange": "KSh 500-1500",
      "popularDishes": ["Nyama Choma", "Pilau", "Ugali"],
      "tags": ["Casual", "Local Cuisine", "Group-friendly"]
    },
    {
      "name": "Red Square Villas",
      "address": "Kangundo Rd, Nairobi, Kenya",
      "location": {
        "lat": -1.2560872,
        "lng": 36.9264976
      },
      "placeId": "ChIJQauUVvEULxgRBcVz6xBf5mo",
      "rating": 4.0,
      "types": ["restaurant", "lodging", "food"],
      "image": "assets/images/restaurant2.jpg", // Placeholder - need to download
      "cuisineType": "International",
      "priceRange": "KSh 800-2000",
      "popularDishes": ["Grilled Fish", "Steaks", "Special Pilau"],
      "tags": ["Fine Dining", "Romantic", "Outdoor Seating"]
    },
    {
      "name": "The Peak Restaurant",
      "address": "Saiko 2, Kangundo Rd, Nairobi, Kenya",
      "location": {
        "lat": -1.2572292,
        "lng": 36.9222271
      },
      "placeId": "ChIJ6V2n5fEULxgRgXrLqwsqhhQ",
      "rating": 4.4,
      "types": ["bar", "restaurant", "food"],
      "image": "assets/images/restaurant3.jpg", // Placeholder - need to download
      "cuisineType": "Fusion",
      "priceRange": "KSh 700-1800",
      "popularDishes": ["Craft Cocktails", "BBQ Platters", "Surf & Turf"],
      "tags": ["Trendy", "Bar", "Nightlife"]
    },
    {
      "name": "Lelo Dishes",
      "address": "PWVG+FW2, Kangundo Rd, Nairobi, Kenya",
      "location": {
        "lat": -1.2563598,
        "lng": 36.92725
      },
      "placeId": "ChIJQ7fSxkoVLxgRaGqVrEFpcCs",
      "rating": 5.0,
      "types": ["restaurant", "food"],
      "image": "assets/images/restaurant4.jpg", // Placeholder - need to download
      "cuisineType": "Traditional Kenyan",
      "priceRange": "KSh 300-800",
      "popularDishes": ["Chapati", "Sukuma Wiki", "Githeri"],
      "tags": ["Local Favorite", "Authentic", "Affordable"]
    },
    {
      "name": "Westgate Bar Restaurant & Lodge",
      "address": "PWXF+376, Nairobi, Kenya",
      "location": {
        "lat": -1.2522869,
        "lng": 36.9231375
      },
      "placeId": "ChIJlyVp3eQULxgRSH_ua5Q3e04",
      "rating": 4.7,
      "types": ["restaurant", "food"],
      "image": "assets/images/restaurant5.jpg", // Placeholder - need to download
      "cuisineType": "Mixed Continental",
      "priceRange": "KSh 600-1500",
      "popularDishes": ["House Special Chicken", "Cocktails", "Signature Stew"],
      "tags": ["Entertainment", "Lodge", "Popular"]
    },
    {
      "name": "The Carnivore Restaurant",
      "address": "Langata Rd, Nairobi West, Nairobi, Kenya",
      "location": {
        "lat": -1.3291611,
        "lng": 36.8005417
      },
      "placeId": "ChIJ2YfT_hQQLxgRdeY1YhwWyyo",
      "rating": 4.5,
      "types": ["restaurant", "food"],
      "image": "assets/images/restaurant6.jpg", // Placeholder - need to download
      "cuisineType": "Grill & BBQ",
      "priceRange": "KSh 1500-3000",
      "popularDishes": ["Nyama Choma", "Game Meat", "All-You-Can-Eat Grill"],
      "tags": ["Famous", "Tourist Spot", "Unique Experience"]
    },
    {
      "name": "About Thyme Restaurant",
      "address": "Eldama Ravine Rd, Nairobi, Kenya",
      "location": {
        "lat": -1.25243,
        "lng": 36.803014
      },
      "placeId": "ChIJeYvGVnMXLxgRQXqlWP_I7xM",
      "rating": 4.4,
      "types": ["restaurant", "food"],
      "image": "assets/images/restaurant7.jpg", // Placeholder - need to download
      "cuisineType": "Mediterranean",
      "priceRange": "KSh 1000-2500",
      "popularDishes": ["Fresh Seafood", "Pasta", "Gourmet Salads"],
      "tags": ["Elegant", "Garden Setting", "Date Night"]
    },
    {
      "name": "Talisman Restaurant",
      "address": "Ngong Rd, Nairobi, Kenya",
      "location": {
        "lat": -1.3230047,
        "lng": 36.7038078
      },
      "placeId": "ChIJr-KeQWQbLxgRv0mZ8dc3zmU",
      "rating": 4.6,
      "types": ["restaurant", "food"],
      "image": "assets/images/restaurant8.jpg", // Placeholder - need to download
      "cuisineType": "Eclectic",
      "priceRange": "KSh 1200-2800",
      "popularDishes": ["Feta Coriander Samosas", "Beef Fillet", "Cocktails"],
      "tags": ["Art Décor", "Cozy", "International"]
    },
    {
      "name": "Zen Garden",
      "address": "Lower Kabete Rd, Nairobi, Kenya",
      "location": {
        "lat": -1.2445651,
        "lng": 36.769689
      },
      "placeId": "ChIJY-MPTYsZLxgRRoD0AsEBNDo",
      "rating": 4.5,
      "types": ["restaurant", "food"],
      "image": "assets/images/restaurant9.jpg", // Placeholder - need to download
      "cuisineType": "Pan-Asian",
      "priceRange": "KSh 1000-3000",
      "popularDishes": ["Sushi", "Thai Curry", "Dim Sum"],
      "tags": ["Serene", "Upscale", "Business Lunch"]
    },
    {
      "name": "Sky View Lounge",
      "address": "Ground,Sky View,Kayole Junction Njiru Road,Matopeni/Spring Valley Embakasi, Kenya",
      "location": {
        "lat": -1.25617,
        "lng": 36.9260979
      },
      "placeId": "ChIJYV2Wq_AVLxgRFolcD5-eSV0",
      "rating": 4.2,
      "types": ["bar", "restaurant", "food"],
      "image": "assets/images/restaurant10.jpg", // Placeholder - need to download
      "cuisineType": "Bar & Grill",
      "priceRange": "KSh 500-1500",
      "popularDishes": ["BBQ Ribs", "Beer", "Bar Snacks"],
      "tags": ["Rooftop", "Views", "Live Music"]
    }
  ];
}
