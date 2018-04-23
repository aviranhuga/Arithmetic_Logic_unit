-- ====================================================================
--
--	File Name:		ALU_unit.vhd
--	Description:	ALU unit
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

entity ALU_unit is 
generic ( N: integer :=8);
port (
	A : in std_logic_vector(N-1 downto 0);
	B : in std_logic_vector(N-1 downto 0);	
	Opcode : in std_logic_vector(3 downto 0);
	clk : in std_logic;
	HI : out std_logic_vector(N-1 downto 0);
	LO : out std_logic_vector(N-1 downto 0);
	status: out std_logic_vector(5 downto 0)
	);
end ALU_unit;

architecture ALU_unit_arch of ALU_unit is

component shift_unit 
generic ( N: integer :=8);
port (
	a : in std_logic_vector(N-1 downto 0);
	b : in std_logic_vector(4 downto 0);	
	left_side : in std_logic; -- '0' for right and '1' for left
	result : out std_logic_vector(N-1 downto 0)
	);
end component;

component ALU_CU 
port (
	opcode_cu : in std_logic_vector(3 downto 0);
	clk_cu : in std_logic := '0';
	shift_left_or_right_cu: out std_logic; --'0' for right, '1' for left
	AU_clk_cu: out std_logic; -- clock for AU	
	ALU_OUT_SELECTOR_SEL_cu : out std_logic_vector(1 downto 0) --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros	
	);
end component;

component Arithmetic_unit 
generic ( N: integer :=8);
port (
	A : in std_logic_vector(N-1 downto 0);
	B : in std_logic_vector(N-1 downto 0);	
	Opcode : in std_logic_vector(3 downto 0);
	clk : in std_logic;
	HI : out std_logic_vector(N-1 downto 0);
	LO : out std_logic_vector(N-1 downto 0);
	status: out std_logic_vector(5 downto 0)
	);
end component;

component OUTPUT_SELECTOR 
generic ( N: integer :=8);
port (
	shift_unit_INPUT : in std_logic_vector(N-1 downto 0);-- shift register output
	AU_LO_INPUT : in std_logic_vector(N-1 downto 0);-- Arithmetic unit output LO
	AU_HI_INPUT : in std_logic_vector(N-1 downto 0);-- Arithmetic unit output HI
	AU_status : in std_logic_vector(5 downto 0);-- MIN_MAX output
	SEL : in std_logic_vector(1 downto 0);
	output_LO : out std_logic_vector(N-1 downto 0) := (others => '0');	
	output_HI : out std_logic_vector(N-1 downto 0) := (others => '0');
	output_status : out std_logic_vector(5 downto 0)
	);
end component;
--control signals
signal ALU_MAC_STATUS: std_logic := '0'; 
signal shift_left_or_right: std_logic; --'0' for right, '1' for left
signal AU_clk: std_logic := '0'; -- clock for AU
signal ALU_OUT_SELECTOR_SEL : std_logic_vector(1 downto 0); --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros

--connection signals
signal shift_unit_result: std_logic_vector(N-1 downto 0);
signal AU_HI_output: std_logic_vector(N-1 downto 0);
signal AU_LO_output: std_logic_vector(N-1 downto 0);
signal AU_status_output: std_logic_vector(5 downto 0);

begin
	
	--component init
	OUTPUT_SELECTOR_s: OUTPUT_SELECTOR
	generic map(N)
	port map(
	shift_unit_INPUT => shift_unit_result,
	AU_LO_INPUT => AU_LO_output,
	AU_HI_INPUT => AU_HI_output,
	AU_status => AU_status_output,
	SEL => ALU_OUT_SELECTOR_SEL,
	output_LO => LO,
	output_HI => HI,
	output_status => status);
	
	shift_unit_s: shift_unit
	generic map(N)
	port map(
	a => A,
	b => B(4 downto 0),
	left_side => shift_left_or_right,
	result => shift_unit_result);

	Arithmetic_unit_s: Arithmetic_unit
	generic map(N)
	port map(
	A => A,
	B => B,
	Opcode => Opcode,
	clk => AU_clk,
	HI => AU_HI_output,
	LO => AU_LO_output,
	status => AU_status_output);
	
	ALU_CU_s: ALU_CU
	port map(
	opcode_cu => opcode,
	clk_cu => clk,
	shift_left_or_right_cu => shift_left_or_right,
	AU_clk_cu => AU_clk,
	ALU_OUT_SELECTOR_SEL_cu => ALU_OUT_SELECTOR_SEL);
	
end ALU_unit_arch;