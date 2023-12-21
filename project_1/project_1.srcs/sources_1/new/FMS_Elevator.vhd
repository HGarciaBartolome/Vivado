library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FMS_Elevator is
 generic(
    t_entrepisos: integer := 10 -- Tiempo entre pisos en segundos
 );
 port (
 RESET: in std_logic;
 CLK : in std_logic;
 EDGE : in std_logic_vector(3 DOWNTO 0);
 MOTORS: OUT std_logic_vector (1 DOWNTO 0); -- 00 stdby 01 Up 10 Down 11 ERROR
 DOORS: OUT std_logic;  -- 1 Abierto 0 Cerrados
 LED_Floor: out std_logic_vector(3 DOWNTO 0);
 LED_EMER: out std_logic
 
 --Pisoactsal: out integer;
 --Pisoobjsal: out integer
 );
end FMS_Elevator;

architecture Behavioral of FMS_Elevator is
    type STATES is (Arranque,Standby, Up, Down, Error);
    signal next_state,current_state: STATES:= Arranque;
    signal flag_error: std_logic;
    signal piso,objetivo:std_logic_vector(3 downto 0);
    signal bufpiso: unsigned(3 downto 0);
    --signal piso:std_logic_vector(3 downto 0);
    signal CE, RESET_T: std_logic := '0';
    signal Func, Flag: std_logic := '0';

component Temporizador
 Port ( 
           CLK : in STD_LOGIC;
           CE : in STD_LOGIC; --Chip enable
           RESET : in STD_LOGIC;
           Tiempo : in integer; -- Tiempo entre pisos en segundos
           Output : out std_logic); -- 1 Subir 0 Bajar
end component;
begin
    Inst_Temporizador_Up: Temporizador
    Port Map(
           CLK => CLK,
           CE=> CE,             
           RESET => RESET_T,
           Tiempo => t_entrepisos, 
           Output =>Flag
    );
  

    state_register: process(CLK, RESET)
    begin 
        if (RESET='1')then
            current_state <= Arranque;
        elsif rising_edge(CLK)then
            current_state <= next_state; 
        end if;
        case piso is
        when "0001" =>
         LED_Floor <= "0001";
        when "0010" =>
          LED_Floor  <= "0010";
        when "0100" =>
          LED_Floor  <= "0100";
        when "1000" =>
          LED_Floor  <= "1000";
        when others =>
        end case;
    end process;
    next_state_decoder: process(EDGE,current_state,piso,CLK)
    begin
    next_state<= current_state;
    case current_state is
        when Arranque =>
            piso <= "0001";
            objetivo<= "0001";
            next_state <= Standby;
        when Standby =>
            RESET_T <= '1';
            if(unsigned(piso) < unsigned(objetivo)) then
              next_state<= Up;
            elsif(unsigned(piso) > unsigned(objetivo)) then
              next_state<= Down;
            end if;
        when Up =>
            CE<= '1';
            RESET_T <= '0';
            if(flag = '1') then -- Puede que no vaya , ahora mismos se encienden todos los leds
                case piso is
                when "0001" =>
                   piso <= "0010";
                when "0010" =>
                   piso <= "0100"; 
                when "0100" =>
                   piso <= "1000";
                when "1000" =>
                when others =>
                end case;
                CE <= '0';
                next_state <= Standby;
            end if;
        when Down =>
            CE<= '1';
            RESET_T <= '0';
            if(flag= '1') then
                case piso is
                when "0001" =>
                when "0010" =>
                   piso <= "0001"; 
                when "0100" =>
                   piso <= "0010";
                when "1000" =>
                    piso <= "0100";
                when others =>
                end case;
                 CE <= '0';
                next_state <= Standby;
            end if;
        when others =>
            --next_state <= Error;
        end case;
     -- if(current_state = Standby) then
        case EDGE is
        when "0001" =>
         objetivo <= "0001";
        when "0010" =>
         objetivo <= "0010";
        when "0100" =>
         objetivo <= "0100";
        when "1000" =>
         objetivo <= "1000";
        when others =>
        end case;
    --  end if;
    end process;
    output_decoder:process(current_state)
    begin
        case current_state is
        when Arranque =>
            LED_EMER<= '0';
            MOTORS(0)<= '0';
            MOTORS(1)<= '0';
            DOORS <= '0';
        when Standby =>
            MOTORS(0)<= '0';
            MOTORS(1)<= '0';
            DOORS <= '1';
        when Up =>
            MOTORS(0)<= '1';
            MOTORS(1)<= '0';
            DOORS <= '0';
        when Down =>
            MOTORS(0)<= '0';
            MOTORS(1)<= '1';
            DOORS <= '0';
        when others =>
            LED_EMER<= '1';
        end case;
        
    end process;
--    input_decoder:process(current_state,EDGE)
--    begin
--      if(current_state = Standby) then
--        case EDGE is
--        when "0001" =>
--         objetivo <= "0001";
--        when "0010" =>
--         objetivo <= "0010";
--        when "0100" =>
--         objetivo <= "0100";
--        when "1000" =>
--         objetivo <= "1000";
--        when others =>
--        end case;
--      end if;
--    end process;


end Behavioral;
