----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:31:19 11/15/2016 
-- Design Name: 
-- Module Name:    flank_count - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flank_count00 is
				
	port(	clk: 			IN STD_LOGIC;
			reset:		IN STD_LOGIC;
			enable:		IN STD_LOGIC;
			overflow:	IN STD_LOGIC;
			tog_count: 	OUT STD_LOGIC_VECTOR(3 downto 0);
			fin_flag:	OUT STD_LOGIC);
end flank_count00;

architecture Behavioral of flank_count00 is

signal toggles:	UNSIGNED (3 downto 0):= (OTHERS =>'0');
signal finish:		STD_LOGIC:='1';


begin
	process (clk, reset, enable)
	begin
	
		if (reset='1' AND enable='1') then
		
			if (RISING_EDGE(clk)) then
			
				if (overflow='1') then
				
					if (toggles<=data_w*2) then
						toggles<= toggles+1;
						finish<='0';
					else
						toggles<=(OTHERS=>'0');
						finish<='1';
					end if;
					
				end if;

			
			end if;
			
		end if;
		
	end process;
	
	flanks	<= STD_LOGIC_VECTOR(toggles);
	fin_flag	<=	finish;

end Behavioral;

