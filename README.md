# 🎯 Déploiement WordPress avec Bedrock + GitHub Actions

Ce projet utilise [Bedrock](https://roots.io/bedrock/) pour une structure WordPress moderne et GitHub Actions pour un déploiement automatique via `rsync`.

## 📦 Dépendances WordPress

### Thème

Le thème installé est Neve avec son thème enfant.
---

### Extensions

Les plugins installés sont :
- Litespeed cache
- Blackhole for bad bots
- WPS Hide Login
- Solide Security
- Rank Math

Tu peux les modifier dans le `composer.json`.

---

## 🧱 Structure Bedrock

```
├── web/           # Dossier public (index.php, wp/, app/)
├── config/        # Config WordPress (environnement, bases, etc.)
├── .env           # Non versionné (utiliser .env.example)
├── composer.json  # Dépendances PHP
```

---

## ⚙️ Installation locale

1. Copier le repo sur Github (Fork)

2. Cloner le repo :
   ```bash
   git clone git@github.com:tonutilisateur/tonrepo.git
   ```

3. Utiliser un des scripts d'installation ou continuer manuellement

4. Modifier les valeurs des variables dans le `.env`
---

### ⌨️ Installation manuelle (Linux / macOS)

1. Copier le `.env.example` :
   ```bash
   cp .env.example .env
   ```

2. Installer les dépendances :
   ```bash
   composer install
   ```

3. Récupérer des SALTS WordPress sur https://roots.io/salts.html et les ajouter dans le `.env`
---

### 🧰 Scripts d'installation

#### Pour Linux / macOS

```bash
chmod +x install.sh
./install.sh
```

#### Pour Windows

Double-clique sur `install.bat` ou exécute-le dans une invite de commande :

```cmd
install.bat
```

Ces scripts :
- Copient `.env.example` vers `.env` si besoin
- Génèrent automatiquement les SALTS WordPress
- Installent les dépendances via `composer install`

---

## 🧪 Déploiement manuel (dev)

1. Modifier les valeurs des variables dans `deploy.sh`

2. Exécuter le script :

```bash
./deploy.sh
```

---

## 🤖 Déploiement automatique avec GitHub Actions

Ce dépôt inclut un workflow GitHub Actions (`.github/workflows/deploy.yml`) qui déclenche un déploiement automatique avec `rsync` à chaque `push` sur la branche `main`.

### 🔐 Prérequis : Secrets et variables GitHub

Ajoute les secrets et variables suivants dans ton dépôt GitHub (Settings > Secrets and variables > Actions) :

| Nom | Description |
|---------------|-------------|
| `SSH_HOST`    | Domaine ou IP de ton serveur |
| `SSH_USER`    | Nom d'utilisateur SSH |
| `SSH_KEY`     | Clé privée SSH (ajoute sa publique dans `~/.ssh/authorized_keys` du serveur – ⚠️ **ne jamais exposer cette clé** !) |
| `WP_FOLDER`    | Dossier d'installation de WordPress (ex: `public_html`) |

---

### 🚀 Fonctionnement

Le workflow :

1. Clone le dépôt
2. Installe les dépendances Composer (production)
3. Synchronise les fichiers vers le dossier d'installation spécifié via `rsync` (hors `.env`, `.git`, etc.)

Tu peux le modifier à ta guise dans `.github/workflows/deploy.yml`.

---

## ‼️ Attention

- **Ne pas modifier `web/wp`** : ce dossier est géré par Composer.
- **Ne jamais versionner `.env` ou `vendor/`**

---

## 🧪 Tester la connexion SSH avant déploiement

Avant d'utiliser le script `deploy.sh` ou GitHub Actions, tu peux tester ta connexion SSH avec la commande suivante :

```bash
ssh -p 22 ton_user@ton_serveur
```

Tu devrais voir un terminal distant s'ouvrir. Si ce n'est pas le cas :

- Vérifie que ta **clé publique est bien dans `~/.ssh/authorized_keys`** du serveur
- Vérifie que tu **as bien modifié le port** si ce n’est pas le `22` par défaut
- Active le mode verbose pour diagnostiquer :  
  ```bash
  ssh -v -p 22 ton_user@ton_serveur
  ```

---

## 📡 Tester rsync

Tu peux également tester le transfert de fichiers avec `rsync` :

```bash
rsync -avz -e "ssh -p 22" test.txt ton_user@ton_serveur:/home/ton_user/test/
```

Assure-toi que :
- `rsync` est installé localement
- Tu as les droits d'écriture sur le dossier distant
