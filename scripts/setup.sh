#!/bin/bash

##
# @title PrivacyPharma Project Setup Script
# @notice Automated setup for development environment
# @dev Sets up all dependencies and configuration
#
# @usage
# bash scripts/setup.sh
#
# @chapter automation

echo "=================================================="
echo "PrivacyPharma Setup Script"
echo "=================================================="

# Check Node.js
echo ""
echo "Checking Node.js installation..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed"
    echo "Please install Node.js v16 or higher from https://nodejs.org"
    exit 1
fi

echo "✅ Node.js $(node --version)"
echo "✅ npm $(npm --version)"

# Install dependencies
echo ""
echo "=================================================="
echo "Installing dependencies..."
echo "=================================================="

if [ -f "package.json" ]; then
    echo "Installing npm packages..."
    npm install

    if [ $? -eq 0 ]; then
        echo "✅ Dependencies installed successfully"
    else
        echo "❌ Failed to install dependencies"
        exit 1
    fi
else
    echo "❌ package.json not found"
    exit 1
fi

# Create necessary directories
echo ""
echo "=================================================="
echo "Creating project directories..."
echo "=================================================="

mkdir -p contracts
mkdir -p test
mkdir -p scripts
mkdir -p public
mkdir -p docs
mkdir -p deployments
mkdir -p artifacts
mkdir -p cache

echo "✅ Directories created"

# Create .env.example if it doesn't exist
echo ""
echo "=================================================="
echo "Configuring environment..."
echo "=================================================="

if [ ! -f ".env.example" ]; then
    cat > .env.example << 'EOF'
# Sepolia RPC Endpoint
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY

# Private key for deployment (remove 0x prefix if present)
PRIVATE_KEY=YOUR_PRIVATE_KEY_HERE

# Contract configuration
CONTRACT_ADDRESS=YOUR_DEPLOYED_CONTRACT_ADDRESS
EOF
    echo "✅ Created .env.example"
fi

if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found"
    echo "Please copy .env.example to .env and fill in your values:"
    echo "  cp .env.example .env"
fi

# Compile contract
echo ""
echo "=================================================="
echo "Compiling smart contract..."
echo "=================================================="

npm run compile

if [ $? -eq 0 ]; then
    echo "✅ Contract compiled successfully"
else
    echo "❌ Contract compilation failed"
    exit 1
fi

# Run tests
echo ""
echo "=================================================="
echo "Running tests..."
echo "=================================================="

npm test

if [ $? -eq 0 ]; then
    echo "✅ All tests passed"
else
    echo "⚠️  Some tests failed - check output above"
fi

# Generate documentation
echo ""
echo "=================================================="
echo "Generating documentation..."
echo "=================================================="

node scripts/generate-docs.js

if [ $? -eq 0 ]; then
    echo "✅ Documentation generated"
fi

# Summary
echo ""
echo "=================================================="
echo "Setup Complete!"
echo "=================================================="
echo ""
echo "Next steps:"
echo "1. Review the .env file and configure your settings:"
echo "   - Add SEPOLIA_RPC_URL (get from Infura or Alchemy)"
echo "   - Add PRIVATE_KEY for your deployment wallet"
echo ""
echo "2. Deploy to Sepolia:"
echo "   npm run deploy"
echo ""
echo "3. Update frontend configuration:"
echo "   - Edit public/index.html"
echo "   - Set CONTRACT_ADDRESS to your deployed address"
echo ""
echo "4. Run locally:"
echo "   npm start"
echo ""
echo "5. View documentation:"
echo "   - README.md - Overview and usage"
echo "   - FHEVM_CONCEPTS.md - FHEVM concepts explained"
echo "   - docs/TEST_DOCUMENTATION.md - Test documentation"
echo ""
echo "Useful commands:"
echo "  npm run compile   - Compile contract"
echo "  npm test          - Run test suite"
echo "  npm run deploy    - Deploy to Sepolia"
echo "  npm start         - Start local development server"
echo ""
echo "=================================================="
