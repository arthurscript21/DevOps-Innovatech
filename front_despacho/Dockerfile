# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /build
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Producción con usuario no root
FROM nginxinc/nginx-unprivileged:alpine
COPY --from=builder --chown=nginx:nginx /build/dist /usr/share/nginx/html
EXPOSE 8080