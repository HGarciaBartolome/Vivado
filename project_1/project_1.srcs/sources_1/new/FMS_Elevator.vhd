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
    signal pisoactual , pisoobjetivo : integer :=0;
    signal trabajando: std_logic:='0';
    signal state: STATES := stdby;
    signal tiempoviaje , loopcount : integer :=0;
    signal flagerror , flagfin: std_logic :='0';
begin
state_register:process(CLK,RESET)
    begin
        if rising_edge(CLK) then
            if(pisoactual = pisoobjetivo) then
                state <= stdby;
            elsif (pisoactual < pisoobjetivo) then
                state <= Up;
            elsif (pisoactual > pisoobjetivo) then
                state <= Down;
            elsif flagerror ='1' then
                state <= Error;
            else 
                state<= Error;
            end if;
        end if;
    end process;
next_state_decoder: process(EDGE,RESET,flagfin)
    begin
        if(RESET = '1') then
           trabajando <='0';
        elsif(trabajando = '0') then
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
        elsif flagfin ='1' then
          trabajando <= '0';
        end if;
    end process;
output_decod: process(pisoactual,state)
    begin
        if (state = stdby) then
            MOTORS(1) <= '0';
            MOTORS(0) <= '0';
            DOORS <= '1';
        elsif (state = Up) then
            MOTORS(1) <= '0';
            MOTORS(0) <= '1';
            DOORS <= '0';
        elsif (state = Down) then
            MOTORS(1) <= '1';
            MOTORS(0) <= '0';
            DOORS <= '0';
        elsif (state = Error) then
            MOTORS(1) <= '0';
            MOTORS(0) <= '0';
            DOORS<= '0';
            LED_EMER<='1';
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
              when others =>
        end case;
    end process;
    
error_detect: process(pisoactual,pisoobjetivo,state) --comprobación de error en la situación actual del ascensor, si baja más de lo que debería o si sube más de lo debido
    begin
        if(pisoactual<pisoobjetivo) and (state=down) then
            flagerror <='1';
        elsif(pisoactual>pisoobjetivo)and(state=up) then
            flagerror <='1';
        end if;
    end process;

cambio_piso: process--se mueve al piso indicado, esperando x tiempo simulando el movimiento del ascensor
    begin
        if(state = Up) then
            loopcount<=0;
           for loopcount in 1 to 10 loop
                wait until rising_edge(CLK);
            end loop;
            pisoactual<= pisoactual+1;--tras terminar la espera, sube un piso
        
        elsif(state = Down) then
            loopcount<=0;
             for loopcount in 1 to 10 loop
                wait until rising_edge(CLK);
            end loop;
            pisoactual<= pisoactual-1;--tras terminar la espera, sube un piso
            
        elsif(state = stdby) then
            loopcount<=0;
             for loopcount in 1 to 20 loop
                wait until rising_edge(CLK);
            end loop;
          flagfin <= '1';
          wait until falling_edge(trabajando);
          flagfin <= '0';
        end if;
    end process;
end Behavioral;
