-- ====================================================================
--
--	File Name:		shift_unit_tb.vhd
--	Description:	shift_unit_tb 
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


entity shift_unit_tb is
end shift_unit_tb;

architecture rtl of shift_unit_tb is  

component shift_unit
generic ( N: integer :=8);
port (
	a : in std_logic_vector(N-1 downto 0);
	b : in std_logic_vector(4 downto 0);	
	left_side : in std_logic; -- '0' for right and '1' for left
	result : out std_logic_vector(N-1 downto 0)
	);
end component;  

signal A : std_logic_vector(31 downto 0);
signal B : std_logic_vector(4 downto 0);
signal innerResult : std_logic_vector(31 downto 0);
signal innerLeft : std_logic := '1';

begin
        tester : shift_unit
		generic map (N   => 32)
        port map(a=>A, b=>B, left_side=>innerLeft ,result=>innerResult);
		
		testbench : process
        begin
		innerLeft <= '1';
		A <= "10000000100000001000000010000000";
     	B <= "00011" ;
	    wait for 200 ps; 
	    innerLeft <= '0';
	    A <= "10000000100000001000000010000000";
     	B <= "10000" ;
	    wait for 200 ps;
	    innerLeft <= '1';
	    A <= "10000000100000001000000010000000";
      	B <= "10000" ;
	    wait for 200 ps;
	    innerLeft <= '1';
		A <= "10000000100000001000000010000000";
      	B <= "11111" ;
	    wait for 200 ps;
	    innerLeft <= '1';
		  A <= "10000000100000001000000010000000";
     	B <= "00011" ;
	    wait for 200 ps; 
	    innerLeft <= '1';
	    A <= "10000000100000001000000010000000";
     	B <= "00010" ;
	    wait for 200 ps;
	    innerLeft <= '0';
	    A <= "10000000100000001000000010000000";
      	B <= "01010" ;
	    wait for 200 ps;
	    innerLeft <= '0';
		A <= "10000000100000001000000010000000";
      	B <= "11111" ;
	    wait for 200 ps;
		
    end process testbench;
		
        
end rtl;