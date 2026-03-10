unit tripletcpu;

{$i fpcdefs.inc}

interface

uses globtype;

function tripletcpustr(tripletstyle: ttripletstyle): ansistring;

implementation

uses globals, cpuinfo;

function tripletcpustr(tripletstyle: ttripletstyle): ansistring;
begin
  result:='m65xx';
end;

end.
