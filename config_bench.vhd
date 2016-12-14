library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity config_bench is
end config_bench;

architecture Bench of config_bench is

component configure00 is

GENERIC (	nslaves: INTEGER :=1; 										-- slave amount
				data_w: INTEGER :=4);										--	size of data to transfer
				
				
port (	clk: 		IN STD_LOGIC;											--	clock input
			reset:	IN STD_LOGIC;											--	asynchonus reset, assertive low
			enable:	IN STD_LOGIC;											--	when high, setup data is captured (cpol, cpha, clk_div, add)
			set_rdy: IN STD_LOGIC;											-- 
			miso:	 	IN STD_LOGIC;
			slave: 	IN STD_LOGIC_VECTOR(2 downto 0);
			add:		IN STD_LOGIC_VECTOR(data_w-1 downto 0);
			tx_data: IN STD_LOGIC_VECTOR(data_w-1 downto 0);
			mosi:		OUT STD_LOGIC;
			ss:		OUT STD_LOGIC_VECTOR(nslaves-1 downto 0);		
			rx_data:	OUT STD_LOGIC_VECTOR(data_w-1 downto 0));
end component configure00;

constant nslaves: INTEGER :=1; 										-- slave amount
constant data_w: INTEGER :=4;										--	size of data to transfe
signal s_clk:		STD_LOGIC:='1';
signal s_reset:	STD_LOGIC:='1';
signal s_enable:	STD_LOGIC:='0';
signal s_setrdy: 	STD_LOGIC:='0';
signal s_miso:		STD_LOGIC:='0';
signal s_slave:	STD_LOGIC_VECTOR (2 downto 0):="000";
signal s_add:		STD_LOGIC_VECTOR(data_w-1 downto 0):=(OTHERS=>'0');
signal s_txdata:	STD_LOGIC_VECTOR(data_w-1 downto 0):=(OTHERS=>'Z');
signal s_mosi:		STD_LOGIC:='Z';
signal s_rxdata: 	STD_LOGIC_VECTOR(data_w-1 downto 0):=(OTHERS=>'Z');
signal s_ss: 		STD_LOGIC_VECTOR(nslaves-1 downto 0):=(OTHERS=>'1');

signal clk:		STD_LOGIC:='1';
signal reset:	STD_LOGIC:='1';
signal enable:	STD_LOGIC:='0';
signal set_rdy: 	STD_LOGIC:='0';
signal miso:		STD_LOGIC:='0';
signal slave:	STD_LOGIC_VECTOR (2 downto 0):="000";
signal add:		STD_LOGIC_VECTOR(data_w-1 downto 0):=(OTHERS=>'0');
signal tx_data:	STD_LOGIC_VECTOR(data_w-1 downto 0):=(OTHERS=>'Z');
signal mosi:		STD_LOGIC:='Z';
signal rx_data: 	STD_LOGIC_VECTOR(data_w-1 downto 0):=(OTHERS=>'Z');
signal ss: 		STD_LOGIC_VECTOR(nslaves-1 downto 0):=(OTHERS=>'1');


begin

maping: configure00 PORT MAP( clk		=>	s_clk,
										reset		=> s_reset,
										enable	=> s_enable,
										set_rdy	=>	s_setrdy,
										miso		=> s_miso,
										slave		=> s_slave,
										add		=> s_add,
										tx_data	=> s_txdata,
										mosi		=> s_mosi,
										rx_data	=> s_rxdata,
										ss			=> s_ss);

clock: process											--500KHz clock
begin
	wait for 10 ns;
	s_clk<='0';
	wait for 50 ns;
	s_clk<='1';
	wait for 50 ns;
end process clock;

sim: process
begin
	wait for 100 ns;
	s_enable<='1';
	wait for 50 ns;
	s_setrdy<='1';
	wait for 50 ns;
	s_add<="1001";
	s_txdata<="1010";
	
end process sim;

end Bench;