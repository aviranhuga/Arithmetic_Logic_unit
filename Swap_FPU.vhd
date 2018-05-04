-- ====================================================================
--
--	File Name:		Swap_FPU.vhd
--	Description:	swap for friction in FPU
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity Swap_FPU is port (
	f1 : in std_logic_vector(23 downto 0);	
	f2 : in std_logic_vector(23 downto 0);
	SEL : in std_logic; 
	o1 : out std_logic_vector(23 downto 0);
	o2 : out std_logic_vector(23 downto 0)
	);
end Swap_FPU;

architecture Swap_FPU_arch of Swap_FPU is
begin                                         
-- Design Body
	process(SEL,f1,f2)
		begin
		if (SEL='0') then
			o1 <= f1;
			o2 <= f2;
		else 
			o1 <= f2;
			o2 <= f1;
		end if;
	end process;
end Swap_FPU_arch;

