-- ====================================================================
--
--	File Name:		FPU_add_sub.vhd
--	Description:	Floating Point add/sub unit
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

entity FPU_add_sub is 
port (
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	result: out std_logic_vector(31 downto 0)
	);
end FPU_add_sub;

architecture FPU_add_sub_arch of FPU_add_sub is

component add_sub_N 
generic( N: integer :=8);
port (
	x : in std_logic_vector(N-1 downto 0);
	y : in std_logic_vector(N-1 downto 0);	
	sub : in std_logic;
	cout : out std_logic;
	result : out std_logic_vector(N-1 downto 0)
	);
end component;

component min_max
generic ( N: integer :=8);
port (
	a : in std_logic_vector(N-1 downto 0);
	b : in std_logic_vector(N-1 downto 0);	
	en : in std_logic;
	min_or_max : in std_logic; -- '0' for finding min, '1' for finding max.
	result : out std_logic_vector(2*N-1 downto 0)
	);
end component;


component Lead_zeros_counter
port (
	add_sub_cout : in std_logic;
	num : in std_logic_vector(23 downto 0);	
	side_to_shift : out std_logic;
	result : out std_logic_vector(4 downto 0)
	);
end component;

component Rounding_unit
port (
	Input : in std_logic_vector(22 downto 0);
	output : out std_logic_vector(22 downto 0)
	);
end component;

component Absoult_value
generic ( N: integer :=8);
port (
	Input : in std_logic_vector(N-1 downto 0);
	Output : out std_logic_vector(N-1 downto 0)
	);
end component;

component Swap_FPU
port (
	f1 : in std_logic_vector(23 downto 0);	
	f2 : in std_logic_vector(23 downto 0);
	SEL : in std_logic; 
	o1 : out std_logic_vector(23 downto 0);
	o2 : out std_logic_vector(23 downto 0)
	);
end component;

component shift_unit
generic ( N: integer :=8);
port (
	a : in std_logic_vector(N-1 downto 0);
	b : in std_logic_vector(4 downto 0);	
	left_side : in std_logic; -- '0' for right and '1' for left
	result : out std_logic_vector(N-1 downto 0)
	);
end component;


-- signals
--operand values
signal e1: std_logic_vector(7 downto 0);
signal e2: std_logic_vector(7 downto 0);
signal s1: std_logic;
signal s2: std_logic;
signal f1: std_logic_vector(23 downto 0);
signal f2: std_logic_vector(23 downto 0);

--connection signals
signal Exponent_Subtracter_result : std_logic_vector(7 downto 0);
signal Alignment_Shifter_result : std_logic_vector(23 downto 0);
signal Absoult_value_result : std_logic_vector(7 downto 0); 
signal Significand_add_sub_result : std_logic_vector(23 downto 0);
signal Normalize_output : std_logic_vector(22 downto 0);
signal Significand_add_sub_result_AB : std_logic_vector(23 downto 0);
signal Significand_add_sub_cout : std_logic;
signal Lead_zeros_counter_side : std_logic;
signal max_exponent : std_logic_vector(15 downto 0);
signal exponent_befor_bias : std_logic_vector(7 downto 0);
signal Lead_zeros_counter_result : std_logic_vector(4 downto 0);
signal Swap_o1 : std_logic_vector(23 downto 0);
signal Swap_o2 : std_logic_vector(23 downto 0);


signal one_signal: std_logic;
signal zero_signal: std_logic;
signal bias: std_logic_vector(7 downto 0);
signal subtract_signal : std_logic;

begin
e1 <= SIGNED(A(30 downto 23)) - SIGNED(bias);
e2 <= SIGNED(B(30 downto 23)) - SIGNED(bias);
s1 <= A(31);
s2 <= B(31);
f1(23) <= '1';
f1(22 downto 0) <= A(22 downto 0);
f2(23) <= '1';
f2(22 downto 0) <= B(22 downto 0);
one_signal <= '1';
zero_signal <= '0';
bias <= "01111111";
subtract_signal <= s1 xor s2; --for Significand_add_sub
			  

			  
--component init

	Exponent_Subtracter: add_sub_N
		generic map (N => 8)
		port map(
		x => e1,
		y => e2,
		sub => one_signal,
		cout => open,
		result => Exponent_Subtracter_result);
		
	Swap: Swap_FPU
		port map(
		f1 => f1,
		f2 => f2,
		SEL => Exponent_Subtracter_result(7),
		o1 => Swap_o1,
		o2 => Swap_o2);
		
	Absoult_value_s : Absoult_value
		generic map(N => 8)
		port map(
		Input => Exponent_Subtracter_result,
		Output => Absoult_value_result);
		
	Alignment_Shifter: shift_unit
		generic map (N => 24)
		port map (
		a => Swap_o2,
		b => Absoult_value_result(4 downto 0),
		left_side => zero_signal,
		result => Alignment_Shifter_result);
		
	Significand_add_sub: add_sub_N
		generic map (N => 24)
		port map(
		x => Swap_o1,
		y => Alignment_Shifter_result,
		sub => subtract_signal,
		cout => Significand_add_sub_cout,
		result => Significand_add_sub_result);
		
	Significand_add_sub_AB: Absoult_value
		generic map(N => 24)
		port map(
		Input => Significand_add_sub_result,
		Output => Significand_add_sub_result_AB);
		
	Lead_zeros_Counter_s: Lead_zeros_counter 
		port map (
		add_sub_cout =>Significand_add_sub_cout,
		num => Significand_add_sub_result_AB,
		side_to_shift => Lead_zeros_counter_side,
		result => Lead_zeros_counter_result);
		
	Select_exponent : min_max
		generic map(N => 8)
		port map (
		a => e1,
		b => e2,
		en => one_signal,
		min_or_max => one_signal,
		result => max_exponent);
		
		Normalize: shift_unit
		generic map (N => 23)
		port map(
		a => Significand_add_sub_result_AB(22 downto 0),
		b => Lead_zeros_counter_result,
		left_side => Lead_zeros_counter_side,
		result => Normalize_output);

		Rounding_unit_output: Rounding_unit
		port map(
		Input => Normalize_output,
		output => result(22 downto 0));
		
		exponent_result_shift: shift_unit
		generic map (N => 8)
		port map(
		a => max_exponent(7 downto 0),
		b => Lead_zeros_counter_result,
		left_side => zero_signal,
		result => exponent_befor_bias);

		result(31) <= (
			  (s2 and Significand_add_sub_result(22)) or
			  (s2 and Exponent_Subtracter_result(7)) or
			  ((not Exponent_Subtracter_result(7)) and (not Significand_add_sub_result(22)) and s1));
			  
		result(30 downto 23) <= SIGNED(exponent_befor_bias) + SIGNED(bias);
	
end FPU_add_sub_arch;
