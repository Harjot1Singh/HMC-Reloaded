unit unitSettings;

interface

uses unitMain, SysUtils, unitLogger;

procedure SaveSettings();
procedure LoadSettings();
procedure UnlockAdmin;

implementation

//Super evil admin settings
procedure UnlockAdmin;
begin
  frmMain.plSettings.Height := 190;
  frmMain.btnSyncMods.Visible := True;
end;

procedure SaveSettings();
var
  SettingsFile : File of TSettings;
begin
  AssignFile(SettingsFile, MinecraftDir + '\.settings');
  Rewrite(SettingsFile);
  Write(SettingsFile, Settings);
  CloseFile(SettingsFile);
  Logger.Add('Settings saved at ' + MinecraftDir + '\.settings');
end;

procedure LoadSettings();
var
  SettingsFile : File of TSettings;
begin
    AssignFile(SettingsFile, MinecraftDir + '\.settings');
    try
      Reset(SettingsFile);
      Read(SettingsFile, Settings);
      CloseFile(SettingsFile);
      Logger.Add('Settings File loaded from ' + MinecraftDir + '\.settings');
    Except On E:Exception do
    begin
        SaveSettings;
        frmMain.btnDefaultXmClick(frmMain);
        Logger.Add('Settings file created');
    end;
  end;
  frmMain.tbXms.Value := Settings.Xms;
  frmMain.tbXmx.Value := Settings.Xmx;
  frmMain.edtName.Text := Settings.Username;
end;


end.
