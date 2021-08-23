unit opFRfl;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JPEG, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.StdCtrls, webcam;

type
  Topenfromfile = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    FileOpenDialog1: TFileOpenDialog;
    Image2: TImage;
    Shape1: TShape;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  openfromfile: Topenfromfile;

implementation

{$R *.dfm}

end.
