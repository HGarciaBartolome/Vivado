
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Temporizador is
    Port ( 
           CLK : in STD_LOGIC;
           CE : in STD_LOGIC; --Chip enable
           RESET : in STD_LOGIC;
           Tiempo : in integer; -- Tiempo entre pisos en segundos
           Output : out std_logic); 
end Temporizador;

architecture Behavioral of Temporizador is
signal buf: std_logic ;
signal counter: integer :=0 ;
begin

 process (RESET, CLK)
  begin
    if RESET = '1' then
      Output<='0';
      counter <= 0;
    elsif rising_edge(CLK) then
      if CE = '1' then
        counter <= counter + 1;
        if (counter > 10*Tiempo) then
            Output <= '1';
            counter <= 0;
        else 
            Output <= '0';
        end if;
      elsif CE = '0' then
       Output <= '0';
       counter <= 0;
      end if;
    end if;
 end process;  
end Behavioral;
