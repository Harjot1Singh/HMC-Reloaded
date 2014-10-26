unit unitWindows;

//Windows Specific

interface
{$IFDEF MSWINDOWS}
uses SHLObj, SysUtils, fmx.dialogs, Windows;

function setMinecraftDir(var MinecraftDir : String):String;
function checkCreateDir(Dir : String):String;
function javaFound():string;

{$ENDIF}
implementation
{$IFDEF MSWINDOWS}
type
  WinIsWow64 = function( Handle: THandle; var Iret: BOOL ): Windows.BOOL; stdcall;

function IAmIn64Bits: Boolean;
var
  HandleTo64BitsProcess: WinIsWow64;
  Iret                 : Windows.BOOL;
begin
  Result := False;
  HandleTo64BitsProcess := GetProcAddress(GetModuleHandle('kernel32.dll'), 'IsWow64Process');
  if Assigned(HandleTo64BitsProcess) then
  begin
    if not HandleTo64BitsProcess(GetCurrentProcess, Iret) then
    Raise Exception.Create('Invalid handle');
    Result := Iret;
  end;
end;

function javaFound():String;
var
  JavaPath, ProgramFiles : String;
begin
  ProgramFiles := GetEnvironmentVariable('ProgramFiles');
  if IAmIn64Bits then ProgramFiles := copy(ProgramFiles, 1, Pos(' (x86)',ProgramFiles) -1);
  JavaPath := ProgramFiles + '\Java';
  if DirectoryExists(JavaPath) then result := 'found' else result := 'not found (if running 64bit, please install 64bit java)';
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


