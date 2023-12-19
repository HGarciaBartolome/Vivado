library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned .all;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is
component Top is
    port(
        RESET: in std_logic;
        Button: in std_logic_vector(3 DOWNTO 0);
        CLK : in std_logic;
        EMER : in std_logic;
        LED_Floor : OUT std_logic_vector(3 DOWNTO 0);
        MOTORS: OUT std_logic_vector (1 DOWNTO 0); -- 00 stdby 01 Up 10 Down 11 ERROR
        DOORS: OUT std_logic;  -- 1 Abierto 0 Cerrados
        EMER_LED : OUT std_logic;
        ---Apartir de aqui hay tests
        EDGES_SAL: out std_logic_vector (3 DOWNTO 0);
        Pisoactsal: out integer;
        Pisoobjsal: out integer
    );
end component Top;
signal Reset: std_logic := '0';
signal Button: std_logic_vector(3 Downto 0) := "0000";
signal CLK: std_logic := '0';
signal Emer: std_logic := '0';
signal Piso: std_logic_vector(3 downto 0):= "0000";
signal Motors: std_logic_vector(1 downto 0):= "00";
signal Doors : std_logic := '0';
signal Led_Emer:std_logic := '0';
signal EDGES_SAL: std_logic_vector( 3 DOWNTO 0):= "0000";
signal Pisoactsal: integer;
signal Pisoobjsal: integer;
begin
Instacia:component top
    port map(
        RESET => Reset,
        Button => Button,
        CLK => CLK,
        EMER => Emer,
        LED_Floor => Piso,
        MOTORS => Motors,
        DOORS => Doors,
        EMER_LED => Led_Emer,
        EDGES_SAL => EDGES_SAL,
        Pisoactsal => Pisoactsal,
        Pisoobjsal => Pisoobjsal
       );

Reloj: CLK <= not CLK after 5ns;

STIM: process
begin
    Button(1) <= '1';
    wait for 10ns;
    Button(1) <= '0';
    wait for 400ns;
    Button(3) <= '1';
    wait for 10ns;
    Button(3) <= '0';
    wait for 900ns;
    Button(2) <= '1';
    wait for 10ns;
    Button(2) <= '0';
    wait for 50ns;
    RESET<= '1';
    wait for 10ns;
    RESET <= '0';
    Button(0) <= '1';
    wait for 10ns;
    Button(0) <= '0';
    wait for 500ns;
    Button(2) <= '1';
    wait for 10ns;
    Button(2) <= '0';
    Button(3) <= '1';
    wait for 10ns;
    Button(3) <= '0';
    wait for 500ns;
end process; 
end Behavioral;
