unit aoptcpub;

{$I fpcdefs.inc}

interface

uses
  cpubase,
  cgbase,
  aasmcpu,aasmtai,
  AOptBase;

type
{ type of a normal instruction }
  TInstr = Taicpu;
  PInstr = ^TInstr;

{ ************************************************************************* }
{ **************************** TCondRegs ********************************** }
{ ************************************************************************* }
{ Info about the conditional registers                                      }
  TCondRegs = Object
    Constructor Init;
    Destructor Done;
  End;

{ ************************************************************************* }
{ **************************** TAoptBaseCpu ******************************* }
{ ************************************************************************* }

  TAoptBaseCpu = class(TAoptBase)
    { checks whether reading the value in reg1 depends on the value of reg2. This
      is very similar to SuperRegisterEquals, except it takes into account that
      R_SUBH and R_SUBL are independent (e.g. reading from AL does not
      depend on the value in AH). }
    function Reg1ReadDependsOnReg2(reg1, reg2: tregister): boolean;
    function RegModifiedByInstruction(Reg: TRegister; p1: tai): boolean; override;
  End;

{ ************************************************************************* }
{ ******************************* Constants ******************************* }
{ ************************************************************************* }
Const

{ the maximum number of things (registers, memory, ...) a single instruction }
{ changes                                                                    }

  MaxCh = 2;

{ the maximum number of operands an instruction has }

  MaxOps = 2;

{Oper index of operand that contains the source (reference) with a load }
{instruction                                                            }

  LoadSrc = 1;

{Oper index of operand that contains the destination (register) with a load }
{instruction                                                                }

  LoadDst = 0;

{Oper index of operand that contains the source (register) with a store }
{instruction                                                            }

  StoreSrc = 1;

{Oper index of operand that contains the destination (reference) with a load }
{instruction                                                                 }

  StoreDst = 0;

  aopt_uncondjmp = [
    A_BRA,
    A_BRL
  ];

  aopt_condjmp = [
    A_BCC,
    A_BCS,
    A_BEQ,
    A_BMI,
    A_BNE,
    A_BPL,
    A_BVC,
    A_BVS    
  ];

implementation

uses
  verbose;

constructor TCondRegs.init;
begin
end;

destructor TCondRegs.Done; {$ifdef inl} inline; {$endif inl}
begin
end;

function TAoptBaseCpu.Reg1ReadDependsOnReg2(reg1, reg2: tregister): boolean;
begin
  result := false;
end;

function TAoptBaseCpu.RegModifiedByInstruction(Reg: TRegister; p1: tai): boolean;
begin
  result := false;
end;

end.