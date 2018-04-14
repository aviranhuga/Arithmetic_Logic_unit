-- ====================================================================
--
--	File Name:		ALU_tb.vhd
--	Description:	Arithmetic unit test bench
--					
--
--	Date:			4/07/2018
--	Designer:		Aviran Huga
--
-- ====================================================================


library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity ALU_tb is
end ALU_tb;

architecture rtl of ALU_tb is  

component ALU_unit
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

constant TIME_DELTA : time := 20  ps;
constant CLOCK_TIME_DELTA : time := 20  ps;
constant numOfClockCounter: integer := 1000000000;
signal A : std_logic_vector(7 downto 0);
signal B : std_logic_vector(7 downto 0);
signal Opcode : std_logic_vector(3 downto 0);
signal clock : std_logic;
signal OUT_HI : std_logic_vector(7 downto 0);
signal OUT_LO : std_logic_vector(7 downto 0);
signal innerStatus : std_logic_vector(5 downto 0);

begin
        tester : ALU_unit
        port map(
		A => A, 
		B => B, 
		Opcode => Opcode,
		clk=> clock,
		HI => OUT_HI,
		LO => OUT_LO, 
		status => innerStatus);
		
		
		testbench : process
		
		
		--TEST RUN PROCEDURE FOR 
		variable test_number : integer;
		procedure test_run(
		test_num : std_logic_vector(7 downto 0);
		A_val : std_logic_vector(7 downto 0);
		B_val : std_logic_vector(7 downto 0);
		Opcode_val : std_logic_vector(3 downto 0);
		expected_status: std_logic_vector(5 downto 0);
		expected_result_LO : std_logic_vector(7 downto 0);
		expected_result_HI : std_logic_vector(7 downto 0)) is
		begin
			test_number := to_integer(UNSIGNED(test_num));
			--Update A B and Opcode
			A <= A_val;
			B <= B_val;
			Opcode <= Opcode_val;
			--WAIT TIMING 
			if Opcode_val="0100" then --MAC OP NEED different time delta
			--wait for 2 clocks
			wait for CLOCK_TIME_DELTA;
			wait for CLOCK_TIME_DELTA;
			else -- wait for 1 clock
			wait for CLOCK_TIME_DELTA;
			end if;
			--CHECK RESULT
			assert OUT_LO=expected_result_LO report "FAIL : result low fail in test number :" & integer'image(test_number);
			assert OUT_LO=expected_result_LO report "FAIL : result high fail in test number :" & integer'image(test_number);
			assert innerStatus=expected_status report "FAIL : status fail in test number :" & integer'image(test_number);
			--TEST NOT FAILED
			report "TEST PASS: test number: " & integer'image(test_number);
		end procedure test_run;
		
		begin ----test num-----A-----------B-----OPCODE----status---LO---------HI------
		--ADD COMMAND TESTS
		test_run("00000000","00000000","00000000","0000","000000","00000000","00000000");--none - test 0
		test_run("00000001","00000011","00000001","0001","000000","00000100","00000000");--ADD - test 1
		test_run("00000010","00000111","00000011","0001","000000","00001010","00000000");--ADD - test 2
		test_run("00000011","00000011","11111100","0001","000000","11111111","00000000");--ADD - test 3
		test_run("00000100","11111111","00000001","0001","000000","00000000","00000000");--ADD - test 4
		test_run("00000101","00000011","00000011","0001","000000","00000110","00000000");--ADD - test 5
		
		--SUB COMMAND TESTS
		test_run("00000110","00000011","00000001","0010","001110","00000010","00000000");--SUB - test 6
		test_run("00000111","00000001","00000010","0010","110010","11111111","00000000");--SUB - test 7
		test_run("00001000","10010011","10010011","0010","010101","00000000","00000000");--SUB - test 8
		test_run("00001001","00000001","11111111","0010","001110","00000010","00000000");--SUB - test 9
		test_run("00001010","00110011","00110001","0010","001110","00000010","00000000");--SUB - test 10
		
		--MUL COMMAND TESTS
		test_run("00001011","00000011","00000001","0011","000000","00000011","00000000");--MUL - test 11
		test_run("00001100","10000000","00000010","0011","000000","00000000","00000001");--MUL - test 12
		test_run("00001101","10001000","00000100","0011","000000","00100000","00000010");--MUL - test 13
		test_run("00001110","11111111","11111111","0011","000000","00000001","00000000");--MUL - test 14
		test_run("00001111","00000011","00000011","0011","000000","00001001","00000000");--MUL - test 15
		
		--MAC AND RESET COMMAND TESTS
		test_run("00010000","00000000","00000000","0111","000000","00000000","00000000");--RESET - test 16
		test_run("00010001","00000011","00000010","0100","000000","00000110","00000000");--MAC - test 17
		test_run("00010010","00000011","00000010","0100","000000","00001100","00000000");--MAC - test 18
		test_run("00010011","00000100","00000001","0100","000000","00010000","00000000");--MAC - test 19
		test_run("00010100","00000000","00000000","0111","000000","00000000","00000000");--RESET - test 20
		test_run("00010101","00000111","00000100","0100","000000","00011100","00000000");--MAC - test 21
		
		--MIN/MAX COMMAND TESTS
		test_run("00010110","00000000","00000000","0110","000000","00000000","00000000");--MIN - test 22
		test_run("00010111","00000011","00000010","0110","000000","00000010","00000000");--MIN - test 23
		test_run("00011000","00000011","00000010","0101","000000","00000011","00000000");--MAX - test 24
		test_run("00011001","00000100","00000001","0101","000000","00000100","00000000");--MAX - test 25
		test_run("00011010","00000100","11111111","0110","000000","11111111","00000000");--MIN - test 26
		test_run("00011011","00000111","00000100","0101","000000","00000111","00000000");--MAX - test 27
		
		--SHR/SHL COMMAND TESTS
		test_run("00011100","00011000","00000000","1000","000000","00011000","00000000");--SHR - test 28
		test_run("00011101","00011000","00000010","1000","000000","00000110","00000000");--SHR - test 29
		test_run("00011110","00011000","00000010","1001","000000","01100000","00000000");--SHL - test 30
		test_run("00011111","00011000","00000011","1001","000000","11000000","00000000");--SHL - test 31
		test_run("00100000","10000000","00000111","1000","000000","00000001","00000000");--SHR - test 32
		test_run("00100001","10000000","00000001","1001","000000","00000000","00000000");--SHL - test 33
		
		--MIX COMMANDS TESTS
		test_run("00100010","00000000","00000000","0111","000000","00000000","00000000");--RESET - test 34
		test_run("00100011","00000111","00000011","0001","000000","00001010","00000000");--ADD - test 35
		test_run("00100100","00000011","11111100","0001","000000","11111111","00000000");--ADD - test 36
		test_run("00100101","00000011","00000010","0100","000000","00000110","00000000");--MAC - test 37
		test_run("00100110","00000011","00000010","0100","000000","00001100","00000000");--MAC - test 38
		test_run("00100111","00000000","00000000","0100","000000","00001100","00000000");--MAC - test 39
		test_run("00101000","00000011","00000010","0110","000000","00000010","00000000");--MIN - test 40
		test_run("00101001","00000011","00000010","0101","000000","00000011","00000000");--MAX - test 41
		test_run("00101010","10000000","00000111","1000","000000","00000001","00000000");--SHR - test 42
		test_run("00101011","10000000","00000001","1001","000000","00000000","00000000");--SHL - test 43
		test_run("00101100","10001000","00000100","0011","000000","00100000","00000010");--SUB - test 44
		test_run("00101101","11111111","11111111","0011","000000","00000001","00000000");--SUB - test 45
		test_run("00101110","00000100","00000001","0100","000000","00010000","00000000");--MAC - test 46
		test_run("00101111","00000000","00000000","0111","000000","00000000","00000000");--RESET - test 47
		test_run("00110000","00000111","00000100","0100","000000","00011100","00000000");--MAC - test 48
		test_run("00110001","00000011","00000011","0011","000000","00001001","00000000");--SUB - test 49
		test_run("00110010","00000000","00000000","0000","000000","00000000","00000000");--none - test 50
		wait;
		
        end process testbench;
		
        clock_timing: process 
        begin
                clock <= '1';
                for i in 0 to numOfClockCounter loop 
                        wait for 10 ps;
                        clock <= not clock;			
                end loop;
                wait;
        end process clock_timing;
end rtl;
