{$define FPC_SYSTEM_HAS_GET_FRAME}
function get_frame: pointer;
begin
  result := nil;
end;

{$define FPC_SYSTEM_HAS_GET_CALLER_ADDR}
function get_caller_addr(framebp: pointer; addr: codepointer = nil): codepointer;
begin
  result := addr;
end;


{$define FPC_SYSTEM_HAS_GET_CALLER_FRAME}
function get_caller_frame(framebp: pointer; addr: codepointer = nil): pointer;
begin
  result := framebp;
end;


{$define FPC_SYSTEM_HAS_SPTR}
function SPtr:pointer;
begin
  result := nil;
end;
