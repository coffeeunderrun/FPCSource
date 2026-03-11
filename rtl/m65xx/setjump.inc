function fpc_setjmp(var s: jmp_buf): smallint; compilerproc;
begin
  result := 0;
end;

procedure fpc_longjmp(var s: jmp_buf; value: smallint); compilerproc;
begin
end;
