; �������� ��������� ��� Bookkeeper

[Setup]
; ��������: �������� AppId �������� ���������� ��������������� ������� ����������.
; �� ����������� ���������� AppId ��� ������ ����������.
; (��� ��������� ������ �������� ����������� ����� ���� Tools | Generate GUID � IDE.)
AppId={{326C531B-535D-4F0B-AB1B-60238BA71C03}
AppName=��������
AppVersion=0.8.2 beta
AppVerName=�������� 0.8.2 beta
AppPublisher="����� ��������"
AppPublisherURL=http://www.megabyte-web.ru
AppSupportURL=http://support.megabyte-web.ru
AppUpdatesURL=http://support.megabyte-web.ru
DefaultDirName={pf}\Bookkeeper
DefaultGroupName=��������
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
Name: "{group}\��������"; Filename: "{app}\Bookkeeper.exe"
Name: "{group}\{cm:ProgramOnTheWeb,��������}"; Filename: "http://www.mr-mr.ru"
Name: "{group}\{cm:UninstallProgram,��������}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\��������"; Filename: "{app}\Bookkeeper.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\��������"; Filename: "{app}\Bookkeeper.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\Bookkeeper.exe"; Description: "{cm:LaunchProgram,��������}"; Flags: nowait postinstall skipifsilent