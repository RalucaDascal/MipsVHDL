----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2020 01:17:04 PM
-- Design Name: 
-- Module Name: UnitControl - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UnitControl is
  Port (   Instruction : in std_logic_vector(2 downto 0);
           RegDst : out std_logic;
           ExtOp : out std_logic;
           ALUSrc : out std_logic;
           Branch : out std_logic;
           Jump : out std_logic;
           ALUOp : out std_logic_vector(2 downto 0);
           MemWrite : out std_logic;
           MemtoReg : out std_logic;
           RegWrite : out std_logic;
           BranchBlt: out std_logic);
end UnitControl;

architecture Behavioral of UnitControl is

begin
 process (Instruction)
  begin
   RegDst <= '0'; 
   ExtOp <= '0'; 
   ALUSrc <= '0'; 
   Branch <= '0'; 
   Jump <= '0'; 
   MemWrite <= '0';
   MemtoReg <= '0'; 
   RegWrite <= '0';
   BranchBlt <='0'; 
   ALUOp <= "000";
   case (Instruction) is
    when "000" => --R Type
     RegDst <= '1';
     RegWrite <='1';
     ALUOp <= "000";
    when "001" => --ADDI
     ExtOp <= '1';
     ALUSrc <= '1';
     RegWrite <= '1';
     ALUOp <= "001";
    when "010" => --LW 
     ExtOp <= '1';
     ALUSrc <= '1';
     MemtoReg <= '1';
     RegWrite <= '1';
     ALUOp <= "010";
    when "011" => --ANDI
     ALUSrc <= '1';
     RegWrite <= '1';
     ALUOp <= "011";
    when "100" => --BEQ
     ExtOp <= '1';
     Branch <= '1';
     ALUOp <= "100"; 
    when "101" => -- J
     Jump <= '1';
    when "110" => --BLT 
     ExtOp <= '1';
     BranchBlt <= '1';
     ALUOp <= "110";  
    when "111" => --SW
     ExtOp <= '1';
     ALUSrc <= '1';
     MemWrite <= '1';
     ALUOp <= "111"; 
    when others => 
     RegDst <= '0'; 
     ExtOp <= '0'; 
     ALUSrc <= '0'; 
     Branch <= '0'; 
     Jump <= '0'; 
     MemWrite <= '0';
     MemtoReg <= '0'; 
     RegWrite <= '0';
     BranchBlt <= '0';
     ALUOp <= "000";
    end case;
  end process;  
end Behavioral;
