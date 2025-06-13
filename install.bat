@echo off
echo 🚀 Initialisation du projet Bedrock

if not exist ".env" (
  echo 📄 Copie de .env.example vers .env
  copy .env.example .env >nul
) else (
  echo ✅ .env déjà présent
)

echo 🔐 Génération des SALTS WordPress...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "(Invoke-WebRequest -Uri 'https://api.wordpress.org/secret-key/1.1/salt/').Content | ^
     ForEach-Object { $_ -replace \"define\\('([A-Z_]+)',\\s*'(.*)'\\);\", '`$1=''`$2''' } | ^
     Out-File -Append -Encoding utf8 .env"

where composer >nul 2>nul
if %errorlevel% equ 0 (
  echo 📦 Installation des dépendances Composer
  composer install
) else (
  echo ❌ Composer non trouvé. Installez Composer pour continuer.
  exit /b 1
)

echo ✅ Projet initialisé avec succès.
