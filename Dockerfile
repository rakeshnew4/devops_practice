# Stage 1: Build the application
FROM node:20-alpine AS build

# Set the working directory
WORKDIR /app

# Copy only package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies with production flag to avoid devDependencies
RUN npm install --only=production

# Copy the rest of the application source code
COPY . .

# Stage 2: Create the minimal runtime image using Alpine
FROM alpine:latest

# Install minimal dependencies for Node.js
RUN apk add --no-cache nodejs

# Set the working directory in the final image
WORKDIR /app

# Copy application code from the build stage
COPY --from=build /app /app

# Use a non-root user for better security (creating a node user manually)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose the necessary port (optional)
EXPOSE 3000

# Command to run the application
CMD ["node", "app.js"]
