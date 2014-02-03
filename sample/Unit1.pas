unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, libpq_fe, PostgresClasses;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ButtonConnect: TButton;
    ButtonPrepare: TButton;
    ButtonGetData: TButton;
    Memo1: TMemo;
    ButtonGetParamData: TButton;
    ButtonSetData: TButton;
    ButtonClear: TButton;
    ButtonCreateTable: TButton;
    procedure ButtonConnectClick(Sender: TObject);
    procedure OnButtonGetDataClick(Sender: TObject);
    procedure ButtonPrepareClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonSetDataClick(Sender: TObject);
    procedure ButtonGetDataClick(Sender: TObject);
    procedure ButtonCreateTableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function CheckIsConnected: boolean;
    procedure ButtonGetParamDataClick(Sender: TObject);
    procedure ButtonGetPreparedParamData(Sender: TObject);
    procedure ButtonGetParamDataByNameClick(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    procedure AddToLog(const str: string);
  end;

  TOnButtonClick = procedure (Sender: TObject) of object;

var
  Form1: TForm1;
  iPQ: IPostgres;
  QueryStmt: IPostgresStmt;
  OnGetDataIdx: integer;
  OnButtonClickEvents: array[0..2]of TOnButtonClick;

const
  LINE_WRAP = #$d#$a;
  QUERY_PREPARED = 'select * from sample where id = $1';

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.AddToLog(const str: string);
begin
    Memo1.Lines.Add(str);
end;

//Postgres still thinking all we have Motorola CPU, can be used ntohl or htonl etc instead for binary params
function bswap(v: dword):dword;
asm
  bswap eax
end;

function TForm1.CheckIsConnected: boolean;
begin
    result:= iPQ <> nil;
    if not(result) then begin
      AddToLog('not connected');
      exit;
    end;

    result:= iPQ.IsConnected;
    if not(result) then
      AddToLog('not connected');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    Randomize;
    OnGetDataIdx:= low(OnButtonClickEvents);
    OnButtonClickEvents[0]:= ButtonGetPreparedParamData;
    OnButtonClickEvents[1]:= ButtonGetParamDataClick;
    OnButtonClickEvents[2]:= ButtonGetParamDataByNameClick;
end;

procedure TForm1.OnButtonGetDataClick(Sender: TObject);
begin
    OnButtonClickEvents[OnGetDataIdx](Sender);
    inc(OnGetDataIdx);
    OnGetDataIdx:= OnGetDataIdx mod length(OnButtonClickEvents);
end;

procedure TForm1.ButtonConnectClick(Sender: TObject);
begin
    FormConnParams.ShowModal;
    if FormConnParams.ModalResult <> mrOK then exit;

    iPQ:= TPostgres.Create('', '', FormConnParams.EditDatabase.Text, FormConnParams.EditLogin.Text, FormConnParams.EditPassword.Text);
    if iPQ.Connect then
      AddToLog('connected')
    else AddToLog(iPQ.LastErrorString);
end;

procedure TForm1.ButtonCreateTableClick(Sender: TObject);
var
  pq: IPostgresQuery;
const
  QUERY = 'CREATE TABLE sample ' + LINE_WRAP +
    '(id serial, ' + LINE_WRAP +
    'name varchar(50) default NULL, ' + LINE_WRAP +
    'i_data bytea, ' + LINE_WRAP +
    'CONSTRAINT id_pkey PRIMARY KEY (id))';
begin
    if not(CheckIsConnected) then exit;

    AddToLog(LINE_WRAP + 'creating table "sample"');
    iPQ.Lock;
    try
      pq:= iPQ.ExecQuery(QUERY);
      if pq = nil then exit;
      if pq.Status <> PGRES_COMMAND_OK then
        AddToLog(iPQ.GetError);
    finally
      iPQ.Unlock;
    end;
end;

procedure TForm1.ButtonSetDataClick(Sender: TObject);
var
  i, j: integer;
  pq: IPostgresQuery;
  p: TParam;
  stuff: array[0..$F]of byte;
  name: string;
const
  QUERY = 'insert into sample (name, i_data) values ($1, $2) returning id';
begin
    if not(CheckIsConnected) then exit;

    AddToLog(LINE_WRAP + 'filling table "sample"');

    PQFillParamDefaults(p, 2, PG_PARAMTYPE_BINARY, PG_PARAMTYPE_BINARY);

    name:= '';
    for i := 0 to 10 do begin
      name:= name + char($41 + i);
      p.paramValues[0]:= PAnsiChar(name);
      p.paramLengths[0]:= length(name);
      for j := low(stuff) to high(stuff) do
        stuff[j]:= random($FF);
      p.paramValues[1]:= @stuff;
      p.paramLengths[1]:= sizeof(stuff);

      iPQ.Lock;
      try
        pq:= iPQ.ExecQueryParams(QUERY, @p);
        if pq = nil then exit;
        if pq.Status <> PGRES_TUPLES_OK then begin
          AddToLog(iPQ.GetError);
          exit;
        end;
        if pq.RecordCount <= 0 then exit;

        AddToLog('added id = ' + IntToHex(bswap(PInteger(pq.Value[0, 0])^), 4));
      finally
        iPQ.Unlock;
      end;
    end;
end;

procedure TForm1.ButtonPrepareClick(Sender: TObject);
var
  p: TParam;
begin
    if not(CheckIsConnected) then exit;

    AddToLog(LINE_WRAP + 'preparing ' + QUERY_PREPARED);
    iPQ.Lock;
    try
      p.nParams:= 0;
      p.paramTypes:= nil;
      QueryStmt:= iPQ.Prepare(QUERY_PREPARED, 'StmtGetInfo', @p);
      if QueryStmt = nil then exit;
      if QueryStmt.Status <> PGRES_COMMAND_OK then begin
        AddToLog(iPQ.GetError);
        exit;
      end;
    finally
      iPQ.Unlock;
    end;
end;

procedure TForm1.ButtonGetDataClick(Sender: TObject);
var
  pq: IPostgresQuery;
  i, j: integer;
  temp: string;
const
  QUERY = 'select * from sample';
begin
    if not(CheckIsConnected) then exit;

    AddToLog(LINE_WRAP + QUERY);

    pq:= iPQ.ExecQuery(QUERY);
    if pq = nil then exit;
    if pq.Status <> PGRES_TUPLES_OK then begin
      AddToLog(iPQ.GetError);
      exit;
    end;

    for i := 0 to pq.RecordCount - 1 do begin
      temp:= '';
      for j := 0 to pq.FieldCount - 1 do
        temp:= temp + pq.Value[i, j] + #9;
      AddToLog(temp);
    end;
end;

procedure TForm1.ButtonGetParamDataByNameClick(Sender: TObject);
var
  pq: IPostgresQuery;
  i, j, value, len: integer;
  temp: string;
  p: TParam;
  stuff: array[0..$F]of byte;
const
  QUERY = 'select * from sample where id = $1';
begin
    if not(CheckIsConnected) then exit;

    value:= random(high(stuff));
    AddToLog(LINE_WRAP + QUERY + ' by name, query param = ' + IntToStr(value) + ' result');
    value:= bswap(value);

    PQFillParamDefaults(p, 1, PG_PARAMTYPE_BINARY, PG_PARAMTYPE_BINARY);
    p.paramValues[0]:= @value;
    p.paramLengths[0]:= sizeof(value);

    pq:= iPQ.ExecQueryParams(QUERY, @p);
    if pq = nil then exit;
    if pq.Status <> PGRES_TUPLES_OK then begin
      AddToLog(iPQ.GetError);
      exit;
    end;

    for i := 0 to pq.RecordCount - 1 do begin
      AddToLog('id = ' + IntToStr(bswap(PInteger(pq.ValueByName[0, 'id'])^)));
      AddToLog('name = ' + pq.ValueByName[0, 'name']);
      len:= pq.ValueLen[0, 2];
      if len > sizeof(stuff) then len:= sizeof(stuff);
      move(pq.Value[0, 2]^, stuff, len);
      temp:= '';
      for j := 0 to len - 1 do
        temp:= temp + IntToHex(stuff[j], 2);
      AddToLog('value = ' + temp);
    end;
end;

procedure TForm1.ButtonGetParamDataClick(Sender: TObject);
var
  pq: IPostgresQuery;
  i, j, value, len: integer;
  temp: string;
  p: TParam;
  stuff: array[0..$F]of byte;
const
  QUERY = 'select * from sample where id = $1';
begin
    if not(CheckIsConnected) then exit;

    value:= random(high(stuff));
    AddToLog(LINE_WRAP + QUERY + ' by param, query param = ' + IntToStr(value) + ' result');
    value:= bswap(value);

    PQFillParamDefaults(p, 1, PG_PARAMTYPE_BINARY, PG_PARAMTYPE_BINARY);
    p.paramValues[0]:= @value;
    p.paramLengths[0]:= sizeof(value);

    pq:= iPQ.ExecQueryParams(QUERY, @p);
    if pq = nil then exit;
    if pq.Status <> PGRES_TUPLES_OK then begin
      AddToLog(iPQ.GetError);
      exit;
    end;

    for i := 0 to pq.RecordCount - 1 do begin
      AddToLog('id = ' + IntToStr(bswap(PInteger(pq.Value[0, 0])^)));
      AddToLog('name = ' + pq.Value[0, 1]);
      len:= pq.ValueLen[0, 2];
      if len > sizeof(stuff) then len:= sizeof(stuff);
      move(pq.Value[0, 2]^, stuff, len);
      temp:= '';
      for j := 0 to len - 1 do
        temp:= temp + IntToHex(stuff[j], 2);
      AddToLog('value = ' + temp);
    end;
end;

procedure TForm1.ButtonGetPreparedParamData(Sender: TObject);
var
  pq: IPostgresQuery;
  i, j, value, len: integer;
  temp: string;
  p: TParam;
  stuff: array[0..$F]of byte;
begin
    if not(CheckIsConnected) then exit;
    if QueryStmt = nil then begin
      AddToLog('prepare query first!');
      exit;
    end;

    value:= random(high(stuff));
    AddToLog(LINE_WRAP + 'prepared ' + QUERY_PREPARED + ', query param = ' + IntToStr(value) + 'result');
    value:= bswap(value);

    PQFillParamDefaults(p, 1, PG_PARAMTYPE_BINARY, PG_PARAMTYPE_BINARY);
    p.paramValues[0]:= @value;
    p.paramLengths[0]:= sizeof(value);

    iPQ.Lock;
    try
      pq:= iPQ.ExecQueryPrepared(QueryStmt.StmtName, @p);
      if pq = nil then exit;
      if pq.Status <> PGRES_TUPLES_OK then begin
        AddToLog(iPQ.GetError);
        exit;
      end;

      for i := 0 to pq.RecordCount - 1 do begin
        AddToLog('id = ' + IntToStr(bswap(PInteger(pq.Value[0, 0])^)));
        AddToLog('name = ' + pq.Value[0, 1]); 
        len:= pq.ValueLen[0, 2];
        if len > sizeof(stuff) then len:= sizeof(stuff);        
        move(pq.Value[0, 2]^, stuff, len);
        temp:= '';
        for j := 0 to len - 1 do
          temp:= temp + IntToHex(stuff[j], 2);
      AddToLog('value = ' + temp);
      end;
    finally
      iPQ.Unlock;
    end;
end;

procedure TForm1.ButtonClearClick(Sender: TObject);
var
  pq: IPostgresQuery;
const
  QUERY = 'drop table sample';
begin
    if not(CheckIsConnected) then exit;

    AddToLog(LINE_WRAP + 'cleanup ' + QUERY);
    iPQ.Lock;
    try
      pq:= iPQ.ExecQuery(QUERY);
      if pq = nil then exit;
      if pq.Status <> PGRES_COMMAND_OK then begin
        AddToLog(iPQ.GetError);
        exit;
      end;
    finally
      iPQ.Unlock;
    end;
end;

end.
