library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity spimaster is
	
GENERIC (	nslaves: INTEGER :=1; 											-- slave amount
				data_w: INTEGER :=4);											--	size of data to transfer

	port (	clk: 		IN STD_LOGIC;											--	input clock
				miso: 	IN STD_LOGIC;											--	recepted bit
				reset:	IN STD_LOGIC;											--	asynchonus reset, assertive lowm n
				enable:	IN STD_LOGIC;											--	when high, setup data is captured (clk_div, add
				clk_div:	IN STD_LOGIC_VECTOR(5 DOWNTO 0);					--	clock divider value for sclk generation
				add:		IN STD_LOGIC_VECTOR(data_w-1 DOWNTO 0);		--	slave addres to be read
				tx_data: IN STD_LOGIC_VECTOR(data_w-1 DOWNTO 0);		--	buffer with data to transfer
				rx_data: OUT STD_LOGIC_VECTOR(data_w-1 DOWNTO 0);		--	buffer with received data
				sclk:		OUT STD_LOGIC;											--	clock output for synchronism
				ss: 		OUT STD_LOGIC_VECTOR(1 downto 0);				--	slave selection signal
				mosi: 	OUT STD_LOGIC;											--	transmited bit
				busy:		OUT STD_LOGIC;											--	indicates when the system is operating)
				warning:	OUT STD_LOGIC);										--	signal to indicate any kind of error				
end component spimaster;

architecture Behavioral of spimater00 is

component configure00 is	
				
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
			rx_data:	OUT STD_LOGIC_VECTOR(data_w-1 downto 0));		-- recieved data
end configure00;


component clk_setup00 is

	port(	clk: 			IN STD_LOGIC;
			reset:		IN STD_LOGIC;
			enable: 		IN STD_LOGIC;
			clk_div: 	IN STD_LOGIC_VECTOR(5 downto 0);
			overflow: 	OUT STD_LOGIC;
			set_flag:	OUT STD_LOGIC;
			oclk:			OUT STD_LOGIC);
end component clk_setup00;


