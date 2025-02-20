# Stage 1: Builder Stage
FROM node:21 AS builder

# Set the working directory
WORKDIR /app

# Copy only package.json and package-lock.json for caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Stage 2
FROM node:21-slim

# Set the working directory
WORKDIR /app

# Copy the above stage as compressed
COPY --from=builder /app .

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 3000

# Start the application, ensuring it binds to all network interfaces
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
