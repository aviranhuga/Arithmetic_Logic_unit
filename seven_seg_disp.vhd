-- ====================================================================
--
--	File Name:		seven_seg_disp.vhd
--	Description:	7 segment Display controler 
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity seven_seg_disp is port (
	data : in std_logic_vector(3 downto 0);	
	data_out : out std_logic_vector(6 downto 0)
	);
end seven_seg_disp;

architecture seven_seg_disp_arch of seven_seg_disp is
begin                                         
-- Design Body
	process(data)
		begin
		case data is
			when "0000" => data_out <= "1000000";
			when "0001" => data_out <= "1111001";			
			when "0010" => data_out <= "0100100";
			when "0011" => data_out <= "0110000";
			when "0100" => data_out <= "0011001";
			when "0101" => data_out <= "0010010";
			when "0110" => data_out <= "0000010";
			when "0111" => data_out <= "1111000";
			when "1000" => data_out <= "0000000";
			when "1001" => data_out <= "0010000";
			when "1010" => data_out <= "0001000";
			when "1011" => data_out <= "0000011";
			when "1100" => data_out <= "1000110";
			when "1101" => data_out <= "0100001";
			when "1110" => data_out <= "0000110";
			when "1111" => data_out <= "0001110";
			when others => data_out <= "1111111";
			end case;
	end process;
end seven_seg_disp_arch;