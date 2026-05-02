# Live Helper Chat

Live Helper Chat is a free, open-source live support chat application written in PHP. It provides a feature-rich platform for real-time customer support directly on your website.

## Core Features

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

## Configuration During Installation

During installation, you will be prompted to provide:
- **Domain** — The domain/subdomain where Live Helper Chat will be accessible
- **Installation Path** — URL path (default: `/lhc`)
- **Admin User** — YunoHost user for app administration
- **Admin Email** — Email address for the Live Helper Chat administrator
- **Admin Password** — Initial password for the Live Helper Chat admin account

## After Installation

1. Visit your site at `https://yourdomain.tld/lhc/` (or whatever path you chose)
2. Log in at `https://yourdomain.tld/lhc/index.php/site_admin` with your admin credentials
3. Complete the initial setup wizard (database verification, mail settings, etc.)
4. Generate your embed code via **Settings → Embed code → Widget embed code (new)**
5. Paste the embed code into your website's HTML to enable the chat widget

## Installation Notes

- A cron job runs every 5 minutes for background tasks (auto-assignment, bot processing, email notifications, etc.)
- The PHP session cookie is namespaced to avoid conflicts with other apps on the same domain
- The application requires MariaDB (MySQL) for data storage
- PHP 8.2 with FPM is used for application processing
- Automatic database backups are included in the YunoHost backup system

## Post-Installation Configuration

### First-Time Setup
1. After installation, visit the admin panel
2. Configure your organization settings
3. Set up departments and assign operators
4. Configure email notifications (Settings → Mail)
5. Customize the chat widget appearance (Settings → Look and feel)

### Widget Integration
To display the chat widget on your website:
1. Get the embed code from Settings → Embed code
2. Add this code to your website's HTML (typically in the `<head>` or before `</body>`)
3. The widget will appear on all pages using the code

### Important Security Notes
- Keep your admin password secure
- Regularly update Live Helper Chat through the YunoHost admin panel
- Review and configure access permissions for your operators
- Enable HTTPS (enabled by default with YunoHost)

## Troubleshooting

### Chat widget not showing
- Verify the embed code is correctly placed in your website
- Check browser console for JavaScript errors
- Ensure your domain is correctly configured in Live Helper Chat settings

### Database issues
- If you experience database errors, check the chat logs (accessible via admin panel)
- Verify database connection settings in Settings → Advanced

### Performance optimization
- The cron job can be adjusted by editing `/etc/cron.d/livehelperchat`
- PHP memory and upload limits can be configured during package configuration

## Support and Documentation

- [Live Helper Chat Official Documentation](https://doc.livehelperchat.com)
- [Live Helper Chat Community Forum](https://livehelperchat.com/support)
- [YunoHost Application Support](https://yunohost.org/support)
