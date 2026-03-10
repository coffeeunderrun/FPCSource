program mkm65xxins;

{$mode objfpc}{$H+}

uses SysUtils;

const
  Version = '1.0.0';
  HeaderStr = '{ don''t edit, this file is generated from m65xxins.dat; to regenerate, run ''make insdat'' in the compiler directory }';
  MaxOperands = 2;

  ParamTypes: array [0..17, 0..1] of string = (
    ('void',  'OT_NONE'),
    ('#',     'OT_IMM'),
    ('a',     'OT_ABS'),
    ('b',     'OT_XYC'),
    ('s',     'OT_S'),
    ('x',     'OT_X'),
    ('y',     'OT_Y'),
    ('al',    'OT_ABS_LONG'),
    ('(a)',   'OT_ABS_IND'),
    ('[a]',   'OT_ABS_IND_LONG'),
    ('(a,x)', 'OT_ABS_X_IND'),
    ('d',     'OT_DIR'),
    ('(d)',   'OT_DIR_IND'),
    ('[d]',   'OT_DIR_IND_LONG'),
    ('(d,x)', 'OT_DIR_X_IND'),
    ('r',     'OT_REL'),
    ('rl',    'OT_REL_LONG'),
    ('(d,s)', 'OT_REL_S_IND')
  );

  FlagTypes: array [0..4, 0..1] of String = (
    ('none',   ''),
    ('6502',   'IF_6502'),
    ('6510',   'IF_6510'),
    ('65c02',  'IF_65C02'),
    ('65c816', 'IF_65C816')
  );

type
  Tm65xxInsDatOutputFiles = class
  public
    OpFile: TextFile;
    NOpFile: TextFile;
    StdOpNames: TextFile;
    InsTabFile: TextFile;

    constructor Create;
    destructor Destroy;override;
  end;

constructor Tm65xxInsDatOutputFiles.Create;
  begin
    AssignFile(OpFile, 'm65xxop.inc');
    Rewrite(OpFile);
    Writeln(OpFile, HeaderStr);
    Writeln(OpFile,'(');

    AssignFile(NOpFile, 'm65xxnop.inc');
    Rewrite(NOpFile);
    Writeln(NOpFile, HeaderStr);

    AssignFile(StdOpNames, 'm65xxstdopnames.inc');
    Rewrite(StdOpNames);
    Writeln(StdOpNames, HeaderStr);
    Writeln(StdOpNames,'(');
    
    AssignFile(InsTabFile, 'm65xxtab.inc');
    Rewrite(InsTabFile);
    Writeln(InsTabFile, HeaderStr);
    Writeln(InsTabFile, '(');
  end;

destructor Tm65xxInsDatOutputFiles.Destroy;
begin
  CloseFile(OpFile);
  CloseFile(NOpFile);
  CloseFile(StdOpNames);
  CloseFile(InsTabFile);
  inherited Destroy;
end;

function FindParamType(const ParamTypeStr: string): Integer;
var
  I: Integer;
begin
  for I := Low(ParamTypes) to High(ParamTypes) do
    if ParamTypes[I, 0] = LowerCase(ParamTypeStr) then exit(I);
  raise Exception.Create('Invalid param type: ''' + ParamTypeStr + '''');
end;

function FindFlagType(const FlagTypeStr: string): Integer;
var
  I: Integer;
begin
  for I := Low(FlagTypes) to High(FlagTypes) do
    if FlagTypes[I, 0] = LowerCase(FlagTypeStr) then exit(I);
  raise Exception.Create('Invalid flag type: ''' + FlagTypeStr + '''');
end;

var
  InsDatFile: TextFile;
  OutputFiles: Tm65xxInsDatOutputFiles = nil;
  CurrentLine, Op: String;
  ParamIdx, ParenStart, ParenEnd: Integer;
  FirstIns: Boolean = true;
  OpCount: Integer = 0;
  S_Split, S_Params: TStringArray;

begin
  WriteLn('FPC MOS 65XX Instruction Table Converter Version ', Version);
  AssignFile(InsDatFile,'../m65xx/m65xxins.dat');
  Reset(InsDatFile);

  try
    OutputFiles := Tm65xxInsDatOutputFiles.Create;

    while not EoF(InsDatFile) do begin
      ReadLn(InsDatFile, CurrentLine);
      CurrentLine := Trim(CurrentLine);

      // Skip comments
      if LeftStr(CurrentLine, 1) = ';' then continue;

      // Op
      if LeftStr(CurrentLine, 1) = '/' then begin
        Op := CurrentLine.Substring(1);
        
        if not FirstIns then begin
          WriteLn(OutputFiles.OpFile, ',');
          WriteLn(OutputFiles.StdOpNames, ',');
        end else
          FirstIns := false;

        Write(OutputFiles.OpFile, 'A_' + Op);
        Write(OutputFiles.StdOpNames, '''' + LowerCase(Op) + '''');
        continue;
      end;

      // Parameters
      if CurrentLine <> '' then begin
        Inc(OpCount);
        if OpCount <> 1 then Writeln(OutputFiles.InsTabFile, ',');
          
        S_Split := CurrentLine.Split(' ', TStringSplitOptions.ExcludeEmpty);
        S_Params := [];

        // Keep operands within parentheses together
        ParenStart := Pos('(', CurrentLine);
        ParenEnd := Pos(')', CurrentLine);
        if (ParenStart > 0) and (ParenEnd > ParenStart) then
          S_Params := Concat(S_Params, [S_Split[0].SubString(ParenStart - 1, ParenEnd - ParenStart + 1)]);

        // Split remaining operands by comma
        S_Params := Concat(S_Params, S_Split[0].SubString(ParenEnd).Split(',', TStringSplitOptions.ExcludeEmpty));

        if (Length(S_Params) = 1) and (S_Params[0] = 'void') then SetLength(S_Params, 0);

        Writeln(OutputFiles.InsTabFile, '  (');
        Writeln(OutputFiles.InsTabFile, '    opcode  : A_', Op, ';');
        Writeln(OutputFiles.InsTabFile, '    ops     : ', Length(S_Params), ';');
        Write(OutputFiles.InsTabFile,   '    optypes : (');

        if Length(S_Params) > MaxOperands then raise Exception.Create('Too many operands');

        for ParamIdx := 0 to MaxOperands - 1 do begin
          if ParamIdx <> 0 then Write(OutputFiles.InsTabFile, ',');
          if ParamIdx <= High(S_Params) then
            Write(OutputFiles.InsTabFile, ParamTypes[FindParamType(S_Params[ParamIdx]), 1])
          else
            Write(OutputFiles.InsTabFile, 'OT_NONE');
        end;

        Writeln(OutputFiles.InsTabFile, ');');
        Writeln(OutputFiles.InsTabFile,  '    code    : ''', S_Split[1], ''';');
        Writeln(OutputFiles.InsTabFile,  '    flags   : ', FlagTypes[FindFlagType(S_Split[2]), 1]);
        Write(OutputFiles.InsTabFile,  '  )');
      end;
    end;

    Writeln(OutputFiles.OpFile,');');
    Writeln(OutputFiles.StdOpNames,');');
    Writeln(OutputFiles.NOpFile,OpCount,';');
    Writeln(OutputFiles.InsTabFile);
    Writeln(OutputFiles.InsTabFile,');');
  finally
    FreeAndNil(OutputFiles);
    CloseFile(InsDatFile);
  end;
end.

