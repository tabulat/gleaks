#!/bin/bash
set -e

echo "🔧 Installing Gitleaks pre-commit hook..."

# 1. Ensure we're inside a Git repository
if [ ! -d ".git" ]; then
  echo "❌ Error: This is not a Git repository. Run this script from the root of your project."
  exit 1
fi

# 2. Copy pre-commit hook
HOOK_SOURCE="scripts/pre-commit"
HOOK_TARGET=".git/hooks/pre-commit"

if [ ! -f "$HOOK_SOURCE" ]; then
  echo "❌ Error: Cannot find $HOOK_SOURCE"
  exit 1
fi

cp "$HOOK_SOURCE" "$HOOK_TARGET"
chmod +x "$HOOK_TARGET"
echo "✅ Hook installed to $HOOK_TARGET"

# 3. Enable the hook via git config
git config gitleaks.enable true
echo "✅ Hook enabled via git config"

# 4. Install Gitleaks if missing
if ! command -v gitleaks &>/dev/null; then
  echo "📦 Gitleaks not found. Installing..."

  OS=$(uname -s)
  case "$OS" in
    Linux)
      curl -sSL https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks-linux-amd64 -o gitleaks
      chmod +x gitleaks
      sudo mv gitleaks /usr/local/bin/
      ;;
    Darwin)
      curl -sSL https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks-darwin-arm64 -o gitleaks
      chmod +x gitleaks
      sudo mv gitleaks /usr/local/bin/
      ;;
    *)
      echo "❌ Unsupported OS: $OS — please install Gitleaks manually."
      exit 1
      ;;
  esac
  echo "✅ Gitleaks installed"
else
  echo "✅ Gitleaks is already installed: $(gitleaks version)"
fi

echo "🎉 Installation complete. Try committing to see the hook in action!"
