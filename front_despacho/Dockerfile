# Multistage
# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /build
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Runner (Usuario no root)
FROM nginxinc/nginx-unprivileged:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar los estáticos asignando la propiedad al usuario nginx
COPY --from=builder --chown=nginx:nginx /build/dist /usr/share/nginx/html

EXPOSE 80