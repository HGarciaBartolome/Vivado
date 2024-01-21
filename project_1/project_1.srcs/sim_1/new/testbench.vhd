library ieee;
use ieee.std_logic_1164.all;

entity tb_Top is
end tb_Top;

architecture tb of tb_Top is

    component Top
        port (RESET      : in std_logic;
              Button     : in std_logic_vector (3 downto 0);
              CLK        : in std_logic;
              EMER       : in std_logic;
              BCD_Floor  : out std_logic_vector (6 downto 0);
              Dig_select : out std_logic_vector (7 downto 0);
              MOTORS     : out std_logic_vector (1 downto 0);
              DOORS      : out std_logic;
              EMER_LED   : out std_logic;
              LED_Piso   : out std_logic_vector (3 downto 0);
              LEDEspera  : out std_logic;
              PISOACT    : in std_logic_vector (3 downto 0));
    end component;

    signal RESET      : std_logic;
    signal Button     : std_logic_vector (3 downto 0):="0000";
    signal CLK        : std_logic;
    signal EMER       : std_logic;
    signal BCD_Floor  : std_logic_vector (6 downto 0);
    signal Dig_select : std_logic_vector (7 downto 0);
    signal MOTORS     : std_logic_vector (1 downto 0);
    signal DOORS      : std_logic;
    signal EMER_LED   : std_logic;
    signal LED_Piso   : std_logic_vector (3 downto 0);
    signal LEDEspera  : std_logic;
    signal PISOACT    : std_logic_vector (3 downto 0):="0000";

    constant TbPeriod : time := 1000 ps; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Top
    port map (RESET      => RESET,
              Button     => Button,
              CLK        => CLK,
              EMER       => EMER,
              BCD_Floor  => BCD_Floor,
              Dig_select => Dig_select,
              MOTORS     => MOTORS,
              DOORS      => DOORS,
              EMER_LED   => EMER_LED,
              LED_Piso   => LED_Piso,
              LEDEspera  => LEDEspera,
              PISOACT    => PISOACT);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        RESET <= '0'; 
        pisoact<=("0001");   
        wait for 800ps;
        Button <= ("1000");
        wait  for 800ps;
        button <=("0000");
        wait for 6000ps;
        pisoact<=("0010");
        wait for 1800ps;
        pisoact<=("0100");
        wait for 1800ps;
        pisoact<=("1000");
        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Top of tb_Top is
    for tb
    end for;
end cfg_tb_Top;