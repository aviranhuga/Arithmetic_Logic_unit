-- ====================================================================
--
--	File Name:		min_max_tb.vhd
--	Description:	min or max testbench  
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


entity min_max_tb is
end min_max_tb;

architecture rtl of min_max_tb is  

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

signal A : std_logic_vector(7 downto 0);
signal B : std_logic_vector(7 downto 0);
signal en : std_logic;
signal innerMin_max : std_logic;
signal innerResult : std_logic_vector(15 downto 0);

begin
        tester : min_max
		generic map (N   => 8)
        port map(a=>A, 
                 b=>B, 
                 en=>en,
                 min_or_max=>innerMin_max
                 ,result=>innerResult);
		
		testbench : process
        begin
        A <= "00000111";
       	B <= "00000101" ;
	    en <= '1';
		innerMin_max <= '1';
        wait for 20 ps;
		
        A <= "00000111";
       	B <= "00000101" ;
	    en <= '1';
		innerMin_max <= '0';
        wait for 20 ps;
		
        A <= "00000111";
       	B <= "00000111" ;
	    en <= '1';
		innerMin_max <= '1';
        wait for 20 ps;
      
        end process testbench;
        
end rtl;
