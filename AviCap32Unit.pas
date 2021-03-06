unit AviCap32Unit;
interface
uses windows,Messages;
const
  WM_CAP_START = WM_USER;
//  WM_CAP_GET_CAPSTREAMPTR = WM_CAP_START + 1;
//  WM_CAP_SET_CALLBACK_ERROR=WM_CAP_START+2;
{  WM_CAP_SET_CALLBACK_STATUS=WM_CAP_START+3;
  WM_CAP_SET_CALLBACK_YIELD=WM_CAP_START+4;
  WM_CAP_SET_CALLBACK_FRAME=WM_CAP_START+5;
  WM_CAP_SET_CALLBACK_VIDEOSTREAM=WM_CAP_START+6;
  WM_CAP_SET_CALLBACK_WAVESTREAM=WM_CAP_START+7;
  WM_CAP_GET_USER_DATA=WM_CAP_START+8;
  WM_CAP_SET_USER_DATA=WM_CAP_START+9;
  }
  WM_CAP_DRIVER_CONNECT = WM_CAP_START + 10;
{  WM_CAP_DRIVER_DISCONNECT = WM_CAP_START + 11;
  WM_CAP_DRIVER_GET_NAME=WM_CAP_START+12;
  WM_CAP_DRIVER_GET_VERSION=WM_CAP_START+13;
  WM_CAP_DRIVER_GET_CAPS=WM_CAP_START+14;
  WM_CAP_FILE_SET_CAPTURE_FILEA = WM_CAP_START + 20;
  WM_CAP_FILE_GET_CAPTURE_FILE=WM_CAP_START+21;
  WM_CAP_FILE_ALLOCATE=WM_CAP_START+22;
  WM_CAP_FILE_SAVEAS=WM_CAP_START+23;
  WM_CAP_FILE_SAVEDIB=WM_CAP_START+25;
  WM_CAP_FILE_SET_INFOCHUNK=WM_CAP_START+24;
  WM_CAP_EDIT_COPY=WM_CAP_START+30;
  WM_CAP_DLG_VIDEOFORMAT = WM_CAP_START + 41;
  WM_CAP_DLG_VIDEOSOURCE = WM_CAP_START + 42;
  }
  WM_CAP_GRAB_FRAME = WM_CAP_START + 60;
{  WM_CAP_SEQUENCE = WM_CAP_START + 62;}
  WM_CAP_STOP = WM_CAP_START + 68;

function capCreateCaptureWindowA(
  lpszWindowName : PAnsiCHAR;
  dwStyle : longint;
  x : integer;
  y : integer;
  nWidth : integer;
  nHeight : integer;
  ParentWin : HWND;
  nId : integer): HWND; stdcall external 'AVICAP32.DLL';

function capGetDriverDescriptionA(
  wDriverIndex        : UINT;
  lpszName            : LPSTR;
  cbName              : Integer;
  lpszVer             : LPSTR;
  cbVer               : Integer): BOOL; stdcall; external 'AVICAP32.DLL';

implementation
end.
