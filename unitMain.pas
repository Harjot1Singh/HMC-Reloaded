unit unitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, unitLogger, unitUpdates,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Edit, FMX.ListView.Types, FMX.ListView, FMX.Layouts,
  FMX.ListBox, FMX.Memo, FMX.Ani, System.Rtti, FMX.Grid, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TfrmMain = class(TForm)
    imgBG: TImage;
    StyleBook: TStyleBook;
    edtName: TClearingEdit;
    btnPlay: TButton;
    sbtnSettings: TSpeedButton;
    plSettings: TPanel;
    tbXms: TTrackBar;
    tbXmx: TTrackBar;
    lblXms: TLabel;
    lblXmx: TLabel;
    btnDefaultXm: TButton;
    btnSyncMods: TButton;
    btnForceUpdate: TButton;
    gdDownloads: TGrid;
    progressColumn: TProgressColumn;
    stringColumn: TStringColumn;
    gdLog: TGrid;
    sgLog: TStringColumn;
    plLog: TPanel;
    sbtnLog: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure OnActiveBG(Sender : TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbtnSettingsClick(Sender: TObject);
    procedure tbXmsTracking(Sender: TObject);
    procedure tbXmxTracking(Sender: TObject);
    procedure btnDefaultXmClick(Sender: TObject);
    procedure btnSyncModsClick(Sender: TObject);
    procedure btnForceUpdateClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure sbtnLogClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
     Logger : TLogger;
     Updater : TUpdateManager;
  end;

  TSettings = record
    Username : String[20];
    Xms, Xmx, Version : integer;
  end;

var
  frmMain: TfrmMain;
  MinecraftDir: String;
  Settings : TSettings;

implementation

{$R *.fmx}

uses unitLayouts, unitSettings, unitMacOS, unitWindows;

procedure TFrmMain.OnActiveBG(Sender : TObject);
begin
  ChooseLayout(frmMain, imgBG);
end;

procedure TfrmMain.tbXmsTracking(Sender: TObject);
begin
  lblXms.Text := 'Starting RAM (-Xms) - ' + IntToStr(Round(tbXms.Value)) + 'MB';
  Settings.Xms := Round(tbXms.Value);
end;

procedure TfrmMain.tbXmxTracking(Sender: TObject);
begin
  lblXmx.Text := 'Maximum RAM (-Xmx) - ' + IntToStr(Round(tbXmx.Value)) + 'MB';
  Settings.Xmx := Round(tbXmx.Value);
end;


procedure TfrmMain.btnDefaultXmClick(Sender: TObject);
begin
  tbXms.Value := 512;
  tbXmx.Value := 2048;
end;

procedure TfrmMain.btnForceUpdateClick(Sender: TObject);
begin
//Forceupdate
end;

procedure TfrmMain.btnPlayClick(Sender: TObject);
begin
  //
end;

procedure TfrmMain.btnSyncModsClick(Sender: TObject);
begin
  Updater.SaveInfo(MinecraftDir + '\HMC.json');
end;

procedure TfrmMain.edtNameChange(Sender: TObject);
begin
  if edtName.Text = 'Harjot' then unlockAdmin;
  Settings.Username := edtName.Text;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
var
  Java : String;
begin
  Logger.Add('Setting Minecraft directory to ' + SetMinecraftDir(MinecraftDir));
  Logger.Add('Minecraft directory ' + CheckCreateDir(MinecraftDir));
  Logger.Add('Settings ' + LoadSettings);
  SetGridWidth;
  Java := JavaFound;
  Logger.Add('Java ' + Java);
  if not (Java = 'found') then btnPlay.Enabled := False;
  if Updater.InternetConnected then Updater.CheckUpdates else Logger.Add('Internet Connection not detected');
  OnActivate := OnActiveBG;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Logger := TLogger.Create(gdLog);
  Updater := TUpdateManager.Create(gdDownloads);
  Logger.Add('Initialising Application...');
  Logger.Add('Layout ' + ChooseLayout(frmMain, imgBG) + ' chosen');
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  SetGridWidth;
end;

procedure TfrmMain.sbtnLogClick(Sender: TObject);
begin
  ToggleLogView;
end;

procedure TfrmMain.sbtnSettingsClick(Sender: TObject);
begin
  ToggleSettingsView;
end;

end.
