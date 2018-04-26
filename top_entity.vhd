-- ====================================================================
--
--	File Name:		top_entity.vhd
--	Description:	top entity 
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
use IEEE.std_logic_unsigned.all; 

entity top_entity is 
port (
	data : in std_logic_vector(7 downto 0);
	key0_en : in std_logic;
	key1_en : in std_logic;
	key2_en : in std_logic;
	clock : in std_logic;
	HI_seven_seg1 : out std_logic_vector(6 downto 0);
	HI_seven_seg2 : out std_logic_vector(6 downto 0);
	LO_seven_seg1 : out std_logic_vector(6 downto 0);
	LO_seven_seg2 : out std_logic_vector(6 downto 0);
	Status_out : out std_logic_vector(5 downto 0)
	);
end top_entity;

architecture top_entity_arch of top_entity is

component ALU_unit
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

component Input_Register
port (
	data : in std_logic_vector(7 downto 0);
	key0_en : in std_logic;
	key1_en : in std_logic;
	key2_en : in std_logic;
	clk : in std_logic;
	A_out : out std_logic_vector(7 downto 0);
	B_out : out std_logic_vector(7 downto 0);
	OP_out : out std_logic_vector(3 downto 0)
	);
end component;

component Output_Register
port (
	clk : in std_logic;
	HI_in : in std_logic_vector(7 downto 0);
	LO_in : in std_logic_vector(7 downto 0);
	Status_in : in std_logic_vector(5 downto 0);
	HI_seven_seg1 : out std_logic_vector(6 downto 0);
	HI_seven_seg2 : out std_logic_vector(6 downto 0);
	LO_seven_seg1 : out std_logic_vector(6 downto 0);
	LO_seven_seg2 : out std_logic_vector(6 downto 0);
	Status_out : out std_logic_vector(5 downto 0)
	);
end component;

signal ALU_A_IN: std_logic_vector(7 downto 0);
signal ALU_B_IN: std_logic_vector(7 downto 0);
signal ALU_OP_IN: std_logic_vector(3 downto 0);
--signal ALU_clc_IN: std_logic;
--signal state: std_logic;
signal ALU_HI_OUT: std_logic_vector(7 downto 0);
signal ALU_LO_OUT: std_logic_vector(7 downto 0);
signal ALU_Status_OUT: std_logic_vector(5 downto 0);

signal alu_clk_tmp: std_logic;
signal q_int : std_logic_vector (31 downto 0):=x"00000000";


begin
	
	--component init
	Input_Register_s: Input_Register
	port map(
	data => data,
	key0_en => not key0_en,
	key1_en => not key1_en,
	key2_en => not key2_en,
	clk => clock,
	A_out => ALU_A_IN,
	B_out  => ALU_B_IN,
	OP_out => ALU_OP_IN);
	
	
	ALU_unit_s: ALU_unit
	generic map(N => 8)
	port map(
	A  => ALU_A_IN,
	B  => ALU_B_IN,
	Opcode => ALU_OP_IN,
	clk => alu_clk_tmp,
	HI => ALU_HI_OUT,
	LO => ALU_LO_OUT,
	status=>ALU_Status_OUT);
	
	Output_Register_s: Output_Register
	port map(
	clk => clock,
	HI_in => ALU_HI_OUT,
	LO_in => ALU_LO_OUT,
	Status_in => ALU_Status_OUT,
	HI_seven_seg1 => HI_seven_seg1,
	HI_seven_seg2 => HI_seven_seg2,
	LO_seven_seg1 => LO_seven_seg1,
	LO_seven_seg2 => LO_seven_seg2,
	Status_out => Status_out);
	
	alu_clk_tmp <= q_int(11);
	
	process (clock)
    begin
        if (rising_edge(clock)) then
           q_int <= q_int + 1;
	     end if;
    end process;
end top_entity_arch;