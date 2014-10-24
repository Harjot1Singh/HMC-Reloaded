unit unitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Edit, FMX.ListView.Types, FMX.ListView, FMX.Layouts,
  FMX.ListBox, FMX.Memo;

type
  TfrmMain = class(TForm)
    imgBG: TImage;
    StyleBook: TStyleBook;
    edtName: TClearingEdit;
    btnPlay: TButton;
    lvMemo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure LogAdd(Entry: String);
    procedure LogModify(Entry: String);
    procedure OnActiveBG(Sender : TObject);
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

uses unitLayouts, unitSettings, unitMacOS, unitWindows, SHLObj;

procedure TFrmMain.OnActiveBG(Sender : TObject);
begin
  ChooseLayout(frmMain, imgBG);
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

procedure TfrmMain.btnPlayClick(Sender: TObject);
begin
  LogAdd('Layout ' + ChooseLayout(frmMain, imgBG) + ' chosen');
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  LogAdd('Setting Minecraft directory to ' + SetMinecraftDir);
  LogAdd('Minecraft directory ' + CheckCreateDir(MinecraftDir));
  LogAdd('Settings ' + LoadSettings);
  OnActivate := OnActiveBG;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  LogAdd('Initialising Application...');
  // Chooses random image
  LogAdd('Layout ' + ChooseLayout(frmMain, imgBG) + ' chosen');
end;


end.
