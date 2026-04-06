To connect your real Google Home devices, here's what you need:
Step 1 — Google Cloud Console (free)

Create a project at console.cloud.google.com
Enable "Smart Device Management API"
Create OAuth 2.0 credentials → Web Application
Add your hosting URL to both "Authorized JavaScript origins" and "Authorized redirect URIs"

Step 2 — Device Access Console (one-time $5 fee)

Go to console.nest.google.com/device-access
Create a project, link your OAuth client ID
This gives you a Project ID

Step 3 — Use the panel

Paste your Client ID and Project ID into the fields
Sign in with Google → devices load automatically


What works right now:

💡 Lights — on/off toggle + brightness slider
🌡️ Thermostat — temperature display + setpoint +/− controls
🔌 Switches, cameras, doorbells — on/off
Room filtering tabs
Pull-up detail modal per device
Refresh button