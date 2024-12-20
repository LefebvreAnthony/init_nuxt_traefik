#!/bin/bash

# Définition des variables
CERT_DIR="./certs"
SUBDOMAINS=("localhost" "127.0.0.1" "::1" "web.localhost" "traefik.localhost")

# Vérifie si mkcert est installé
if ! command -v mkcert >/dev/null 2>&1; then
    echo "🔍 mkcert n'est pas installé. Installation en cours..."

    # Installation de mkcert avec Chocolatey si sous Windows
    if [[ "$OS" == "Windows_NT" ]]; then
        echo "⚠️ Ce script nécessite des privilèges administratifs."
        echo "🔧 Demande d'exécution en mode administrateur via PowerShell..."
        # Relancer le script en mode administrateur
        powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -NoExit -File $0' -Verb RunAs"
        exit 0
        echo "🟦 Système détecté : Windows. Installation de mkcert avec Chocolatey..."
        if ! command -v choco >/dev/null 2>&1; then
            echo "⚠️ Chocolatey n'est pas installé. Installation de Chocolatey..."
            powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = 'Tls12'; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
        fi
        choco install mkcert -y
    else
        # Pour Linux/MacOS : installation via Homebrew
        echo "🟩 Système détecté : Linux/MacOS. Installation avec Homebrew..."
        if ! command -v brew >/dev/null 2>&1; then
            echo "⚠️ Homebrew n'est pas installé. Installez Homebrew pour continuer."
            exit 1
        fi
        brew install mkcert
    fi
else
    echo "✅ mkcert est déjà installé."
fi

# Installation de l'autorité de certification locale
echo "🔧 Installation de l'autorité de certification locale..."
mkcert -install

# Création du dossier pour les certificats
echo "📁 Création du dossier des certificats : $CERT_DIR"
mkdir -p "$CERT_DIR"

# Génération des certificats pour les sous-domaines
echo "🔑 Génération des certificats pour : ${SUBDOMAINS[*]}"
mkcert -cert-file "$CERT_DIR/localhost.crt" \
    -key-file "$CERT_DIR/localhost.key" \
    "${SUBDOMAINS[@]}"

echo "✅ Certificats générés avec succès dans : $CERT_DIR"
