#---------------------------Stage 1: Builder------------------------------
FROM node:23-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package files separately for caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

#---------------------------Stage 2: Final Image----------------------------
FROM node:23-alpine

# Set the working directory
WORKDIR /app 

# Create a non-root user with home directory for better security
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Copy the built application from the builder stage with correct ownership
COPY --from=builder /app . 

# Ensure the non-root user has correct ownership of the files
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose the application port
EXPOSE 3000

# Set ENTRYPOINT and CMD for flexibility
ENTRYPOINT ["npm", "run"]
CMD ["dev", "--", "--host", "0.0.0.0"]
