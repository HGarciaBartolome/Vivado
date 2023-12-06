library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FMS_Elevator is
 port (
 CLK : in std_logic;
 EDGE : in std_logic_vector(3 DOWNTO 0);
 DOOR_CLOSE : out std_logic;
 DOOR_OPEN : out std_logic;
 MOTOR_UP : out std_logic;
 MOTOR_DOWN : out std_logic;
 LED_Floor: out std_logic_vector(3 DOWNTO 0);
 LED_EMER: out std_logic
 );
end FMS_Elevator;

architecture Behavioral of FMS_Elevator is

begin

end Behavioral;
