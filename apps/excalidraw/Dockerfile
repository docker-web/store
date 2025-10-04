FROM node:20 AS builder

# Récupérer le code source officiel
RUN git clone https://github.com/excalidraw/excalidraw.git /app
WORKDIR /app

# Modifier la limite max (1500 MB)
RUN sed -i 's/4 \* 1024 \* 1024/1500 * 1024 * 1024/' src/constants.ts

# Installer et builder
RUN npm ci
RUN npm run build

# Étape finale : servir avec nginx
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html

# Config nginx custom (taille max requêtes)
RUN echo 'server { \
    listen 80; \
    server_name _; \
    client_max_body_size 1500M; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
