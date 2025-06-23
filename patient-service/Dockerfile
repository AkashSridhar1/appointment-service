# Use official Node.js image
FROM node:20-alpine

# Create app directory
WORKDIR /app

# Copy package.json files
COPY package*.json ./

# Install only production dependencies
RUN npm install --omit=dev

# Copy the rest of your application
COPY . .

# Expose port (adjust if needed)
EXPOSE 3000

# Command to run the app
CMD ["node", "index.js"]
