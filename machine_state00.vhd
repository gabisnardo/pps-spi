----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:13:35 11/18/2016 
-- Design Name: 
-- Module Name:    machine_state - Behavioral 
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

entity machine_state is

GENERIC (	nslaves: INTEGER :=1; 											-- slave amount
				data_w: INTEGER :=4);											--	size of data to transfer
				
				
	PORT (	clk: 		IN STD_LOGIC;											--	clock input
				reset:	IN STD_LOGIC;											--	asynchonus reset, assertive low
				enable:	IN STD_LOGIC;											--	when high, setup data is captured (cpol, cpha, clk_div, add)
				finish: 	IN STD_LOGIC;
				miso: 	IN STD_LOGIC;
				overflow:IN STD_LOGIC;
				add:		IN STD_LOGIC_VECTOR(2 DOWNTO 0);					--	slave addres to be acceded
				sclk:		OUT STD_LOGIC;												--	clock output for synchronism
				mosi: 	OUT STD_LOGIC;
				busy:		OUT STD_LOGIC;	
				warning:	OUT STD_LOGIC;											--	signal to indicate any kind of error
				ss: 		OUT STD_LOGIC_VECTOR(1 downto 0);
				rx_data: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);				--	buffer with received data
				flanks: 	OUT STD_LOGIC_VECTOR(3 downto 0));
end machine_state;

architecture Behavioral of machine_state is

	
type fsm_states is (	idle,    	-- initial state
							working,		-- indicates when an operation is being set
							error,		-- starts a signal when a configuration is not accepted
							setup,		-- signals configuration
							clk_counter,-- counts clk cicles
							refresh,		-- set operation tipe and reset clk counter
							finish_read,-- regular end of reading without continous mode
							read_op,		-- captures miso value to rx_buff
							write_op);	--	passes mosi value to tx_buff
SIGNAL next_state, state: fsm_states;

SIGNAL clk_count: UNSIGNED (5 downto 0) :=(others=> '0');
begin

-------- CURRENT STATE LOGIC -----------

curr_st: process(clk)
	begin 
	if(RISING_EDGE(clk)) then
		state<=next_state;
	end if;
end process curr_st;
----------------------------------------

---------- NEXT STATE LOGIC ------------
nxt_st: process(clk,overflow)
	begin
	case state is
		when idle =>
			if(reset = '0') then
				next_state<=idle;
			else
				if (enable = '0') then
					next_state<= idle;
				else
					next_state<= working;
				end if;
			end if;
			
		when working=>
			if (to_integer(unsigned(add))<=nslaves) then
				if (set_flag='1') then
					next_state<= setup;
				else
					next_state<= error;
				end if;
			else 
				next_state<= error;
			end if;
			
		when error =>
			next_state<= idle;
	
		when setup =>
			if (overflow='1') then
				next_state<= refresh;
			else
				next_state<= clk_counter;
			end if;
			
		when clk_counter =>
			if (overflow='1') then
				next_state<= refresh;
			else
				next_state<= clk_counter;
			end if;
			
		when refresh =>
			if (finish='0') then
				if (op_kind='0') then
					next_state<= read_op;
				else
					next_state<= write_op;
				end if;
			else
				next_state<= finish_read;
			end if;
		
		when finish_read=>
			next_state<=idle;
		
		when read_op =>
			next_state<= refresh;
		
		when write_op =>
			next_state<= refresh;
			
		when others =>
			next_state<=idle;
	end case;
end process nxt_st;
----------------------------------------

----------- OUTPUT PROCESS -------------
out_pr: process(clk)
	begin
	if(rising_edge(clk)) then
	
		case next_state is
			when idle =>
				mosi<= 'Z';
				--rx_data<= (OTHERS => '0');
				ss<= (OTHERS => '1');
				--contmode<= '0';
				warning<= '1';
				busy<= '0';

			when error =>
				warning<= '0';
				
			when working =>
				busy<= '1';
			
			when setup =>
				sclk<= cpol;
				set_flag<='1';
				ss(to_integer (unsigned(add)))<='0';
				
			when clk_counter =>
				clk_count<= clk_count+1;
				count<= std_logic_vector(clk_count);
				
			when refresh =>
				op_kind<=not(op_kind);
				sclk<=not(sclk);
			
			when finish_read=>
				mosi<= 'Z';
				rx_data<= rx_buff;
				ss<= (OTHERS => '1');
				busy<= '0';

			when read_op =>
				--rx_buff<= rx_buff(2 DOWNTO 0) & miso;
				recieve<='1';
		
			when write_op =>
--				mosi<=tx_buff(3);
--				tx_buff<= tx_buff(2 DOWNTO 0) & '0';
				transmit<='1';
				
		end case;
	end if;
end process out_pr;
----------------------------------------

end Behavioral;

