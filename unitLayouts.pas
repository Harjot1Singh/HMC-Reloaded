unit unitLayouts;

interface

uses FMX.Forms, FMX.Objects, Math, System.Classes, System.Types, System.SysUtils;

function ChooseLayout(Form : TForm; BG : TImage):String;

implementation

function ChooseLayout(Form : TForm; BG : TImage):String;
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
  Result := IntToStr(LayoutID);
end;

end.
