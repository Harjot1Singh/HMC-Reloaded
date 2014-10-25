unit unitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
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
    lvMemo: TMemo;
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
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure LogAdd(Entry: String);
    procedure LogModify(Entry: String);
    procedure OnActiveBG(Sender : TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbtnSettingsClick(Sender: TObject);
    procedure tbXmsTracking(Sender: TObject);
    procedure tbXmxTracking(Sender: TObject);
    procedure btnDefaultXmClick(Sender: TObject);
    procedure btnSyncModsClick(Sender: TObject);
    procedure btnForceUpdateClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure gdDownloadsGetValue(Sender: TObject; const Col, Row: Integer;
      var Value: TValue);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TSettings = record
    Username : String[20];
    Xms, Xmx : integer;
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

procedure TfrmMain.sbtnSettingsClick(Sender: TObject);
begin
  if sbtnSettings.StyleLookup = 'stepperbuttonleft' then
  begin
    plSettings.AnimateFloat('position.x', imgBG.Width - plSettings.Width, 1.5, TAnimationType.atOut, TInterpolationType.itElastic);
    sbtnSettings.StyleLookup := 'stepperbuttonright';
  end else
  begin
    plSettings.AnimateFloat('position.x', imgBG.Width , 1.5, TAnimationType.atOut, TInterpolationType.itBounce);
    sbtnSettings.StyleLookup := 'stepperbuttonleft'
  end;
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

Procedure TfrmMain.LogModify(Entry: string);
begin
  lvMemo.Lines[lvMemo.Lines.Count] := Entry;
end;

Procedure TfrmMain.LogAdd(Entry: String);
begin
  lvMemo.Lines.Add(Entry);
  lvMemo.GoToTextEnd;
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
  LogAdd('Layout ' + ChooseLayout(frmMain, imgBG) + ' chosen');
end;

procedure TfrmMain.btnSyncModsClick(Sender: TObject);
begin
  //Sync mods etc
end;

procedure TfrmMain.edtNameChange(Sender: TObject);
begin
  if edtName.Text = 'Harjot' then unlockAdmin;
  Settings.Username := edtName.Text;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  LogAdd('Setting Minecraft directory to ' + SetMinecraftDir(MinecraftDir));
  LogAdd('Minecraft directory ' + CheckCreateDir(MinecraftDir));
  LogAdd('Settings ' + LoadSettings);
  LogAdd('Java ' + JavaFound);
  OnActivate := OnActiveBG;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings();
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  LogAdd('Initialising Application...');
  // Chooses random image
  LogAdd('Layout ' + ChooseLayout(frmMain, imgBG) + ' chosen');
end;


procedure TfrmMain.gdDownloadsGetValue(Sender: TObject; const Col, Row: Integer;
  var Value: TValue);
begin
  if col = 1 then Value := TValue.From<single>(Row);

end;

end.
