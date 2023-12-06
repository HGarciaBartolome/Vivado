library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top is
 PORT ( 
 Button: in std_logic_vector(3 DOWNTO 0);
 CLK : in std_logic;
 EMER : in std_logic;
 LED_Floor : OUT std_logic_vector(3 DOWNTO 0);
 Motor_Up: OUT std_logic;
 Motor_Down : OUT std_logic; 
 Door_Close : OUT std_logic; 
 Door_open : OUT std_logic; 
 EMER_LED : OUT std_logic

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
 CLK : in std_logic;
 EDGE : in std_logic_vector(3 DOWNTO 0);
 DOOR_CLOSE : out std_logic;
 DOOR_OPEN : out std_logic;
 MOTOR_UP : out std_logic;
 MOTOR_DOWN : out std_logic;
 LED_Floor: out std_logic_vector(3 DOWNTO 0);
 LED_EMER: out std_logic
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
 CLK => CLK,
 EDGE => EDGES,
 DOOR_CLOSE =>Door_Close,
 DOOR_OPEN =>Door_Open,
 MOTOR_UP=>Motor_Up,
 MOTOR_DOWN=>Motor_Down,
 LED_Floor => LED_Floor,
 LED_EMER => EMER_LED
);
end Behavioral;
