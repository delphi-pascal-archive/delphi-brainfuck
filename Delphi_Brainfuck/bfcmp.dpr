program bfcmp;

{$APPTYPE CONSOLE}
{$R interpretator.res}
{$DEFINE RLN}

uses
  SysUtils, Classes, Windows;

const chars : set of char = ['<','>','+','-',',','.','[',']'];

var ob,cb,i : integer;
    s, s1 : string;
    b : byte;
    src : textfile;
    EXE : TFileStream;
    Res : TResourceStream;
begin
  if (not FileExists(ParamStr(1))) or
  (lowercase(ExtractFileExt(ParamStr(1))) <> '.bf') then begin
    WriteLn('bfcmp : File is not brainfuck source!');
    {$IFDEF RLN}ReadLn;{$ENDIF}
    Halt(2);
  end;
  AssignFile(src, ParamStr(1));
  Reset(src);
  s := '';
  while not Eof(src) do begin
    ReadLn(src, s1);
    s := s + s1;
  end;
  CloseFile(src);
  WriteLn('File succesfully loaded.');
  ob := 0;
  cb := 0;
  for i := 1 to Length(s) do begin
    if s[i] = ']' then begin
      inc(cb);
      if cb > ob then begin
        WriteLn('bfcmp : Error : "]" before "["!');
        {$IFDEF RLN}ReadLn;{$ENDIF}
        Halt(1);
      end;
    end;
    if s[i] = '[' then inc(ob);
  end;
  if ob > cb then begin
    WriteLn('bfcmp : Error : "]" missing!');
    {$IFDEF RLN}ReadLn;{$ENDIF}
    Halt(1);
  end;
  WriteLn('File succesfully validated.');
  s1 := '';
  for i := 1 to Length(s) do
    if s[i] in Chars then s1 := s1 + s[i];
  s := s1;
  s1 := '';
  try
    Res := TResourceStream.Create(hInstance, 'interpret', RT_RCDATA);
    EXE := TFileStream.Create(ChangeFileExt(ParamStr(1), '.exe'), fmCreate);
    EXE.CopyFrom(Res, 0);

    for ob := 1 to length(s) do begin
      b := Ord(s[ob]);
      EXE.Write(b,1);
    end;
    i := Length(s);
    EXE.Write(i,4);
  finally
    EXE.Free;
    Res.Free;
  end;
  if ParamStr(2) <> '' then ReadLn;
end.
