LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY decoder IS
PORT (
code : IN std_logic_vector(3 DOWNTO 0);
led : OUT std_logic_vector(6 DOWNTO 0)
);
END ENTITY decoder;
ARCHITECTURE dataflow OF decoder IS
BEGIN
WITH code SELECT
led <= "0000001" WHEN "0000",
"1001111" WHEN "0001",
"0010010" WHEN "0010",
"0000110" WHEN "0011",
"1001100" WHEN "0100",
"0100100" WHEN "0101",
"0100000" WHEN "0110",
"0001111" WHEN "0111",
"0000000" WHEN "1000",
"0000100" WHEN "1001",
"1111110" WHEN others;
END ARCHITECTURE dataflow;