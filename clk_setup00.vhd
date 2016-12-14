----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:16:55 11/11/2016 
-- Design Name: 
-- Module Name:    clk_setup - Behavioral 
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

entity clk_setup00 is
	port(	clk: 			IN STD_LOGIC;
			reset:		IN STD_LOGIC;
			enable: 		IN STD_LOGIC;
			clk_div: 	IN STD_LOGIC_VECTOR(5 downto 0);
			overflow: 	OUT STD_LOGIC;
			set_flag:	OUT STD_LOGIC;
			oclk:			OUT STD_LOGIC);
end clk_setup00;

architecture Behavioral of clk_setup00 is

--signal tmp_count: STD_LOGIC_VECTOR(5 downto 0):=(OTHERS=>'0');
signal tmp_count: unsigned (5 downto 0) :=(others=> '0');
signal tmp_offlag: STD_LOGIC;
signal tmp_setflag: STD_LOGIC;
signal sclk: STD_LOGIC:='1';

begin
	process (clk, reset, enable)
	begin
	
		if (reset='0') then
			tmp_offlag<='0';
			tmp_setflag <='0';
		elsif (RISING_EDGE(clk)) then
		
			if (enable='1') then
 	
				if (unsigned(clk_div)<=0) then
					tmp_count<= "000001";
					tmp_setflag <='1';
				else
					tmp_count<=unsigned(clk_div );
					tmp_setflag<='1';
				end if;
				
			end if;
			
			if (tmp_count=unsigned(clk_div )) then
				sclk<=not(sclk);
				tmp_offlag<='1';
				tmp_count<=(others=>'0');
			else
				tmp_count<=tmp_count+1;
			end if;
			
			
		end if;
		
		overflow<=tmp_offlag;
		set_flag<=tmp_setflag;
		oclk<=sclk;
		
	end process;
	
end Behavioral;

