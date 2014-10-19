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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  MinecraftDir: String;

implementation

{$R *.fmx}
{$IFDEF MACOS}

uses unitLayouts;


{$ELSE}

uses unitLayouts, SHLObj;

{$ENDIF}

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
  OnActivate := Nil;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  LogAdd('Initialising Application...');
  // Chooses random image
  LogAdd('Layout ' + ChooseLayout(frmMain, imgBG) + ' chosen');
end;

end.
