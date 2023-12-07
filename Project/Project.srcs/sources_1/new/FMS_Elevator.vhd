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
 LED_EMER: out std_logic
 );
end FMS_Elevator;

architecture Behavioral of FMS_Elevator is
    type STATES is (stdby, Up, Down, Error);
    signal pisoactual : integer :=0;
    signal pisoobjetivo: integer := 0;
    signal trabajando: std_logic:='0';
    signal state: STATES := stdby;
    
begin
state_register:process(CLK,RESET)
    begin
        if(RESET = '1') then
            trabajando <='0';
        elsif rising_edge(CLK) then
            if(pisoactual = pisoobjetivo) then
                state <= stdby;
            elsif (pisoactual < pisoobjetivo) then
                state <= Up;
            elsif (pisoactual > pisoobjetivo) then
                state <= Down;
            else
                state <= ERROR;
            end if;
        end if;
    end process;
next_state_decoder: process(EDGE,trabajando)
    begin
        if(trabajando = '0') then
            case EDGE is
                when "0001" =>
                   pisoobjetivo<= 0;
                   trabajando <= '1';
                when "0010" =>
                   pisoobjetivo<= 1;
                   trabajando <= '1';
                when "0100" =>
                   pisoobjetivo<= 2;
                   trabajando <= '1';
                when "1000" =>
                   pisoobjetivo<= 3;
                   trabajando <= '1';
                when others =>
            end case;
        end if;
    end process;
output_decod: process(pisoactual,state)
    begin
        if (state = stdby) then
            MOTORS <= "00";
            DOORS <= '1';
        elsif (state = UP) then
            MOTORS <= "01";
            DOORS <= '0';
        elsif (state = DOWN) then
            MOTORS <= "10";
            DOORS <= '0';
        end if;
        case pisoactual is
            when 0 =>
                LED_floor <= "0001";
            when 1 =>
                LED_floor <= "0010";
            when 2 =>
                LED_floor <= "0100";
            when 3 =>
                LED_floor <= "1000";
        end case;
    end process;
error_detect: process
    begin
    end process;

cambio_piso: process
    begin
    end process;

end Behavioral;
