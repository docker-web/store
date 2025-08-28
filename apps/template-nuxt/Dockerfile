# Stage de build
FROM node:20-alpine AS build

WORKDIR /app

# Installer pnpm
RUN npm install -g pnpm

# Copier package.json et lockfile pour cache pnpm
COPY package.json pnpm-lock.yaml* ./

RUN pnpm install --frozen-lockfile

# Copier tout le projet
COPY . .

# Build Nuxt
RUN pnpm build

# Stage production
FROM node:20-alpine

WORKDIR /app

COPY --from=build /app/.output .output
COPY --from=build /app/package.json ./
COPY --from=build /app/node_modules ./node_modules

EXPOSE 3000
CMD ["node", ".output/server/index.mjs"]
