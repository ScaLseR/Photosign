unit webcam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, CamCaptureUnit, AviCap32Unit, JPEG, iniFiles,
  wgssSTU_TLB,SignatureForm, Vcl.ComCtrls, GDIPOBJ, ofUnit, Vcl.ImgList, sSkinProvider, sSkinManager, directshow9, ActiveX;

type
  TphotoXsign = class(TForm)
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ImageList1: TImageList;
    sSkinManager1: TsSkinManager;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Image1: TImage;
    Image2: TImage;
    Shape1: TShape;
    Label1: TLabel;
    Shape3: TShape;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox2: TComboBox;
    Button4: TButton;
    Button8: TButton;
    Label2: TLabel;
    Image4: TImage;
    ComboBox3: TComboBox;
    CheckBox1: TCheckBox;
    Button10: TButton;
    Button9: TButton;
    Button7: TButton;
    Button6: TButton;
    Button5: TButton;
    Shape2: TShape;
    Image3: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Button11: TButton;
    ListBox1: TListBox;

    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
     procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Shape2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Shape2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Shape2MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure LoadComboText;
    procedure LoadComboText2;
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button11Click(Sender: TObject);
    function CaptureBitmap: HResult;
    procedure ListBox1DblClick(Sender: TObject);
    function CreateGraph:HResult;
    function Initializ: HResult;
    procedure FormDestroy(Sender: TObject);
    




  




  private
   CamList : TCamList;
   cam: TCamera;
    { Private declarations }
  public

    { Public declarations }


  end;

var
  photoXsign: TphotoXsign;
   X0, Y0: integer;
   move: boolean;
   x,y,y1,x2,y3,x4:integer;
   sw,sh,sw1,sh1,shu,fh,fw,sph1,spw1:integer;
   bmpmain: TBitmap;
  /////
  FileName:string; //имя файла для записи
  RecMode: Boolean = False; //флаг записи
  DeviceName:OleVariant;  //имя устройства
  PropertyName:IPropertyBag; //
  pDevEnum:ICreateDEvEnum; //перечислитель устройств
  pEnum:IEnumMoniker; //перечислитель моникеров
  pMoniker:IMoniker;
  MArray1,MArray2: array of IMoniker; //Это список моникеров, из которго
                                                        //мы потом будем получать необходмый моникер
    FGraphBuilder:        IGraphBuilder;
    FCaptureGraphBuilder: ICaptureGraphBuilder2;
    FMux:                 IBaseFilter;
    FSink:                IFileSinkFilter;
    FMediaControl:        IMediaControl;
    FVideoWindow:         IVideoWindow;

    FVideoCaptureFilter:  IBaseFilter;
    FAudioCaptureFilter:  IBaseFilter;
    //область вывода изображения
      FBaseFilter:          IBaseFilter;
     FVideoRect:           TRect;
     FSampleGrabber:       ISampleGrabber;
     MediaType:            AM_MEDIA_TYPE;
  ////




   const
  FULLSCALE = 100;





implementation

{$R *.dfm}

 function TphotoXsign.Initializ: HResult;
begin
//Создаем объект для перечисления устройств
Result:=CoCreateInstance(CLSID_SystemDeviceEnum, NIL, CLSCTX_INPROC_SERVER,
IID_ICreateDevEnum, pDevEnum);
if Result<>S_OK then EXIT;

//Перечислитель устройств Video
Result:=pDevEnum.CreateClassEnumerator(CLSID_VideoInputDeviceCategory, pEnum, 0);
if Result<>S_OK then EXIT;
//Обнуляем массив в списке моникеров
setlength(MArray1,0);
//Пускаем массив по списку устройств
while (S_OK=pEnum.Next(1,pMoniker,Nil)) do
begin
setlength(MArray1,length(MArray1)+1); //Увеличиваем массив на единицу
MArray1[length(MArray1)-1]:=pMoniker; //Запоминаем моникер в масиве
Result:=pMoniker.BindToStorage(NIL, NIL, IPropertyBag, PropertyName); //Линкуем моникер устройства к формату хранения IPropertyBag
if FAILED(Result) then Continue;
Result:=PropertyName.Read('FriendlyName', DeviceName, NIL); //Получаем имя устройства
if FAILED(Result) then Continue;
//Добавляем имя устройства в списки
Listbox1.Items.Add(DeviceName);
//combobox1.Items.Add(DeviceName);
end;


//Первоначальный выбор устройств для захвата видео
//Выбираем из спиcка камеру
if ListBox1.Count=0 then
   begin
      ShowMessage('Камера не обнаружена');
      Result:=E_FAIL;;
      Exit;
   end;
Listbox1.ItemIndex:=0;

//если все ОК
Result:=S_OK;
end;


procedure TphotoXsign.Button11Click(Sender: TObject);
//Вызов страницы свойств Web-камеры
var
  StreamConfig: IAMStreamConfig;
  PropertyPages: ISpecifyPropertyPages;
  Pages: CAUUID;
begin
timer1.Enabled:=false;
  // Если отсутствует интерфейс работы с видео, то завершаем работу
  if FVideoCaptureFilter = NIL then EXIT;
  // Останавливаем работу графа
  FMediaControl.Stop;
  try
    // Ищем интерфейс управления форматом данных выходного потока
    // Если интерфейс найден, то ...
    if SUCCEEDED(FCaptureGraphBuilder.FindInterface(@PIN_CATEGORY_CAPTURE,
      @MEDIATYPE_Video, FVideoCaptureFilter, IID_IAMStreamConfig, StreamConfig)) then
    begin
      // ... пытаемся найти интерфейс управления страницами свойств ...
      // ... и, если он найден, то ...
      if SUCCEEDED(StreamConfig.QueryInterface(ISpecifyPropertyPages, PropertyPages)) then
      begin
        // ... получаем массив страниц свойств
        PropertyPages.GetPages(Pages);
        PropertyPages := NIL;

        // Отображаем страницу свойств в виде модального диалога
        OleCreatePropertyFrame(
           Handle,
           0,
           0,
           PWideChar(ListBox1.Items.Strings[listbox1.ItemIndex]),
           1,
           @StreamConfig,
           Pages.cElems,
           Pages.pElems,
           0,
           0,
           NIL
        );

        // Освобождаем память
        StreamConfig := NIL;
        CoTaskMemFree(Pages.pElems);
      end;
    end;

  finally
    // Восстанавливаем работу графа
    FMediaControl.Run;
    timer1.Enabled:=true;
  end;
end;



function TphotoXsign.CreateGraph:HResult;

var
  pConfigMux: IConfigAviMux;
begin
//Чистим граф
  FVideoCaptureFilter  := NIL;
  FVideoWindow         := NIL;
  FMediaControl        := NIL;
  FSampleGrabber       := NIL;
  FBaseFilter          := NIL;
  FCaptureGraphBuilder := NIL;
  FGraphBuilder        := NIL;

//Создаем объект для графа фильтров
Result:=CoCreateInstance(CLSID_FilterGraph, NIL, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, FGraphBuilder);
if FAILED(Result) then EXIT;
// Создаем объект для граббинга
Result:=CoCreateInstance(CLSID_SampleGrabber, NIL, CLSCTX_INPROC_SERVER, IID_IBaseFilter, FBaseFilter);
if FAILED(Result) then EXIT;
//Создаем объект для графа захвата
Result:=CoCreateInstance(CLSID_CaptureGraphBuilder2, NIL, CLSCTX_INPROC_SERVER, IID_ICaptureGraphBuilder2, FCaptureGraphBuilder);
if FAILED(Result) then EXIT;

// Добавляем фильтр в граф
Result:=FGraphBuilder.AddFilter(FBaseFilter, 'GRABBER');
if FAILED(Result) then EXIT;
// Получаем интерфейс фильтра перехвата
Result:=FBaseFilter.QueryInterface(IID_ISampleGrabber, FSampleGrabber);
if FAILED(Result) then EXIT;

  if FSampleGrabber <> NIL then
  begin
    //обнуляем память
    ZeroMemory(@MediaType, sizeof(AM_MEDIA_TYPE));
    // Устанавливаем формат данных для фильтра перехвата
    with MediaType do
    begin
      majortype  := MEDIATYPE_Video;
      subtype    := MEDIASUBTYPE_RGB24;
      formattype := FORMAT_VideoInfo;
    end;

    FSampleGrabber.SetMediaType(MediaType);

    // Данные будут записаны в буфер в том виде, в котором они
    // проходят через фильтр
    FSampleGrabber.SetBufferSamples(TRUE);

    // Граф не будет остановлен для получения кадра
    FSampleGrabber.SetOneShot(FALSE);
  end;

//Задаем граф фильтров
Result:=FCaptureGraphBuilder.SetFiltergraph(FGraphBuilder);
if FAILED(Result) then EXIT;

//выбор устройств ListBox - ов
if Listbox1.ItemIndex>=0 then
           begin
              //получаем устройство для захвата видео из списка моникеров
              MArray1[Listbox1.ItemIndex].BindToObject(NIL, NIL, IID_IBaseFilter, FVideoCaptureFilter);
              //добавляем устройство в граф фильтров
              FGraphBuilder.AddFilter(FVideoCaptureFilter, 'VideoCaptureFilter'); //Получаем фильтр графа захвата
           end;

//Задаем, что откуда будем получать и куда оно должно выводиться
Result:=FCaptureGraphBuilder.RenderStream(@PIN_CATEGORY_PREVIEW, nil, FVideoCaptureFilter ,FBaseFilter  ,nil);
if FAILED(Result) then EXIT;

//Получаем интерфейс управления окном видео
Result:=FGraphBuilder.QueryInterface(IID_IVideoWindow, FVideoWindow);
if FAILED(Result) then EXIT;
//Задаем стиль окна вывода
FVideoWindow.put_WindowStyle(WS_CHILD or WS_CLIPSIBLINGS);
//Накладываем окно вывода на  Panel1
//FVideoWindow.put_Owner(Panel1.Handle);
//Задаем размеры окна во всю панель
//FVideoRect:=Panel1.ClientRect;
FVideoWindow.SetWindowPosition(FVideoRect.Left,FVideoRect.Top, FVideoRect.Right - FVideoRect.Left,FVideoRect.Bottom - FVideoRect.Top);
//показываем окно
FVideoWindow.put_Visible(TRUE);

//Запрашиваем интерфейс управления графом
Result:=FGraphBuilder.QueryInterface(IID_IMediaControl, FMediaControl);
if FAILED(Result) then Exit;
//Запускаем отображение просмотра с вебкамер
FMediaControl.Run();
end;

//с помощью этой функции будем грабить изображение
function TphotoXsign.CaptureBitmap: HResult;

var
  bSize: integer;
  pVideoHeader: TVideoInfoHeader;
  MediaType: TAMMediaType;
  BitmapInfo: TBitmapInfo;
  Buffer: Pointer;
  tmp: array of byte;
  Bitmap: TBitmap;

begin
  // Результат по умолчанию
  Result := E_FAIL;

  // Если  отсутствует интерфейс фильтра перехвата изображения,
  // то завершаем работу
  if FSampleGrabber = NIL then EXIT;

  // Получаем размер кадра
    Result := FSampleGrabber.GetCurrentBuffer(bSize, NIL);
    if (bSize <= 0) or FAILED(Result) then EXIT;
  // Создаем изображение
  Bitmap := TBitmap.Create;
  try
  //обнуляем память
  ZeroMemory(@MediaType, sizeof(TAMMediaType));
  // Получаем тип медиа потока на входе у фильтра перехвата
  Result := FSampleGrabber.GetConnectedMediaType(MediaType);
  if FAILED(Result) then EXIT;

    // Копируем заголовок изображения
    pVideoHeader := TVideoInfoHeader(MediaType.pbFormat^);
    ZeroMemory(@BitmapInfo, sizeof(TBitmapInfo));
    CopyMemory(@BitmapInfo.bmiHeader, @pVideoHeader.bmiHeader, sizeof(TBITMAPINFOHEADER));

    Buffer := NIL;

    // Создаем побитовое изображение
    Bitmap.Handle := CreateDIBSection(0, BitmapInfo, DIB_RGB_COLORS, Buffer, 0, 0);

    // Выделяем память во временном массиве
    SetLength(tmp, bSize);

    try
      // Читаем изображение из медиа потока во временный буфер
      FSampleGrabber.GetCurrentBuffer(bSize, @tmp[0]);

      // Копируем данные из временного буфера в наше изображение
      CopyMemory(Buffer, @tmp[0], MediaType.lSampleSize);


    except

      // В случае сбоя возвращаем ошибочный результат
      Result := E_FAIL;
    end;
    image1.Picture.Assign(bitmap);
  finally
    // Освобождаем память
    SetLength(tmp, 0);
    Bitmap.Free;

  end;
end;



// процедура загрузки размеров фотографий из ini файла в ComboBox

procedure TphotoXsign.ListBox1DblClick(Sender: TObject);
begin
if ListBox1.Count=0 then
    Begin
       ShowMessage('Камера не найдена');
       Exit;
    End;
//перестраиваем  граф при смене камеры
if FAILED(CreateGraph) then
    Begin
      ShowMessage('Внимание! Произошла ошибка при построении графа фильтров');
      Exit;
    End;
//Panel2.Caption:='Режим просмотра';
end;

procedure TphotoXsign.LoadComboText;
    var
      IniF,ini: TIniFile;
      i:integer;
      b: string;
     begin
      iniF := TIniFile.Create(ExtractFilePath(Application.ExeName)+'rfoto.ini');
      for i := 1 to 4 do begin
      b := IniF.ReadString('SECTION',inttostr(i),'не читается файл');
      photoXsign.ComboBox2.Items.Add(b);
      end;
      IniF.Free;
      ini:=TiniFile.Create(ExtractFilePath(Application.ExeName)+'size.ini');
      combobox2.ItemIndex:=ini.readInteger('foto', 'F', combobox2.ItemIndex);
      ini.Free;

    end;

 procedure TphotoXsign.LoadComboText2;
    var
      IniF,ini: TIniFile;
      i:integer;
      b: string;
    begin
      iniF := TIniFile.Create(ExtractFilePath(Application.ExeName)+'rpodp.ini');
      for i := 1 to 4 do begin
      b := IniF.ReadString('SECTION',inttostr(i),'не читается файл');
      photoXsign.ComboBox3.Items.Add(b);
    end;
      IniF.Free;
      ini:=TiniFile.Create(ExtractFilePath(Application.ExeName)+'size.ini');
      combobox3.ItemIndex:=ini.readInteger('sign', 'S', combobox3.ItemIndex);
      ini.Free;


    end;







// процедуры  используются для передвижения прицельной рамки по изображения, а так же контроль выхода рамки за пределы.

procedure TphotoXsign.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   move := true;
  x0 := x;
  y0 := y;
end;

procedure TphotoXsign.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move := false;
end;

procedure TphotoXsign.Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
VAR Left,Top :Integer;
begin
    if move = true then
  begin
    Left := Shape1.Left + X - X0;
    Top := Shape1.top + Y - Y0;
    IF Left<Image1.Left THEN Left:=Image1.Left;
    IF Top<Image1.top THEN Top:=Image1.top;
    IF Left+Shape1.Width>Image1.Left+Image1.Width THEN Left:=Image1.Left+Image1.Width-Shape1.Width;
    IF Top+Shape1.Height>Image1.top+Image1.Height THEN Top:=Image1.top+Image1.Height-Shape1.Height;
    Shape1.Left := Left;
    Shape1.top  := Top;
    shape3.Left:=Left+25;
    shape3.Top:=top+25;
  end;
end;


procedure TphotoXsign.Shape2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   move := true;
  x0 := x;
  y0 := y;
end;

procedure TphotoXsign.Shape2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move := false;
end;


procedure TphotoXsign.Shape2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
VAR Left,Top :Integer;
begin
    if move = true then
  begin
    Left := Shape2.Left + X - X0;
    Top := Shape2.top + Y - Y0;
    IF Left<Image3.Left THEN Left:=Image3.Left;
    IF Top<Image3.top THEN Top:=Image3.top;
    IF Left+Shape2.Width>Image3.Left+Image3.Width THEN Left:=Image3.Left+Image3.Width-Shape2.Width;
    IF Top+Shape2.Height>Image3.top+Image3.Height THEN Top:=Image3.top+Image3.Height-Shape2.Height;
    Shape2.Left := Left;
    Shape2.top  := Top;
  end;
end;


procedure TphotoXsign.Button10Click(Sender: TObject);
begin
   if checkbox1.Checked then
     begin
     Image4.Width  := (x4-x2);
     Image4.Height := (y3-y1);
     Image4.Canvas.Draw(round(-(Shape2.Left-image3.Left)), round(-(Shape2.top-image3.Top)), Image3.Picture.Graphic);
     image4.Visible:=true;
     end else
         begin
         image4.Width:=image3.Width;
         image4.Height:=image3.Height;
         Image4.Canvas.Draw(0, 0, Image3.Picture.Graphic);
         image4.Visible:=true;
         end;
     end;

procedure TphotoXsign.Button1Click(Sender: TObject);
var i,c:integer;
    ini:Tinifile;
    swh:string;
    n:word;


begin

if FAILED(CreateGraph) then
            Begin
              ShowMessage('Внимание! Произошла ошибка при построении графа фильтров');
              Exit;
            End;

   c:=length(combobox2.Text);
   if c>0 then
        begin
       if fileexists(ExtractFilePath(Application.ExeName)+'shape.ini') then
        begin
          ini:=TiniFile.Create(ExtractFilePath(Application.ExeName)+'shape.ini');
          shape1.Left:=ini.ReadInteger('shleft', 'L', shape1.Left);
          sw:=ini.ReadInteger('shwidth', 'W', shape1.Width);
          shape1.Top:=ini.ReadInteger('shtop', 'T', shape1.top);
          sh:=ini.ReadInteger('shheight', 'H', shape1.Height);
          ini.Free;
          swh:=combobox2.Text;
          i:=length(swh);
          n:=pos('*',swh);
          fw:=strtoint(copy(swh,1,n-1));
          fh:=strtoint(copy(swh,n+1,(i-(n))));
        end else
         begin
          swh:=combobox2.Text;
          i:=length(swh);
          n:=pos('*',swh);
          sw:=strtoint(copy(swh,1,n-1));
          sh:=strtoint(copy(swh,n+1,(i-(n))));
          fh:=sh;
          fw:=sw;
          end;
       //cam:=CamList[ComboBox1.ItemIndex];
     // if(cam.Start)then
      //  begin
      // ComboBox1.Enabled:=false;
     //  comboBox2.Enabled:=false;
      // Timer1.Enabled:=true;
     //  end;


       end else showmessage('Не выбран размер фото!');

     c:=length(combobox2.Text);
     if c>0 then
        begin
      //cam:=CamList[ComboBox1.ItemIndex];
     // if(cam.Start)then
      //  begin
       //ComboBox1.Enabled:=false;
       comboBox2.Enabled:=false;
       Timer1.Enabled:=true;
      // end;
       end else showmessage('Не выбран размер фото!');

       end;



// делаем фото снимок заданной области и отображаем на Image2
procedure TphotoXsign.Button2Click(Sender: TObject);
var L,R,B,T:Extended;
    ini: TIniFile;
  begin


{  if fileexists(ExtractFilePath(Application.ExeName)+'shape.ini') then
                                                                  begin

                                                                  end else
                                                                  begin }
                                                                    ini:=TiniFile.Create(ExtractFilePath(Application.ExeName)+'shape.ini');
                                                                    ini.WriteInteger('shleft', 'L', shape1.Left);
                                                                    ini.WriteInteger('shwidth', 'W', shape1.Width);
                                                                    ini.WriteInteger('shtop', 'T', shape1.top);
                                                                    ini.WriteInteger('shheight', 'H', shape1.Height);
                                                                    ini.Free;
                                                           //       end;


  L:=(Shape1.Left-Image1.Left);
  R:=L+(Shape1.Width);
  B:=(Shape1.top-image1.top);
  T:=B+(Shape1.Height);

  image2.Visible:=true;
  Image2.Width  := round(R-L);
  Image2.Height := round(T-B);
  Image2.Canvas.Draw(round(-l), round(-b), Image1.Picture.Graphic);

end;



procedure SetResJpg(name: string; dpix, dpiy: Integer);
const
  BufferSize = 50;
  DPI = 1; //inch
  DPC = 2; //cm
var
  Buffer: string;
  index: INTEGER;
  FileStream: TFileStream;
  xResolution: WORD;
  yResolution: WORD;
  _type: Byte;
begin
  FileStream := TFileStream.Create(name,
    fmOpenReadWrite);
  try
    SetLength(Buffer, BufferSize);
    FileStream.Read(buffer[1], BufferSize);
    index := POS('JFIF' + #$00, buffer);
    if index > 0
      then begin
      FileStream.Seek(index + 6, soFromBeginning);
      _type := DPI;
      FileStream.write(_type, 1);
      xresolution := swap(dpix);
      FileStream.write(xresolution, 2);
      yresolution := swap(dpiy);
      FileStream.write(yresolution, 2);
    end
  finally
    FileStream.Free;
  end;
end;



Procedure ReSizeJpeg(var jpg:TJpegImage; NewWidth,NewHeight:integer);
var
 bmp,sbmp:Tbitmap;
begin
 bmp:=Tbitmap.create;
 bmp.assign(jpg);
 sbmp:=Tbitmap.create;
 sbmp.width:=NewWidth;
 sbmp.Height:=NewHeight;
 sbmp.pixelFormat:=pf24bit;
 SetStretchBltMode(sbmp.canvas.handle,4);// мягкое растягивание
 StretchBlt(sbmp.canvas.handle,0,0,NewWidth,NewHeight,bmp.canvas.handle,
               0,0,bmp.width,bmp.height,SRCCOPY);
 jpg.assign(sbmp);
 jpg.CompressionQuality := 100;
 jpg.compress;
 sbmp.free;
 bmp.free;
end;






//сохранение полученной фотографии
procedure TphotoXsign.Button3Click(Sender: TObject);
var jpgImg: TJPEGImage;

begin
if image2.Visible=false then
                   begin
                    showmessage('Нет фотографии для сохранения!');
                   end else
                       begin
                       if savedialog1.Execute then
                       begin
                       jpgImg := TJPEGImage.Create;
                       jpgimg.CompressionQuality:=100;
                       jpgImg.Assign(image2.Picture.Graphic);
                       reSizeJpeg(JpgImg,fw,fh);
                       jpgimg.Compress;
                       jpgImg.SaveToFile(savedialog1.FileName+'.jpg');
                       SetResJpg(savedialog1.FileName+'.jpg',300,300);
                       jpgImg.Free;
                       image2.Picture.Bitmap:=nil;
                       end;
                       end;
end;

//создание формы, инициализация камеры, добавление списка всех камер в ComboBox для дальнейшего выбора
//проверка наличия подключенных камер к компьютеру
procedure TphotoXsign.FormClose(Sender: TObject; var Action: TCloseAction);
var ini:Tinifile;
begin
                                             ini:=TiniFile.Create(ExtractFilePath(Application.ExeName)+'size.ini');
                                                                    ini.WriteInteger('foto', 'F', combobox2.ItemIndex);
                                                                    ini.WriteInteger('sign', 'S', combobox3.ItemIndex);
                                                                    ini.Free;
end;

procedure TphotoXsign.FormCreate(Sender: TObject);
var i:integer;

begin
///
CoInitialize(nil);// инициализировать OLE COM
//вызываем процедуру поиска и инициализации устройств захвата видео и звука
if FAILED(Initializ) then
    Begin
      ShowMessage('Внимание! Произошла ошибка при инициализации');
      Exit;
    End;
//проверяем найденный список устройств
if Listbox1.Count>0 then
    Begin
        //если необходимые для работы устройства найдены,
        //то вызываем процедуру построения графа фильтров
       { if FAILED(CreateGraph) then
            Begin
              ShowMessage('Внимание! Произошла ошибка при построении графа фильтров');
              Exit;
            End;}
       // Panel2.Caption:='Режим просмотра';
    end else
            Begin
              ShowMessage('Внимание! Камера не обнаружена.');
              //Application.Terminate;
            End;

  ///
   timer1.Enabled:=false;

   LoadComboText;
   LoadComboText2;
  // CamList:=TCamList.Create;
  // CamList.Emumerate;
   {if(CamList.count=0)then
     begin
      ShowMessage('Подключенные камеры не обнаружены!');
       Application.Terminate;
       exit;
       end; }
    { ComboBox1.items.BeginUpdate;
     try
     ComboBox1.items.Clear;
       for i:=0 to CamList.count-1 do
        ComboBox1.items.AddObject(CamList[i].Name,CamList[i]);
        ComboBox1.ItemIndex:=0;
     finally
     ComboBox1.items.EndUpdate;
    end;    }

 end;

procedure TphotoXsign.FormDestroy(Sender: TObject);
begin
    pEnum := NIL;
        pDevEnum := NIL;
        pMoniker := NIL;
        PropertyName := NIL;
        DeviceName:=Unassigned;
        CoUninitialize;// деинициализировать OLE COM
end;

procedure TphotoXsign.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
sw:=sw-1;
sh:=sh-1;


end;

procedure TphotoXsign.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
 sw:=sw+1;
 sh:=sh+1;

end;

// получаем изображение с камеры, создаем прицельную рамку Shape и используем
//возможности выбора нужного фрагмента для фотографии
procedure TphotoXsign.Timer1Timer(Sender: TObject);
//var bmp  : TBitmap;
    begin
        shape1.Width:=sw;
        shape1.Height:=sh;
       // bmp:=TBitmap.Create;
        shape1.pen.Color:=cLred;
        shape1.Brush.Style:=bsclear;
        shape1.Visible:=true;
        shape3.Left:=shape1.Left+25;
        shape3.Top:=shape1.Top+25;
        shape3.Width:=shape1.Width-50;
        shape3.Height:=shape1.Height-50;
        shape3.pen.Color:=cLred;
        shape3.Brush.Style:=bsclear;
        shape3.Visible:=true;
        shape1.OnMouseDown:= Shape1MouseDown;
        shape1.OnMouseMove:=Shape1MouseMove;
        shape1.OnMouseUp:=Shape1MouseUp;

      //capturebitmap;

     if FAILED(CaptureBitmap) then
    Begin
      ShowMessage('Внимание! Произошла ошибка при получении изображения');
      Exit;
    End;
     //image1.Picture.LoadFromFile('C:\test.bmp');
     // image1.Width:=640;
      //image1.Height:=480;
     //image1.Stretch:=true;
     // cam.CaptureBMP(bmp,0,0);
      //Image1.Picture.Assign(bmp);

      //bmp.Destroy;

 end;

// функция перевода цветного изображения в черно-белое
function RgbToGray(RGBColor : TColor) : TColor;
var Gray : byte;
begin
Gray:=Round((0.30*GetRValue(RGBColor))+(0.59*GetGValue(RGBColor))+(0.11*GetBValue(RGBColor)));
Result:=RGB(Gray, Gray, Gray);
end;

procedure TphotoXsign.Button4Click(Sender: TObject);
var i,j: integer;
    c,d: TColor;
begin
if image2.Visible=false then
                   begin
                    showmessage('Нет фотографии для преобразования!');
                   end else
                   begin
Label1.Caption:='Подождите пожалуйста!';
Label1.Visible:=True;
//image2.Picture.Bitmap.Monochrome:=true;
Application.ProcessMessages;
for i:=Image2.left to Image2.Left+Image2.Picture.Width do
for j:=Image2.Top to +Image2.Top+Image2.Picture.Height do
begin
c:=Image2.Picture.Bitmap.Canvas.Pixels[i-Image2.Left,j-Image2.Top];
d:=RgbToGray(c);
Image2.Picture.Bitmap.Canvas.Pixels[i-Image2.Left,j-Image2.Top]:=d;
end;
Label1.Visible:=False;
Application.ProcessMessages;
end;
end;


 procedure TphotoXsign.Button5Click(Sender: TObject);
var
  usbDevices : IUsbDevices;
  usbDevice  : IUsbDevice;
begin
checkbox1.Enabled:=true;
button10.Enabled:=true;
//image4.Visible:=true;
    usbDevices := CoUsbDevices.Create();
    if (usbDevices.Count > 0) then
   begin
     try
        begin
          usbDevice := usbDevices.Item[0];
          Form2.connect(usbDevice);
          form2.Position:=poScreenCenter;
          Form2.ShowModal();
        end;
      except
        on e : Exception do
          ShowMessage(e.Message);
      end;
    end
    else
    begin
      ShowMessage('Нет подключенных устройств Wacom');
    end;
end;


procedure TphotoXsign.Button6Click(Sender: TObject);
var color:Tcolor;
     L,B:integer;

begin

 //отсечка по перхней грани
  color:=clwhite;
  x:=1;
  y:=1;
  while color=clwhite do
     begin
       color:=image3.Canvas.Pixels[x,y];
       if x=288 then
                  begin
                    x:=0; y:=y+1;
                  end;
        x:=x+1;

     end;
   y1:=y-10;


//отсечка по левой грани

  x:=1;
  y:=1;
 color:=clwhite;
  while color<>clblack do
     begin
       color:=image3.Canvas.Pixels[x,y];
       if y=112 then
                  begin
                    y:=1; x:=x+1;
                  end;
             y:=y+1;
     end;
  x2:=x-10;



//отсечка по нижней грани
  color:=clwhite;
  x:=1;
  y:=112;
  while color<>clblack do
     begin
       color:=image3.Canvas.Pixels[x,y];
       if x=288 then
                  begin
                    x:=0; y:=y-1;
                  end;
        x:=x+1;
     end;
   y3:=y+10;


//отсечка по правой грани
  color:=clwhite;
  x:=288;
  y:=1;
  while color<>clblack do
     begin
       color:=image3.Canvas.Pixels[x,y];
       if y=112 then
                  begin
                    x:=x-1; y:=1;
                  end;
             y:=y+1;
     end;
  x4:=x+10;


      shape2.Left:=image3.left+x2;
      shape2.Top:=image3.top+y1;
      shape2.Width:=(x4-x2);
      shape2.Height:=(y3-y1);
      shape2.pen.Color:=cLRed;
      shape2.Brush.Style:=bsclear;
      shape2.Visible:=true;
      sw1:=shape2.Width;
      sh1:=shape2.Height;
      L:=Shape2.Left-image3.Left;
      B:=Shape2.top-image3.Top;

    { Image4.Width  := (x4-x2);
     Image4.Height := (y3-y1);
     Image4.Canvas.Draw(round(-l), round(-b), Image3.Picture.Graphic);
     image4.Visible:=true; }



 end;


procedure TphotoXsign.Button7Click(Sender: TObject);
var jpgImg2: TJPEGImage;
 begin
if image4.Visible=false then
                   begin
                    showmessage('Нет подписи для сохранения!');
                   end else
                   begin
                      if savedialog1.Execute then
                       begin
                       sw1:=image4.Width;
                       sh1:=image4.Height;
                       jpgImg2 := TJPEGImage.Create;
                       jpgImg2.Assign(image4.Picture.Bitmap);
                       reSizeJpeg(JpgImg2,sw1,sh1);
                       jpgImg2.SaveToFile(savedialog1.FileName+'.jpg');
                       jpgImg2.Free;
                       image3.Picture.Bitmap:=nil;
                       image4.Picture.Bitmap:=nil;
                       shape2.Visible:=false;
                       checkbox1.Checked:=false;
                       combobox3.Enabled:=true;
                       end;
                      end;

end;





procedure TphotoXsign.Button8Click(Sender: TObject);
 var
   i,n,s:integer;
   swh:string;
  jpg:TJPEGImage;
 begin

     jpg := TJPEGImage.Create;
     jpg.Performance:=jpBestQuality;
     if OpenDialog1.Execute then
      begin
      jpg.LoadFromFile(OpenDialog1.FileName);
      bmpmain := TBitmap.Create;
      bmpmain.PixelFormat := pf32bit;
      bmpmain.Assign(jpg)
      end;

        i:=length(combobox2.Text);
         if i>0 then
                begin
                  swh:=combobox2.Text;
                  s:=length(swh);
                  n:=pos('*',swh);
                  spw1:=strtoint(copy(swh,1,n-1));
                  sph1:=strtoint(copy(swh,n+1,(s-(n))));
          fw:=spw1;
          fh:=sph1;
                 shu:=1;
          Application.CreateForm(Topenfromfile, openfromfile);
          openfromfile.Position:=poScreenCenter;
          openfromfile.ShowModal();
          openfromfile.destroy;
         end else   showmessage('Не выбран размер фотографии!');

end;

procedure TphotoXsign.Button9Click(Sender: TObject);
var i,n,s:integer;
   swh:string;
   jpg:TJPEGImage;
begin
       jpg := TJPEGImage.Create;
       jpg.Performance:=jpBestQuality;
      if OpenDialog1.Execute then
      begin
      jpg.LoadFromFile(OpenDialog1.FileName);
      bmpmain := TBitmap.Create;
      bmpmain.PixelFormat := pf32bit;
      bmpmain.Assign(jpg);

       end;




         i:=length(combobox3.Text);
         if i>0 then
                begin
                  swh:=combobox3.Text;
                  s:=length(swh);
                  n:=pos('*',swh);
                  sw1:=strtoint(copy(swh,1,n-1));
                  sh1:=strtoint(copy(swh,n+1,(s-(n))));
                  shu:=0;
                 combobox3.Enabled:=false;
                 Application.CreateForm(Topenfromfile, openfromfile);
                 openfromfile.Position:=poScreenCenter;
                 openfromfile.ShowModal();
                 openfromfile.destroy;
                end
                else showmessage('Не выбран размер подписи!');

end;

procedure TphotoXsign.CheckBox1Click(Sender: TObject);
begin
if checkbox1.Checked=true then
                            begin
                            button6.Enabled:=true;
                            end;
if checkbox1.Checked=false then
                            begin
                            button6.Enabled:=false;
                            end;
end;



end.
