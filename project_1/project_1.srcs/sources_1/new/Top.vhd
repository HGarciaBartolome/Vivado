library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top is
 PORT ( 
 --Real
 RESET: in std_logic;
 Button: in std_logic_vector(3 DOWNTO 0);
 CLK : in std_logic;
 EMER : in std_logic;
 BCD_Floor : OUT std_logic_vector(6 DOWNTO 0);
 Dig_select: out std_logic_vector(7 downto 0);
 MOTORS: OUT std_logic_vector (1 DOWNTO 0); -- 00 stdby 01 Up 10 Down 11 ERROR
 DOORS: OUT std_logic;  -- 1 Abierto 0 Cerrados
 EMER_LED : OUT std_logic;
 LED_Piso:out std_logic_vector(3 DOWNTO 0);
 LEDEspera:out std_logic;
 PISOACT: in std_logic_vector(3 DOWNTO 0)

 );
end Top;

architecture Behavioral of Top is
    signal SSYNC : std_logic_vector(3 DOWNTO 0);
    signal EDGES : std_logic_vector(3 DOWNTO 0);
    signal pisobcd: std_logic_vector(3 Downto 0);
    signal Pisoobjsal: std_logic_vector(3 Downto 0);
    signal bcdflip: std_logic := '0';
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
 --TestBench
 Pisoobjsal: out std_logic_vector(3 DOWNTO 0);
 
 --Real
 RESET: in std_logic;
 CLK : in std_logic;
 EDGE : in std_logic_vector(3 DOWNTO 0);
 MOTORS: OUT std_logic_vector (1 DOWNTO 0); -- 00 stdby 01 Up 10 Down 11 ERROR
 DOORS: OUT std_logic;  -- 1 Abierto 0 Cerrados
 LEDEspera:out std_logic;
 LED_EMER: out std_logic;
 PISOACT: in std_logic_vector(3 DOWNTO 0)
 --Pisoactsal: out integer;
 --Pisoobjsal: out integer
 );
END COMPONENT;

COMPONENT decoder
    port(
    code : IN std_logic_vector(3 DOWNTO 0);
    led : OUT std_logic_vector(6 DOWNTO 0)  
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

 Pisoobjsal => Pisoobjsal,
 RESET => RESET,
 CLK => CLK,
 EDGE => EDGES,
 DOORS =>DOORS,
 MOTORS => MOTORS,
 LEDEspera => LEDEspera,
 LED_EMER => EMER_LED,
 PISOACT => PISOACT

);
Inst_decoderPiso: decoder PORT MAP(
       code => pisobcd,
       led  => BCD_Floor
);

LED_Piso <= PISOACT;

-- Conversor de Piso objetivo a  BCD para el decoder, si no hay piso actual se pone a 7
in_a_bcd:process(Pisoobjsal)
begin
        Dig_select<= "11111110";
        case Pisoobjsal is
        when "0001" =>
            pisobcd<="0001";
        when "0010" =>
            pisobcd<="0010";
        when "0100" =>
            pisobcd<="0011";
        when "1000" =>
            pisobcd<="0100";
        when others =>
            pisobcd <="0111";
        end case;
end process;
end Behavioral;
