@echo off
setlocal enabledelayedexpansion

REM === CONFIGURATION ===
set "REMOTE_USER=ton_user"
set "REMOTE_HOST=ton_serveur"
set "REMOTE_PATH=/home/%REMOTE_USER%/ton_dossier"
set "SSH_PORT=22"
set "LOCAL_PATH=%cd%"
set "EXCLUDE_FILE=.rsyncignore"

echo 🚀 Déploiement du projet Bedrock via rsync (Windows)
echo 🔒 Connexion SSH : %REMOTE_USER%@%REMOTE_HOST%:%SSH_PORT%
echo 📂 Source locale : %LOCAL_PATH%
echo 📁 Cible distante : %REMOTE_PATH%
echo.

REM === TEST SSH ===
echo 🔌 Test de connexion SSH...
ssh -p %SSH_PORT% -o BatchMode=yes -o ConnectTimeout=5 %REMOTE_USER%@%REMOTE_HOST% "echo Connexion OK" >nul 2>&1
if errorlevel 1 (
    echo ❌ Erreur : Échec de la connexion SSH à %REMOTE_USER%@%REMOTE_HOST% sur le port %SSH_PORT%.
    echo 👉 Vérifie que le serveur est accessible et que ta clé SSH est bien configurée.
    exit /b 1
)

REM === COMPOSER INSTALL (PRODUCTION) ===
where composer >nul 2>&1
if %errorlevel% equ 0 (
    echo 📦 Installation des dépendances Composer (sans les dev)
    composer install --no-dev --optimize-autoloader
) else (
    echo ❌ Composer n'est pas installé. Interruption du déploiement.
    exit /b 1
)

REM === RSYNC ===
echo 🔄 Synchronisation des fichiers vers le serveur...
rsync -avz -e "ssh -p %SSH_PORT%" --exclude-from="%EXCLUDE_FILE%" "%LOCAL_PATH%/" %REMOTE_USER%@%REMOTE_HOST%:%REMOTE_PATH%

if errorlevel 1 (
    echo ❌ Une erreur est survenue pendant la synchronisation.
    exit /b 1
)

echo.
echo ✅ Déploiement terminé avec succès.
