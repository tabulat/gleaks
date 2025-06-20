#!/bin/bash
set -e

echo "🔧 Installing Gitleaks pre-commit hook..."

# 1. Check if we're inside a git repo
if [ ! -d ".git" ]; then
  echo "❌ This is not a Git repository. Please run from the root of a repo."
  exit 1
fi

# 2. Copy the pre-commit hook
HOOK_SOURCE="scripts/pre-commit"
HOOK_TARGET=".git/hooks/pre-commit"

if [ ! -f "$HOOK_SOURCE" ]; then
  echo "❌ Cannot find $HOOK_SOURCE. Make sure the script is located in scripts/pre-commit"
  exit 1
fi

cp "$HOOK_SOURCE" "$HOOK_TARGET"
chmod +x "$HOOK_TARGET"
echo "✅ Hook installed to $HOOK_TARGET"

# 3. Enable gitleaks via Git config
git config gitleaks.enable true
echo "✅ Enabled gitleaks in Git config"

# 4. Check if gitleaks is installed
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
      echo "❌ Unsupported OS: $OS. Please install Gitleaks manually."
      exit 1
      ;;
  esac
else
  echo "✅ Gitleaks already installed: $(gitleaks version)"
fi

echo "🎉 Setup complete. Try committing to see the hook in action!"
