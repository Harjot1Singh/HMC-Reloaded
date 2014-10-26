unit unitUpdates;

// Multi-threaded downloader that should plug into any TGrid

interface

uses System.Classes, FMX.Grid, FMX.Ani, idHTTP, idComponent, SysUtils,
  System.Rtti, idSSLOpenSSL, idTCPClient;

type

  TDownloader = Class(TThread)
  public
    URL: String;
    Path: String;
    Percent: Single;
    procedure Download;
    Constructor Create(Sender : TObject);
    Destructor Destroy;
  protected
    procedure Execute; override;
  private
    Worker: TidHTTP;
    Parent : TObject;
    procedure onWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure UpdateUI;
  End;

  TUpdateManager = Class
  public
    Grid : TGrid;
    Constructor Create(var SGrid: TGrid);
    Destructor Destroy;
    function InternetConnected: Boolean;
    procedure Update;
    procedure ProgramUpdate;
    procedure FilesUpdate;
    procedure AddDownload(DURL, DPath: String);
    procedure Refresh;
  private
    Workers: Array of TDownloader;
    procedure GetValue(Sender: TObject; const Col, Row: Integer;
      var Value: TValue);
  End;

implementation

uses unitMain;

function TUpdateManager.InternetConnected: Boolean;
var
  Client: TidTCPClient;
begin
  Client := TidTCPClient.Create(nil);
  Client.Host := 'google.com';
  Client.Port := 80;
  try
    Client.Connect;
    Result := True;
    Client.Disconnect;
  Except
    On E:Exception do
      Result := False
  end;
  Client.Free;
end;

procedure TUpdateManager.GetValue(Sender: TObject; const Col, Row: Integer;
  var Value: TValue);
begin
  if Col = 0 then
    Value := TValue.From<string>('(' + IntToStr(Row + 1) + '/' + IntToStr(Grid.RowCount) + ') '  + Workers[Row].URL)
  else if Col = 1 then
    Value := TValue.From<Single>(Workers[Row].Percent);
end;

procedure TUpdateManager.AddDownload(DURL: string; DPath: string);
begin
  SetLength(Workers, Length(Workers) + 1);
  Grid.RowCount := Length(Workers);
  Workers[High(Workers)] := TDownloader.Create(Self);
  With Workers[High(Workers)] do
  begin
    URL := DURL;
    Path := DPath;
    Start;
  end;
end;

procedure TUpdateManager.ProgramUpdate;
begin
  //
end;

procedure TUpdateManager.FilesUpdate;
begin
  //
end;

procedure TUpdateManager.Update;
begin
  AddDownload('https://dl.dropboxusercontent.com/u/43879036/Minecraft/MCLauncher.exe', MinecraftDir + '\tst1.test');
  AddDownload('https://dl.dropboxusercontent.com/u/43879036/Minecraft/GenModList.exe', MinecraftDir + '\tst2.test');
end;

Constructor TDownloader.Create(Sender : TObject);
begin
  inherited Create(True);
  Parent := Sender;
  Worker := TidHTTP.Create(nil);
  Worker.onWork := onWork;
  Worker.HandleRedirects := True;
end;

Destructor TDownloader.Destroy;
begin
  Worker.Free;
  Inherited Destroy;
end;

Procedure TDownloader.Download;
var
  MS: TMemoryStream;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    MS := TMemoryStream.Create;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      Worker.IOHandler := SSL;
      Worker.Get(URL, MS);
      MS.SaveToFile(Path);
    finally
      MS.Free;
    end;
  finally
    Destroy;
  end;
end;

procedure TDownloader.Execute;
begin
  Download;
end;

Constructor TUpdateManager.Create(var SGrid: TGrid);
begin
  SGrid.OnGetValue := GetValue;
  Grid := SGrid;
end;

Destructor TUpdateManager.Destroy;
begin
  inherited Destroy;
end;

procedure TUpdateManager.Refresh;
begin
  Grid.UpdateColumns;
end;

procedure TDownloader.onWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  Worker: TidHTTP;
  ContentLength: Int64;
begin
  if not Terminated then
  begin
    Worker := TidHTTP(ASender);
    ContentLength := Worker.Response.ContentLength;
    if (Pos('chunked', LowerCase(Worker.Response.TransferEncoding)) = 0) and
      (ContentLength > 0) then
    begin
      Percent := 100 * AWorkCount / ContentLength;
      Synchronize(UpdateUI);
    end;
  end;
end;

procedure TDownloader.UpdateUI;
begin
  (Parent as TUpdateManager).Refresh;
end;

end.
