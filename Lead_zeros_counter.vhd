-- ====================================================================
--
--	File Name:		Lead_zeros_counter.vhd
--	Description:	Lead_zeros_counter
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

entity Lead_zeros_counter is 
port (
	add_sub_cout : in std_logic;
	num : in std_logic_vector(23 downto 0);	
	side_to_shift : out std_logic;
	result_f : out std_logic_vector(4 downto 0);
	result_e : out std_logic_vector(7 downto 0)
	);
end Lead_zeros_counter;

architecture Lead_zeros_counter_arch of Lead_zeros_counter is

begin   
	side_to_shift <= not add_sub_cout;                                      
	process(add_sub_cout,num)
	variable leading_zeros : integer;
	begin
		if add_sub_cout='1' then
			result_e <= "00000001";
			result_f <= "00001";
		else
		leading_zeros := 0;
		for i in 23 downto 0 loop
			if num(i)='1' then
				exit;
			end if;
			leading_zeros := leading_zeros + 1;
		end loop;
		 result_e <= std_logic_vector(to_unsigned(leading_zeros,8));
		 result_f <= std_logic_vector(to_unsigned(leading_zeros,5));
		end if;
	end process;
end Lead_zeros_counter_arch;