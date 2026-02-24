# Stage 1 

FROM node:20-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci


# Stage 2 

FROM base AS test
COPY . .
RUN npm test


# Stage 3 

FROM base AS dev
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]

# Stage 4 

FROM test AS build
RUN npm run build


# Stage 5 

FROM nginx:1.27-alpine AS production
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
