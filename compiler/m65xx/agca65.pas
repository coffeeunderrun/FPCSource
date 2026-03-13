unit agca65;

{$I fpcdefs.inc}

interface

uses
  globtype, systems,
  aasmbase, aasmtai, aasmdata, aasmcpu,
  assemble,
  cpubase;

type
  TCA65Assembler = class(TExternalAssembler)
  private
    function GetSectionName(SecType: TAsmSectionType; const SecName: String): String;
    procedure WriteSection(SecType: TAsmSectiontype; const SecName: String);
  public
    procedure WriteTree(Tree: TAsmList); override;
    procedure WriteAsmList; override;
    function MakeCmdLine: TCmdStr; override;
  end;

implementation

uses
  cutils, globals, verbose,
  cpuinfo,
  cgbase, cgutils;

const
  line_length = 70;
  max_tokens: longint = 25;

function TCA65Assembler.GetSectionName(SecType: TAsmSectionType; const SecName: String): String;
begin
  { TODO: Need to add cases for other possible section names }
  case SecType of
    sec_code, sec_fpc, sec_init, sec_fini: 
      result := 'CODE';
    sec_data, sec_bss, sec_stack, sec_heap: 
      result := 'DATA';
    sec_rodata, sec_rodata_norel: 
      result := 'RODATA';
    else 
      result := SecName;
  end;
end;

procedure TCA65Assembler.WriteSection(SecType: TAsmSectiontype; const SecName: String);
begin
  Writer.AsmWriteLn('.SEGMENT "' + GetSectionName(SecType, SecName) + '"');
  LastSecType := SecType;
end;

procedure TCA65Assembler.WriteTree(Tree: TAsmList);
var
  hp: tai;
  LastSecName, SymbolName: String;
begin
  if not Assigned(Tree) then exit;

  hp := tai(Tree.First);
  while Assigned(hp) do begin
    Prefetch(Pointer(hp.Next)^);

    case hp.typ of
      ait_cutobject: begin
        // Split files if smart linking.
        if SmartAsm then begin
          if not Writer.ClearIfEmpty then begin
            Writer.AsmClose;
            DoAssemble;
            Writer.AsmCreate(tai_cutobject(hp).Place);
          end;

          LastSecType := sec_none;
          LastSecName := '';

          { Skip any types we won't emit.
            If at least one section is encountered during this skip, remember the latest one. }
          while Assigned(hp.Next) and (tai(hp.Next).Typ in [ait_cutobject, ait_section, ait_comment]) do begin
            if tai(hp.Next).Typ = ait_section then begin
              LastSecType := tai_section(hp.Next).SecType;
              LastSecName := tai_section(hp.Next).Name^;
            end;
            hp := tai(hp.Next);
          end;

          // Start new file with section if one was encountered.
          if LastSecType <> sec_none then WriteSection(LastSecType, LastSecName);

          Writer.MarkEmpty;
        end;
      end;

      ait_label: if tai_label(hp).LabSym.is_used then begin
        Writer.AsmWrite(ApplyAsmSymbolRestrictions(tai_label(hp).LabSym.Name));
        Writer.AsmWriteLn(':');
      end;

      ait_section: begin
        ResetSourceLines;
        WriteSection(tai_section(hp).SecType, tai_section(hp).Name^);
      end;

      ait_symbol: begin
        SymbolName := ApplyAsmSymbolRestrictions(tai_symbol(hp).Sym.Name);
        if tai_symbol(hp).has_value then begin
          if tai_symbol(hp).is_global then Writer.AsmWrite('.EXPORT ' + SymbolName);
          Writer.AsmWriteLn('=' + ToStr(tai_symbol(hp).Value))
        end else begin
          if tai_symbol(hp).is_global then Writer.AsmWriteLn('.EXPORT ' + SymbolName);
          Writer.AsmWriteLn(SymbolName + ':');
        end;
      end;

      else
        Writer.AsmWriteLn(AsmInfo^.Comment + ' Not implemented: ' + TaiTypeStr[hp.Typ]);
    end;

    hp := tai(hp.Next);
  end;
end;

procedure TCA65Assembler.WriteAsmList;
var
  ListType: TAsmListType;
begin
  for ListType := Low(TAsmListType) to High(TAsmListType) do
    WriteTree(current_asmdata.AsmLists[ListType]);
end;

function TCA65Assembler.MakeCmdLine: TCmdStr;
begin
  result := inherited MakeCmdLine;
end;

const
  as_ca65_info: tasminfo = (
      id     : as_ca65;
      idtxt  : 'CA65';
      asmbin : 'ca65';
      asmcmd : '-o $OBJ $EXTRAOPT $ASM';
      supported_targets : [system_m65xx_embedded];
      flags : [af_needar];
      labelprefix : 'L';
      labelmaxlen : -1;
      comment : '; ';
      dollarsign: '_';
    );

begin
  RegisterAssembler(as_ca65_info, TCA65Assembler);
end.