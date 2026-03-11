unit n65xxmat;

{$i fpcdefs.inc}

interface

uses
  cgbase,
  node, nmat, ncgmat;

type
  t65xxnotnode = class(tcgnotnode)
  protected
    procedure second_boolean; override;
  end;

  t65xxmoddivnode = class(tcgmoddivnode)
  protected
    procedure emit_div_reg_reg_reg(signed: boolean; denum, num, res: tregister); override;
    procedure emit_mod_reg_reg_reg(signed: boolean; denum, num, res: tregister); override;
  end;

implementation

uses
  cpubase,
  cgutils,cgobj,
  pass_2;

procedure t65xxnotnode.second_boolean;
begin
  secondpass(left);
  if not handle_locjump then begin
    location_reset(location, LOC_FLAGS, OS_NO);
    location.resflags := F_EQ;
  end;
end;

procedure t65xxmoddivnode.emit_div_reg_reg_reg(signed: boolean; denum, num, res: tregister);
begin
end;

procedure t65xxmoddivnode.emit_mod_reg_reg_reg(signed: boolean; denum, num, res: tregister);
begin
end;

begin
  cmoddivnode := t65xxmoddivnode;
  cnotnode := t65xxnotnode;
end.