unit unitSettings;

interface

uses unitMain, SysUtils;

function SaveSettings() : String;
function LoadSettings() : String;
procedure UnlockAdmin;

implementation

//Super evil admin settings
procedure UnlockAdmin;
begin
  frmMain.plSettings.Height := 190;
  frmMain.btnSyncMods.Visible := True;
end;

function SaveSettings() : String;
var
  SettingsFile : File of TSettings;
begin
  AssignFile(SettingsFile, MinecraftDir + '\.settings');
  Rewrite(SettingsFile);
  Write(SettingsFile, Settings);
  CloseFile(SettingsFile);
end;

function LoadSettings() : String;
var
  SettingsFile : File of TSettings;
begin
  if FileExists(MinecraftDir + '\.settings') then
  begin
    AssignFile(SettingsFile, MinecraftDir + '\.settings');
    Reset(SettingsFile);
    Read(SettingsFile, Settings);
    CloseFile(SettingsFile);
    Result := 'loaded';
  end else
  begin
    frmMain.btnDefaultXmClick(frmMain);
    SaveSettings;
    Result := 'created';
  end;
  frmMain.tbXms.Value := Settings.Xms;
  frmMain.tbXmx.Value := Settings.Xmx;
  frmMain.edtName.Text := Settings.Username;
end;

end.
