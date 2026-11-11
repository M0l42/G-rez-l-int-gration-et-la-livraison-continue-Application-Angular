# ---- Build stage: compile the Angular app ----
FROM node:20-alpine AS build
WORKDIR /src
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---- Runtime stage: serve the compiled files with nginx ----
FROM nginx:1.27-alpine
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /src/dist/olympic-games-starter/browser /app
EXPOSE 80
