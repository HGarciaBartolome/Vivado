library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FMS_Elevator is
 port (
  
 --- PARA TESTBENCH
 --Pisoactsal: out integer;
-- Pisoobjsal: out std_logic_vector(3 DOWNTO 0);
 
 --Reales
 RESET: in std_logic;
 CLK : in std_logic;
 EDGE : in std_logic_vector(3 DOWNTO 0);
 MOTORS: OUT std_logic_vector (1 DOWNTO 0); -- 00 stdby 01 Up 10 Down 11 ERROR
 DOORS: OUT std_logic;  -- 1 Abierto 0 Cerrados
 LED_Floor: out std_logic_vector(3 DOWNTO 0);
 LED_EMER: out std_logic;
 PISOACT: in std_logic_vector(3 DOWNTO 0)
 

 );
end FMS_Elevator;

architecture Behavioral of FMS_Elevator is
    type STATES is (Arranque,Error,Piso1,Piso2,Piso3,Piso4,S12,S13,S14,B21,S23,S24,B31,B32,S34,B41,B42,B43,Espera);
    signal pisoobjetivo : std_logic_vector(3 Downto 0):="0000";
    signal trabajando: std_logic:='0';
    signal current_state: STATES:= Arranque;
    signal flagerror : std_logic :='0';
    signal flag1, flag2, flag3, flag4: std_logic :='0';
    signal flagdown: std_logic:= '1';
begin

state_decoder: process(EDGE,CLK,RESET,current_state)
    begin
    
        --current_state <= current_state;
-- Cambio de estados
    if (RESET = '1') then
            current_state <= Arranque;
   elsif (rising_edge(CLK)) then
     case current_state is
        when Arranque =>
            case PISOACT is
            when "0001" =>
                current_state <= Piso1;
            when "0010" =>
                current_state <= Piso2;
            when "0100" =>
                current_state <= Piso3;
            when "1000" =>
                current_state <= Piso4;
            when others =>
                current_state <= Arranque;
            end case;
--         case PISOACT is
--            when "0001" =>
--                current_state <= Piso1;
--            when "0010" =>
--                current_state <= Piso2;
--            when "0100" =>
--                current_state <= Piso3;
--            when "1000" =>
--                current_state <= Piso4;
--            when others =>
--                current_state <= Error;
--         end case;
        when Piso1 =>
         case pisoobjetivo is
            when "0010" =>
                current_state <= S12;
            when "0100" =>
                current_state <= S13;
            when "1000" =>
                current_state <= S14;   
            when others=>
                current_state <= Piso1;
         end case;
        when Piso2 =>
         case pisoobjetivo is
            when "0001" =>
                current_state <= B21;
            when "0100" =>
                current_state <= S23;
            when "1000" =>
                current_state <= S24;
            when others=>
                current_state <= Piso2;
         end case;
        when Piso3 =>
         case pisoobjetivo is
            when "0001" =>
                current_state <= B31;
            when "0010" =>
                current_state <= B32;
            when "1000" =>
                current_state <= S34;
            when others=>
                current_state <= Piso3;
         end case;
        when Piso4 =>
         case pisoobjetivo is
            when "0001" =>
                current_state <= B41;
            when "0010" =>
                current_state <= B42;
            when "0100" =>
                current_state <= B43;  
            when others=>
                current_state <= Piso4;
         end case;
         
-- Cambios Piso 1 a otros
        when S12 =>
            flagdown<='0';
            if ( flag2='1') then
                current_state<= Espera;
                flagdown<='1';
            else
             current_state <= S12;
            end if;
        when S13 =>
            flagdown<='0';
            if ( flag2='1' and flag3='1') then
                current_state<= Espera;
                flagdown<='1';
            else
               current_state <= S13;
            end if;
        when S14 =>
            flagdown<='0';
            if ( flag2='1' and flag3='1' and flag4='1') then
                current_state<= Espera;
                flagdown<='1';
            else
                current_state <= S14;
            end if;
         
-- Cambios Piso 2 a otros
        when B21 =>
            flagdown<='0';
            if ( flag1='1') then
                current_state<= Espera;
            end if;
        when S23 =>
            flagdown<='0';
            if ( flag3='1') then
                current_state<= Espera;
                flagdown<='1';
            end if;
        when S24 =>
            flagdown<='0';
            if ( flag3='1' and flag4='1') then
                current_state<= Espera;
                flagdown<='1';
            end if;
         
-- Cambios Piso 3 a otros
        when B31 =>
            flagdown<='0';
            if ( flag2='1' and flag3 = '1') then
                current_state<= Espera;
                flagdown<='1';
            end if;
        when B32 =>
            flagdown<='0';
            if ( flag2='1') then
                current_state<= Espera;
                flagdown<='1';
            end if;
        when S34 =>
            flagdown<='0';
            if ( flag4='1') then
                current_state<= Espera;
                flagdown<='1';
            end if; 
         
-- Cambios Piso 4 a otros
        when B41 =>
            flagdown<='0';
            if ( flag2='1' and flag3='1' and flag1='1') then
                current_state<= Espera;
                flagdown<='1';                
            end if;
        when B42 =>
            flagdown<='0';
            if ( flag2='1' and flag3='1') then
                current_state<= Espera;
                flagdown<='1';
            end if;
        when B43 =>
            flagdown<='0';
            if (flag3='1') then
                current_state<= Espera;
                flagdown<='1';
            end if;
            
-- Asegurarse que limpia la barra de tarreas
        when Espera =>
            pisoobjetivo<= "0000";
            case PISOACT is
            when "0001" =>
                current_state <= Piso1;
            when "0010" =>
                current_state <= Piso2;
            when "0100" =>
                current_state <= Piso3;
            when "1000" =>
                current_state <= Piso4;
            when others =>
                current_state <= Espera;
         end case; 
            
-- Estado raro = Error     
        when others =>
            current_state <= Error;
        end case;
      
       end if;
      
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
            LED_EMER<='0';
        elsif (current_state= S12 or current_state= S13 or current_state= S14 or current_state= S23 or current_state= S24 or current_state= S34) then
            MOTORS(1) <= '0';
            MOTORS(0) <= '1';
            DOORS <= '0';
            LED_EMER<='0';
        elsif (current_state=B21 or current_state=B31 or current_state=B32 or current_state=B41 or current_state=B42 or current_state=B43 ) then
            MOTORS(1) <= '1';
            MOTORS(0) <= '0';
            DOORS <= '0';
            LED_EMER<='0';
        elsif (current_state = Error or current_state = Espera) then
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
flags: process (PISOACT,CLK,flagdown)
    begin
        if(flagdown = '1') then
            flag1<='0';
            flag2<='0';
            flag3<='0';
            flag4<='0';
        else
           case PISOACT is
            when "0001" =>
                flag1 <= '1';
            when "0010" =>
                flag2 <= '1';
            when "0100" =>
                flag3 <= '1';
            when "1000" =>
                flag4 <= '1';
            when others =>
                flag1<=flag1;
                flag2<=flag2;
                flag3<=flag3;
                flag4<=flag4;
            end case;
       end if;
    end process;
--error_detect: process(PISOACT,pisoobjetivo,current_state) --comprobaci�n de error en la situaci�n actual del ascensor, si baja m�s de lo que deber�a o si sube m�s de lo debido
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
 --Pisoobjsal <= pisoobjetivo;
end Behavioral;
