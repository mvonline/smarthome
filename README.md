# HomePanel — Smart Home Dashboard

A single-file smart home dashboard that connects to Google Home devices via the Smart Device Management (SDM) API. Designed for tablets, wall-mounted displays, and everyday use.

## Features

### Devices

- 💡 **Lights** — on/off toggle, brightness slider, color wheel for color-capable lights
- 🌡️ **Thermostat** — ambient temperature display, setpoint +/− controls, HVAC status, humidity
- 📷 **Cameras & doorbells** — open the device card for **live preview**: **WebRTC** in the browser (when the device reports `WEB_RTC`), or **RTSP URL** to copy for VLC/ffplay (when it reports `RTSP`). Power toggle when the device exposes on/off. Sessions follow [Google SDM](https://developers.google.com/nest/device-access/traits/device/camera-live-stream) limits (~5 minutes; extend WebRTC on wired power where supported).
- 🔌 **Switches** — on/off control
- 🏠 **Room filtering** — tabs to filter devices by room
- 📱 **Detail modal** — pull-up modal with full device info per device
- 🔄 **Refresh** — reload device state from the API

### Media Player

- ▶ **YouTube** — paste any YouTube URL to play directly in the panel
- ♫ **YouTube Music** — paste YouTube Music URLs, or search with music category filter
- 📺 **Subscriptions** — latest video from each channel you subscribe to (uses your Google account; no URL pasting)
- 🔍 **Search** — search YouTube while signed in (OAuth), or with an optional API key
- 🎛️ **Playback controls** — play/pause, previous/next, volume slider, seekable progress bar
- 📋 **Queue** — auto-queued search results with "Up Next" list

### Calendar

- 📅 **Google Calendar** — view your primary calendar events in a monthly grid
- 🗓️ **Mini calendar** — navigate months, click any day to see its events
- 📌 **Agenda view** — all-day events, timed events with title, time, and location
- 🎨 **Color-coded** — events displayed with rotating accent colors

### Weather

- 🌤️ **7-day forecast** — current conditions plus daily high/low from [Open-Meteo](https://open-meteo.com/) (no API key)
- 🔎 **City search** — find any city worldwide
- 📍 **My location** — uses browser geolocation when you allow it
- 💾 **Remembers** your last place (saved in the browser)

### World Clock

- 🕐 **Multiple zones** — add cities by name (Open-Meteo resolves IANA timezones) or use quick-add presets (UTC, New York, London, Paris, Tokyo, Dubai, Sydney)
- ⏱️ **Live updates** — time and date refresh every second while the tab is open (stops when you leave the tab to save battery)
- 🏠 **Local time** — always includes your device’s local timezone; list is saved in the browser

### Markets

- ₿ **Crypto** — watchlist with live USD price and 24h change ([CoinGecko](https://www.coingecko.com/), no API key). Search to add coins; default list BTC, ETH, SOL
- 📊 **Stocks** — US-style tickers via [Finnhub](https://finnhub.io/) (free API key). Add symbols like `AAPL`, `MSFT`
- 🔄 **Auto-refresh** — prices refresh every 60 seconds while the Markets tab is open, plus a manual **Refresh now** button

### Photos & screen saver

- 🖼️ **Photo library** — add images via file picker or drag-and-drop; thumbnails and delete in the **Photos** tab
- 💾 **Local only** — pictures are stored in **IndexedDB** in this browser (not uploaded)
- ⏱️ **Idle slideshow** — optional fullscreen slideshow after a quiet period (1–30 minutes, configurable) while the dashboard is visible
- 🎛️ **Timing** — slide interval (about 6–30 seconds) and **Preview** to test without waiting
- ⌚ **Clock** — time shown on the overlay; **tap** the screen or press **Escape** to exit

### General

- 🔐 **Remember Me** — saves your session so you don't have to sign in every time
- ☀️ **Stay Awake** — wake lock toggle keeps the screen on (perfect for tablets)
- 🎭 **Demo Mode** — try everything without a Google account
- 🌙 **Dark theme** — designed for always-on displays
- 📱 **Responsive** — works on phones, tablets, and desktops

## Authentication Overview


| Feature                    | Auth type                 | What you need                                      |
| -------------------------- | ------------------------- | -------------------------------------------------- |
| Devices                    | Google OAuth              | Client ID + SDM Project ID                         |
| Calendar                   | Google OAuth              | Same sign-in — enable Calendar API                 |
| YouTube playback           | None                      | Paste a URL — no auth                              |
| YouTube search             | Google OAuth *or* API key | Sign-in uses your quota; or add a Data API key     |
| YouTube subscriptions feed | Google OAuth              | Same sign-in — `youtube.readonly` scope            |
| Weather                    | None                      | Open-Meteo is free, no key                         |
| World Clock                | None                      | Uses browser + Open-Meteo geocoding for new cities |
| Markets (crypto)           | None                      | CoinGecko public API                               |
| Markets (stocks)           | Finnhub API key (free)    | Register at finnhub.io, paste key in the tab       |
| Photos / screen saver      | None                      | Images stay on this device (IndexedDB)             |


- **One Google sign-in** requests: Smart Home, Calendar (read-only), and YouTube (read-only for subscriptions + search).
- **YouTube Data API v3** must be **enabled** in Cloud Console for subscription feed and OAuth search to work (same as API-key search).
- **YouTube playback** still works with zero credentials — only paste a video URL.

> If you signed in before YouTube or calendar features existed, **sign out and sign in again** so Google can show the new permissions.

## Setup

### Step 1 — Google Cloud Console (free)

1. Create a project at [console.cloud.google.com](https://console.cloud.google.com/)
2. Enable these APIs:
  - **Smart Device Management API** (devices)
  - **Google Calendar API** (calendar tab)
  - **YouTube Data API v3** (subscriptions feed + search with Google sign-in, or search with an API key)
3. Configure the **OAuth consent screen** (see [OAuth consent screen](#oauth-consent-screen) below)
4. Create **OAuth 2.0 credentials** → **Web application** (see [Origins & redirect URIs](#authorized-javascript-origins-and-redirect-uris))
5. Copy the **Client ID** (the long string ending in `.apps.googleusercontent.com`) into the panel

#### OAuth consent screen

This is what users see when they sign in (“app wants to access…”). You only configure it once per project.

| What | Why |
|------|-----|
| **User type** | Choose **External** unless you have a Google Workspace-only app. External is normal for personal / homelab use. |
| **App name & support email** | Shown on the consent dialog; use something you recognize. |
| **Scopes** | You add scopes when you enable APIs or in the consent screen editor. The panel needs the ones listed in [Authentication Overview](#authentication-overview) (SDM, Calendar, YouTube read-only, email/profile). |
| **Test users** | While the app is in **Testing**, only listed Google accounts can sign in. Add your own Gmail address under **Test users**. |
| **Publishing** | “In production” removes the 100-user test limit but may require verification if you use sensitive scopes. For a private homelab, **Testing** + test users is often enough. |

#### Authorized JavaScript origins and redirect URIs

Create credentials: **APIs & Services** → **Credentials** → **Create credentials** → **OAuth client ID** → **Web application**.

You will see two lists. They are **not** the same thing:

| Field | What to put | Example |
|--------|--------------|---------|
| **Authorized JavaScript origins** | The **origin** only: `scheme` + `host` + `port`. **No path**, no trailing slash. This is where your panel’s HTML is served from. | `http://192.168.1.10:8080`, `https://panel.example.com` |
| **Authorized redirect URIs** | The **exact** URL Google is allowed to send the user back to after login. This app sets `redirect_uri` to `window.location.origin + window.location.pathname` (see `CONFIG.REDIRECT_URI` in `smart-home-panel.html`). | If you open `http://192.168.1.10:8080/`, add **`http://192.168.1.10:8080/`**. If you sometimes open `http://192.168.1.10:8080/index.html`, add that URI **as well** — it must match **character for character**. |

**Tips**

- Use **`https://`** origins in production; Google may block non-localhost `http://` in some cases — for LAN IP + HTTP, testing mode + test users usually still works.
- Every distinct URL you use to open the app (different host, port, or path) needs a matching **origin** (for JS) and usually a matching **redirect URI** if the pathname differs.
- You do **not** put the Client Secret in this single-page app for the flows used here; you only copy the **Client ID** into HomePanel.

### Step 2 — Device Access Console (one-time $5 fee)

1. Go to [console.nest.google.com/device-access](https://console.nest.google.com/device-access)
2. Create a project, link your OAuth client ID
3. Copy the **Project ID**

### Step 3 — YouTube API key (optional)

If you prefer **search without** using OAuth quota, or need search when not signed in:

1. **Credentials** → **Create Credentials** → **API Key**
2. Paste it in the Media tab

Signed-in users can search without this key (uses OAuth).

### Step 4 — Use the panel

1. Open `smart-home-panel.html` in a browser (or host it on any web server)
2. Paste your **Client ID** and **SDM Project ID**
3. Optional: check **Remember me**
4. **Sign in with Google** and accept all requested permissions
5. Use **Devices**, **Media** (including **Subscriptions**), **Calendar**, **Weather**, **World Clock**, **Markets**, and **Photos** (screen saver)

## Tablet / Kiosk Mode

For a wall-mounted tablet or bedside dashboard:

1. Open the panel in your tablet's browser
2. Tap **Stay on** in the top bar to prevent screen sleep (Screen Wake Lock; iPad Safari 16.4+, Android Chrome)
3. Add to home screen: **iPad** — Share → Add to Home Screen · **Android** — Menu → Add to Home Screen

## Demo Mode

Click **Try Demo Mode** on the login screen. Includes sample devices, demo calendar, sample subscription cards, London weather, and a working media player — no Google account required.