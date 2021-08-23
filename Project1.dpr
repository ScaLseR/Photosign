program Project1;

uses
  Vcl.Forms,
  webcam in 'webcam.pas' {photoXsign},
  SignatureForm in 'SignatureForm.pas' {Form2},
  wgssSTU_TLB in 'wgssSTU_TLB.pas',
  ofUnit in 'ofUnit.pas' {openfromfile};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TphotoXsign, photoXsign);
  Application.CreateForm(TForm2, Form2);
  /// Application.CreateForm(Topenfromfile, openfromfile);
  Application.CreateForm(Topenfromfile, openfromfile);
  Application.Run;
end.
