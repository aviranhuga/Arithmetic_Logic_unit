-- ====================================================================
--
--	File Name:		AU_tb.vhd
--	Description:	Arithmetic unit test bench
--					
--
--	Date:			4/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity AU_tb is
end AU_tb;

architecture rtl of AU_tb is  

component Arithmetic_unit
port (
	A : in std_logic_vector(7 downto 0);
	B : in std_logic_vector(7 downto 0);	
	Opcode : in std_logic_vector(3 downto 0);
	clk : in std_logic;
	HI : out std_logic_vector(7 downto 0);
	LO : out std_logic_vector(7 downto 0);
	status: out std_logic_vector(5 downto 0)
	);
end component;  

constant numOfClockCounter: integer := 1000000000;
signal A : std_logic_vector(7 downto 0);
signal B : std_logic_vector(7 downto 0);
signal Opcode : std_logic_vector(3 downto 0);
signal clock : std_logic;
signal OUT_HI : std_logic_vector(7 downto 0);
signal OUT_LO : std_logic_vector(7 downto 0);
signal innerStatus : std_logic_vector(5 downto 0);

begin
        tester : Arithmetic_unit
        port map(
		A => A, 
		B => B, 
		Opcode => Opcode,
		clk=> clock,
		HI => OUT_HI,
		LO => OUT_LO, 
		status => innerStatus);
		
		testbench : process
        begin
		A <= "00000001";
		B <= "00000010";
		Opcode <= "0111";
		wait for 500 ps; -- reset
		A <= "00000011";
		B <= "00000001";
		Opcode <= "0101";
		wait for 500 ps; -- MAX
		A <= "00000011";
		B <= "00000001";
		Opcode <= "0110";
		wait for 500 ps; -- MIN
		A <= "00000011";
		B <= "00000001";
		Opcode <= "0001";
		wait for 500 ps; -- ADD
		A <= "00000011";
		B <= "00000010";
		Opcode <= "0100";
		wait for 500 ps; -- MAC
		A <= "00000010";
		B <= "00000010";
		Opcode <= "0100";
		wait for 500 ps; -- MAC
		A <= "00000011";
		B <= "00000011";
		Opcode <= "0001";
		wait for 500 ps; -- ADD
		A <= "00000011";
		B <= "00000001";
		Opcode <= "0011";
		wait for 500 ps; -- MUL
		A <= "00000011";
		B <= "00000010";
		Opcode <= "0011";
		wait for 500 ps; -- MUL
		A <= "00000111";
		B <= "00000010";
		Opcode <= "0010";
		wait for 500 ps; -- SUB
		A <= "00000001";
		B <= "00000010";
		Opcode <= "0010";
		wait for 500 ps; -- SUB
		A <= "00000001";
		B <= "00000010";
		Opcode <= "0111";
		wait for 500 ps; -- reset
		A <= "00000011";
		B <= "00000010";
		Opcode <= "0100";
		wait for 500 ps; -- MAC
		A <= "00000010";
		B <= "00000010";
		Opcode <= "0100";
		wait for 500 ps; -- MAC
		wait for 5 ns;
		
        end process testbench;
		
        clock_timing: process 
        begin
                clock <= '1';
                for i in 0 to numOfClockCounter loop 
                        wait for 50 ps;
                        clock <= not clock;			
                end loop;
                wait;
        end process clock_timing;
end rtl;
