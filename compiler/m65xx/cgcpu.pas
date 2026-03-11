unit cgcpu;

{$i fpcdefs.inc}

interface

uses
  globtype, symtype, symdef,
  cgbase, cgutils, cgobj,
  aasmbase, aasmcpu, aasmtai, aasmdata,
  parabase,
  cpubase, cpuinfo, node, cg64f32, rgcpu,

  { TODO: remove this after switching from thlbasecgcpu to tcg }
  cghlcpu;

type
  tregisterlist = array of tregister;

  { TODO: switch from `thlbasecgcpu` to `tcg` once everything is implemented }
  tcg65xx = class(thlbasecgcpu)
    procedure init_register_allocators; override;
    procedure done_register_allocators; override;

    function getaddressregister(list: TAsmList): Tregister; override;

    procedure a_call_name(list: TAsmList; const s: string; weak: boolean); override;
    procedure a_call_reg(list: TAsmList; reg: tregister); override;

    procedure a_op_const_reg(list: TAsmList; Op: TOpCG; size: TCGSize; a: tcgint; reg: TRegister); override;
    procedure a_op_reg_reg(list: TAsmList; Op: TOpCG; size: TCGSize; reg1, reg2: TRegister); override;

    procedure a_load_const_reg(list: TAsmList; size: tcgsize; a: tcgint; register: tregister); override;
    procedure a_load_reg_ref(list: TAsmList; fromsize, tosize: tcgsize; register: tregister; const ref: treference); override;
    procedure a_load_ref_reg(list: TAsmList; fromsize, tosize: tcgsize; const ref: treference; register: tregister); override;
    procedure a_load_reg_reg(list: TAsmList; fromsize, tosize: tcgsize; reg1, reg2: tregister); override;

    procedure a_cmp_reg_reg_label(list: TAsmList; size: tcgsize; cmp_op: topcmp; reg1, reg2: tregister; l: tasmlabel); override;

    procedure a_jmp_name(list: TAsmList; const s: string); override;
    procedure a_jmp_always(list: TAsmList; l: tasmlabel); override;
    procedure a_jmp_flags(list: TAsmList; const f: TResFlags; l: tasmlabel); override;

    procedure g_flags2reg(list: TAsmList; size: TCgSize; const f: tresflags; reg: TRegister); override;

    procedure g_proc_entry(list: TAsmList; localsize: longint; nostackframe: boolean); override;
    procedure g_proc_exit(list: TAsmList; parasize: longint; nostackframe: boolean); override;

    procedure a_loadaddr_ref_reg(list: TAsmList; const ref: treference; r: tregister); override;

    procedure g_concatcopy(list: TAsmList; const source, dest: treference; len: tcgint); override;

    procedure g_overflowcheck(list: TAsmList; const Loc: tlocation; def: tdef); override;

    { TODO: might be able to remove this after switching to `tcg` }
    function makeregsize(list: TAsmList; reg: Tregister; size: Tcgsize): Tregister; override;
  end;

  tcg64f65xx = class(tcg64f32)
    procedure a_op64_reg_reg(list: TAsmList; op: TOpCG; size: tcgsize; regsrc, regdst: tregister64); override;
    procedure a_op64_const_reg(list: TAsmList; op: TOpCG; size: tcgsize; value : int64; reg: tregister64); override;
  end;

procedure create_codegen;

implementation

uses
  verbose,
  rgobj;

procedure tcg65xx.init_register_allocators;
begin
  inherited init_register_allocators;
  rg[R_INTREGISTER] := trgobj.create(R_INTREGISTER, R_SUBWHOLE, [RS_A, RS_X, RS_Y], first_int_imreg, []);
end;

procedure tcg65xx.done_register_allocators;
begin
  rg[R_INTREGISTER].free;
  inherited done_register_allocators;
end;

function tcg65xx.getaddressregister(list: TAsmList): Tregister;
begin
  result := getintregister(list, OS_ADDR);
end;

procedure tcg65xx.a_call_name(list: TAsmList; const s: string; weak: boolean);
begin
end;

procedure tcg65xx.a_call_reg(list: TAsmList; reg: tregister);
begin
end;

procedure tcg65xx.a_op_const_reg(list: TAsmList; Op: TOpCG; size: TCGSize; a: tcgint; reg: TRegister);
begin
end;

procedure tcg65xx.a_op_reg_reg(list: TAsmList; Op: TOpCG; size: TCGSize; reg1, reg2: TRegister);
begin
end;

procedure tcg65xx.a_load_const_reg(list: TAsmList; size: tcgsize; a: tcgint; register: tregister);
begin
end;

procedure tcg65xx.a_load_reg_ref(list: TAsmList; fromsize, tosize: tcgsize; register: tregister; const ref: treference);
begin
end;

procedure tcg65xx.a_load_ref_reg(list: TAsmList; fromsize, tosize: tcgsize; const ref: treference; register: tregister);
begin
end;

procedure tcg65xx.a_load_reg_reg(list: TAsmList; fromsize, tosize: tcgsize; reg1, reg2: tregister);
begin
end;

procedure tcg65xx.a_cmp_reg_reg_label(list: TAsmList;size: tcgsize; cmp_op: topcmp; reg1, reg2: tregister; l: tasmlabel);
begin
end;

procedure tcg65xx.a_jmp_name(list: TAsmList; const s: string);
begin
end;

procedure tcg65xx.a_jmp_always(list: TAsmList; l: tasmlabel);
begin
end;

procedure tcg65xx.a_jmp_flags(list: TAsmList; const f: TResFlags; l: tasmlabel);
begin
end;

procedure tcg65xx.g_flags2reg(list: TAsmList; size: TCgSize; const f: tresflags; reg: TRegister);
begin
end;

procedure tcg65xx.g_proc_entry(list: TAsmList; localsize: longint; nostackframe: boolean);
begin
end;

procedure tcg65xx.g_proc_exit(list: TAsmList; parasize: longint; nostackframe: boolean);
begin
end;

procedure tcg65xx.a_loadaddr_ref_reg(list: TAsmList; const ref: treference; r: tregister);
begin
end;

procedure tcg65xx.g_concatcopy(list: TAsmList; const source, dest: treference; len: tcgint);
begin
end;

procedure tcg65xx.g_overflowcheck(list: TAsmList; const Loc: tlocation; def: tdef);
begin
end;

function tcg65xx.makeregsize(list: TAsmList; reg: Tregister; size: Tcgsize): Tregister;
begin
    result := reg;
end;

procedure tcg64f65xx.a_op64_reg_reg(list: TAsmList; op: TOpCG; size: tcgsize; regsrc, regdst: tregister64);
begin
end;

procedure tcg64f65xx.a_op64_const_reg(list: TAsmList; op: TOpCG; size: tcgsize; value: int64; reg: tregister64);
begin
end;

procedure create_codegen;
begin
  cg := tcg65xx.create;
  cg64 := tcg64f65xx.create;
end;

end.