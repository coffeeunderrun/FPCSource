unit hlcgcpu;

{$i fpcdefs.inc}

interface

uses
  aasmdata,
  symdef,
  hlcg2ll;

type
  thlcgcpu = class(thlcg2ll)
    procedure g_intf_wrapper(list: TAsmList; procdef: tprocdef; const labelname: string; ioffset: longint);override;
  end;

procedure create_hlcodegen;

implementation

uses
  hlcgobj,
  cgcpu;

procedure thlcgcpu.g_intf_wrapper(list: TAsmList; procdef: tprocdef; const labelname: string; ioffset: longint);
begin
end;

procedure create_hlcodegen;
begin
  hlcg := thlcgcpu.create;
  create_codegen;
end;

begin
  chlcgobj := thlcgcpu;
end.
