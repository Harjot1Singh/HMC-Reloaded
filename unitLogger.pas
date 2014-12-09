unit unitLogger;

//Logs stuff to TGrid

interface
uses System.Classes, FMX.Grid, System.Rtti, System.SysUtils;

type

TLogger = Class
  public
    Constructor Create(var SGrid : TGrid);
    Destructor Destroy;
    Procedure Add(Item : String);
    Procedure onError(Sender : TObject; E : Exception);
  private
    Grid : TGrid;
    Log : array of String;
    procedure GetValue(Sender: TObject; const Col, Row: Integer;
      var Value: TValue);
End;

var
Logger : TLogger;

implementation

Constructor TLogger.Create(var SGrid: TGrid);
begin
  Grid := SGrid;
  Grid.Columns[0].Width := Grid.Width - 20;
  Grid.OnGetValue := GetValue;
end;

Destructor TLogger.Destroy;
var
  LogFile : TextFile;
  i : integer;
begin
  AssignFile(LogFile, 'HMC Reloaded.log');
  Rewrite(LogFile);
  for i := Low(Log) to High(Log) do Writeln(LogFile, Log[i]);
  CloseFile(LogFile);
  inherited Destroy;
end;

Procedure TLogger.GetValue(Sender: TObject; const Col: Integer; const Row: Integer; var Value: TValue);
begin
  if Col = 0 then Value := TValue.From<String>(Log[Row]);
end;

Procedure TLogger.Add(Item: string);
begin
  SetLength(Log, Length(Log) + 1);
  Grid.RowCount := Length(Log);
  Log[High(Log)] := Item;
  Grid.UpdateColumns;
  Grid.Selected := Grid.Index;
end;

procedure TLogger.onError(Sender: TObject; E: Exception);
begin
  Add(E.ClassName + ' - ' + E.Message);
end;

end.
