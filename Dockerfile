## BUILD STAGE

# Use the official Node.js image as base
FROM node:alpine as build

# Set the working directory inside the container
WORKDIR /app

# Copy the public and src directories, package.json, and tsconfig.json into the container
COPY public/ ./public
COPY src/ ./src
COPY package.json ./
COPY tsconfig.json ./

# Install dependencies and build the project
RUN npm install
RUN npm run build

# Remove unnecessary directories after building
RUN rm -rf public src

### UP NGINX STAGE

# Use the official Nginx image as base
FROM nginx:alpine

# Copy the built files from the previous stage into the Nginx HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to allow external access
EXPOSE 80

# Start Nginx in the foreground when the container starts
CMD ["nginx", "-g", "daemon off;"]
