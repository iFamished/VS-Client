#!/bin/bash

# Microsoft OAuth settings
CLIENT_ID="00000000402b5328"  # Public client ID (used by mc-oauth.net)
REDIRECT_URI="https://login.live.com/oauth20_desktop.srf"

echo "🔗 Open this URL in your browser to log in:"
echo "https://login.live.com/oauth20_authorize.srf?client_id=$CLIENT_ID&response_type=code&redirect_uri=$REDIRECT_URI&scope=XboxLive.signin%20offline_access"
read -p "📥 Paste the returned code here: " CODE

echo "🔄 Requesting Microsoft access token..."
TOKEN_RESPONSE=$(curl -s -X POST https://login.live.com/oauth20_token.srf \
  -d "client_id=$CLIENT_ID" \
  -d "code=$CODE" \
  -d "grant_type=authorization_code" \
  -d "redirect_uri=$REDIRECT_URI")

ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')

echo "🔄 Authenticating with Xbox Live..."
XBL_RESPONSE=$(curl -s -X POST https://user.auth.xboxlive.com/user/authenticate \
  -H "Content-Type: application/json" \
  -d '{
    "Properties": {
      "AuthMethod": "RPS",
      "SiteName": "user.auth.xboxlive.com",
      "RpsTicket": "'$ACCESS_TOKEN'"
    },
    "RelyingParty": "http://auth.xboxlive.com",
    "TokenType": "JWT"
  }')

XBL_TOKEN=$(echo "$XBL_RESPONSE" | jq -r '.Token')
USER_HASH=$(echo "$XBL_RESPONSE" | jq -r '.DisplayClaims.xui[0].uhs')

echo "🔄 Requesting XSTS token..."
XSTS_RESPONSE=$(curl -s -X POST https://xsts.auth.xboxlive.com/xsts/authorize \
  -H "Content-Type: application/json" \
  -d '{
    "Properties": {
      "SandboxId": "RETAIL",
      "UserTokens": ["'$XBL_TOKEN'"]
    },
    "RelyingParty": "rp://api.minecraftservices.com/",
    "TokenType": "JWT"
  }')

XSTS_TOKEN=$(echo "$XSTS_RESPONSE" | jq -r '.Token')

echo "🔄 Logging into Minecraft..."
MC_RESPONSE=$(curl -s -X POST https://api.minecraftservices.com/authentication/login_with_xbox \
  -H "Content-Type: application/json" \
  -d '{
    "identityToken": "XBL3.0 x='$USER_HASH';'$XSTS_TOKEN'"
  }')

MC_TOKEN=$(echo "$MC_RESPONSE" | jq -r '.access_token')

echo "🔍 Fetching Minecraft profile..."
PROFILE=$(curl -s -H "Authorization: Bearer $MC_TOKEN" https://api.minecraftservices.com/minecraft/profile)
USERNAME=$(echo "$PROFILE" | jq -r '.name')
UUID=$(echo "$PROFILE" | jq -r '.id')

if [ "$USERNAME" = "null" ] || [ -z "$USERNAME" ]; then
  echo "❌ Failed to retrieve Minecraft profile."
  exit 1
fi

echo "✅ Logged in as: $USERNAME"
echo "🆔 UUID: $UUID"
