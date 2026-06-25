FROM nginx:alpine

# Copy the checklist into the nginx web root
COPY nist-800171-checklist.html /usr/share/nginx/html/index.html
RUN chmod 644 /usr/share/nginx/html/index.html

# Optional: copy a custom nginx config if you want to add gzip, caching, etc.
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
