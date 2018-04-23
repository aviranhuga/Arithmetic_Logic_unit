-- ====================================================================
--
--	File Name:		Input_Register.vhd
--	Description:	Input register
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Input_Register is 
port (
	data : in std_logic_vector(7 downto 0);
	key0_en : in std_logic;
	key1_en : in std_logic;
	key2_en : in std_logic;
	clk : in std_logic;
	A_out : out std_logic_vector(7 downto 0);
	B_out : out std_logic_vector(7 downto 0);
	OP_out : out std_logic_vector(3 downto 0)
	);
end Input_Register;

architecture Input_Register_arch of Input_Register is

component DFF_for_reg 
	port (
	data : in std_logic := '0';	
	clk : in std_logic;	
	en : in std_logic := '0';	
	q : out std_logic := '0'
	);
end component;


begin    
	--Register for A
	Array_Of_DFF_A: for i in 0 to 7 generate
		dff_Ai: DFF_for_reg port map(data => data(i),clk=>clk, en=>key0_en, q=>A_out(i));
	end generate Array_Of_DFF_A;
	
	--Register for B
	Array_Of_DFF_B: for i in 0 to 7 generate
		dff_Bi: DFF_for_reg port map(data => data(i),clk=>clk, en=>key1_en, q=>B_out(i));
	end generate Array_Of_DFF_B;
	
		--Register for OP
	Array_Of_DFF_OP: for i in 0 to 3 generate
		dff_OPi: DFF_for_reg port map(data => data(i),clk=>clk, en=>key2_en, q=>OP_out(i));
	end generate Array_Of_DFF_OP;
	
end Input_Register_arch;