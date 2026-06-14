FROM hugomods/hugo:0.157.0 AS builder

WORKDIR /site
COPY go.mod go.sum ./
RUN hugo mod get

COPY . .
RUN hugo

FROM nginx:alpine
COPY --from=builder /site/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
