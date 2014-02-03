unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TFormConnParams = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    EditDatabase: TEdit;
    EditLogin: TEdit;
    Label2: TLabel;
    EditPassword: TEdit;
    Label3: TLabel;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConnParams: TFormConnParams;

implementation

{$R *.dfm}

end.
