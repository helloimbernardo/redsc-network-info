FROM node:22-alpine AS builder

LABEL authors="helloimbernardo"
LABEL org.opencontainers.image.source=https://github.com/helloimbernardo/redsc-network-info
LABEL org.opencontainers.image.title="REDSC Network Info"
LABEL org.opencontainers.image.description="small website for a networking class experiment"

WORKDIR /app
COPY . .

RUN corepack enable pnpm
RUN pnpm install
RUN pnpx @tailwindcss/cli -i ./src/style.css -o ./dist/assets/style.css --minify


FROM nginx:stable-alpine AS runner

COPY --from=builder /app/dist /usr/share/nginx/html
COPY ./src/index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]