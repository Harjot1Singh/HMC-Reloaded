unit unitUpdates;

// Multi-threaded downloader that should plug into any TGrid

interface

uses System.Classes, FMX.Grid, FMX.Ani, idHTTP, idComponent, SysUtils,
  System.Rtti, idSSLOpenSSL;

type

  TDownloader = Class(TThread)
  public
    URL: String;
    Path: String;
    Percent: single;
    procedure Download;
    Constructor Create;
    Destructor Destroy;
  protected
    procedure Execute; override;
  private
    Worker: TidHTTP;
    procedure onWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure UpdateUI;
  End;

  TUpdateManager = Class
  public
    Constructor Create(var Grid: TGrid);
    Destructor Destroy;
  private
    Workers: Array of TDownloader;
    procedure GetValue(Sender: TObject; const Col, Row: Integer;
      var Value: TValue);
  End;

implementation

uses unitMain;

Constructor TDownloader.Create;
begin
  inherited Create(True);
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
  inherited;
  Download;
end;

Constructor TUpdateManager.Create(var Grid: TGrid);
begin
  Grid.OnGetValue := GetValue;
end;

Destructor TUpdateManager.Destroy;
begin
  //
end;

procedure TDownloader.onWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  Worker: TidHTTP;
  ContentLength: Int64;
begin
  while not Terminated do
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
  frmMain.LogAdd(FloatToStr(Percent));
end;

procedure TUpdateManager.GetValue(Sender: TObject; const Col, Row: Integer;
  var Value: TValue);
begin
  if Col = 0 then // item
  else if Col = 1 then // percent

end;

end.
