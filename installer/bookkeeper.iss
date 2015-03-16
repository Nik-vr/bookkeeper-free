; Сценарий установки для Bookkeeper

[Setup]
; ВНИМАНИЕ: значение AppId является уникальным идентификатором данного приложения.
; Не используйте одинаковые AppId для разных приложений.
; (для генерации нового значения используйте пункт меню Tools | Generate GUID в IDE.)
AppId={{326C531B-535D-4F0B-AB1B-60238BA71C03}
AppName=Счетовод
AppVersion=0.8.2 beta
AppVerName=Счетовод 0.8.2 beta
AppPublisher=Николай Петроченко
AppPublisherURL=http://petrochenko.ru
AppSupportURL=http://petrochenko.ru
AppUpdatesURL=http://petrochenko.ru
DefaultDirName={pf}\Bookkeeper
DefaultGroupName=Счетовод
AllowNoIcons=yes
OutputDir=..\installer
OutputBaseFilename=bookkeeper-setup
;SetupIconFile=D:\Practic\Bookkeeper.ico
InfoAfterFile=..\Bookkeeper\history.txt
Compression=lzma2/ultra64
SolidCompression=yes

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "..\Bookkeeper\Bookkeeper.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Bookkeeper\MyTools.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Bookkeeper\sqlite3.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Bookkeeper\data\valutes.lst"; DestDir: "{app}\data"; Flags: ignoreversion
Source: "..\Bookkeeper\data\colors.lst"; DestDir: "{app}\data"; Flags: ignoreversion
Source: "..\Bookkeeper\history.txt"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\Счетовод"; Filename: "{app}\Bookkeeper.exe"
Name: "{group}\{cm:ProgramOnTheWeb,Счетовод}"; Filename: "http://petrochenko.ru"
Name: "{group}\{cm:UninstallProgram,Счетовод}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Счетовод"; Filename: "{app}\Bookkeeper.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Счетовод"; Filename: "{app}\Bookkeeper.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\Bookkeeper.exe"; Description: "{cm:LaunchProgram,Счетовод}"; Flags: nowait postinstall skipifsilent