unit unitUpdates;

//Multi-threaded downloader that should plug into any TGrid

interface

uses System.Classes, FMX.Grid, FMX.Ani, idHTTP, idComponent, SysUtils, unitMain;

type

TDownloader = Class(TThread)
  public
    URL : String;
    Path : String;
    procedure Download;
    Constructor Create;
    Destructor Destroy;
  private
    Worker : TidHTTP;
End;

TUpdateManager = Class
  public
    Constructor Create(Grid : TGrid);
    Destructor Destroy;
  private
    Workers : Array of TDownloader;
    procedure onWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
End;

implementation

Constructor TDownloader.Create;
begin
  Worker := TidHTTP.Create(nil);
end;

Destructor TDownloader.Destroy;
begin
  Worker.Free;
  Inherited Destroy;
end;

Procedure TDownloader.Download;
var
  MS: TMemoryStream;
begin
  try
    MS := TMemoryStream.Create;
    try
      Worker.Get(URL, MS);
      MS.SaveToFile(Path);
    finally
      MS.Free;
    end;
  finally
    Destroy;
  end;
end;

Constructor TUpdateManager.Create(Grid: TGrid);
begin
  //
end;

Destructor TUpdateManager.Destroy;
begin
  //
end;

procedure TUpdateManager.onWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
var
  Worker: TIdHTTP;
  ContentLength: Int64;
  Percent: Integer;
begin
  Worker := TIdHTTP(ASender);
  ContentLength := Worker.Response.ContentLength;

  if (Pos('chunked', LowerCase(Worker.Response.TransferEncoding)) = 0) and
     (ContentLength > 0) then
  begin
    Percent := 100*AWorkCount div ContentLength;
    frmMain.LogAdd(IntToStr(Percent));
  end;
end;

end.
