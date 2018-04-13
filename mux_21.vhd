-- ====================================================================
--
--	File Name:		mux_21.vhd
--	Description:	Arithmentic unit mul output mux
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity mux_21 is
generic ( N: integer :=8);
port (
	input : in std_logic_vector(2*N-1 downto 0);
	SEL : in std_logic; -- '0' for a and '1' for b
	output_a : out std_logic_vector(2*N-1 downto 0); 
	output_b : out std_logic_vector(2*N-1 downto 0) 
	);
end mux_21;

architecture mux_21_arch of mux_21 is
begin                                         
-- Design Body
	process(input,SEL)
		begin
		if SEL='0' then 
				output_a <= input;
		else 
				output_b <= input;
		end if;
	end process;
end mux_21_arch;