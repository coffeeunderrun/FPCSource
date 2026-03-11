type
   pjmp_buf = ^jmp_buf;
   jmp_buf = packed record
     a, x, y, p, s: byte;
     pc: word;
   end;

function setjmp(var S: jmp_buf) : shortint; [external name 'FPC_SETJMP'];

procedure longjmp(var S: jmp_buf; value: shortint); [external name 'FPC_LONGJMP'];
