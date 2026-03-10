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

{$ifndef NOAGCPUCA65}
  ,agca65
{$endif}
  ;

end.