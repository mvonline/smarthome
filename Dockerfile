# Static single-page app — nginx serves index.html at /
FROM nginx:1.27-alpine

# Panel is the site root (browsers expect / or /index.html)
COPY smart-home-panel.html /usr/share/nginx/html/index.html

# Tighter default: hide nginx version, enable gzip for HTML
COPY nginx-default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1/ >/dev/null || exit 1
