# Use the official Node.js image as the base image
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

# Use a lightweight Node.js image to serve the app
FROM node:18

# Set the working directory
WORKDIR /app

# Copy the build output from the previous stage
COPY --from=build /app/dist /app

# Install a simple static file server
RUN npm install -g serve

# Expose port 80
EXPOSE 80

# Start the static file server
CMD ["serve", "-s", ".", "-l", "80"]
