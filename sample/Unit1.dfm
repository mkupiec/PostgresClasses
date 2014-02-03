object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 397
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 356
    Width = 594
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitWidth = 516
    object ButtonConnect: TButton
      Left = 16
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 0
      OnClick = ButtonConnectClick
    end
    object ButtonPrepare: TButton
      Left = 177
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Prepare'
      TabOrder = 1
      OnClick = ButtonPrepareClick
    end
    object ButtonGetData: TButton
      Left = 339
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Get Data'
      TabOrder = 2
      OnClick = ButtonGetDataClick
    end
    object ButtonGetParamData: TButton
      Left = 420
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Get P Data'
      TabOrder = 3
      OnClick = ButtonGetParamDataClick
    end
    object ButtonSetData: TButton
      Left = 258
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Set Data'
      TabOrder = 4
      OnClick = ButtonSetDataClick
    end
    object ButtonClear: TButton
      Left = 501
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 5
      OnClick = ButtonClearClick
    end
    object ButtonCreateTable: TButton
      Left = 96
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Create Tbl'
      TabOrder = 6
      OnClick = ButtonCreateTableClick
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 594
    Height = 356
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitWidth = 516
  end
end
