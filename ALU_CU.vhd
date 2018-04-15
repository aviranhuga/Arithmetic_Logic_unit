-- ====================================================================
--
--	File Name:		ALU_CU.vhd
--	Description:	ALU control unit
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;

entity ALU_CU is
port (
	opcode_cu : in std_logic_vector(3 downto 0);
	clk_cu : in std_logic := '0';
	shift_left_or_right_cu: out std_logic; --'0' for right, '1' for left
	AU_clk_cu: out std_logic; -- clock for AU	
	ALU_IN_MUX_SEL_cu: out std_logic; -- '0' for AU , '1' for Shift unit
	ALU_OUT_SELECTOR_SEL_cu : out std_logic_vector(1 downto 0) --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros	
	);
end ALU_CU;

architecture ALU_CU_arch of ALU_CU is

signal ALU_MAC_STATUS: std_logic := '0'; 
signal AU_temp_clk: std_logic := '0';

begin                    

	AU_clk_cu <= AU_temp_clk;
	
	process(clk_cu)
		begin
		if rising_edge(clk_cu) then
		case Opcode_cu is
		when "1000" | "1001" => --shift opcode
			if ALU_MAC_STATUS='0' then
			shift_left_or_right_cu <= Opcode_cu(0); --'0' for right, '1' for left
			AU_temp_clk <= '0'; -- clock for AU
			ALU_IN_MUX_SEL_cu <= '1'; -- '0' for AU , '1' for Shift unit
			ALU_OUT_SELECTOR_SEL_cu <= "00"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
			end if;
		when "0101" | "0110" | "0001" | "0010" | "0111" => -- MIN/MAX/ADD/SUB/RST
			if ALU_MAC_STATUS='0' then
			AU_temp_clk <= (not AU_temp_clk); -- clock for AU
			ALU_IN_MUX_SEL_cu <= '0'; -- '0' for AU , '1' for Shift unit
			ALU_OUT_SELECTOR_SEL_cu <= "01"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
			end if;
		when "0011" => -- MUL OPCODE
			if ALU_MAC_STATUS='0' then
			AU_temp_clk <= (not AU_temp_clk); -- clock for AU
			ALU_IN_MUX_SEL_cu <= '0'; -- '0' for AU , '1' for Shift unit
			ALU_OUT_SELECTOR_SEL_cu <= "10"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
			end if;			
		when "0100" => --MAC OPCODE
			if ALU_MAC_STATUS='0' then
				ALU_MAC_STATUS <= '1';					
				AU_temp_clk <= (not AU_temp_clk); -- clock for AU
				ALU_IN_MUX_SEL_cu <= '0'; -- '0' for AU , '1' for Shift unit
				ALU_OUT_SELECTOR_SEL_cu <= "10"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
			else
				AU_temp_clk <= (not AU_temp_clk); -- clock for AU
				ALU_MAC_STATUS <= '0';
			end if;
		when others =>
			ALU_MAC_STATUS <= '0';	
			AU_temp_clk <= '0'; -- clock for AU
			ALU_OUT_SELECTOR_SEL_cu <= "11"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
		end case;
		end if;
	end process;
	
end ALU_CU_arch;