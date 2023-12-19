library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top is
 PORT ( 
 RESET: in std_logic;
 Button: in std_logic_vector(3 DOWNTO 0);
 CLK : in std_logic;
 EMER : in std_logic;
 LED_Floor : OUT std_logic_vector(3 DOWNTO 0);
 MOTORS: OUT std_logic_vector (1 DOWNTO 0); -- 00 stdby 01 Up 10 Down 11 ERROR
 DOORS: OUT std_logic;  -- 1 Abierto 0 Cerrados
 EMER_LED : OUT std_logic;
 EDGES_SAL: out std_logic_vector(3 downto 0);
 Pisoactsal: out integer;
 Pisoobjsal: out integer
 );
end Top;

architecture Behavioral of Top is
    signal SSYNC : std_logic_vector(3 DOWNTO 0);
    signal EDGES : std_logic_vector(3 DOWNTO 0);
COMPONENT SYNCHRNZR 
 port (
 CLK : in std_logic;
 ASYNC_IN : in std_logic;
 SYNC_OUT : out std_logic
 );
END COMPONENT;
COMPONENT EDGEDTCTR
 port (
 CLK : in std_logic;
 SYNC_IN : in std_logic;
 EDGE : out std_logic
 );
END COMPONENT;
COMPONENT FMS_Elevator
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
END COMPONENT;

begin

Inst_synchrnzr0:  SYNCHRNZR port MAP(
 CLK =>CLK,
 ASYNC_IN => Button(0),
 SYNC_OUT => SSYNC(0)
 );
 Inst_edgedtctr0: EDGEDTCTR PORT MAP (
 CLK => CLK,
 SYNC_IN=>SSYNC(0),
 EDGE=>EDGES(0)
);
Inst_synchrnzr1:  SYNCHRNZR port MAP(
 CLK =>CLK,
 ASYNC_IN => Button(1),
 SYNC_OUT => SSYNC(1)
 );
 Inst_edgedtctr1: EDGEDTCTR PORT MAP (
 CLK => CLK,
 SYNC_IN=>SSYNC(1),
 EDGE=>EDGES(1)
);
Inst_synchrnzr2:  SYNCHRNZR port MAP(
 CLK =>CLK,
 ASYNC_IN => Button(2),
 SYNC_OUT => SSYNC(2)
 );
 Inst_edgedtctr2: EDGEDTCTR PORT MAP (
 CLK => CLK,
 SYNC_IN=>SSYNC(2),
 EDGE=>EDGES(2)
);
Inst_synchrnzr3:  SYNCHRNZR port MAP(
 CLK =>CLK,
 ASYNC_IN => Button(3),
 SYNC_OUT => SSYNC(3)
 );
 Inst_edgedtctr3: EDGEDTCTR PORT MAP (
 CLK => CLK,
 SYNC_IN=>SSYNC(3),
 EDGE=>EDGES(3)
);
Inst_fmsElevator: FMS_Elevator PORT MAP(
 RESET => RESET,
 CLK => CLK,
 EDGE => EDGES,
 DOORS =>DOORS,
 MOTORS => MOTORS,
 LED_Floor => LED_Floor,
 LED_EMER => EMER_LED,
 Pisoactsal => Pisoactsal,
 Pisoobjsal => Pisoobjsal
);
EDGEs_SAL <= EDGES;
end Behavioral;
