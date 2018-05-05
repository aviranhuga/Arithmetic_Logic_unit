-- ====================================================================
--
--	File Name:		Rounding_unit.vhd
--	Description:	Rounding unit for FPU
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Rounding_unit is 
port (
	Input : in std_logic_vector(22 downto 0);
	output : out std_logic_vector(22 downto 0)
	);
end Rounding_unit;

architecture Rounding_unit_arch of Rounding_unit is

signal after_rounding : std_logic_vector(22 downto 0);
--signal test : std_logic_vector(22 downto 0);

begin                                
	process(Input)
	begin
		for i in 0 to 22 loop
			if (Input(i)='1' and (i > 0)) then
				after_rounding <= (others => '0');
				after_rounding(i-1) <= '1';
				exit;
			end if;
			after_rounding(i) <= Input(i);
		end loop;
	end process;
	--test <= "00000000000000000000001";
	output <= Input or after_rounding;
end Rounding_unit_arch;