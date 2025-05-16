# Script to download missing restaurant images for Tripperry app

# Create directory if it doesn't exist
$assetsDir = "assets/images"
if (-not (Test-Path $assetsDir)) {
    New-Item -ItemType Directory -Path $assetsDir -Force
    Write-Host "Created directory: $assetsDir"
}

# Array of restaurant image URLs from Unsplash (high-quality, free-to-use images)
$restaurantImages = @(
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop",  # Elegant restaurant with mood lighting
    "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=1000&auto=format&fit=crop",     # Traditional/cultural restaurant
    "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1000&auto=format&fit=crop",     # Outdoor dining
    "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=1000&auto=format&fit=crop",  # Fine dining setup
    "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1000&auto=format&fit=crop",  # Food close-up
    "https://images.unsplash.com/photo-1590846406792-0adc7f938f1d?q=80&w=1000&auto=format&fit=crop",  # Casual restaurant
    "https://images.unsplash.com/photo-1537047902294-62a40c20a6ae?q=80&w=1000&auto=format&fit=crop",  # Beachfront dining
    "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=1000&auto=format&fit=crop"      # Safari/wilderness dining
)

# Download each restaurant image
Write-Host "Starting download of 8 restaurant images..." -ForegroundColor Cyan

$successCount = 0
for ($i = 0; $i -lt $restaurantImages.Count; $i++) {
    $imageNumber = $i + 1
    $outputPath = "$assetsDir/restaurant$imageNumber.jpg"
    
    try {
        Write-Host "Downloading restaurant$imageNumber.jpg..." -NoNewline
        Invoke-WebRequest -Uri $restaurantImages[$i] -OutFile $outputPath
        Write-Host " SUCCESS" -ForegroundColor Green
        $successCount++
    } catch {
        Write-Host " FAILED" -ForegroundColor Red
        Write-Host "Error downloading restaurant$imageNumber.jpg: $_" -ForegroundColor Red
    }
}

# Summary
Write-Host "`nDownload summary:" -ForegroundColor Cyan
Write-Host "Successfully downloaded $successCount out of 8 restaurant images" -ForegroundColor $(if ($successCount -eq 8) { "Green" } else { "Yellow" })
Write-Host "Images saved to $((Get-Item $assetsDir).FullName)"
Write-Host "`nRemember to make sure your pubspec.yaml includes the assets/images/ directory" -ForegroundColor Yellow
