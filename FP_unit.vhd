-- ====================================================================
--
--	File Name:		FP_unit.vhd
--	Description:	FP unit
--					
--
--	Date:			7/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity FP_unit is 
port (
	A : in std_logic_vector(7 downto 0);
	B : in std_logic_vector(7 downto 0);	
	SW8 : in std_logic;
	Opcode : in std_logic_vector(3 downto 0);
	HI : out std_logic_vector(7 downto 0);
	LO : out std_logic_vector(7 downto 0)
	);
end FP_unit;

architecture FP_unit_arch of FP_unit is

component FPU_encoder 
port (
	Input : in std_logic_vector(7 downto 0);	
	Output : out std_logic_vector(31 downto 0)
	);
end component;

component FPU_add_sub 
port (
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	result: out std_logic_vector(31 downto 0)
	);
end component;

component FPU_MUL 
port (
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	Result: out std_logic_vector(31 downto 0)
	);
end component;

signal A_FP : std_logic_vector(31 downto 0);
signal B_FP : std_logic_vector(31 downto 0);
signal Mul_result : std_logic_vector(31 downto 0);
signal add_result : std_logic_vector(31 downto 0);
begin

--component init
	FPU_encoder_A: FPU_encoder
	port map(
	Input => A,
	Output => A_FP);
	
	FPU_encoder_B: FPU_encoder
	port map(
	Input => B,
	Output => B_FP);
	
	FPU_MUL_unit: FPU_MUL
	port map(
	A => A_FP,
	B => B_FP,
	Result => Mul_result);
	
	FPU_add_unit: FPU_add_sub
	port map(
	A => A_FP,
	B => B_FP,
	Result => add_result);	
	
	
	process(SW8,A,B,Opcode,Mul_result,Add_result)
		begin
		case Opcode is
		when "1100" => -- MUL 
			if SW8='0' then
			 LO <= Mul_result(7 downto 0);
			 HI <= Mul_result(15 downto 8);
			else
			 LO <= Mul_result(23 downto 16);
			 HI <= Mul_result(31 downto 24);
			end if;
		when "1101" => -- ADD
			if SW8='0' then
			 LO <= add_result(7 downto 0);
			 HI <= add_result(15 downto 8);
			else
			 LO <= add_result(23 downto 16);
			 HI <= add_result(31 downto 24);
			end if;
		when others => -- other commands
			LO <= (others => '0');
			HI <= (others => '0');
		end case;
	end process;
end FP_unit_arch;
