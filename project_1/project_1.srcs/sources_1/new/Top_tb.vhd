----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.12.2023 18:35:53
-- Design Name: 
-- Module Name: Top_tb - Behavioral
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

entity Top_tb is
--  Port ( );
end Top_tb;

architecture Behavioral of Top_tb is

signal RESET, CLK, EMER, DOORS, EMER_LED : std_logic :='0';
signal Button,LED_Floor : std_logic_vector(3 DOWNTO 0);
signal MOTORS : std_logic_vector(1 DOWNTO 0);
component Top is
 PORT ( 
 RESET: in std_logic;
 Button: in std_logic_vector(3 DOWNTO 0);
 CLK : in std_logic;
 EMER : in std_logic;
 LED_Floor : OUT std_logic_vector(3 DOWNTO 0);
 MOTORS: OUT std_logic_vector (1 DOWNTO 0); -- 00 stdby 01 Up 10 Down 11 ERROR
 DOORS: OUT std_logic;  -- 1 Abierto 0 Cerrados
 EMER_LED : OUT std_logic

 );
 end component;
 constant TbPeriod : time := 100 ps;
begin

toptb : top port map(
RESET => RESET,
Button=>Button,
CLK=>CLK,
EMER=>EMER,
LED_Floor=>LED_Floor,
MOTORS=>MOTORS,
DOORS=>DOORS,
EMER_LED=>EMER_LED);
CLK <= not CLK after TbPeriod / 2; -- SIMULACION DEL RELOJ EN TESTBENCH

RESET<='1' after 1000ps;
--creo que hay bastante aqui que esta mal, pero bueno, parte de la simulacion sale bien
STIMULUS_PROCESS : process
begin
--Empezamos pulsando el boton para ir al tercer piso, para comprobar si sube y los indicadores del motor y puerta funcionan como deben
Button <= "0100";
wait for 200ps;
--ahora hacemos que baje para ver si los inidicadores de motor hacia abajo tambien funcionan
Button <="0001";
wait for 200ps;
--ahora pulsamos el botón de emergencia
EMER<='1';
wait for 100ps;
EMER<='0';
wait for 200ps;
Button <="1000";
wait for 200ps;
RESET<='1';
wait for 100ps;
RESET<='0';
end process;

end Behavioral;
