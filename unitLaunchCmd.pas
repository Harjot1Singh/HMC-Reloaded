unit unitLaunchCmd;

//Parses library JSON provided, builds a string out of it, and parse mods JSON.

interface

uses XSuperObject, SysUtils, unitMacOS, unitWindows;

function Xms(Size : Integer) : String;
function Xmx(Size : Integer) : String;

implementation

function Xms(Size : Integer) : String;
begin
  if not Size = 0 then  Result := '-Xms' + IntToStr(Size) else Result := '';
end;

function Xmx(Size : Integer) : String;
begin
  if not Size = 0 then  Result := '-Xmx' + IntToStr(Size) else Result := '';
end;

end.
