#!/bin/bash
echo "🚀 Initialisation du projet Bedrock"

if [ ! -f .env ]; then
  echo "📄 Copie de .env.example vers .env"
  cp .env.example .env
else
  echo "✅ .env déjà présent"
fi

echo "🔐 Génération des SALTS WordPress..."
SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
SALTS_ENV=$(echo "$SALTS" | sed -E "s/define\('([A-Z_]+)', *'(.*)'\);/\1='\2'/")
echo -e "\n$SALTS_ENV" >> .env

if command -v composer &> /dev/null; then
  echo "📦 Installation des dépendances Composer"
  composer install
else
  echo "❌ Composer non trouvé. Installez Composer pour continuer."
  exit 1
fi

echo "✅ Projet initialisé avec succès."
