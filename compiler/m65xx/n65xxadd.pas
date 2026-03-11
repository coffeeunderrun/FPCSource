unit n65xxadd;

{$i fpcdefs.inc}

interface

uses
  node, ncgadd, cpubase, cgbase;

type
  t65xxaddnode = class(tcgaddnode)
    procedure second_cmpfloat; override;
    procedure second_cmpordinal;override;
    procedure second_cmpsmallset; override;
    procedure second_cmp64bit; override;
  end;

implementation

uses
  cgutils, cgobj,
  nadd;

procedure t65xxaddnode.second_cmpfloat;
begin
  pass_left_right;
  location_reset(location, LOC_FLAGS, OS_NO);
  location.resflags := F_EQ;
end;

procedure t65xxaddnode.second_cmpordinal;
begin
  pass_left_right;
  location_reset(location, LOC_REGISTER, OS_8);
end;

procedure t65xxaddnode.second_cmpsmallset;
begin
  pass_left_right;
  location_reset(location, LOC_FLAGS, OS_NO);
  location.resflags := F_EQ;
end;

procedure t65xxaddnode.second_cmp64bit;
begin
  pass_left_right;
  location_reset(location, LOC_FLAGS, OS_NO);
  location.resflags := F_EQ;
end;

begin
  caddnode := t65xxaddnode;
end.
