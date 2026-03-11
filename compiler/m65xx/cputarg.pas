unit cputarg;

{$i fpcdefs.inc}

interface

implementation

uses
  systems

{**************************************
             Targets
**************************************}

{$ifndef NOTARGETEMBEDDED}
  ,t_embed
{$endif}

{**************************************
             Assemblers
**************************************}

{$ifndef NOAGCA65}
  ,agca65
{$endif}

{**************************************
             Optimizer
**************************************}

{$ifndef NOOPT}
  ,aoptcpu
{$endif NOOPT}
  ;

end.