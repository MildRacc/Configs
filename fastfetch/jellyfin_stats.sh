#!/bin/bash
JELLYFIN_URL="http://localhost:8096"
API_KEY="7adcfa4c0c184ad58c3ef45af6b2a163"

response=$(curl -s "$JELLYFIN_URL/Items/Counts?api_key=$API_KEY")
albums=$(echo "$response" | jq '.AlbumCount')
songs=$(echo "$response" | jq '.SongCount')

echo "Albums: $albums  Songs: $songs"
