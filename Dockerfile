# Stage 1: Build the React application using Node.js 20.14.0
FROM node:20.14.0-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the React application for production
RUN npm run build

# Debugging: List contents of the /app/dist directory to ensure it exists
RUN ls -la /app/dist

# Stage 2: Serve the React build with Nginx
FROM nginx:alpine

# Copy the built React app from the builder stage (change 'build' to 'dist')
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 for serving the application
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
