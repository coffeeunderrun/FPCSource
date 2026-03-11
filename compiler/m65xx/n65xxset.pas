unit n65xxset;

{$i fpcdefs.inc}

interface

uses
  globtype, globals, constexp, symtype,
  node, nset, cpubase, cgbase, cgutils, cgobj, aasmbase, aasmtai, aasmdata,
  ncgset;

type
  tm65xxcasenode = class(tcgcasenode)
    procedure pass_generate_code; override;
  end;

implementation

uses
  verbose,
  cutils,
  symconst, symdef, symsym, defutil,
  pass_2,
  tgobj,
  nbas, ncon, ncgflw,
  ncgutil,
  hlcgobj;

procedure tm65xxcasenode.pass_generate_code;
var
  oldflowcontrol: tflowcontrol;
  i: longint;
  dist: asizeuint;
  distv,
  lv, hv,
  max_label: tconstexprint;
  max_linear_list: int64;
  max_dist: qword;
  ShortcutElse: Boolean;
begin
  location_reset(location, LOC_VOID, OS_NO);

  oldflowcontrol := flowcontrol;
  include(flowcontrol, fc_inflowcontrol);

  current_asmdata.getjumplabel(endlabel);

  ShortcutElse := GetBranchLabel(elseblock, elselabel);

  for i := 0 to blocks.count - 1 do
    with pcaseblock(blocks[i])^ do
      shortcut := GetBranchLabel(statement, blocklabel);

  with_sign := is_signed(left.resultdef);
  if with_sign then
    begin
      jmp_gt := OC_GT;
      jmp_lt := OC_LT;
      jmp_le := OC_LTE;
    end
  else
    begin
      jmp_gt := OC_A;
      jmp_lt := OC_B;
      jmp_le := OC_BE;
    end;

  secondpass(left);
  if (left.expectloc = LOC_JUMP) <>
     (left.location.loc = LOC_JUMP) then
    internalerror(2006050501);

  opsize := left.resultdef;
  hlcg.location_force_reg(current_asmdata.CurrAsmList, left.location, left.resultdef, opsize, false);
{$if not defined(cpu64bitalu)}
  if def_cgsize(opsize) in [OS_S64, OS_64] then
    begin
      hregister := left.location.register64.reglo;
      hregister2 := left.location.register64.reghi;
    end
  else
{$endif not cpu64bitalu and not cpuhighleveltarget}
    hregister := left.location.register;

  min_label := case_get_min(labels);

{$if not defined(cpu64bitalu)}
  if def_cgsize(opsize) in [OS_64, OS_S64] then
    genlinearcmplist(labels)
  else
{$endif not cpu64bitalu and not cpuhighleveltarget}
    begin
      if cs_opt_level1 in current_settings.optimizerswitches then
        begin
          max_label := case_get_max(labels);

          getrange(left.resultdef, lv, hv);
          jumptable_no_range := (lv = min_label) and (hv = max_label);

          distv := max_label - min_label;
          if distv >= 0 then
            dist := min(distv.uvalue, high(dist))
          else
            dist := min(asizeuint(-distv.svalue), high(dist));

          if cs_opt_size in current_settings.optimizerswitches then
            begin
              if has_jumptable and
                 (min_label >= int64(low(aint))) and
                 (max_label <= high(aint)) and
                 not ((labelcnt <= 2) or
                      (distv.svalue < 0) or
                      (dist > 3 * labelcnt)) then
                genjumptable(labels, min_label.svalue, max_label.svalue)
              else
                genlinearlist(labels);
            end
          else
            begin
              max_dist := 4 * labelcoverage;

              if max_dist > 4 * labelcnt then
                max_dist := min(max_dist, 2048);

              if jumptable_no_range then
                max_linear_list := 4
              else
                max_linear_list := 2;

              optimizevalues(max_linear_list, max_dist);

              if (labelcnt <= max_linear_list) then
                genlinearlist(labels)
              else
                begin
                  if (has_jumptable) and
                     (dist < max_dist) and
                     (min_label >= int64(low(aint))) and
                     (max_label <= high(aint)) then
                    genjumptable(labels, min_label.svalue, max_label.svalue)
                  else if labelcnt >= 64 then
                    genjmptree(labels)
                  else
                    genlinearlist(labels);
                end;
            end;
        end
      else
        genlinearlist(labels);
    end;

  for i := 0 to blocks.count - 1 do
    with pcaseblock(blocks[i])^ do
      begin
        if not shortcut then
          begin
            current_asmdata.CurrAsmList.concat(cai_align.create(current_settings.alignment.jumpalign));
            cg.a_label(current_asmdata.CurrAsmList, blocklabel);
            secondpass(statement);
            if assigned(current_asmdata.CurrAsmList.getlasttaifilepos) then
              current_filepos := current_asmdata.CurrAsmList.getlasttaifilepos^;
            hlcg.a_jmp_always(current_asmdata.CurrAsmList, endlabel);
          end;
      end;

  if not ShortcutElse then
    begin
      current_asmdata.CurrAsmList.concat(cai_align.create(current_settings.alignment.jumpalign));
      hlcg.a_label(current_asmdata.CurrAsmList, elselabel);
    end;

  if Assigned(elseblock) then
    secondpass(elseblock);

  current_asmdata.CurrAsmList.concat(cai_align.create(current_settings.alignment.jumpalign));
  hlcg.a_label(current_asmdata.CurrAsmList, endlabel);

  for i := 0 to blocks.count - 1 do
    pcaseblock(blocks[i])^.blocklabel := nil;
  flowcontrol := oldflowcontrol + (flowcontrol - [fc_inflowcontrol]);
end;

begin
  ccasenode := tm65xxcasenode;
end.
