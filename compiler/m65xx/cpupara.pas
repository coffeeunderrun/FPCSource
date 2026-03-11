unit cpupara;

{ TODO: copied just enough to avoid access violation errors; needs to be properly implemented }

{$i fpcdefs.inc}

interface

uses
  globtype,
  cpubase,
  symconst,
  symtype, symdef, symsym,
  parabase, paramgr, cgbase;

type
  tcpuparamanager = class(tparamanager)
    function push_addr_param(varspez: tvarspez; def: tdef; calloption: tproccalloption): boolean; override;
    function create_paraloc_info(p: tabstractprocdef; side: tcallercallee): longint; override;
    function get_funcretloc(p: tabstractprocdef; side: tcallercallee; forcetempdef: tdef): tcgpara; override;
    function create_varargs_paraloc_info(p: tabstractprocdef; side: tcallercallee; varargspara: tvarargsparalist): longint; override;
  end;

implementation

uses
  verbose,
  defutil;

function tcpuparamanager.push_addr_param(varspez: tvarspez; def: tdef; calloption: tproccalloption): boolean;
begin
  result := false;

  if varspez in [vs_var, vs_out, vs_constref] then exit(true);

  case def.typ of
    objectdef:
      result := is_object(def) and ((varspez=vs_const) or (def.size=0));
      
    recorddef:
      result := (varspez = vs_const) or (def.size = 0);

    variantdef, formaldef:
      result := true;

    arraydef:
      result := (tarraydef(def).highrange >= tarraydef(def).lowrange) or
        is_open_array(def) or
        is_array_of_const(def) or
        is_array_constructor(def);

    setdef:
      result := not is_smallset(def);

    stringdef:
      result := tstringdef(def).stringtype in [st_shortstring, st_longstring];
  else
    result := def.size > 8;
  end;
end;

function tcpuparamanager.create_paraloc_info(p: tabstractprocdef; side: tcallercallee): longint;
var
  i: longint;
  hp: tparavarsym;
  paraloc: pcgparalocation;
  stack_offset: longint;
begin
  result := 0;
  stack_offset := 0;

  for i := 0 to p.paras.count - 1 do begin
    hp := tparavarsym(p.paras[i]);

    with hp.paraloc[side] do begin
      reset;
      size := OS_ADDR;
      intsize := tcgsize2size[OS_ADDR];
      alignment := std_param_align;
      def := voidpointertype;

      paraloc := add_location;
    end;

    with paraloc^ do begin
      loc := LOC_REFERENCE;
      size := OS_ADDR;
      def := voidpointertype;
      
      if side = calleeside then
        reference.index := NR_FRAME_POINTER_REG
      else
        reference.index := NR_STACK_POINTER_REG;

      reference.offset := stack_offset;
    end;

    inc(stack_offset, tcgsize2size[OS_ADDR]);
  end;

  create_funcretloc_info(p, side);
  result := stack_offset;
end;

function tcpuparamanager.get_funcretloc(p: tabstractprocdef; side: tcallercallee; forcetempdef: tdef): tcgpara;
var
  paraloc: pcgparalocation;
  retcgsize: tcgsize;
begin
  result.init;
  if set_common_funcretloc_info(p, forcetempdef, retcgsize, result) then exit;

  paraloc := result.add_location;

  with paraloc^ do begin
    if (retcgsize in [OS_8,OS_S8]) then begin
      loc := LOC_REGISTER;
      size := retcgsize;
      def := result.def;

      if side = callerside then
        register := NR_FUNCTION_RESULT_REG
      else
        register := NR_FUNCTION_RETURN_REG;
    end else begin
      loc := LOC_REFERENCE;
      size := retcgsize;
      def := result.def;
      reference.index := NR_STACK_POINTER_REG;
      reference.offset := 0;
    end;
  end;
end;

function tcpuparamanager.create_varargs_paraloc_info(p: tabstractprocdef; side: tcallercallee; varargspara: tvarargsparalist): longint;
begin
  result := 0;
end;

begin
	paramanager := tcpuparamanager.create;
end.