{ don't edit, this file is generated from m65xxins.dat; to regenerate, run 'make insdat' in the compiler directory }
(
  (
    opcode  : A_None;
    ops     : 0;
    optypes : (OT_NONE,OT_NONE);
    code    : 'void';
    flags   : 
  ),
  (
    opcode  : A_ADC;
    ops     : 1;
    optypes : (OT_IMM,OT_NONE);
    code    : '$69,{0}';
    flags   : IF_6502
  ),
  (
    opcode  : A_ADC;
    ops     : 1;
    optypes : (OT_ABS,OT_NONE);
    code    : '$6D,{0}';
    flags   : IF_6502
  ),
  (
    opcode  : A_ADC;
    ops     : 2;
    optypes : (OT_ABS,OT_X);
    code    : '$7D,{0}';
    flags   : IF_6502
  ),
  (
    opcode  : A_ADC;
    ops     : 2;
    optypes : (OT_ABS,OT_Y);
    code    : '$79,{0}';
    flags   : IF_6502
  ),
  (
    opcode  : A_ADC;
    ops     : 1;
    optypes : (OT_ABS_LONG,OT_NONE);
    code    : '$6F,{0}';
    flags   : IF_65C816
  ),
  (
    opcode  : A_ADC;
    ops     : 2;
    optypes : (OT_ABS_LONG,OT_X);
    code    : '$7F,{0}';
    flags   : IF_65C816
  ),
  (
    opcode  : A_ADC;
    ops     : 1;
    optypes : (OT_DIR,OT_NONE);
    code    : '$65,{0}';
    flags   : IF_6502
  ),
  (
    opcode  : A_ADC;
    ops     : 2;
    optypes : (OT_DIR,OT_S);
    code    : '$63,{0}';
    flags   : IF_65C816
  ),
  (
    opcode  : A_ADC;
    ops     : 2;
    optypes : (OT_DIR,OT_X);
    code    : '$75,{0}';
    flags   : IF_6502
  ),
  (
    opcode  : A_ADC;
    ops     : 1;
    optypes : (OT_DIR_IND,OT_NONE);
    code    : '$72,{0}';
    flags   : IF_6502
  ),
  (
    opcode  : A_ADC;
    ops     : 2;
    optypes : (OT_REL_S_IND,OT_Y);
    code    : '$73,{0}';
    flags   : IF_65C816
  ),
  (
    opcode  : A_ADC;
    ops     : 1;
    optypes : (OT_DIR_X_IND,OT_NONE);
    code    : '$61,{0}';
    flags   : IF_6502
  ),
  (
    opcode  : A_ADC;
    ops     : 2;
    optypes : (OT_DIR_IND,OT_Y);
    code    : '$71,{0}';
    flags   : IF_6502
  ),
  (
    opcode  : A_ADC;
    ops     : 1;
    optypes : (OT_DIR_IND_LONG,OT_NONE);
    code    : '$67,{0}';
    flags   : IF_65C816
  ),
  (
    opcode  : A_ADC;
    ops     : 2;
    optypes : (OT_DIR_IND_LONG,OT_Y);
    code    : '$77,{0}';
    flags   : IF_65C816
  ),
  (
    opcode  : A_BRA;
    ops     : 1;
    optypes : (OT_REL,OT_NONE);
    code    : '$80,{0}';
    flags   : IF_6502
  ),
  (
    opcode  : A_BRL;
    ops     : 1;
    optypes : (OT_REL_LONG,OT_NONE);
    code    : '$82,{0}';
    flags   : IF_65C816
  ),
  (
    opcode  : A_MVN;
    ops     : 2;
    optypes : (OT_XYC,OT_XYC);
    code    : '$54,{0},{1}';
    flags   : IF_65C816
  ),
  (
    opcode  : A_MVP;
    ops     : 2;
    optypes : (OT_XYC,OT_XYC);
    code    : '$44,{0},{1}';
    flags   : IF_65C816
  )
);
