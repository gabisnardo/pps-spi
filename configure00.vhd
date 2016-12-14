----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:58:04 11/17/2016 
-- Design Name: 
-- Module Name:    configure - Behavioral 
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

entity configure00 is

generic (	nslaves: INTEGER :=1; 											-- slave amount
				data_w: INTEGER :=4);											--	size of data to transfer
				
port (	clk: 		IN STD_LOGIC;											--	input clock
			reset:	IN STD_LOGIC;											--	asynchonus reset, assertive low
			enable:	IN STD_LOGIC;											--	when high, setup data is captured (cpol, cpha, clk_div, add)
			set_rdy: IN STD_LOGIC;											-- clock flag, high when the clock divisor has ben processed
			miso:	 	IN STD_LOGIC;
			slave: 	IN STD_LOGIC_VECTOR(2 downto 0);					-- slave to be acceded
			add:		IN STD_LOGIC_VECTOR(data_w-1 downto 0);		-- register's address of interest
			tx_data: IN STD_LOGIC_VECTOR(data_w-1 downto 0);		-- data to transmit
			mosi:		OUT STD_LOGIC;		
			ss:		OUT STD_LOGIC_VECTOR(nslaves-1 downto 0);		
			rx_data:	OUT STD_LOGIC_VECTOR(data_w-1 downto 0));
end entity;		-- recieved data


architecture Behavioral of configure00 is

signal write_flag:	STD_uLOGIC:='0';
signal read_flag: 	STD_uLOGIC:='0';
signal output: 		STD_LOGIC:='0';
signal txx_buff: 		STD_LOGIC_VECTOR(data_w-1 downto 0):=(OTHERS=>'0');
signal buf_rx: 		STD_LOGIC_VECTOR(data_w-1 downto 0):=(OTHERS=>'0');
signal slaveselect:	STD_LOGIC_VECTOR(nslaves-1 downto 0):=(OTHERS=>'1');

begin
	op_type:process (reset, enable)
	begin
	
		if (reset='1' AND enable='1') then
			
				if (set_rdy='1') then
				
					txx_buff		<=	add;
					slaveselect	<=	(OTHERS=>'1');
					
					if (rising_edge(clk)) then
					
						for i in data_w-1 to 0 loop
						
							slaveselect(TO_INTEGER(UNSIGNED(slave)))<='0';
							
							--ACA ME ESTA FALTANDO ESPERAR UN FLANCO DESPUES DE SELECCIONAR EL ESCLAVO
							output	<=	txx_buff(i);
							
						end loop;
						
						if (txx_buff(data_w-1)='1') then
						
							write_flag	<=	'1';
							
						elsif (txx_buff(data_w-1)='0') then
						
							read_flag	<=	'1';
							
						end if;
						
					end if;
					
				end if;

			--end if;
		
		elsif (reset='0') then
			slaveselect	<=	(OTHERS	=>'1');
			txx_buff		<= (OTHERS 	=>'Z');
			read_flag	<=	'0';
			write_flag	<=	'0';
		
		end if;
		
	end process op_type;
	
	mosi	<=		output;
	ss		<=		slaveselect;
	
	rw_pro: process (clk, write_flag, read_flag)
	begin
	
		for j in data_w-1 to 0 loop
		
			if (rising_edge(clk)) then
			
				if (write_flag='1') then
				
					output	<=	txx_buff(data_w-1);
					
					for i in data_w-1 to 1 loop
					
						txx_buff(i) <= txx_buff(i-1);
					end loop;
					
					txx_buff(0)	<=	'0';
					write_flag	<=	'0';
					
				elsif (read_flag='1') then
				
					--buf_rx(0)	<= miso;
					
					for i in 1 to data_w-1 loop
					
						buf_rx(i)	<= buf_rx(i-1);
						
					end loop;
					
					buf_rx(0)	<= miso;
					read_flag	<=	'0';
					
				end if;
				
			end if;
			
		end loop;
		
	end process rw_pro;
		
	mosi		<=		output;
	ss			<=		slaveselect;
	rx_data	<=		buf_rx;

end Behavioral;

