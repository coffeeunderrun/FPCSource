unit cpuinfo;

{$i fpcdefs.inc}

interface

uses globtype;

type
  bestreal    = double;
  bestrealrec = TDoubleRec;
  ts32real    = single;
  ts64real    = double;
  ts80real    = type extended;
  ts128real   = type extended;
  ts64comp    = comp;

  pbestreal = ^bestreal;

  tcputype = (
    cpu_none,
    cpu_6502,
    cpu_6510,
    cpu_65c02,
    cpu_65c816
  );

  tfputype = (
    fpu_none,
    fpu_soft,
    fpu_libgcc
  );

  tcontrollertype = (
    ct_none
  );

  tcontrollerdatatype = record
    controllertypestr, controllerunitstr: string[20];
    cputype: tcputype; fputype: tfputype;
    flashbase, flashsize, srambase, sramsize, eeprombase, eepromsize, bootbase, bootsize: dword;
  end;

  tcpuflags = (
    cf_none
  );

const
  { target cpu string (used by compiler options) }
  target_cpu_string = '65xx';

  { Is there support for dealing with multiple microcontrollers available }
  ControllerSupport = false;

  { We know that there are fields after sramsize but we don't care about this warning }
  {$PUSH}
  {$WARN 3177 OFF}
  embedded_controllers : array [tcontrollertype] of tcontrollerdatatype = (
    (controllertypestr:''; controllerunitstr:''; cputype:cpu_none; fputype:fpu_none; flashbase:0; flashsize:0; srambase:0; sramsize:0)
  );
  {$POP}

  { calling conventions supported by the code generator }
  supported_calling_conventions : tproccalloptions = [
    pocall_internproc,
    pocall_safecall,
    pocall_stdcall,
    { same as stdcall only different name mangling }
    pocall_cdecl,
    { same as stdcall only different name mangling }
    pocall_cppdecl,
    { same as stdcall but floating point numbers are handled like equal sized integers }
    pocall_softfloat
  ];

  cputypestr : array[tcputype] of string[16] = (
    '',
    '6502',
    '6510',
    '65C02',
    '65C816'
  );

  fputypestr : array[tfputype] of string[6] = (
    'NONE',
    'SOFT',
    'LIBGCC'
  );

  cpu_capabilities : array [tcputype] of set of tcpuflags = (
    { cpu_none  } [],
    { cpu_6502  } [],
    { cpu_6510  } [],
    { cpu_65c02 } [],
    { cpu_65c816  } []
  );

  { Supported optimizations, only used for information }
  supported_optimizerswitches = genericlevel1optimizerswitches+
                                genericlevel2optimizerswitches+
                                genericlevel3optimizerswitches-
                                { no need to write info about those }
                                [cs_opt_level1,cs_opt_level2,cs_opt_level3]+
                                [{cs_opt_regvar,}cs_opt_loopunroll,cs_opt_tailrecursion,
                                cs_opt_stackframe,cs_opt_nodecse,cs_opt_reorder_fields,cs_opt_fastmath];

  level1optimizerswitches = genericlevel1optimizerswitches;
  level2optimizerswitches = genericlevel2optimizerswitches + level1optimizerswitches +
    [{cs_opt_regvar,}cs_opt_stackframe,cs_opt_tailrecursion];
  level3optimizerswitches = genericlevel3optimizerswitches + level2optimizerswitches;
  level4optimizerswitches = genericlevel4optimizerswitches + level3optimizerswitches + [];

implementation

end.