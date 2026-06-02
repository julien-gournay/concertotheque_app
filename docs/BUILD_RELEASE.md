# Build & Release

Ce document décrit comment compiler Concertothèque, construire l'installeur Windows et publier une nouvelle version.

---

## Prérequis

| Outil | Version | Rôle |
|---|---|---|
| Flutter SDK | ≥ 3.0 | Compilation Dart/Flutter |
| Visual Studio 2022 | workload **Desktop development with C++** | Compilation C++ Windows |
| Inno Setup 6 | ≥ 6.0 | Génération de l'installeur |
| GitHub CLI (`gh`) | ≥ 2.0 | Création de la release GitHub |
| Git | — | Gestion du code source |

Vérifie l'installation Flutter :

```bash
flutter doctor -v
```

---

## 1. Mettre à jour le numéro de version

Dans [pubspec.yaml](../pubspec.yaml), modifie la ligne `version` :

```yaml
version: 1.2.0+1   # format : semver+buildNumber
```

Dans [concertotheque.iss](../concertotheque.iss), modifie `AppVersion` :

```ini
#define AppVersion "1.2.0"
```

---

## 2. Compiler Flutter en mode release

```bash
flutter build windows --release
```

L'exécutable est généré dans :

```
build\windows\x64\runner\Release\concertotheque_app.exe
```

La compilation prend environ 1 à 2 minutes sur la première build (et moins lors des recompilations incrémentales).

---

## 3. Construire l'installeur Inno Setup

```bash
iscc concertotheque.iss
```

> Si `iscc` n'est pas dans le PATH, utilise le chemin complet :
> `"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" concertotheque.iss`

L'installeur est généré dans :

```
installer\ConcertothequeSetup-v1.2.0.exe
```

---

## 4. Créer l'archive portable (Scoop)

```powershell
Compress-Archive -Path "build\windows\x64\runner\Release\*" `
  -DestinationPath "installer\ConcertothequePortable-v1.2.0.zip" -Force
```

Génère le fichier de hash SHA256 (utilisé par Scoop pour l'autoupdate) :

```powershell
(Get-FileHash "installer\ConcertothequePortable-v1.2.0.zip" -Algorithm SHA256).Hash.ToLower() |
  Set-Content "installer\ConcertothequePortable-v1.2.0.zip.sha256" -NoNewline
```

---

## 5. Commit et tag Git

Committe les changements de code (pas les binaires — ils sont dans `.gitignore`) :

```bash
git add .
git commit -m "Release v1.2.0"
git tag -a v1.2.0 -m "Release v1.2.0"
git push origin main --tags
```

---

## 6. Créer la release GitHub

Authentifie `gh` si ce n'est pas déjà fait :

```bash
gh auth login --web --hostname github.com
```

Crée la release avec les trois assets :

```powershell
gh release create v1.2.0 `
  "installer\ConcertothequeSetup-v1.2.0.exe#Installeur Windows" `
  "installer\ConcertothequePortable-v1.2.0.zip#Archive portable Scoop" `
  "installer\ConcertothequePortable-v1.2.0.zip.sha256#SHA256 archive portable" `
  --repo julien-gournay/concertotheque_app `
  --title "Concertothèque v1.2.0" `
  --notes "Description des changements de cette version."
```

---

## 7. Mettre à jour le manifest Scoop

Dans le dépôt [scoop-concertotheque](https://github.com/julien-gournay/scoop-concertotheque), modifie `bucket/concertotheque.json` :

```json
{
  "version": "1.2.0",
  "architecture": {
    "64bit": {
      "url": "https://github.com/julien-gournay/concertotheque_app/releases/download/v1.2.0/ConcertothequePortable-v1.2.0.zip",
      "hash": "sha256:<nouveau_hash>"
    }
  }
}
```

Récupère le hash depuis le fichier `.sha256` généré à l'étape 4, puis commit et push :

```bash
cd ..\scoop-concertotheque
git add .
git commit -m "concertotheque: 1.1.0 -> 1.2.0"
git push
```

Les utilisateurs qui ont installé via Scoop peuvent maintenant mettre à jour :

```powershell
scoop update concertotheque
```

---

## Résumé des fichiers produits

| Fichier | Destination | Usage |
|---|---|---|
| `installer\ConcertothequeSetup-vX.Y.Z.exe` | GitHub Release | Installation traditionnelle |
| `installer\ConcertothequePortable-vX.Y.Z.zip` | GitHub Release | Installation via Scoop |
| `installer\ConcertothequePortable-vX.Y.Z.zip.sha256` | GitHub Release | Vérification d'intégrité Scoop |

> Ces fichiers sont exclus du dépôt Git (`.gitignore`). Ils ne vivent que dans les GitHub Releases.

---

## Notes importantes

- **Le GUID Inno Setup** (`{B3F7E8A2-1D4C-4F9E-8B6A-7C2D5E0F3A91}`) dans `concertotheque.iss` **ne doit jamais changer**. Il est partagé avec le GUID Windows Notifications dans `notification_service.dart`. Le modifier casse les mises à jour en place.
- L'installeur nécessite Windows 10 minimum (64 bits).
- La compilation Flutter nécessite Visual Studio avec le workload C++ Desktop.
