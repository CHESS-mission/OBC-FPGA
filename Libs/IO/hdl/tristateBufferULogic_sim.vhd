ARCHITECTURE sim OF tristateBufferULogic IS
BEGIN
  out1 <= in1 after delay when OE = '1' else 'Z' after delay;
END ARCHITECTURE sim;

