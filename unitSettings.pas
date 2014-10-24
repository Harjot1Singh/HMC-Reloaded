unit unitSettings;

interface

uses unitMain, SysUtils;

function SaveSettings() : String;
function LoadSettings() : String;

implementation


function SaveSettings() : String;
var
  SettingsFile : File of TSettings;
begin
  AssignFile(SettingsFile, MinecraftDir + '\.settings.dat');
  Rewrite(SettingsFile);
  Write(SettingsFile, Settings);
end;

function LoadSettings() : String;
var
  SettingsFile : File of TSettings;
begin
  if FileExists(MinecraftDir + '\.settings.dat') then
  begin
    AssignFile(SettingsFile, MinecraftDir + '\.settings.dat');
    Reset(SettingsFile);
    Read(SettingsFile, Settings);
    CloseFile(SettingsFile);
    Result := 'loaded';
  end else
  begin
    SaveSettings;
    Result := 'created';
  end;
end;

end.
