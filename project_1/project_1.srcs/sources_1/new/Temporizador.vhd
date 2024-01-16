----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2024 13:40:55
-- Design Name: 
-- Module Name: Temporizador - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Temporizador is
    Generic(Tiempo : integer := 5 ); -- Tiempo que se quiere esperar en segundos. Max 20s.
    Port ( 
           CLK : in STD_LOGIC;
           CE : in STD_LOGIC; --Chip enable
           RESET : in STD_LOGIC;
           Output : out std_logic); 
end Temporizador;

architecture Behavioral of Temporizador is
signal count,max: integer := 0;

begin
max<= Tiempo*100000000;

process(CLK,RESET)
begin
    if (RESET = '1') then
        count <= 0;
        Output<='0';
    elsif (CE = '1') then
        if (count>= max)then
            Output<='1';
        elsif(rising_edge(CLK)) then
            count <= count + 1;
        end if;
    end if;
end process;
end Behavioral;
