unit cpubase;

{$i fpcdefs.inc}

interface

uses
  cutils, cclasses,
  globtype, globals,
  cpuinfo,
  aasmbase,
  cgbase;

{*****************************************************************************
                                Assembler Opcodes
*****************************************************************************}

type
  TAsmOp = {$I m65xxop.inc}

  { This should define the array of instructions as string }
  op2strtable = array [TAsmOp] of string[4];

const
  { First value of opcode enumeration }
  firstop = low(tasmop);

  { Last value of opcode enumeration  }
  lastop = high(tasmop);

  std_op2str: op2strtable = {$I m65xxstdopnames.inc}

  { call/reg instructions are not considered as jmp instructions for the usage cases of
    this set }
  jmp_instructions = [
    A_BCC,
    A_BCS,
    A_BEQ,
    A_BMI,
    A_BNE,
    A_BPL,
    A_BRA,
    A_BRL,
    A_BVC,
    A_BVS
  ];

  call_jmp_instructions = [
    A_JSL,
    A_JSR
  ] + jmp_instructions;

  { instructions that can have a condition }
  cond_instructions = [
    A_BCC,
    A_BCS,
    A_BEQ,
    A_BMI,
    A_BNE,
    A_BPL,
    A_BVC,
    A_BVS
  ];

{*****************************************************************************
                                  Registers
*****************************************************************************}

type
  { Number of registers used for indexing in tables }
  tregisterindex = 0..{$i r65xxnor.inc} - 1;

const
  { Available Superregisters }
  {$i r65xxsup.inc}

  { No Subregisters }
  R_SUBWHOLE = R_SUBL;

  { Available Registers }
  {$i r65xxcon.inc}

  { Integer Super registers first and last }
  first_int_supreg = RS_A;
  first_int_imreg  = $20;

  { Float Super register first and last }
  first_fpu_supreg = RS_INVALID;
  first_fpu_imreg  = 0;

  { MM Super register first and last }
  first_mm_supreg = RS_INVALID;
  first_mm_imreg  = 0;

  regnumber_count_bsstart = 32;

  regnumber_table : array [tregisterindex] of tregister = (
    {$i r65xxnum.inc}
  );

  regstabs_table : array [tregisterindex] of shortint = (
    {$i r65xxsta.inc}
  );

  regdwarf_table : array [tregisterindex] of shortint = (
    {$i r65xxdwa.inc}
  );

  { registers which may be destroyed by calls }
  VOLATILE_INTREGISTERS = [
    RS_A,
    RS_X,
    RS_Y
  ];

  VOLATILE_FPUREGISTERS = [];

{*****************************************************************************
                                Conditions
*****************************************************************************}

type
  TAsmCond = (
    C_None,
    C_PL, // N = 0
    C_MI, // N = 1
    C_VC, // V = 0
    C_VS, // V = 1
    C_CC, // C = 0
    C_CS, // C = 1
    C_NE, // Z = 0
    C_EQ  // Z = 1
  );

const
  cond2str : array [TAsmCond] of string[2] = (
    '',
    'pl',
    'mi',
    'vc',
    'vs',
    'cc',
    'cs',
    'ne',
    'eq'
  );

  uppercond2str : array [TAsmCond] of string[2] = (
    '',
    'PL',
    'MI',
    'VC',
    'VS',
    'CC',
    'CS',
    'NE',
    'EQ'
  );

{*****************************************************************************
                                   Flags
*****************************************************************************}

type
  TResFlags = (
    F_NotPossible,
    F_PL,
    F_MI,
    F_VC,
    F_VS,
    F_CC,
    F_CS,
    F_NE,
    F_EQ
  );

{*****************************************************************************
                                 Constants
*****************************************************************************}

const
  max_operands = 2;
  maxintregs = 3;
  maxfpuregs = 0;
  maxaddrregs = 0;

{*****************************************************************************
                          Default generic sizes
*****************************************************************************}

  { Defines the default address size for a processor, }
  OS_ADDR = OS_16;
  { the natural int size for a processor,
    has to match osuinttype/ossinttype as initialized in psystem,
    initially, this was OS_16/OS_S16 on avr, but experience has
    proven that it is better to make it 8 Bit thus having the same
    size as a register.
  }
  OS_INT = OS_8;
  OS_SINT = OS_S8;
  { the maximum float size for a processor,           }
  OS_FLOAT = OS_F64;
  { the size of a vector register for a processor     }
  OS_VECTOR = OS_M32;

{*****************************************************************************
                          Generic Register names
*****************************************************************************}

  { Stack pointer register }
  NR_STACK_POINTER_REG = NR_S;
  RS_STACK_POINTER_REG = RS_S;
  { Frame pointer register }
  RS_FRAME_POINTER_REG = RS_D;
  NR_FRAME_POINTER_REG = NR_D;
  { Register for addressing absolute data in a position independant way,
    such as in PIC code. The exact meaning is ABI specific. For
    further information look at GCC source : PIC_OFFSET_TABLE_REGNUM
  }
  NR_PIC_OFFSET_REG = NR_INVALID;
  { Results are returned in this register (32-bit values) }
  NR_FUNCTION_RETURN_REG = NR_A;
  RS_FUNCTION_RETURN_REG = RS_A;
  { Low part of 64bit return value }
  NR_FUNCTION_RETURN64_LOW_REG = NR_A;
  RS_FUNCTION_RETURN64_LOW_REG = RS_A;
  { High part of 64bit return value }
  NR_FUNCTION_RETURN64_HIGH_REG = NR_X;
  RS_FUNCTION_RETURN64_HIGH_REG = RS_X;
  { The value returned from a function is available in this register }
  NR_FUNCTION_RESULT_REG = NR_FUNCTION_RETURN_REG;
  RS_FUNCTION_RESULT_REG = RS_FUNCTION_RETURN_REG;
  { The lowh part of 64bit value returned from a function }
  NR_FUNCTION_RESULT64_LOW_REG = NR_FUNCTION_RETURN64_LOW_REG;
  RS_FUNCTION_RESULT64_LOW_REG = RS_FUNCTION_RETURN64_LOW_REG;
  { The high part of 64bit value returned from a function }
  NR_FUNCTION_RESULT64_HIGH_REG = NR_FUNCTION_RETURN64_HIGH_REG;
  RS_FUNCTION_RESULT64_HIGH_REG = RS_FUNCTION_RETURN64_HIGH_REG;

  NR_FPU_RESULT_REG = NR_NO;

  NR_MM_RESULT_REG  = NR_NO;

  NR_RETURN_ADDRESS_REG = NR_FUNCTION_RETURN_REG;

  { Offset where the parent framepointer is pushed }
  PARENT_FRAMEPOINTER_OFFSET = 0;

  NR_DEFAULTFLAGS = NR_P;
  RS_DEFAULTFLAGS = RS_P;

{*****************************************************************************
                       GCC /ABI linking information
*****************************************************************************}

  std_param_align = 4;

{*****************************************************************************
                                  Helpers
*****************************************************************************}

function reg_cgsize(const reg: tregister): tcgsize;
function cgsize2subreg(regtype: tregistertype; s: Tcgsize): Tsubregister;
function findreg_by_number(r: Tregister): tregisterindex;
function std_regnum_search(const s: string): Tregister;
function std_regname(r: Tregister): string;

function inverse_cond(const c: TAsmCond): TAsmCond; {$ifdef USEINLINE}inline;{$endif USEINLINE}
function conditions_equal(const c1, c2: TAsmCond): boolean; {$ifdef USEINLINE}inline;{$endif USEINLINE}

{ Checks if Subset is a subset of c (e.g. "less than" is a subset of "less than or equal" }
function condition_in(const Subset, c: TAsmCond): Boolean;

function dwarf_reg(r: tregister): byte;
function eh_return_data_regno(nr: longint): longint;

implementation

uses
  rgBase, verbose;

const
  std_regname_table: TRegNameTable = (
    {$i r65xxstd.inc}
  );

  regnumber_index: array [tregisterindex] of tregisterindex = (
    {$i r65xxrni.inc}
  );

  std_regname_index: array [tregisterindex] of tregisterindex = (
    {$i r65xxsri.inc}
  );

function reg_cgsize(const reg: tregister): tcgsize;
begin
  case getregtype(reg) of
    R_INTREGISTER,
    R_SPECIALREGISTER:
      case getsubreg(reg) of
        R_SUBNONE,
        R_SUBL,
        R_SUBH:
          reg_cgsize := OS_8;
        R_SUBW:
          reg_cgsize := OS_16;
        else
          internalerror(2020041901);
      end;
    R_ADDRESSREGISTER:
      reg_cgsize := OS_16;
    else
      internalerror(2011021905);
    end;
end;

function cgsize2subreg(regtype: tregistertype; s: Tcgsize): Tsubregister;
begin
  cgsize2subreg := R_SUBWHOLE;
end;

function findreg_by_number(r: Tregister): tregisterindex;
begin
  result := rgBase.findreg_by_number_table(r, regnumber_index);
end;

function std_regnum_search(const s: string): Tregister;
begin
  result := regnumber_table[findreg_by_name_table(s, std_regname_table, std_regname_index)];
end;

function std_regname(r: Tregister): string;
var
  p: tregisterindex;
begin
  p := findreg_by_number_table(r, regnumber_index);
  if p <> 0 then
    result := std_regname_table[p]
  else
    result := generic_regname(r);
end;

function inverse_cond(const c: TAsmCond): TAsmCond; {$ifdef USEINLINE}inline;{$endif USEINLINE}
const
  inverse: array[TAsmCond] of TAsmCond=(
    C_None,
    C_MI, // N = 1
    C_PL, // N = 0
    C_VS, // V = 1
    C_VC, // V = 0
    C_CS, // C = 1
    C_CC, // C = 0
    C_EQ, // Z = 1
    C_NE  // Z = 0
  );
begin
  result := inverse[c];
end;

function conditions_equal(const c1, c2: TAsmCond): boolean; {$ifdef USEINLINE}inline;{$endif USEINLINE}
begin
  result := c1 = c2;
end;

{ Checks if Subset is a subset of c (e.g. "less than" is a subset of "less than or equal" }
function condition_in(const Subset, c: TAsmCond): Boolean;
begin
  Result := (c = C_None) or conditions_equal(Subset, c);
end;

function dwarf_reg(r: tregister): byte;
var
  reg: shortint;
begin
  reg := regdwarf_table[findreg_by_number(r)];
  if reg = -1 then internalerror(200603251);
  result := reg;
end;

function eh_return_data_regno(nr: longint): longint;
begin
  result := -1;
end;

end.