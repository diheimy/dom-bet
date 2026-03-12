#!/bin/bash

# Setup script for Dom Bet project
set -e

echo "🚀 Setting up Dom Bet project..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required. Please install from nodejs.org"
    exit 1
fi

# Check Python
if ! command -v python &> /dev/null && ! command -v python3 &> /dev/null; then
    echo "❌ Python is required. Please install from python.org"
    exit 1
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "⚠️  Docker is recommended for running the project"
fi

# Setup environment
if [ ! -f .env ]; then
    echo "📋 Creating .env from .env.example..."
    cp .env.example .env
    echo "✅ .env created. Please fill in your credentials."
fi

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd frontend
npm install
cd ..

# Install backend dependencies
echo "📦 Installing backend dependencies..."
cd backend
pip install -r requirements.txt
cd ..

# Create necessary directories
echo "📁 Creating project directories..."
mkdir -p src/core src/services src/lib src/utils src/types
mkdir -p tests/unit tests/integration

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Fill in .env with your credentials"
echo "2. Run: docker-compose up -d"
echo "3. Or run: npm run dev (frontend) / pytest (backend)"
