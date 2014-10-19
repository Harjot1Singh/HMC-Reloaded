program HMCReloaded;

{$R 'resources.res' 'resources.rc'}

uses
  FMX.Forms,
  FMX.Types,
  unitMain in 'unitMain.pas' {frmMain},
  unitLayouts in 'unitLayouts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  FMX.Types.GlobalUseDX10Software := true;
  Application.Run;
end.
