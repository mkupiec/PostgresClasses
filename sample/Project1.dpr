program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {FormConnParams};

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown := DebugHook <> 0; 
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormConnParams, FormConnParams);
  Application.Run;
end.
