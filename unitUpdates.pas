unit unitUpdates;

// Multi-threaded downloader that should plug into any TGrid

interface

uses System.Classes, FMX.Grid, FMX.Ani, idHTTP, idComponent, SysUtils,
  System.Rtti, idSSLOpenSSL, idTCPClient, XSuperObject, idHashMessageDigest, system.IOUtils, system.Types;

type

  TDownloader = Class(TThread)
  public
    URL: String;
    Path: String;
    Percent: Single;
    procedure Download;
    Constructor Create(Sender: TObject);
    Destructor Destroy;
  protected
    procedure Execute; override;
  private
    Worker: TidHTTP;
    Parent: TObject;
    procedure onWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure UpdateUI;
  End;


  TUpdateManager = Class
  public
    Grid: TGrid;
    Info : ISuperObject;
    MaxWorkers : Integer;
    CurrentDownloads : Integer;
    NextDownload : Integer;
    DownloadList : Array of String;
    Queued : Array of Boolean;
    Constructor Create(var SGrid: TGrid);
    Destructor Destroy;
    function InternetConnected: Boolean;
    procedure Update(Sender: TObject);
    procedure ProgramUpdate;
    procedure FilesUpdate;
    procedure AddDownload(DURL, DPath: String);
    procedure CheckUpdates;
    procedure GenerateInfo;
    procedure SaveInfo(Path : String);
    procedure onTermination(Sender : TObject);
    procedure Refresh;
    procedure ProcessQueue;
    procedure CompareInfo;
  private
    Workers: Array of TDownloader;
    procedure GetValue(Sender: TObject; const Col, Row: Integer;
      var Value: TValue);
  End;

implementation

uses unitMain;

CONST
RootURL = 'https://dl.dropboxusercontent.com/u/43879036/Minecraft/HMC/';

function MD5(const FileName: string): string;
var
  IdMD5: TIdHashMessageDigest5;
  FS: TFileStream;
begin
 IdMD5 := TIdHashMessageDigest5.Create;
 FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
 try
   Result := IdMD5.HashStreamAsHex(FS)
 finally
   FS.Free;
   IdMD5.Free;
 end;
end;

function TUpdateManager.InternetConnected: Boolean;
var
  Client: TidTCPClient;
begin
  Client := TidTCPClient.Create(nil);
  Client.Host := 'google.com';
  Client.Port := 80;
  try
    Client.Connect;
    result := True;
    Client.Disconnect;
  Except
    On E: Exception do
      result := False
  end;
  Client.Free;
end;

Procedure TUpdateManager.SaveInfo(Path : String);
begin
  Info.SaveTo(Path);
end;

procedure TUpdateManager.GetValue(Sender: TObject; const Col, Row: Integer;
  var Value: TValue);
begin
  if Col = 0 then
    Value := TValue.From<string>('(' + IntToStr(Row + 1) + '/' +
      IntToStr(Grid.RowCount) + ') ' + Workers[Row].URL)
  else if Col = 1 then
    Value := TValue.From<Single>(Workers[Row].Percent);
end;

procedure TUpdateManager.ProcessQueue;
var
  i : integer;
begin
  if CurrentDownloads < MaxWorkers then
   for i := 1 to MaxWorkers - CurrentDownloads do
      if not Queued[High(Queued)] then
      begin
        Workers[NextDownload].Start;
        Queued[NextDownload] := True;
        Inc(CurrentDownloads);
        Inc(NextDownload);
      end;
end;

procedure TUpdateManager.AddDownload(DURL: string; DPath: string);
begin
  SetLength(Workers, Length(Workers) + 1);
  SetLength(Queued, Length(Workers));
  Workers[High(Workers)] := TDownloader.Create(Self);
  Grid.RowCount := Length(Workers);
  With Workers[High(Workers)] do
  begin
    URL := DURL;
    Path := DPath;
    OnTerminate := OnTermination;
    ProcessQueue;
  end;
end;

procedure TUpdateManager.onTermination(Sender: TObject);
begin
  if NextDownload mod MaxWorkers = 0 then Grid.TopRow := Grid.TopRow + 1 else Grid.TopRow := Grid.TopRow + MaxWorkers;
  Dec(CurrentDownloads);
  ProcessQueue;
end;

procedure TUpdateManager.ProgramUpdate;
begin
  //
end;

procedure TUpdateManager.FilesUpdate;
begin
  //
end;

procedure TUpdateManager.Update(Sender: TObject);
begin
  CurrentDownloads := 0;
  GenerateInfo;
  ProgramUpdate;
  FilesUpdate;
  frmMain.btnPlay.enabled := true;
end;

procedure TUpdateManager.CheckUpdates;
begin
  Grid.RowCount := 0;
  CurrentDownloads := 0;
  SetLength(Workers, 0);
  AddDownload
    (RootURL + 'HMC.json',
    MinecraftDir + '\HMC.json');
  Workers[0].OnTerminate := Update;
end;

Constructor TUpdateManager.Create(var SGrid: TGrid);
var
  i : integer;
begin
  SGrid.OnGetValue := GetValue;
  Grid := SGrid;
  Info := SO;
  MaxWorkers := 2;
end;


procedure TUpdateManager.GenerateInfo;
var
  Files : TStringDynArray;
  i:integer;
  JFiles : ISuperObject;
begin
  JFiles := SO;
  Info.S['launcherMD5'] := MD5(ParamStr(0));
  Files := TDirectory.GetFiles(MinecraftDir, '*' ,TSearchOption.soAllDirectories);
  for I := Low(Files) + 1 to High(Files) do    //Trying to skip including .settings file by assuming no other .files exist and . is furthest up
  begin
    JFiles.S[Copy(Files[i], pos('HMC\', Files[i]) + 4, Length(Files[i]))] := MD5(Files[i]);
  end;
  JFiles := SO(StringReplace(JFiles.AsJSON, '\\', '/', [rfReplaceAll]));
  Info.O['files'] := JFiles;
end;

procedure TUpdateManager.CompareInfo;
begin
  //http://stackoverflow.com/questions/14082886/superobject-extract-all
end;

Constructor TDownloader.Create(Sender: TObject);
begin
  inherited Create(True);
  Parent := Sender;
  Worker := TidHTTP.Create(nil);
  Worker.onWork := onWork;
  Worker.HandleRedirects := True;
end;

Destructor TDownloader.Destroy;
begin
  Inherited Destroy;
end;

Procedure TDownloader.Download;
var
  MS: TMemoryStream;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    Worker := Worker.Create(nil);
    MS := TMemoryStream.Create;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      Worker.IOHandler := SSL;
      Worker.Get(URL, MS);
      MS.SaveToFile(Path);
    finally
      Worker.Free;
      MS.Free;
    end;
  finally
    Terminate;
  end;
end;

procedure TDownloader.Execute;
begin
  Download;
end;


Destructor TUpdateManager.Destroy;
begin
  //
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
  Worker := TidHTTP(ASender);
  ContentLength := Worker.Response.ContentLength;
  if (Pos('chunked', LowerCase(Worker.Response.TransferEncoding)) = 0) and
    (ContentLength > 0) then
  begin
    Percent := 100 * AWorkCount / ContentLength;
    Synchronize(UpdateUI);
  end;
end;

procedure TDownloader.UpdateUI;
begin
  (Parent as TUpdateManager).Refresh;
end;

end.
