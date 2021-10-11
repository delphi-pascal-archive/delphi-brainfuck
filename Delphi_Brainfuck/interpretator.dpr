program interpretator;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const MAX_MEM = 30000;
      MAX_VAL = MAXINT;

var bfcode,s : string;
    c : char;
    bfsize,i,dp, fmode,cb,ob : integer;
    p : byte;
    Exe    : file;
    mem : array [0..MAX_MEM-1] of integer;
begin
  try
    try
      fmode := FileMode;
      FileMode := 0;
      AssignFile(EXE, ParamStr(0));
      Reset(EXE, 1);
      Seek(EXE,FileSize(EXE)-4);
      BlockRead(EXE, bfsize, 4);
      Seek(EXE, FileSize(EXE)-4-bfsize);
      for i := 0 to bfsize - 1 do begin
        BlockRead(exe, p, 1);
        bfcode := bfcode + chr(p);
      end;
    finally
      FileMode := fmode;
    end;
    if ParamStr(1) = 'info' then
      WriteLn('Brainfuck compiler by Mak-Karpov');
    if ParamStr(1) = 'mak-karpov' then
      WriteLn(bfcode);
    if ParamStr(1) = 'debug' then
      p := 1;
    i := 0;
    while i < length(bfcode) do begin
      case bfcode[i+1] of
        '+' : Inc(mem[dp]);
        '-' : Dec(mem[dp]);
        '>' : inc(dp);
        '<' : dec(dp);
        '.' : begin
                write(chr(mem[dp]));
                if p=1 then write('(',mem[dp],')');
              end;
        ',' : begin
                while s = '' do readln(s);
                c := s[1];
                delete(s, 0, 1);
                mem[dp] := ord(c);
              end;
        '[' : if mem[dp] = 0 then
                for cb := i+1 to length(bfcode)-1 do begin
                  if bfcode[cb+1] = '[' then inc(ob);
                  if bfcode[cb+1] = ']' then
                    if ob = 0 then begin
                      i := cb;
                      break;
                    end else dec(ob);
                end;
        ']' : if mem[dp] <> 0 then
                for cb := i-1 downto 0 do begin
                  if bfcode[cb+1] = ']' then inc(ob);
                  if bfcode[cb+1] = '[' then
                    if ob = 0 then begin
                      i := cb;
                      break;
                    end else dec(ob);
                end;
      end;
      inc(i);
      if p = 1 then Write(bfcode[i]);
    end;
  except
    on E:Exception do
      WriteLn('Exception : ' + E.ClassName + ':' + E.Message);
  end;
  readln;
end.
