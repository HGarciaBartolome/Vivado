library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FMS_Elevator is
 port (
  
 --- PARA TESTBENCH
 --Pisoactsal: out integer;
 Pisoobjsal: out std_logic_vector(3 DOWNTO 0);
 
 --Reales
 RESET: in std_logic;
 CLK : in std_logic;
 EDGE : in std_logic_vector(3 DOWNTO 0);
 MOTORS: OUT std_logic_vector (1 DOWNTO 0); -- 00 stdby 01 Up 10 Down 11 ERROR
 DOORS: OUT std_logic;  -- 1 Abierto 0 Cerrados
 LEDEspera:out std_logic;
 --LED_Floor: out std_logic_vector(3 DOWNTO 0);
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
    signal TiempoEspera: integer := 6;
    signal CE,SalTempo: std_logic:='0';
    signal resetTempo:std_logic :='1';
COMPONENT Temporizador 
    Generic(Tiempo : integer  ); -- Tiempo que se quiere esperar en segundos. Max 20s.
    Port ( 
           CLK : in std_logic;
           CE : in std_logic; --Chip enable
           RESET : in std_logic;
           Output : out std_logic); 
END COMPONENT;
begin

Inst_Temporizador: Temporizador GENERIC MAP( Tiempo => TiempoEspera)
PORT MAP(
           CLK=> CLK,
           CE => CE, --Chip enable
           RESET=> resetTempo,
           Output =>SalTempo
);

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
            if( SalTempo = '1') then
                case PISOACT is
                when "0001" =>
                    current_state <= Piso1;
                    resetTempo <='1';
                when "0010" =>
                    current_state <= Piso2;
                    resetTempo <='1';
                when "0100" =>
                    current_state <= Piso3;
                    resetTempo <='1';
                when "1000" =>
                    current_state <= Piso4;
                    resetTempo <='1';
                when others =>
                    current_state <= Espera;
                end case;
             else
                CE<='1';
                resetTempo <= '0';
            end if;
          
            
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
            LEDEspera<='0';
        elsif (current_state= S12 or current_state= S13 or current_state= S14 or current_state= S23 or current_state= S24 or current_state= S34) then
            MOTORS(1) <= '0';
            MOTORS(0) <= '1';
            DOORS <= '0';
            LED_EMER<='0';
            LEDEspera<='0';
        elsif (current_state=B21 or current_state=B31 or current_state=B32 or current_state=B41 or current_state=B42 or current_state=B43 ) then
            MOTORS(1) <= '1';
            MOTORS(0) <= '0';
            DOORS <= '0';
            LED_EMER<='0';
            LEDEspera<='0';
        elsif (current_state = Error ) then
            MOTORS(1) <= '0';
            MOTORS(0) <= '0';
            DOORS<= '0';
            LED_EMER<='1';
            LEDEspera<='0';
        elsif(current_state = Espera) then
            LEDEspera<='1';
            MOTORS(1) <= '0';
            MOTORS(0) <= '0';
            DOORS<= '1';
            LED_EMER<='0';
        end if;
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
Pisoobjsal <= pisoobjetivo;

end Behavioral;
