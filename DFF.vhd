-- ====================================================================
--
--	File Name:		dff.vhd
--	Description:	full adder 
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity dff is port (
	data : in std_logic := '0';	
	clk : in std_logic := '0';	
	reset : in std_logic := '0';	
	q : out std_logic := '0'
	);
end dff;

architecture dff_arch of dff is
begin                                         
-- Design Body
	process(clk,data,reset)
	 begin
	 if clk='1' then
		if reset='1' then
			q <= '0';
		else
			q <= data;
		end if;
	 end if;
	end process;
end dff_arch;

