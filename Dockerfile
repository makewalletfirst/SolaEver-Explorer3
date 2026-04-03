# 1. Base image
FROM node:18-alpine AS base

# pnpm 설치 및 환경 설정
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

# 2. Dependencies stage (의존성 설치)
FROM base AS deps
WORKDIR /app

# package.json, lock 파일 및 패치 파일 복사
COPY package.json pnpm-lock.yaml ./
COPY patches ./patches

# 캐시를 사용하여 pnpm 의존성 설치
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

# 3. Builder stage (프로젝트 빌드)
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Next.js 빌드 실행
RUN pnpm run build

# 4. Runner stage (실행 환경)
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# 빌드된 결과물과 실행에 필요한 파일만 복사
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

# Next.js 서버 실행
CMD ["pnpm", "start"]
