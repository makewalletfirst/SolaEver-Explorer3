# ---- Base ----
FROM node:20-alpine AS base
RUN npm install -g pnpm@10.17.1

# ---- Builder ----
FROM base AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml .pnpmfile.cjs ./
COPY patches/ ./patches/
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

# ---- Runner ----
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3001
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
USER appuser
EXPOSE 3001
CMD ["node", "server.js"]
