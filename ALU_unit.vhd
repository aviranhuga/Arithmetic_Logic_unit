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

component AU_IN_MUX 
generic ( N: integer :=8);
port (
	input_a : in std_logic_vector(N-1 downto 0);
	input_b : in std_logic_vector(N-1 downto 0);	
	SEL : in std_logic;
	output1_a : out std_logic_vector(N-1 downto 0);--output for Arithmetic_unit
	output1_b : out std_logic_vector(N-1 downto 0);--output for Arithmetic_unit
	output2_a : out std_logic_vector(N-1 downto 0);--output for shift_unit
	output2_b : out std_logic_vector(N-1 downto 0) --output for shift_unit	
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
signal ALU_MAC_STATUS: std_logic_vector(1 downto 0) := "00"; 
signal shift_left_or_right: std_logic; --'0' for right, '1' for left
signal AU_clk: std_logic := '0'; -- clock for AU
signal ALU_IN_MUX_SEL: std_logic; -- '0' for AU , '1' for Shift unit
signal ALU_OUT_SELECTOR_SEL : std_logic_vector(1 downto 0); --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros

--connection signals
signal ALU_IN_MUX_output1_a: std_logic_vector(N-1 downto 0);
signal ALU_IN_MUX_output1_b: std_logic_vector(N-1 downto 0);
signal ALU_IN_MUX_output2_a: std_logic_vector(N-1 downto 0);
signal ALU_IN_MUX_output2_b: std_logic_vector(N-1 downto 0);
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
	
	
	ALU_IN_MUX_s: AU_IN_MUX
	generic map(N)
	port map(
	input_a => A, 
	input_b => B,
	SEL => ALU_IN_MUX_SEL,
	output1_a => ALU_IN_MUX_output1_a,
	output1_b => ALU_IN_MUX_output1_b,
	output2_a => ALU_IN_MUX_output2_a,
	output2_b => ALU_IN_MUX_output2_b);
	
	shift_unit_s: shift_unit
	generic map(N)
	port map(
	a => ALU_IN_MUX_output2_a,
	b => ALU_IN_MUX_output2_b(4 downto 0),
	left_side => shift_left_or_right,
	result => shift_unit_result);

	Arithmetic_unit_s: Arithmetic_unit
	generic map(N)
	port map(
	A => ALU_IN_MUX_output1_a,
	B => ALU_IN_MUX_output1_b,
	Opcode => Opcode,
	clk => AU_clk,
	HI => AU_HI_output,
	LO => AU_LO_output,
	status => AU_status_output);
	
	
	--opcode decode and change control lines
	process(clk)
		begin
		if rising_edge(clk) then
		case Opcode is
		when "1000" | "1001" => --shift opcode
			if ALU_MAC_STATUS="00" then
			shift_left_or_right <= Opcode(0); --'0' for right, '1' for left
			AU_clk <= '0'; -- clock for AU
			ALU_IN_MUX_SEL <= '1'; -- '0' for AU , '1' for Shift unit
			ALU_OUT_SELECTOR_SEL <= "00"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
			end if;
		when "0101" | "0110" | "0001" | "0010" | "0111" => -- MIN/MAX/ADD/SUB/RST
			if ALU_MAC_STATUS="00" then
			AU_clk <= (not AU_clk); -- clock for AU
			ALU_IN_MUX_SEL <= '0'; -- '0' for AU , '1' for Shift unit
			ALU_OUT_SELECTOR_SEL <= "01"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
			end if;
		when "0011" => -- MUL OPCODE
			if ALU_MAC_STATUS="00" then
			AU_clk <= (not AU_clk); -- clock for AU
			ALU_IN_MUX_SEL <= '0'; -- '0' for AU , '1' for Shift unit
			ALU_OUT_SELECTOR_SEL <= "10"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
			end if;			
		when "0100" => --MAC OPCODE
				case ALU_MAC_STATUS is
					when "00" => -- first MAC Clock
					ALU_MAC_STATUS <= "01";					
					AU_clk <= (not AU_clk); -- clock for AU
					ALU_IN_MUX_SEL <= '0'; -- '0' for AU , '1' for Shift unit
					ALU_OUT_SELECTOR_SEL <= "10"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
					when "01" => -- second MAC Clock
					ALU_MAC_STATUS <= "10";
					AU_clk <= (not AU_clk); -- clock for AU
					ALU_OUT_SELECTOR_SEL <= "10"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
					when "10" =>
					AU_clk <= (not AU_clk); -- clock for AU
					ALU_MAC_STATUS <= "00";	
					when others =>
					ALU_MAC_STATUS <= "00";	
				end case;
		when others =>
			ALU_MAC_STATUS <= "00";	
			AU_clk <= '0'; -- clock for AU
			ALU_OUT_SELECTOR_SEL <= "11"; --'00' shift,'01' AU_LO,'10' AU_LO_HI,'11' all zeros
		end case;
		end if;
	end process;
end ALU_unit_arch;

