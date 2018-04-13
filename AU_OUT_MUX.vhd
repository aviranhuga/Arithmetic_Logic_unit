-- ====================================================================
--
--	File Name:		AU_OUT_MUX.vhd
--	Description:	Arithmentic unit HI output mux
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity AU_OUT_MUX is
generic ( N: integer :=8);
port (
	input_a : in std_logic_vector(2*N-1 downto 0);-- ADD/SUB  Output
	input_b : in std_logic_vector(2*N-1 downto 0);-- MUL  output
	input_c : in std_logic_vector(2*N-1 downto 0);-- MIN_MAX output
	SEL : in std_logic_vector(1 downto 0);
	TRIGGER : in std_logic;
	output_LO : out std_logic_vector(N-1 downto 0) := (others => '0');	
	output_HI : out std_logic_vector(N-1 downto 0) := (others => '0')
	);
end AU_OUT_MUX;

architecture AU_OUT_MUX_arch of AU_OUT_MUX is
begin                                         
-- Design Body
	process(input_a,input_b,input_c,SEL,TRIGGER)
		begin
		case SEL is
			when "00" => 
				output_HI <= input_a(2*N-1 downto N);
				output_LO <= input_a(N-1 downto 0);
		  when "01" => 
				output_HI <= input_b(2*N-1 downto N);
				output_LO <= input_b(N-1 downto 0);
			when "10" =>
				output_HI <= input_c(2*N-1 downto N);
				output_LO <= input_c(N-1 downto 0);
			when others =>
				output_HI <= (others => '0');
				output_LO <= (others => '0');
			end case;
	end process;
end AU_OUT_MUX_arch;