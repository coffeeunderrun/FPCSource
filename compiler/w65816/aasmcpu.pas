unit aasmcpu;

{$i fpcdefs.inc}

interface

uses
  cclasses,
  globtype,globals,verbose,
  aasmbase,aasmtai,aasmdata,aasmsym,
  cgbase,cgutils,cpubase,cpuinfo,
  ogbase;

const
  { "mov reg,reg" source operand number }
  O_MOV_SOURCE = 1;
  { "mov reg,reg" source operand number }
  O_MOV_DEST = 0;

type
  taicpu = class(tai_cpu_abstract_sym)
  end;

  tai_align = class(tai_align_abstract)
    { nothing to add }
  end;

procedure InitAsm;
procedure DoneAsm;

function spilling_create_load(const ref:treference;r:tregister):Taicpu;
function spilling_create_store(r:tregister; const ref:treference):Taicpu;

implementation

procedure InitAsm;
begin
end;

procedure DoneAsm;
begin
end;

function spilling_create_load(const ref:treference;r:tregister):Taicpu;
begin
  result := default(Taicpu);
end;

function spilling_create_store(r:tregister; const ref:treference):Taicpu;
begin
  result := default(Taicpu);
end;

end.