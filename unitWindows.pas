unit unitWindows;

//Windows Specific

interface
{$IFDEF MSWINDOWS}
uses SHLObj, SysUtils, fmx.dialogs;

function setMinecraftDir(var MinecraftDir : String):String;
function checkCreateDir(Dir : String):String;
function javaFound():string;

{$ENDIF}
implementation
{$IFDEF MSWINDOWS}

function javaFound():String;
var
  JavaPath : String;
begin
  showmessage(GetEnvironmentVariable('ProgramFiles'));
end;

function AppDataPath : string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0..254] of char;
begin
  SHGetFolderPath(0,CSIDL_APPDATA,0,SHGFP_TYPE_CURRENT,@path[0]);
  Result := StrPas(path);
end;

//Path for windows
function setMinecraftDir(var MinecraftDir : String):string;
begin
  MinecraftDir := AppdataPath + '\.minecraft\HMC';
  Result := MinecraftDir;
end;

//Checks for .minecraft directory and then HMC directory and creates if necessary
function checkCreateDir(Dir : string):string;
begin
  if ForceDirectories(Dir) then result := 'found' else result := 'failed';
end;
{$ENDIF}
end.


