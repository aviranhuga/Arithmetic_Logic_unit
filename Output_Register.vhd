-- ====================================================================
--
--	File Name:		Output_Register.vhd
--	Description:	Output register
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

entity Output_Register is 
port (
	clk : in std_logic;
	HI_in : in std_logic_vector(7 downto 0);
	LO_in : in std_logic_vector(7 downto 0);
	Status_in : in std_logic_vector(5 downto 0);
	HI_out : out std_logic_vector(7 downto 0);
	LO_out : out std_logic_vector(7 downto 0);
	Status_out : out std_logic_vector(5 downto 0)
	);
	
end Output_Register;

architecture Output_Register_arch of Output_Register is

component DFF_for_reg 
	port (
	data : in std_logic := '0';	
	clk : in std_logic;	
	en : in std_logic := '0';	
	q : out std_logic := '0'
	);
end component;

signal the_one_and_the_only : std_logic;

begin    
	the_one_and_the_only <= '1';
	--register for HI
	Array_Of_DFF_HI: for i in 0 to 7 generate
		dff_HIi: DFF_for_reg port map(data => HI_in(i),clk=>clk, en=>the_one_and_the_only, q=>HI_out(i));
	end generate Array_Of_DFF_HI;
	
	--Register for B
	Array_Of_DFF_LO: for i in 0 to 7 generate
		dff_LOi: DFF_for_reg port map(data => LO_in(i),clk=>clk, en=>the_one_and_the_only, q=>LO_out(i));
	end generate Array_Of_DFF_LO;
	
		--Register for OP
	Array_Of_DFF_status: for i in 0 to 5 generate
		dff_statusi: DFF_for_reg port map(data => Status_in(i),clk=>clk, en=>the_one_and_the_only, q=>Status_out(i));
	end generate Array_Of_DFF_status;
	
end Output_Register_arch;