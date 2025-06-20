# 🛡️ Gitleaks Git Pre-Commit Hook

This repository demonstrates how to use [Gitleaks](https://github.com/gitleaks/gitleaks) to
detect secrets in your code before committing it to Git.
Integration is done via a Git `pre-commit` hook.

---

## 📦 Installation

### 🔧 1. Install Gitleaks

> Recommended version: **8.17.0 or higher** (supports `--staged` flag)

#### On Linux:

```bash
curl -sSL https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks-linux-amd64 -o gitleaks
chmod +x gitleaks
sudo mv gitleaks /usr/local/bin/
```bash

#### On macOS:

brew install gitleaks

manually
```bash
curl -sSL https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks-darwin-arm64 -o gitleaks
chmod +x gitleaks
sudo mv gitleaks /usr/local/bin/
```bash

## 2. Set Up the Pre-Commit Hook

Copy the hook script into your Git hooks directory:
```bash
cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```bash
This enables automatic secret scanning before each commit.

## ⚙️ 3. Enable or Disable the Hook via Git Config

To enable:
```bash
git config gitleaks.enable true
```bash

To disable:
```bash
git config gitleaks.enable false
```bash

## ✅ 4. Usage

Stage your changes:
```bash
git add .
```bash

Commit:
```bash
git commit -m "your message"
```bash
If secrets are found, the commit will be blocked with an error message.

## 5. Test Example

Paste this into any file (example secret.env):
```bash
AWS_SECRET_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
GITHUB_TOKEN=ghp_1234567890abcdefghijklmnopqrstuvwxyzABCD
```bash
Then try to commit — Gitleaks should detect it and block the commit.

## 6. Custom Configuration
You can customize detection rules with a .gitleaks.toml file in your project root.

Example Rule:
```bash
[[rules]]
  id = "generic-api-key"
  description = "Generic API Key"
  regex = '''(?i)(apikey|token|secret|key)[\s:=]+['"]?[a-z0-9]{16,45}['"]?'''
  tags = ["key", "custom"]
```bash

##  7. Ignoring Files or Paths
To ignore files or directories during scans:
Create a .gitleaksignore file in the root.
Add paths or patterns to skip, e.g.:

```bash
.env
*.test.js
vendor/
```bash