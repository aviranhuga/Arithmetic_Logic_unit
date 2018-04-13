-- ====================================================================
--
--	File Name:		Add_sub_tb.vhd
--	Description:	add-sub testbench  
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


entity Add_sub_tb is
end Add_sub_tb;

architecture rtl of Add_sub_tb is  

component add_sub
generic ( N: integer :=8);
port (
	x : in std_logic_vector(2*N-1 downto 0);
	y : in std_logic_vector(2*N-1 downto 0);	
	sub : in std_logic;
	result : out std_logic_vector(2*N-1 downto 0)
	);
end component;  

signal A : std_logic_vector(15 downto 0);
signal B : std_logic_vector(15 downto 0);
signal innerResult : std_logic_vector(15 downto 0);
signal innersub : std_logic;

begin
        tester : add_sub
        port map(x=>A, y=>B, sub=>innersub ,result=>innerResult);
		
		testbench : process
        begin
		A <= "1010011110100111";
      	B <= "1010011110100111" ;
	    innersub <= '0';
	    wait for 1 ns;
		
		A <= "0000011100000111" ;
	    B <= "0000111100000111" ;
	    innersub <= '1';
	    wait for 1 ns;
		
	    A <= "0000111100001111";
	    B <= "0000010000001111";
	    innersub <= '1';
	    wait for 1 ns;
		
	    A <= "0000000100000001" ;
	    B <= "0000000100000001" ;
	    innersub <= '1';
	    wait for 1 ns;
		
        end process testbench;
        
end rtl;
