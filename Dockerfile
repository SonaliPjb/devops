# Stage 1: Build the Node.js application
FROM node:18 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Vite application
RUN npm run build

# Stage 2: Create a lightweight Jenkins image with Docker
FROM jenkins/jenkins:lts

USER root

# Install Docker
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean

USER jenkins

# Set the working directory for your application
WORKDIR /app

# Copy the build output from the previous stage
COPY --from=build /app/dist /app

# Install a simple static file server
RUN npm install -g serve

# Expose port 80
EXPOSE 80

# Start the static file server
CMD ["serve", "-s", ".", "-l", "80"]
