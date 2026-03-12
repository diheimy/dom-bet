#!/bin/bash

# Deploy script for Dom Bet project
set -e

echo "🚀 Deploying Dom Bet to Vercel..."

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI is required. Run: npm install -g vercel"
    exit 1
fi

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ .env not found. Run: cp .env.example .env"
    exit 1
fi

# Build frontend
echo "📦 Building frontend..."
cd frontend
npm run build
cd ..

# Deploy to Vercel
echo "🌍 Deploying to Vercel..."
cd frontend
vercel --prod

echo "✅ Deploy complete!"
