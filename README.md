# 🎯 Déploiement WordPress avec Bedrock + GitHub Actions

Ce projet propose une base moderne pour WordPress avec [Bedrock](https://roots.io/bedrock/), optimisée pour les performances, la sécurité, et le déploiement continu via GitHub Actions et `rsync`.


## 🧩 Stack WordPress

### 🎨 Thème
- [Neve](https://themeisle.com/themes/neve/) + Neve Child Theme

### 🔌 Plugins installés via Composer
- [LiteSpeed Cache](https://www.litespeedtech.com/products/cache-plugins/wordpress-acceleration)
- [Blackhole for Bad Bots](https://wordpress.org/plugins/blackhole-bad-bots/)
- [WPS Hide Login](https://wordpress.org/plugins/wps-hide-login/)
- [Solid Security (anciennement iThemes Security)](https://wordpress.org/plugins/better-wp-security/)
- [Rank Math SEO](https://rankmath.com/)

Tu peux les modifier dans le `composer.json`.

---

## 🧱 Structure

```
├── web/          # Dossier public (index.php, wp/, app/)
│ └── wp/         # Core WordPress (géré par Composer)
│ └── app/        # Thèmes et plugins
├── config/       # Config WordPress par environnement
├── .env          # Variables d'environnement (non versionné)
├── .env.example  # Exemple de fichier .env
├── composer.json # Dépendances PHP
├── .rsyncignore  # Fichiers exclus du déploiement
```

---

## ⚙️ Installation locale

### ✅ Option 1 : Démarrer un nouveau projet avec l'installeur

```bash
git clone https://github.com/objectifseo/bedrock-wordpress-starter.git monsite
cd monsite
./install.sh      # ou install.bat sur Windows
```

Ce script :

Copie .env.example → .env si absent

Génère automatiquement les SALTS WordPress

Installe les dépendances via Composer

🔐 N'oublie pas de modifier les variables dans .env (base de données, URLs…)

---

### ⌨️ Option 2 : Installation manuelle avancée

1. Créer le projet :
   ```bash
   composer create-project objectifseo/bedrock-wordpress-starter monsite
   cd monsite
   ```

2. Copier le `.env.example` :
   ```bash
   cp .env.example .env
   ```

3. Installer les dépendances :
   ```bash
   composer install
   ```

4. Récupérer des SALTS WordPress sur https://roots.io/salts.html et les ajouter dans le `.env`
---

# 🚀 Déploiement

## 🧪 Déploiement manuel (dev)

1. Modifier les valeurs des variables ( REMOTE_USER, REMOTE_HOST, REMOTE_PATH, etc.) dans `deploy.sh` (ou deploy.bat sur Windows)

2. Exécuter le script :

```bash
./deploy.sh  # deploy.bat sur windows
```
Ce script :

Installe les dépendances (mode production)

Vérifie la connexion SSH

Envoie les fichiers via rsync, en suivant .rsyncignore

---

## 🤖 Déploiement automatique avec GitHub Actions

Un workflow est déjà configuré dans .github/workflows/deploy.yml.

À chaque push sur main, il :

1. Clône le dépôt

2. Installe les dépendances Composer

3. Déploie le projet sur ton serveur via rsync

### 🔐 Prérequis : Secrets et variables GitHub

Ajoute les secrets et variables suivants dans ton dépôt GitHub (Settings > Secrets and variables > Actions) :

| Nom | Description |
|---------------|-------------|
| `SSH_HOST`    | Domaine ou IP de ton serveur |
| `SSH_USER`    | Nom d'utilisateur SSH |
| `SSH_KEY`     | Clé privée SSH (ajoute sa publique dans `~/.ssh/authorized_keys` du serveur – ⚠️ **ne jamais exposer cette clé** !) |
| `WP_FOLDER`    | Dossier d'installation de WordPress (ex: `public_html`) |

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

---

# 💡 Astuces
- Tu peux personnaliser le thème enfant neve-child dans web/app/themes/

- Si tu ajoutes d'autres plugins ou thèmes, utilise composer require wpackagist-plugin/nom ou wpackagist-theme/nom

- Pour mettre à jour Bedrock, WordPress ou les plugins :

```bash
composer update
```
⚠️ Pense à tester ton site localement après chaque mise à jour.