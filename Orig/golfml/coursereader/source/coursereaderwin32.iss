; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Golfml Course Reader"
#define MyAppVersion "1.5"
#define MyAppPublisher "minesadorada"
#define MyAppURL "http://code.google.com/p/golfml/"
#define MyAppExeName "golfmlreaderwin32.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{98E34CAE-514D-491E-83FC-A2F391FDF8A2}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=C:\lazarus\golfmlsvn\golfml\coursereader\windowsbinaries\32bit
OutputBaseFilename=GolfmlCourseReaderWin32Setup
SetupIconFile=C:\lazarus\golfmlsvn\golfml\coursereader\source\golfuml.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "C:\lazarus\golfmlsvn\golfml\coursereader\source\golfmlreaderwin32.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\lazarus\golfmlsvn\golfml\coursereader\source\coursedata.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\lazarus\golfmlsvn\golfml\coursewriter\courses\tenerife_abamagolf.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\lazarus\golfmlsvn\golfml\coursewriter\courses\tenerife_amarillagolf.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\lazarus\golfmlsvn\golfml\coursewriter\courses\tenerife_buenavistagolf.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\lazarus\golfmlsvn\golfml\coursewriter\courses\tenerife_costaadejegolf.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\lazarus\golfmlsvn\golfml\coursewriter\courses\tenerife_golfdelsur.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\lazarus\golfmlsvn\golfml\coursewriter\courses\tenerife_golfdelsur1.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\lazarus\golfmlsvn\golfml\coursewriter\courses\tenerife_golflasamericas.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\lazarus\golfmlsvn\golfml\coursewriter\courses\tenerife_larosaleda.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\lazarus\golfmlsvn\golfml\coursewriter\courses\tenerife_lospalosgolfcentre.xml"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

