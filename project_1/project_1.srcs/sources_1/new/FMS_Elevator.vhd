library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FMS_Elevator is
 port (
 RESET: in std_logic;
 CLK : in std_logic;
 EDGE : in std_logic_vector(3 DOWNTO 0);
 MOTORS: OUT std_logic_vector (1 DOWNTO 0); -- 00 stdby 01 Up 10 Down 11 ERROR
 DOORS: OUT std_logic;  -- 1 Abierto 0 Cerrados
 LED_Floor: out std_logic_vector(3 DOWNTO 0);
 LED_EMER: out std_logic;
 Pisoactsal: out integer;
 Pisoobjsal: out integer
 );
end FMS_Elevator;

architecture Behavioral of FMS_Elevator is
    type STATES is (stdby, Up, Down, Error);
begin
    
end Behavioral;
