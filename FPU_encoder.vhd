-- ====================================================================
--
--	File Name:		FPU_encoder.vhd
--	Description:	FPU 8 bit convert to 32 bit FPU
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

entity FPU_encoder is 
port (
	Input : in std_logic_vector(7 downto 0);	
	Output : out std_logic_vector(31 downto 0)
	);
end FPU_encoder;

architecture FPU_encoder_arch of FPU_encoder is

signal f: std_logic_vector(22 downto 0);
signal shift_counter: std_logic_vector(4 downto 0);
signal bias: std_logic_vector(7 downto 0);
signal e: std_logic_vector(7 downto 0);
signal AB_Input: std_logic_vector(5 downto 0);

begin   
	bias <= "01111111";
	
	process(Input)
	variable leading_one : integer;
	variable e_with_bias : integer;
	begin
		if Input(6 downto 2)="00000" then
		 shift_counter <= (others => '0');
		 f <= (others => '0');
		 f(22 downto 21) <= Input(1 downto 0);
		 e <= bias;
		else
		leading_one := 4;
		for i in 4 downto 1 loop
			if Input(i+2)='1' then
				exit;
			end if;
			leading_one := leading_one - 1;
		end loop;
		 e_with_bias := leading_one + 127;
		 shift_counter <= std_logic_vector(to_unsigned(leading_one,5));
		 f <= (others => '0');
		 f(22 downto 21-leading_one) <= Input(leading_one+1 downto 0);
		 e <= std_logic_vector(to_unsigned(e_with_bias,8));
		end if;
	end process;
	
	Output(31) <= Input(7);
	Output(30 downto 23) <= e;
	Output(22 downto 0) <= f;
	
end FPU_encoder_arch;