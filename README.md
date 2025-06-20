# 🛡️ Gitleaks Git Pre-Commit Hook

This repository demonstrates how to use [Gitleaks](https://github.com/gitleaks/gitleaks) to
detect secrets in your code before committing it to Git.
Integration is done via a Git `pre-commit` hook.

---

## 📦 Installation

### 🔧 1. Install Gitleaks and Set Up Pre-Commit Hook

To automatically install Gitleaks and configure the Git pre-commit hook, simply run the setup script:
```bash
./install-gitleaks-hook.sh
```
This script will:

✅ Download and install the latest compatible version of Gitleaks

✅ Copy the pre-commit hook to .git/hooks/pre-commit

✅ Enable the hook using git config gitleaks.enable true

✅ Make the hook executable

💡 Make sure to run this command from the root of your Git repository.

If you see a permissions error, you might need to run:
```bash
chmod +x install-gitleaks-hook.s
```


## ⚙️ 3. Enable or Disable the Hook via Git Config

To enable:
```bash
git config gitleaks.enable true
```

To disable:
```bash
git config gitleaks.enable false
```

## ✅ 4. Usage

Stage your changes:
```bash
git add .
```

Commit:
```bash
git commit -m "your message"
```
If secrets are found, the commit will be blocked with an error message.

## 5. Test Example

Paste this into any file (example secret.env):
```bash
AWS_SECRET_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
GITHUB_TOKEN=ghp_1234567890abcdefghijklmnopqrstuvwxyzABCD
```
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
```

##  7. Ignoring Files or Paths
To ignore files or directories during scans:
Create a .gitleaksignore file in the root.
Add paths or patterns to skip, e.g.:

```bash
.env
*.test.js
vendor/
```