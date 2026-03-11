unit cpunode;

{$i fpcdefs.inc}

interface

implementation

uses
	{ generic nodes }
	ncgbas, 
  ncgld, 
  ncgflw, 
  ncgcnv, 
  ncgmem, 
  ncgcon, 
  ncgcal, 
  ncgset, 
  ncginl, 
  ncgopt, 
  ncgmat, 
  ncgadd,

  { symtable }
  symcpu,
  aasmdef,

	{ these are not really nodes }
	tgobj,

	{ m65xx-specific nodes }
	n65xxflw,
	n65xxadd,
	n65xxset,
	n65xxmat;

end.