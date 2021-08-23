object openfromfile: Topenfromfile
  Left = 0
  Top = 0
  Caption = 'openfromfile'
  ClientHeight = 648
  ClientWidth = 883
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 200
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Label1'
    Visible = False
  end
  object Image2: TImage
    Left = 16
    Top = 16
    Width = 105
    Height = 105
  end
  object Image3: TImage
    Left = 636
    Top = 8
    Width = 105
    Height = 105
    Visible = False
  end
  object TrackBar1: TTrackBar
    Left = 144
    Top = 39
    Width = 150
    Height = 45
    TabOrder = 0
    Visible = False
    OnChange = TrackBar1Change
  end
  object Button2: TButton
    Left = 776
    Top = 16
    Width = 91
    Height = 25
    Caption = #1054#1073#1088#1077#1079#1072#1090#1100
    ImageIndex = 7
    Images = photoXsign.ImageList1
    TabOrder = 1
    OnClick = Button2Click
  end
  object ScrollBox1: TScrollBox
    Left = 32
    Top = 144
    Width = 825
    Height = 481
    TabOrder = 2
    object Image1: TImage
      Left = 3
      Top = 0
      Width = 831
      Height = 457
      Stretch = True
    end
    object Shape1: TShape
      Left = 50
      Top = 21
      Width = 121
      Height = 145
      Visible = False
      OnMouseDown = Shape1MouseDown
      OnMouseMove = Shape1MouseMove
      OnMouseUp = Shape1MouseUp
    end
    object Shape2: TShape
      Left = 87
      Top = 61
      Width = 49
      Height = 57
      Shape = stEllipse
      Visible = False
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = #1092#1086#1090#1086','#1087#1086#1076#1087#1080#1089#1100'|*.jpg'
    Top = 520
  end
end
