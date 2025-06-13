
# 🎯 WordPress Deployment with Bedrock + GitHub Actions

This project uses [Bedrock](https://roots.io/bedrock/) for a modern WordPress structure and GitHub Actions for automatic deployment via `rsync`.

## 📦 WordPress Dependencies

### Theme

The installed theme is Neve with its child theme.

---

### Plugins

Installed plugins include:
- Litespeed Cache
- Blackhole for Bad Bots
- WPS Hide Login
- Solid Security
- Rank Math

You can modify them in the `composer.json`.

---

## 🧱 Bedrock Structure

```
├── web/           # Public folder (index.php, wp/, app/)
├── config/        # WordPress configuration (environment, database, etc.)
├── .env           # Not versioned (use .env.example)
├── composer.json  # PHP dependencies
```

---

## ⚙️ Local Installation

1. Fork the repo on GitHub.

2. Clone the repository:
   ```bash
   git clone git@github.com:yourusername/yourrepo.git
   ```

3. Use the install scripts or proceed manually.

4. Edit the `.env` values.

---

### ⌨️ Manual Installation (Linux / macOS)

1. Copy `.env.example`:
   ```bash
   cp .env.example .env
   ```

2. Install dependencies:
   ```bash
   composer install
   ```

3. Generate WordPress SALTS from https://roots.io/salts.html and add them to `.env`.

---

### 🧰 Installation Scripts

#### For Linux / macOS

```bash
chmod +x install.sh
./install.sh
```

#### For Windows

Double-click `install.bat` or run it from Command Prompt:

```cmd
install.bat
```

These scripts:
- Copy `.env.example` to `.env` if not present
- Automatically generate WordPress SALTS
- Install Composer dependencies

---

## 🧪 Manual Deployment (dev)

1. Edit the variables in `deploy.sh`.

2. Run the script:

```bash
./deploy.sh
```

---

## 🤖 Automatic Deployment with GitHub Actions

This repo includes a GitHub Actions workflow (`.github/workflows/deploy.yml`) that triggers deployment via `rsync` on every `push` to the `main` branch.

### 🔐 GitHub Secrets and Variables

Add the following secrets in your GitHub repo (Settings > Secrets and variables > Actions):

| Name         | Description |
|--------------|-------------|
| `SSH_HOST`   | Your server's domain or IP |
| `SSH_USER`   | Your SSH username |
| `SSH_KEY`    | Your private SSH key (**never expose this key!**) |
| `WP_FOLDER`  | WordPress install directory (e.g., public_html) |

---

### 🚀 How it works

The workflow:
1. Clones the repo
2. Installs Composer dependencies (production mode)
3. Syncs files using `rsync` (excluding `.env`, `.git`, etc.)

Customize it in `.github/workflows/deploy.yml`.

---

## ‼️ Warnings

- **Do not edit `web/wp`**: this folder is managed by Composer.
- **Never version `.env` or `vendor/`**

---

## 🧪 Test SSH Connection

Before using `deploy.sh` or GitHub Actions:

```bash
ssh -p 22 your_user@your_server
```

If it fails:
- Make sure your **public key is in `~/.ssh/authorized_keys`** on the server
- Check that the **SSH port is correct**
- Use verbose mode for debug:
  ```bash
  ssh -v -p 22 your_user@your_server
  ```

---

## 📡 Test rsync

```bash
rsync -avz -e "ssh -p 22" test.txt your_user@your_server:/home/your_user/test/
```

Ensure:
- `rsync` is installed locally
- You have write permissions to the remote folder
