unit unitMacOS;

//Mac specific

interface
{$IFDEF MACOS}
function checkCreateDir(Dir : string):string;
{$ENDIF}

implementation

{$IFDEF MACOS}

function checkCreateDir(Dir : string):string;
begin
  if ForceDirectories(Dir) then result := 'found' else result := 'failed';
end;

{$ENDIF}
end.
