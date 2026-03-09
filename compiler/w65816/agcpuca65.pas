unit agcpuca65;

{$I fpcdefs.inc}

interface

uses
  globtype,systems,
  aasmtai,aasmdata,
  assemble,
  cpubase;

type
  TCA65Assembler = class(TExternalAssembler)
  private
    function EscapeLabel(s: ansistring): ansistring;
  public
    procedure WriteTree(p : TAsmList); override;
    procedure WriteAsmList; override;
    function MakeCmdLine: TCmdStr; override;
  end;

implementation

uses
  cutils,globals,verbose,
  aasmbase,aasmcpu,
  cpuinfo,
  cgbase,cgutils;

const
  line_length = 70;
  max_tokens : longint = 25;
  ait_const2str : array [aitconst_128bit..aitconst_64bit_unaligned] of string[20] = (
    #9''#9,#9'DQ'#9,#9'DD'#9,#9'DW'#9,#9'DB'#9,
    #9'FIXMESLEB',#9'FIXEMEULEB',
    #9'DD RVA'#9,#9'DD SECREL32'#9,
    #9'FIXME',#9'FIXME',#9'FIXME',#9'FIXME',
    #9'DW'#9,#9'DD'#9,#9'DQ'#9
  );

function TCA65Assembler.EscapeLabel(s: ansistring): ansistring;
var
  i: Integer;
begin
  result := '';
  for i := 1 to length(s) do case s[i] of
    '0'..'9', 'a'..'z', 'A'..'Z': result := result + s[i];
    '_': result := result + '__';
    else result := result + ('_' + HexStr(Ord(s[i]), 2));
  end;
end;

procedure TCA65Assembler.WriteTree(p: TAsmList);
begin
end;

procedure TCA65Assembler.WriteAsmList;
begin
end;

function TCA65Assembler.MakeCmdLine: TCmdStr;
begin
  result := inherited MakeCmdLine;
end;

const
  as_w65816_ca65_info: tasminfo = (
      id     : as_w65816_ca65;
      idtxt  : 'CA65';
      asmbin : 'ca65';
      asmcmd : '-o $OBJ $EXTRAOPT $ASM';
      supported_targets : [system_w65816_embedded];
      flags : [af_none];
      labelprefix : 'L';
      labelmaxlen : -1;
      comment : '; ';
      dollarsign: 's';
    );

begin
  RegisterAssembler(as_w65816_ca65_info, TCA65Assembler);
end.