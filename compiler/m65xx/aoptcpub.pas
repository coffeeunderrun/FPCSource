unit aoptcpub;

{$I fpcdefs.inc}

interface

uses
  cpubase,
  cgbase,
  aasmcpu, aasmtai,
  AOptBase;

type
  TInstr = Taicpu;
  PInstr = ^TInstr;

  TAOptBaseCpu = class(TAOptBase)
  end;

const
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

end.