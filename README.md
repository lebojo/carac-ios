# Carac
C'est une app de suivi de sport

<img src="https://github.com/user-attachments/assets/a6835cb1-0f24-4093-a30d-043f462da4ed" width="128">

You can test it here: [TestFlight](https://testflight.apple.com/join/cnudJaMH)

# Utilisation pour les développeurs

## Prérequis
- macOS avec Xcode installé
- Git

## Cloner le dépôt
```bash
git clone https://github.com/lebojo/carac-ios.git
cd carac-ios
```

## Ouvrir le projet avec Xcode
```bash
open carac/carac.xcodeproj
```
Ou bien, vous pouvez ouvrir Xcode et sélectionner "File > Open", puis naviguer vers le fichier `carac/carac.xcodeproj`.

## Créer une branche pour vos modifications
Avant de commencer à travailler sur une nouvelle fonctionnalité ou correction :
```bash
git checkout -b ma-nouvelle-fonctionnalite
```

## Tester vos modifications
1. Sélectionnez un simulateur ou un appareil cible dans Xcode
2. Appuyez sur `Cmd + R` pour compiler et exécuter l'application
3. Testez vos modifications de manière approfondie

## Faire une Pull Request
Une fois vos modifications testées et prêtes :
1. Committez vos changements :
   ```bash
   git add .
   git commit -m "Description de vos modifications"
   ```
2. Poussez votre branche vers GitHub :
   ```bash
   git push origin ma-nouvelle-fonctionnalite
   ```
3. Allez sur [GitHub](https://github.com/lebojo/carac-ios) et créez une Pull Request depuis votre branche
4. Décrivez vos modifications dans la Pull Request et attendez la revue

# Made with love
Made with ❤️ by Jordan Chap
