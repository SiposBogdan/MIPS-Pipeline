----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2024 14:31:14
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
Port(
instr : in std_logic_vector(31 downto 26);
MemtoReg: out std_logic;
MemWrite: out std_logic;
Jump: out std_logic;
Branch: out std_logic;
Branch_gt: out std_logic;
ALUSrc: out std_logic;
ALUOp: out std_logic_vector(2 downto 0);
RegWrite: out std_logic;
RegDst: out std_logic;
ExtOp: out std_logic
);
end UC;

architecture Behavioral of UC is

begin
    process(instr(31 downto 26))
    begin
    RegDst <= '0';
    ExtOp <= '0';
    ALUSrc <= '0';
    Branch <= '0';
    Jump <= '0';
    MemWrite <= '0';
    MemtoReg <= '0';
    RegWrite <= '0';
    ALUOp <= "000";
    Branch_gt <= '0';
    case instr(31 downto 26) is
        when "000000" => --tip R
            RegDst <= '1';
            RegWrite <= '1';
            ALUSrc <= '0';
            ALUOp <= "001";
            MemWrite <= '0';
            MemtoReg <= '0';
            Branch <= '0';
            Jump <= '0';
        when "001000" => --ADDI
            RegDst <= '0';
            RegWrite <= '1';
            ALUSrc <= '1';
            ExtOp<='1';
            ALUOp <= "010";
            MemWrite <= '0';
            MemtoReg <= '0';
            Branch <= '0';
            Jump <= '0';
        when "100011" => --LW
            RegDst <= '0';
            RegWrite <= '1';
            ALUSrc <= '1';
            ExtOp <= '1';
            ALUOp <= "111";
            MemWrite <= '0';
            MemtoReg <= '1';
            Branch <= '0';
            Jump <= '0';
        when "000100" => --BEQ
            RegWrite <= '0';
            ALUSrc <= '0';
            ExtOp <= '1';
            ALUOp <= "100";
            MemWrite <= '0';
            Branch <= '1';
            Jump <= '0';
        when "000010" => --J
            RegWrite <= '0';
            MemWrite <= '0';
            Jump <= '1';
        when "001100" => --ANDI
            ALUSrc <= '1';
            ExtOp <= '1';
            ALUOp <= "011";
        when "000111" => --BGTZ
            --RegDst <= '1';
            --RegWrite <= '1';
            --ALUSrc <= '1';
            --ExtOp<='1';
            RegWrite <= '0';
            ALUSrc <= '0';
            ExtOp <= '1';
            ALUOp <= "101";
            Branch_gt <= '1';
            Jump <= '0';
            Branch <= '0';
        when others => --SW
            RegDst<='0';--1erA
            RegWrite<='0';
            ALUSrc<='1';
            Branch<='0';
            Jump<='0';
            --MemtoReg<='1';
            MemWrite<='1';
            ALUOp<="111";
            ExtOp<='1';
    end case;
    
    end process;

end Behavioral;
