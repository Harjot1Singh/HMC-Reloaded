program HMCReloaded;

{$R 'resources.res' 'resources.rc'}

uses
  FMX.Forms,
  FMX.Types,
  unitMain in 'unitMain.pas' {frmMain},
  unitLayouts in 'unitLayouts.pas',
  unitSettings in 'unitSettings.pas',
  unitMacOS in 'unitMacOS.pas',
  unitWindows in 'unitWindows.pas',
  unitLaunchCmd in 'unitLaunchCmd.pas',
  unitUpdates in 'unitUpdates.pas',
  unitLogger in 'unitLogger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  FMX.Types.GlobalUseDX10Software := true;
  Application.Run;
end.
