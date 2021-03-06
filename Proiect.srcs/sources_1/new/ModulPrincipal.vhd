----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2020 01:46:01 PM
-- Design Name: 
-- Module Name: ModulPrincipal - Behavioral
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

entity ModulPrincipal is
  Port (Clk: in std_logic;
        Rst: in std_logic;
        En: in std_logic;
        PC:  out std_logic_vector (15 downto 0);
        ALUResult: out std_logic_vector (15 downto 0));
end ModulPrincipal;

architecture Behavioral of ModulPrincipal is

signal Instruction, nextInstruction, RD1, RD2, writedata, extImm : STD_LOGIC_VECTOR(15 downto 0); 
signal JumpAddress, BranchAddress, ALURes, ALUResAUX, MemData : STD_LOGIC_VECTOR(15 downto 0);
signal func : STD_LOGIC_VECTOR(2 downto 0);
signal sa, zero : STD_LOGIC;
signal PCSrc,BranchBlt,bltFlag : STD_LOGIC; 
signal RegDest, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite : STD_LOGIC;
signal ALUOp :  STD_LOGIC_VECTOR(2 downto 0);

begin
IFETCH: entity work.IFetch 
Port map (Clk=> Clk,
          Rst=> Rst,
          EN=> En,
          branchAddress=>  branchAddress,
          jumpAddress=>    jumpAddress,
          jump=> jump,
          pcSrc=> pcSrc,
          instruction=> instruction,
          nextInstruction=> nextInstruction);
IDECODE: entity work.IDecode 
 Port map (Clk=> Clk,
           EN=> En,
           instruction=> instruction,
           writeData=> writeData,
           regWrite=> regWrite,
           regDest=> regDest,
           extOp=> extOp,
           rd1=> rd1,
           rd2=> rd2,
           extImm=> extImm,
           func=> func,
           sa=> sa);
UnitControl: entity work.UnitControl
  Port map (Instruction=> instruction (15 downto 13),
            RegDst => regDest,
            ExtOp=> extOp,
            ALUSrc=> ALUSrc,
            Branch=> branch,
            Jump=> jump,
            ALUOp=> ALUOp,
            MemWrite=> MemWrite,
            MemtoReg=> MemtoReg,
            RegWrite=> RegWrite,
            BranchBlt=>BranchBlt );
UnitEX: entity work.UnitEX 
    Port map ( pc=> nextInstruction,
              rd1=> rd1,
              rd2=> rd2,
              extImm => extImm,
              func=> func,
              sa=> sa,
              ALUSrc=> ALUSrc,
              ALUOp=> ALUOp,
              zero=> zero,
              BranchAddress=> BranchAddress,
              ALURes=> ALURes,
              bltFlag=> bltFlag);
MEM: entity work.MEM 
   Port map ( Clk=> Clk,
              EN=> En,
              MemWrite=> MemWrite,
              ALUResIn=> ALURes, 
              rd2=> rd2,
              MemData=> MemData,
              ALUResOut=> ALUResAUX);

 with MemtoReg select
     writedata <= MemData when '1',
      ALUResAUX when '0',
      (others => '0') when others;

PCSrc<= (zero and branch) or (BranchBlt and bltFlag);
jumpAddress <=nextinstruction(15 downto 13) & instruction(12 downto 0); 
pc<=instruction;
ALUResult<=writeData;
 end behavioral;