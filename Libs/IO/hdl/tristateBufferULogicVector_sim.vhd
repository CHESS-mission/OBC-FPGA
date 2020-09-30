ARCHITECTURE sim OF tristateBufferULogicVector IS
BEGIN
  out1 <= std_logic_vector(in1) after delay when OE = '1' else (others => 'Z') after delay;
END ARCHITECTURE sim;

