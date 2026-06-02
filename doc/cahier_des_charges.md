#Développer une application de bureau

Il vous est demandé de développer une application de bureau avec le frameowrk de votre choix parmi ceux vus en cours (Electron, Flutter, etc.). L'application sera une app de type CRUD (Create, Read, Update, Delete) cavec les contraintes suivantes :
- Valider le thème du projet avec l'intervenant. Saisie du thème ici
- Authentification (2 pts)
    - Bien implémentée (par exemple RLS conforme avec supabase)
    - Vous pouvez utiliser utiliser la techno que vous souhaitez pour la partie backend.
    - Astuces : utiliser Supabase ou Firebase
- CRUD (persisté sur un serveur distant) (2 pts)
    - Vous pouvez utiliser utiliser la techno que vous souhaitez pour la partie backend
    - ⚠ La BDD des utilisateurs (authentification) n'est pas comptée dans cette partie
    - Astuce: Utiliser Supabase ou Firebase
- Au moins 8 écrans (Accueil, listing, détail, paramètres, ajout, édition, authentification, à propos) (2 pts)
- App élégante et intuitive pour du desktop (2 pt)
Réalisation d'un design / maquette de l'app avec figma ou autre (2 pts) (svp ne faites pas un design pensé pour du mobile)
- Implémentation de 4 fonctionnalités natives à l'OS: (2 pt)
    - Paramètre de démarrage auto
    - Affichage de l'app dans la zone de notification
    - Envoi de notifications
    - Ouverture et sauvegarde des données dans le disque dans un répertoire choisi par l'utilisateur
- Utilisation soit du crash reporter firebase ou des logs de supabase (1 pts) (si backend custom, impélmenter un mécanisme de collecte de crash)
- Création d’un installeur pour votre plateforme de développement (1 pts)
- Publication sur un gestionnaire de paquets (scoop, chocolatey, brew, etc.) (2 pts)
- Réponse aux 2 questions de l'oral (4 pts)

##Rendu
Déposer sur moodle :
- Une archive contentant le code source (sans le node_modules) de votre projet sur moodle et votre auto-évaluation (dans un fichier texte)
- Présentation de votre application lors de la dernière séance

##Ressouces
https://samuelbankole.medium.com/google-firebase-in-react-1acc64516788
https://github.com/CSFrequency/react-firebase-hooks