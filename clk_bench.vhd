library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_bench is
end clk_bench;

architecture Bench of clk_bench is

component clk_setup00

	port(	clk: 			IN STD_LOGIC;
			reset:		IN STD_LOGIC;
			enable: 		IN STD_LOGIC;
			clk_div: 	IN STD_LOGIC_VECTOR(5 downto 0);
			overflow: 	OUT STD_LOGIC;
			set_flag:	OUT STD_LOGIC;
			oclk:			OUT STD_LOGIC);
end component clk_setup00;

signal s_clk:		STD_LOGIC:='0';
signal s_reset:	STD_LOGIC:='1';
signal s_enable:	STD_LOGIC:='0';
signal s_clk_div: STD_LOGIC_VECTOR(5 downto 0):="000001";
signal s_overflow:STD_LOGIC:='0';
signal s_setflag:	STD_LOGIC:='0';
signal n_clk:		STD_LOGIC:='1';
begin

maping: clk_setup00 PORT MAP( clk	=>	s_clk,
										reset	=> s_reset,
										enable=> s_enable,
										clk_div=> s_clk_div,
										overflow=> s_overflow,
										set_flag=> s_setflag,
										oclk	=> n_clk);

clock: process
begin
	s_clk<='1';
	wait for 20 ns;
	s_clk<='0';
	wait for 20 ns;
end process clock;

sim: process
begin
	wait for 10 ns;
	s_enable<='1';
	wait for 5 ns;
	s_clk_div<="000100";
	
end process sim;

end Bench;
	
