unit aasmcpu;

{$i fpcdefs.inc}

interface

uses
  cclasses,
  globtype, globals, verbose,
  aasmbase, aasmtai, aasmdata, aasmsym,
  cgbase, cgutils, cpubase, cpuinfo,
  ogbase;

const
  { "mov reg,reg" source operand number }
  O_MOV_SOURCE = 1;
  { "mov reg,reg" source operand number }
  O_MOV_DEST = 0;

type
  { Minimum CPU level required for instruction }
  tinsflag = (
    IF_6502,
    IF_6510,
    IF_65C02,
    IF_65C816
  );

  taicpu = class(tai_cpu_abstract_sym)
  private
    procedure init;
  public
    constructor op_reg_ref(op: tasmop; _op1: tregister; const _op2: treference);
    constructor op_ref_reg(op: tasmop; const _op1: treference; _op2: tregister);
  end;

  tai_align = class(tai_align_abstract)
    { nothing to add }
  end;

procedure InitAsm;
procedure DoneAsm;

function spilling_create_load(const ref: treference; r: tregister): Taicpu;
function spilling_create_store(r: tregister; const ref: treference): Taicpu;

implementation

procedure taicpu.init;
begin
end;

constructor taicpu.op_reg_ref(op: tasmop; _op1: tregister; const _op2: treference);
begin
  inherited create(op);
  init;
  ops := 2;
  loadreg(0, _op1);
  loadref(1, _op2);
end;

constructor taicpu.op_ref_reg(op: tasmop; const _op1: treference; _op2: tregister);
begin
  inherited create(op);
  init;
  ops := 2;
  loadref(0, _op1);
  loadreg(1, _op2);
end;

procedure InitAsm;
begin
end;

procedure DoneAsm;
begin
end;

function spilling_create_load(const ref: treference; r: tregister): Taicpu;
begin
  case getregtype(r) of
    R_INTREGISTER: case r of
      NR_A: result := taicpu.op_reg_ref(A_LDA, r, ref);
      NR_X: result := taicpu.op_reg_ref(A_LDX, r, ref);
      NR_Y: result := taicpu.op_reg_ref(A_LDY, r, ref);
      else internalerror(2004010403);
    end;
    else
      internalerror(200401041);
  end;
end;

function spilling_create_store(r: tregister; const ref: treference): Taicpu;
begin
  case getregtype(r) of
    R_INTREGISTER: case r of
      NR_A: result := taicpu.op_ref_reg(A_STA, ref, r);
      NR_X: result := taicpu.op_ref_reg(A_STX, ref, r);
      NR_Y: result := taicpu.op_ref_reg(A_STY, ref, r);
      else internalerror(2004010403);
    end;
    else internalerror(2004010403);
  end;
end;

end.