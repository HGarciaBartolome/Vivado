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
 LED_EMER: out std_logic;
 PISOACT: in std_logic_vector(3 DOWNTO 0)
 
 
 --- PARA TESTBENCH
 --Pisoactsal: out integer;
 --Pisoobjsal: out integer
 );
end FMS_Elevator;

architecture Behavioral of FMS_Elevator is
    type STATES is (Arranque,Error,Piso1,Piso2,Piso3,Piso4,S12,S13,S14,B21,S23,S24,B31,B32,S34,B41,B42,B43,Espera);
    signal pisoobjetivo : std_logic_vector(3 Downto 0):="0000";
    signal trabajando: std_logic:='0';
    signal current_state, next_state: STATES;
    signal flagerror : std_logic :='0';
    signal flag1, flag2, flag3, flag4: std_logic :='0';
begin
state_register:process(CLK,RESET)
    begin
        if (RESET = '1') then
            current_state <= Arranque;
        elsif (rising_edge(CLK)) then
            current_state <= next_state;
        end if;
    end process;
next_state_decoder: process(EDGE,RESET,current_state,PISOACT)
    begin
    
        next_state <= current_state;
-- Cambio de estados
     case current_state is
        when Arranque =>
         case PISOACT is
            when "0001" =>
                next_state <= Piso1;
            when "0010" =>
                next_state <= Piso2;
            when "0100" =>
                next_state <= Piso3;
            when "1000" =>
                next_state <= Piso4;
            when others =>
                next_state <= Error;
         end case;
        when Piso1 =>
         case pisoobjetivo is
            when "0010" =>
                next_state <= S12;
                pisoobjetivo<="0000";
            when "0100" =>
                next_state <= S13;
                pisoobjetivo<="0000";
            when "1000" =>
                next_state <= S14;
                pisoobjetivo<="0000";      
            when others=>
         end case;
        when Piso2 =>
         case pisoobjetivo is
            when "0001" =>
                next_state <= B21;
                pisoobjetivo<="0000";
            when "0100" =>
                next_state <= S23;
                pisoobjetivo<="0000";
            when "1000" =>
                next_state <= S24;
                pisoobjetivo<="0000";      
            when others=>
         end case;
        when Piso3 =>
         case pisoobjetivo is
            when "0001" =>
                next_state <= B31;
                pisoobjetivo<="0000";
            when "0010" =>
                next_state <= B32;
                pisoobjetivo<="0000";
            when "1000" =>
                next_state <= S34;
                pisoobjetivo<="0000";      
            when others=>
         end case;
        when Piso4 =>
         case pisoobjetivo is
            when "0001" =>
                next_state <= B41;
                pisoobjetivo<="0000";
            when "0010" =>
                next_state <= B42;
                pisoobjetivo<="0000";
            when "0100" =>
                next_state <= B43;
                pisoobjetivo<="0000";      
            when others=>
         end case;
         
-- Cambios Piso 1 a otros
        when S12 =>
            if ( flag2<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
        when S13 =>
            if ( flag2<='1' and flag3<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
        when S14 =>
            if ( flag2<='1' and flag3<='1' and flag4<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
         
-- Cambios Piso 2 a otros
        when B21 =>
            if ( flag1<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
        when S23 =>
            if ( flag3<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
        when S24 =>
            if ( flag3<='1' and flag4<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
         
-- Cambios Piso 3 a otros
        when B31 =>
            if ( flag2<='1' and flag3 <= '1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
        when B32 =>
            if ( flag2<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
        when S34 =>
            if ( flag4<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if; 
         
-- Cambios Piso 4 a otros
        when B41 =>
            if ( flag2<='1' and flag3<='1' and flag1<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
        when B42 =>
            if ( flag2<='1' and flag3<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
        when B43 =>
            if (flag3<='1') then
                next_state<= Espera;
                flag1<='0';
                flag2<='0';
                flag3<='0';
                flag4<='0';
            end if;
            
-- Asegurarse que limpia la barra de tarreas
        when Espera =>
            pisoobjetivo<= "0000";
            case PISOACT is
            when "0001" =>
                next_state <= Piso1;
            when "0010" =>
                next_state <= Piso2;
            when "0100" =>
                next_state <= Piso3;
            when "1000" =>
                next_state <= Piso4;
            when others =>
                next_state <= Error;
         end case; 
            
-- Estado raro = Error     
        when others =>
            next_state <= Error;
      end case;
      
      
      
 -- Detecion entradas     
            case EDGE is
                when "0001" =>
                   pisoobjetivo<= "0001";
                when "0010" =>
                   pisoobjetivo<="0010";
                when "0100" =>
                   pisoobjetivo<= "0100";
                when "1000" =>
                   pisoobjetivo<= "1000";
                when others =>
            end case;

    end process;
output_decod: process(PISOACT,current_state)
    begin
        if (current_state = Piso1 or current_state= Piso2 or current_state= Piso3 or current_state= Piso4  ) then
            MOTORS(1) <= '0';
            MOTORS(0) <= '0';
            DOORS <= '1';
        elsif (current_state= S12 or current_state= S13 or current_state= S14 or current_state= S23 or current_state= S24 or current_state= S34) then
            MOTORS(1) <= '0';
            MOTORS(0) <= '1';
            DOORS <= '0';
        elsif (current_state=B21 or current_state=B31 or current_state=B32 or current_state=B41 or current_state=B42 or current_state=B43 ) then
            MOTORS(1) <= '1';
            MOTORS(0) <= '0';
            DOORS <= '0';
        elsif (current_state = Error) then
            MOTORS(1) <= '0';
            MOTORS(0) <= '0';
            DOORS<= '0';
            LED_EMER<='1';
        end if;
        case PISOACT is
            when "0001"=>
                LED_floor <= "0001";
            when "0010" =>
                LED_floor <= "0010";
            when "0100" =>
                LED_floor <= "0100";
            when "1000" =>
                LED_floor <= "1000";
            when others =>
        end case;
    end process;
    
-- Detecion Cambio de Piso
flags: process (PISOACT)
    begin
        if ( rising_edge(PISOACT(0))) then
            flag1 <= '1';
        end if;
        if (rising_edge(PISOACT(1))) then
            flag2 <= '1';
        end if;
        if ( rising_edge(PISOACT(2))) then
            flag3 <= '1';
        end if;
        if ( rising_edge(PISOACT(3))) then
            flag4 <= '1';
        end if;
    end process;
--error_detect: process(PISOACT,pisoobjetivo,current_state) --comprobación de error en la situación actual del ascensor, si baja más de lo que debería o si sube más de lo debido
--    begin
--        if(pisoactual<pisoobjetivo) and (current_state=B21 or current_state=B31 or current_state=B32 or current_state=B41 or current_state=B42 or current_state=B43 ) then
--            flagerror <='1';
--        elsif(pisoactual>pisoobjetivo)and (current_state= S12 or current_state= S13 or current_state= S14 or current_state= S23 or current_state= S24 or current_state= S34)  then
--            flagerror <='1';
--        end if;
--    end process;

--cambio_piso: process--se mueve al piso indicado, esperando x tiempo simulando el movimiento del ascensor
--    begin
--        if(state = Up) then
--            loopcount<=0;
--           for loopcount in 1 to 10 loop
--                wait until rising_edge(CLK);
--            end loop;
--            if(state = Up) then
--                pisoactual<= pisoactual+1;--tras terminar la espera, sube un piso
--            end if;
--        elsif(state = Down) then
--            loopcount<=0;
--             for loopcount in 1 to 10 loop
--                wait until rising_edge(CLK);
--            end loop;
--            if(state = Down) then
--                pisoactual<= pisoactual-1;--tras terminar la espera, sube un piso
--            end if;
--        elsif(state = stdby) then
--            loopcount<=0;
--             for loopcount in 1 to 20 loop
--                wait until rising_edge(CLK);
--            end loop;
--          flagfin <= '1';
--          wait until falling_edge(trabajando);
--          flagfin <= '0';
--        end if;
----    end process;

-- TestBench

-- Pisoactsal <= pisoactual;
-- Pisoobjsal <= pisoobjetivo;
end Behavioral;
