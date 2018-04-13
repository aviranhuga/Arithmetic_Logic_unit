-- ====================================================================
--
--	File Name:		MUL_tb.vhd
--	Description:	MUL testbench  
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


entity MUL_tb is
end MUL_tb;

architecture rtl of MUL_tb is  

component MUL
generic ( N: integer :=8);
port (
	x : in std_logic_vector(N-1 downto 0);
	y : in std_logic_vector(N-1 downto 0);
	en: in std_logic;
	result : out std_logic_vector(2*N-1 downto 0)
	);
end component;  

signal en : std_logic;
signal A : std_logic_vector(7 downto 0);
signal B : std_logic_vector(7 downto 0);
signal innerResult : std_logic_vector(15 downto 0);

begin
        tester : MUL
        port map(x=>A, y=>B, en=>en ,result=>innerResult);
		
		testbench : process
        begin
		en <= '1';
        A <= "00000111";
      	B <= "00000011" ;
		--output should be 21
	    wait for 50 ps;
		
		en <= '1';
        A <= "01111111";
      	B <= "01111111" ;
		--output should be 21
	    wait for 50 ps;
		
		en <= '1';
        A <= "01010111";
      	B <= "00000000" ;
		--output should be 0
	    wait for 50 ps;
		wait;
		
        end process testbench;
		
        
end rtl;