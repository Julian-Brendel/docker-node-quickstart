FROM node:14

# Add package-lock and dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Add source files
COPY ./ ./

# Run entrypoint
CMD ["npm", "start"]