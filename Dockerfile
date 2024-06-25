# Base image
FROM node:14-alpine as node

# Set working directory
WORKDIR /app

# Copy package.json
COPY package.json ./

# Install dependencies
RUN npm install --only=production
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]

# Stage 2
FROM nginx:stable-alpine
WORKDIR usr/share/nginx/html
RUN rm -rf ./*
COPY --from=node /app/build .
#EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
#ENTRYPOINT ["nginx", "-g", "daemon off;"]