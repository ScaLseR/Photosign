 unit CamCaptureUnit;
       interface
       uses Windows,Graphics,AviCap32Unit;
       type TCamera=class

          protected
            FWidth    : integer;
            FHeight   : integer;
                   FCamIndex : integer;
                  Fh        : THandle;
                  FName     : string;
                   FVer      : string;

          public
             Constructor Create;

            Destructor Destroy; override;

            function Start():boolean;

            function CaptureBMP(bmp:TBitmap;X:integer;Y:integer):boolean;

            property CamIndex:integer read FCamIndex write FCamIndex;

            property Name:string read FName write FName;

            property Ver:string read FVer write FVer;

          end;

         TCamList=class

          protected

            FList : array of TCamera;

            function FGetCount:integer;

            function FGetItem(index:integer):TCamera;

          public

            procedure Emumerate();

            property count:integer read FGetCount;

            property List[index:integer]:TCamera read FGetItem; default;

          end;



    implementation



    Constructor TCamera.Create;

    begin

      inherited;

      Fh:=0;

      FWidth:=640;

      FHeight:=480;


    end;



    Destructor TCamera.Destroy;

    begin

      if(Fh<>0)then CloseHandle(Fh);

      inherited;

    end;



    function TCamera.Start():boolean;

    begin

      Fh:=capCreateCaptureWindowA('video',

        WS_VISIBLE or WS_CHILD,

        10000,

        10000,

        FWidth,

        FHeight,

        GetDesktopWindow,

        0);

      if(fh<>0)then

        begin

        SendMessage(Fh, WM_CAP_DRIVER_CONNECT, 0, 0);

        result:=true;

        end else

        begin

        result:=false;

        end;

    end;



    function TCamera.CaptureBMP(bmp:TBitmap;x:integer;y:integer):boolean;

    begin

      SendMessage(Fh, WM_CAP_GRAB_FRAME,X,Y);

      bmp.Width:=FWidth;

      bmp.Height:=FHeight;

      BitBlt(BMP.Canvas.Handle,0,0,FWidth,FHeight,GetDC(Fh),0,0,SRCCOPY);

      result:=true;

    end;



    function TCamList.FGetCount:integer;

    begin

      result:=length(FList);

    end;



    function TCamList.FGetItem(index:integer):TCamera;

    begin

      result:=FList[index];

    end;



    procedure TCamList.Emumerate();

    var i       : integer;

        name    : array[0..255]of AnsiChar;

        ver     : array[0..255]of AnsiChar;

        cam     : TCamera;

    begin

     for i:=0 to 9 do

      begin

      if(capGetDriverDescriptionA(i,@name,SizeOf(name),@ver,SizeOf(ver)))then

         begin

         cam:=TCamera.Create;

         cam.Name:=string(name);

         cam.Ver:=string(ver);

         cam.CamIndex:=i;

         SetLength(FList,length(FList)+1);

         FList[High(FList)]:=cam;

         end;

      end;

    end;

    end.
