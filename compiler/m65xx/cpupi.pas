unit cpupi;

{$i fpcdefs.inc}

interface

uses
	psub;

type
	tcpuprocinfo = class(tcgprocinfo)
	end;

implementation

uses
  procinfo;

begin
	cprocinfo := tcpuprocinfo;
end.