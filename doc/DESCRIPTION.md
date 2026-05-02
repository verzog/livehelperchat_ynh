# Live Helper Chat

Live Helper Chat is a free, open-source live support chat application written in PHP. It provides a feature-rich platform for real-time customer support directly on your website.

## Features

- **Live Chat** — Real-time chat with visitors on your site
- **Bot Support** — Built-in bot system with ChatGPT/AI integration
- **Voice, Video & Screen Share** — WebRTC-based communication
- **Messaging Platform Integrations** — Telegram, WhatsApp (Twilio), Facebook Messenger
- **Multi-department & Multi-operator** — Route chats to departments and manage many agents
- **Proactive Chat Invitations** — Automatically invite visitors to chat based on behavior
- **Online Visitor Tracking** — See who's on your site in real time
- **File Uploads** — Allow visitors to share files
- **Chat Archives** — Full history of all conversations
- **Mobile-Friendly** — Responsive widget and mobile web app
- **Desktop Client** — Electron-based standalone app available
- **Canned Responses** — Pre-written answers to common questions
- **Multiple Languages** — Full internationalization support

## After Installation

1. Visit your site at `https://yourdomain.tld/lhc/` (or whatever path you chose)
2. Log in at `https://yourdomain.tld/lhc/index.php/site_admin`
3. Generate your embed code via **Settings → Embed code → Widget embed code (new)**
4. Paste the embed code into your website's HTML

## Notes

- A cron job runs every 5 minutes for background tasks (auto-assignment, bot processing, etc.)
- The PHP session cookie is namespaced to avoid conflicts with other apps on the same domain
