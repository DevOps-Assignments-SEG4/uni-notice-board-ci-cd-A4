
FROM node:alpine AS app-build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npx htmlhint "src/**/*.html"
RUN npx stylelint "styles/**/*.css"
RUN npx parcel build src/index.html  --dist-dir dist --public-url ./ --no-cache

FROM nginx:alpine 
RUN rm -rf /usr/share/nginx/html/*
COPY --from=app-build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]