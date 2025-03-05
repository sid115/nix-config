if [ $# -eq 0 ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

url=$1

# Check if input URL is a playlist URL
if [[ "$url" == *"playlist"* ]]; then
    playlist_id=$(echo "$url" | grep -o 'list=[A-Za-z0-9_-]*' | cut -d'=' -f2)
    
    if [ -n "$playlist_id" ]; then
        echo "https://www.youtube.com/feeds/videos.xml?playlist_id=$playlist_id"
    else
        echo "Could not extract playlist ID from URL."
    fi
else
    curl -s "$url" | grep -o 'https://www.youtube.com/feeds/videos.xml?channel_id=[A-Za-z0-9_-]*' | sort | uniq
fi

exit 0
