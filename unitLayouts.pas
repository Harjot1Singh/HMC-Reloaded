unit unitLayouts;

interface

uses FMX.Forms, FMX.Objects, Math, System.Classes, System.Types, System.SysUtils, UnitMain, FMX.Types, unitLogger;

procedure ChooseLayout(Form : TForm; BG : TImage);
procedure ToggleLogView;
procedure ToggleSettingsView;
procedure SetGridWidth;


implementation

procedure SetGridWidth;
begin
  frmMain.gdDownloads.Columns[0].Width := (frmMain.Width -16) div 2;
  frmMain.gdDownloads.Columns[1].Width := (frmMain.Width -16) div 2;
end;

procedure ChooseLayout(Form : TForm; BG : TImage);
Const
  BGNUMBER = 7;
var
  LayoutID : Integer;
  RStream : TResourceStream;
begin
//Choose a random image out of those available and load it
  Randomize;
  LayoutID := Round(RandomRange(1, BGNUMBER + 1));
  RStream := TResourceStream.Create(MainInstance, 'BG' + IntToStr(LayoutID), RT_RCDATA);
  BG.MultiResBitmap.LoadItemFromStream(RStream, 1.000);
  RStream.Free;
  Logger.Add('Layout ' + IntToStr(LayoutID) + ' chosen');
end;

Procedure ToggleLogView;
begin
  if frmMain.sbtnLog.StyleLookup = 'stepperbuttonright' then
  begin
    frmMain.plLog.AnimateFloat('position.x', frmMain.plLog.Position.X + frmMain.plLog.Width, 1.5, TAnimationType.atOut, TInterpolationType.itElastic);
    frmMain.sbtnLog.StyleLookup := 'stepperbuttonleft';
  end else
  begin
    frmMain.plLog.AnimateFloat('position.x', 1-frmMain.plLog.Width , 1.5, TAnimationType.atOut, TInterpolationType.itBounce);
    frmMain.sbtnLog.StyleLookup := 'stepperbuttonright'
  end;
end;

procedure ToggleSettingsView;
begin
  if frmMain.sbtnSettings.StyleLookup = 'stepperbuttonleft' then
  begin
    frmMain.plSettings.AnimateFloat('position.x', frmMain.imgBG.Width - frmMain.plSettings.Width, 1.5, TAnimationType.atOut, TInterpolationType.itElastic);
    frmMain.sbtnSettings.StyleLookup := 'stepperbuttonright';
  end else
  begin
    frmMain.plSettings.AnimateFloat('position.x', frmMain.imgBG.Width , 1.5, TAnimationType.atOut, TInterpolationType.itBounce);
    frmMain.sbtnSettings.StyleLookup := 'stepperbuttonleft'
  end;
end;

end.
