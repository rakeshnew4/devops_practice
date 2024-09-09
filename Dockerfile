FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install -g @angular/cli
COPY . .
RUN npm install --configuration=production-en
RUN ng build 

# Stage 2: Serve the Angular app with Nginx
FROM nginx:alpine
COPY --from=build /app/dist/en /usr/share/nginx/html
EXPOSE 80 8000
CMD ["nginx", "-g", "daemon off;"]
