unit n65xxflw;

{ TODO: this unit can be removed once code generation is implemented }

{$i fpcdefs.inc}

interface

uses
  ncgflw,
  nflw;

type
  t65xxifnode = class(tcgifnode)
    procedure pass_generate_code; override;
  end;

implementation

procedure t65xxifnode.pass_generate_code;
begin
end;

begin
  cifnode := t65xxifnode;
end.
