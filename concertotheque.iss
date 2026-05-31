; ============================================================
;  Concertothèque — Script Inno Setup
;  Compilez avec : iscc concertotheque.iss
;  Prérequis     : flutter build windows --release
; ============================================================

#define AppName      "Concertothèque"
#define AppVersion   "1.0.0"
#define AppPublisher "Julien Gournay"
#define AppExeName   "concertotheque_app.exe"
#define SourceDir    "build\windows\x64\runner\Release"

[Setup]
; GUID unique pour cette application — ne pas modifier après la première installation
AppId={{B3F7E8A2-1D4C-4F9E-8B6A-7C2D5E0F3A91}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} v{#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
AllowNoIcons=yes
; Dossier de sortie de l'installateur (créé automatiquement)
OutputDir=installer
OutputBaseFilename=ConcertothequeSetup-v{#AppVersion}
SetupIconFile=windows\runner\resources\concertotheque.ico
UninstallDisplayIcon={app}\{#AppExeName}
UninstallDisplayName={#AppName}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
; Windows 10 minimum (Flutter desktop exige au moins Win 10)
MinVersion=10.0
; 64 bits uniquement
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; \
  Description: "Créer une icône sur le bureau"; \
  GroupDescription: "Raccourcis :"; \
  Flags: unchecked

[Files]
; Exécutable principal
Source: "{#SourceDir}\{#AppExeName}"; \
  DestDir: "{app}"; \
  Flags: ignoreversion

; DLLs Flutter et plugins
Source: "{#SourceDir}\flutter_windows.dll";                       DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourceDir}\flutter_local_notifications_windows.dll";   DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourceDir}\screen_retriever_plugin.dll";               DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourceDir}\tray_manager_plugin.dll";                   DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourceDir}\url_launcher_windows_plugin.dll";           DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourceDir}\window_manager_plugin.dll";                 DestDir: "{app}"; Flags: ignoreversion

; Données Flutter (assets, moteur ICU…)
Source: "{#SourceDir}\data\*"; \
  DestDir: "{app}\data"; \
  Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Menu Démarrer
Name: "{group}\{#AppName}";               Filename: "{app}\{#AppExeName}"
Name: "{group}\Désinstaller {#AppName}";  Filename: "{uninstallexe}"
; Bureau (optionnel)
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon

[Registry]
; Nettoyage de la clé de démarrage automatique à la désinstallation
; (au cas où l'utilisateur l'aurait activée depuis les Paramètres de l'app)
Root: HKCU; \
  Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; \
  ValueName: "{#AppName}"; \
  Flags: deletevalue uninsdeletevalue

[Run]
; Proposition de lancer l'app à la fin de l'installation
Filename: "{app}\{#AppExeName}"; \
  Description: "Lancer {#AppName}"; \
  Flags: nowait postinstall skipifsilent
