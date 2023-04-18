FROM node:18-alpine3.16 AS base
WORKDIR /app
COPY ./my-app-src .
RUN npm install
COPY . .

RUN npm run build

FROM nginx:1.23.4-alpine
COPY --from=base /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
