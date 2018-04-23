-- ====================================================================
--
--	File Name:		dff for reg.vhd
--	Description:	dff for register
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity dff_for_reg is port (
	data : in std_logic := '0';	
	clk : in std_logic;	
	en : in std_logic := '0';	
	q : out std_logic := '0'
	);
end dff_for_reg;

architecture dff_for_reg_arch of dff_for_reg is
begin                                         
-- Design Body
	process(clk)
	 begin
	  if rising_edge(clk) then
		if en='1' then
			q <= data;
	  end if;
	  end if;
	end process;
end dff_for_reg_arch;
