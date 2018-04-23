-- ====================================================================
--
--	File Name:		dff_for_mac.vhd
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

entity dff_for_mac is port (
	data : in std_logic := '0';	
	clk : in std_logic := '0';	
	reset : in std_logic := '0';	
	q : out std_logic := '0'
	);
end dff_for_mac;

architecture dff_for_mac_arch of dff_for_mac is
begin                                         
-- Design Body
	process(clk)
	 begin
	 if clk='1' then
		if reset='1' then
			q <= '0';
		else
			q <= data;
		end if;
	 end if;
	end process;
end dff_for_mac_arch;

