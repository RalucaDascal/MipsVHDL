----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2020 10:20:55 AM
-- Design Name: 
-- Module Name: UnitEx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UnitEx is
 Port (  pc: in std_logic_Vector (15 downto 0);
         rd1: in std_logic_Vector (15 downto 0);
         rd2: in std_logic_Vector (15 downto 0);
         extImm:  in std_logic_Vector (15 downto 0);
         func:  in std_logic_Vector (2 downto 0);
         sa:  in std_logic;
         ALUSrc: in std_logic;
         ALUOp: in std_logic_Vector (2 downto 0);
         zero: out  std_logic;
         BranchAddress: out std_logic_Vector (15 downto 0);
         ALURes: out std_logic_Vector (15 downto 0);
         bltFlag: out  std_logic);
end UnitEx;

architecture Behavioral of UnitEx is
signal muxAux:  std_logic_Vector (15 downto 0);
signal result:  std_logic_Vector (15 downto 0);
signal ALUCtrl:  std_logic_Vector (2 downto 0);
begin

with ALUSrc select
      muxAux <= RD2 when '0', 
	            extImm when '1',
	            (others => '0') when others;
	              
process(ALUOp, func)
       begin
           case ALUOp is
               when "000" => --R-Type
                           case func is
                               when "001" => ALUCtrl <= "000"; -- ADD
                               when "010" => ALUCtrl  <= "001"; -- SUB
                               when "011" => ALUCtrl  <= "011"; -- SRL
                               when "100" => ALUCtrl  <= "100"; -- SLL
                               when "101" => ALUCtrl  <= "010"; -- AND
                               when "110" => ALUCtrl  <= "101"; -- OR
                               when "111" => ALUCtrl  <= "110"; -- XOR
                               when others => ALUCtrl <= "111";
                           end case;
               when "001" => ALUCtrl  <="000";--addi
               when "010" => ALUCtrl  <= "000";--LW
               when "011" => ALUCtrl  <="010";--andi 
               when "100" => ALUCtrl  <="001";--beq
               when "110" => ALUCtrl  <="001";--blt
               when "111" => ALUCtrl  <="000";--sw
               when others => ALUCtrl  <="111"; 
           end case;
       end process;
   ALU : process (ALUCtrl, muxAux, rd1, sa)
              begin
                  case ALUCtrl is
                      when "000" => result <= rd1 + muxAux; --  +
                      when "001" => result <= rd1 - muxAux; -- -
                      when "011" => result <= '0' & rd1(15 downto 1); --SRL
                      when "100" => result <= rd1(14 downto 0) & '0'; --SLL
                      when "010" => result<= rd1 and muxAux; -- AND
                      when "101" => result<= rd1 or muxAux; -- OR
                      when "111" => result <= rd1 xor  muxAux; -- XOR
                      when others => result <= x"0000";
                      end case;
            end process;
            zero<='1' when result=x"0000" else '0';         
            bltFlag<='1' when result (15)='1' else '0';    
              

ALURes <=result;
BranchAddress<=pc+extImm;

end Behavioral;
