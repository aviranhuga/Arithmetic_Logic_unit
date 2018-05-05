-- ====================================================================
--
--	File Name:		FPU_MUL.vhd
--	Description:	Floating Point MUL unit
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

entity FPU_MUL is 
port (
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	Result: out std_logic_vector(31 downto 0)
	);
end FPU_MUL;

architecture FPU_MUL_arch of FPU_MUL is

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

component MUL
generic ( N: integer :=8);
port (
	x : in std_logic_vector(N-1 downto 0);
	y : in std_logic_vector(N-1 downto 0);
	result : out std_logic_vector(2*N-1 downto 0)
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
signal Exponent_adder_result : std_logic_vector(7 downto 0);
signal New_f : std_logic_vector(47 downto 0);

signal zero_signal: std_logic;
signal bias: std_logic_vector(7 downto 0);
signal one: std_logic_vector(7 downto 0);
begin
e1 <= SIGNED(A(30 downto 23)) - SIGNED(bias);
e2 <= SIGNED(B(30 downto 23)) - SIGNED(bias);
s1 <= A(31);
s2 <= B(31);
f1(23) <= '1';
f1(22 downto 0) <= A(22 downto 0);
f2(23) <= '1';
f2(22 downto 0) <= B(22 downto 0);
zero_signal <= '0';
bias <= "01111111";
one <= "00000001";

--component init
	Exponent_Adder: add_sub_N
		generic map (N => 8)
		port map(
		x => e1,
		y => e2,
		sub => zero_signal,
		cout => open,
		result => Exponent_adder_result);
		
	process(A,B,New_f,s1,s2,Exponent_adder_result,bias,one)
	begin
		if New_f(47)='1' then
			Result(31) <= s1 XOR s2;
			Result(22 downto 0) <= New_f(46 downto 24);
			Result(30 downto 23) <= SIGNED(Exponent_adder_result) + SIGNED(bias) + SIGNED(one);
		else 
			Result(31) <= s1 XOR s2;
			Result(22 downto 0) <= New_f(45 downto 23);
			Result(30 downto 23) <= SIGNED(Exponent_adder_result) + SIGNED(bias);
		end if;
	end process;
		
	New_f <= UNSIGNED(f1) * UNSIGNED(f2);
	
end FPU_MUL_arch;