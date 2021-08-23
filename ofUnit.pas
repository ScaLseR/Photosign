unit ofUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JPEG, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls;

type
  Topenfromfile = class(TForm)
    Label1: TLabel;
    TrackBar1: TTrackBar;
    Image2: TImage;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Image3: TImage;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Shape1: TShape;
    Shape2: TShape;
    procedure TrackBar1Change(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  openfromfile: Topenfromfile;
   bmpmain: TBitmap;
   const
  FULLSCALE = 100;
implementation

{$R *.dfm}

uses webcam;

procedure Topenfromfile.TrackBar1Change(Sender: TObject);
var
  Zoom: Integer;
begin
  Zoom := TrackBar1.Position;
  if not (Visible or (Zoom = FULLSCALE)) or (Zoom = 0) then
    Exit;
  if zoom>100 then image1.Stretch:=true;

  SetMapMode(image1.Canvas.Handle, MM_ISOTROPIC);
  SetWindowExtEx(image1.Canvas.Handle, FULLSCALE, FULLSCALE, nil);
  SetViewportExtEx(image1.Canvas.Handle, Zoom, Zoom, nil);

  image1.Width := Round(bmpmain.Width * Zoom / FULLSCALE);
  image1.Height := Round(bmpmain.Height * Zoom / FULLSCALE);
  if Assigned(image1.Picture.Graphic) then begin
  image1.Picture.Graphic.Width := image1.Width;
  image1.Picture.Graphic.Height := image1.Height;
  end;

  image1.Picture.Assign(bmpmain);
  Label1.Caption := 'Zoom: ' +
      IntToStr(Round(TrackBar1.Position / FULLSCALE * 100)) + '%';
end;

procedure Topenfromfile.Button2Click(Sender: TObject);
var L,R,B,T:Extended;
     aX,aY :Extended;
begin
  ax:= Image1.Picture.Width/Image1.Width;
  aY:= Image1.Picture.Height/Image1.Height;

  L:=(Shape1.Left-Image1.Left)*ax;
  R:=L+(Shape1.Width*ax);
  B:=(Shape1.top-image1.top)*ay;
  T:=B+(Shape1.Height*ay);
  if webcam.shu=0 then
                  begin
                 // photoxsign.Image4.Visible:=true;
                  photoxsign.Image4.Width:= sw1;
                  photoxsign.Image4.Height:= sh1;
                   photoxsign.Image4.Stretch:=TRUE;
                   photoxsign.Image4.Proportional:=TRUE;
                   Image3.Width  := round(R-L);
                   Image3.Height := round(T-B);
                   image3.Canvas.Draw(round(-l), round(-b), Image1.Picture.Graphic);
                   photoxsign.Image4.Picture.Assign(image3.Picture);
                   photoxsign.Image4.Visible:=true;
                   image2.Picture.Bitmap:=nil;
                   image1.Picture.Bitmap:=nil;
                   image3.Picture.Bitmap:=nil;
                   shape1.Visible:=false;
                   shape2.Visible:=false;
                   //shu:=nil;
                   openfromfile.Close();
                  end;
    if webcam.shu=1 then
                  begin
                  photoxsign.Image2.Visible:=true;
                  photoxsign.Image2.Width:= spw1;
                  photoxsign.Image2.Height:= sph1;
                   photoxsign.Image2.Stretch:=TRUE;
                   photoxsign.Image2.Proportional:=TRUE;
                   Image3.Width  := round(R-L);
                   Image3.Height := round(T-B);
                   image3.Canvas.Draw(round(-l), round(-b), Image1.Picture.Graphic);
                   photoxsign.Image2.Picture.Assign(image3.Picture);
                   photoxsign.Image2.Visible:=true;
                   image2.Picture.Bitmap:=nil;
                   image1.Picture.Bitmap:=nil;
                   image3.Picture.Bitmap:=nil;
                   shape1.Visible:=false;
                   shape2.Visible:=false;
                   //shu:=nil;
                   openfromfile.Close();
                  end;

                  end;




procedure Topenfromfile.FormCreate(Sender: TObject);
begin
  bmpmain := TBitmap.Create;
  bmpmain.PixelFormat := pf32bit;
  bmpmain.Assign(webcam.bmpmain);

  IMAGE2.Stretch:=TRUE;
  IMAGE2.Proportional:=TRUE;
  IMAGE2.Picture.Assign(bmpmain);
  if scrollbox1.Width>image2.Picture.Width then scrollbox1.Width:=image2.Picture.Width;
  if scrollbox1.Height>image2.Picture.Height then scrollbox1.Height:=image2.Picture.Height;

  Trackbar1.Visible:=true;
  label1.Visible:=true;
  TrackBar1.Min := FULLSCALE div 10;   // %10
  TrackBar1.Max := FULLSCALE * 2;      // %200
  TrackBar1.PageSize := (TrackBar1.Max - TrackBar1.Min) div 19;
  TrackBar1.Frequency := TrackBar1.PageSize;
  TrackBar1.Position := FULLSCALE;



     if webcam.shu=0 then
                      begin
                      shape2.Visible:=false;
                      shape1.Width:=webcam.sw1;
                      shape1.Height:=webcam.sh1;
                      shape1.pen.Color:=cLred;
                      shape1.Brush.Style:=bsclear;
                      shape1.Left:=image2.Left;
                      shape1.Top:=image2.Top;
                      shape1.Visible:=true;
                      end;
     if webcam.shu=1 then
                      begin
                      shape1.Width:=webcam.spw1;
                      shape1.Height:=webcam.sph1;
                      shape1.pen.Color:=cLred;
                      shape1.Brush.Style:=bsclear;
                      shape1.Visible:=true;
                      shape1.Left:=image2.Left;
                      shape1.Top:=image2.Top;
                      shape2.Width:=webcam.spw1-50;
                      shape2.Height:=webcam.sph1-50;
                      shape2.pen.Color:=cLred;
                      shape2.Brush.Style:=bsclear;
                      shape2.Left:=image2.Left+25;
                      shape2.Top:=image2.Top+25;
                      shape2.Visible:=true;

                      end;
end;

procedure Topenfromfile.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   move := true;
  x0 := x;
  y0 := y;
end;

procedure Topenfromfile.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move := false;
end;

procedure Topenfromfile.Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
VAR Left,Top :Integer;
begin
    if move = true then
  begin
    Left := openfromfile.Shape1.left + X - X0;
    Top := openfromfile.Shape1.top + Y - Y0;
    IF Left<openfromfile.Image1.Left THEN Left:=openfromfile.Image1.Left;
    IF Top<openfromfile.Image1.top THEN Top:=openfromfile.Image1.top;
    IF Left+openfromfile.Shape1.Width>openfromfile.Image1.Left+openfromfile.Image1.Width THEN Left:=openfromfile.Image1.Left+openfromfile.Image1.Width-openfromfile.Shape1.Width;
    IF Top+openfromfile.Shape1.Height>openfromfile.Image1.top+openfromfile.Image1.Height THEN Top:=openfromfile.Image1.top+openfromfile.Image1.Height-openfromfile.Shape1.Height;
    openfromfile.Shape1.Left := Left;
    openfromfile.Shape1.top  := Top;

    if webcam.shu=1 then
                      begin
    openfromfile.shape2.Left:=Left+25;
    openfromfile.shape2.Top:=top+25;
                       end;
  end;
end;





end.
