object FormConnParams: TFormConnParams
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Connection params'
  ClientHeight = 288
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 247
    Width = 428
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitLeft = 24
    ExplicitTop = 232
    ExplicitWidth = 185
    object BitBtn1: TBitBtn
      Left = 175
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkOK
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 428
    Height = 247
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 32
    ExplicitTop = 48
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Label1: TLabel
      Left = 48
      Top = 35
      Width = 46
      Height = 13
      Caption = 'Database'
    end
    object Label2: TLabel
      Left = 48
      Top = 62
      Width = 25
      Height = 13
      Caption = 'Login'
    end
    object Label3: TLabel
      Left = 48
      Top = 89
      Width = 46
      Height = 13
      Caption = 'Database'
    end
    object EditDatabase: TEdit
      Left = 120
      Top = 32
      Width = 257
      Height = 21
      TabOrder = 0
      Text = 'postgres'
    end
    object EditLogin: TEdit
      Left = 120
      Top = 59
      Width = 257
      Height = 21
      TabOrder = 1
      Text = 'postgres'
    end
    object EditPassword: TEdit
      Left = 120
      Top = 86
      Width = 257
      Height = 21
      TabOrder = 2
      Text = 'root'
    end
  end
end
