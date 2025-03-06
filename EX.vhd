----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.04.2024 18:28:40
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
port(RD1: in std_logic_vector(31 downto 0);
    ALUSrc: in std_logic;
    RD2: in  std_logic_vector(31 downto 0);
    Ext_Imm: in std_logic_vector(31 downto 0);
    sa: in std_logic_vector(4 downto 0);
    func: in std_logic_vector(5 downto 0);
    ALUOp: in std_logic_vector(2 downto 0);
    PCplusPatru: in std_logic_vector(31 downto 0);
    RT: in std_logic_vector(4 downto 0);
    RD: in std_logic_vector(4 downto 0);
    regdst: in std_logic;
    rwa: out std_logic_vector(4 downto 0);
    Zero: out std_logic;
    NotZero: out std_logic;
    ALURes: out std_logic_vector(31 downto 0);
    BranchAddress: out std_logic_vector(31 downto 0)
);
end EX;

architecture Behavioral of EX is
signal ALUCtrl: std_logic_vector(3 downto 0):=(others=>'0');
signal mux: std_logic_vector(31 downto 0):=(others => '0');
signal C: std_logic_vector(31 downto 0):=(others=>'0');
signal numar_zero : std_logic_vector(2downto 0):=(others=>'0');
begin

process(regdst)
begin
    if regdst = '1' then
        rwa <= rd;
        else rwa <= rt;
    end if;

end process;




ALUCONTROL:process(ALUOp, func)--ALU control
begin
    case ALUOp is
    when "001" =>
        case func is
            when "100000" => ALUCtrl <= "0000";--add
            when "100010" => ALUCtrl <= "0001";--minus
            when "000000" => ALUCtrl <= "0010";--ssl
            when "000010" => ALUCtrl <= "0011";--ssr
            when "100100" => ALUCtrl <= "0100";--and
            when "100101" => ALUCtrl <= "0101";--or
            when "100110" => ALUCtrl <= "0110";--xor
            when others => ALUCtrl <= "0111";--sra
        end case;
    when "010" => ALUCtrl <= "0000"; 
    when "011" => ALUCtrl <= "1001";--andi
    when "100" => ALUCtrl <= "0001";--beq
    when "101" => ALUCtrl <= "1010"; --bgtz
    when others => ALUCtrl <= "1000";--lw sw -1000
    end case;
end process;

BranchAddress <= PCplusPatru + (Ext_Imm(29 downto 0) & "00");

process(ALUSrc)
begin
    if(ALUSrc = '1') then
        mux <= Ext_Imm;
    else
        mux <= RD2;
    end if;
end process;



process(ALUCtrl)
begin
    case ALUCtrl is
    when "0000" => C <= RD1 + mux;
    when "0001" => C <= RD1 - mux;
    when "0010" => C <= to_stdlogicvector(to_bitvector(mux) sll conv_integer(sa));--ssl
    when "0011" => C <= to_stdlogicvector(to_bitvector(mux) srl conv_integer(sa));--slr
    when "0100" => C <= RD1 and mux;
    when "0101" => C <= RD1 or mux;
    when "0110" => C <= RD1 xor mux;
    when "0111" => C <= to_stdlogicvector(to_bitvector(mux) sra conv_integer(sa));--sra
    when "1000" => C <= RD1 + mux; --LW SW
    when "1010" => if signed(RD1) < signed(mux) then
                    C <= X"00000000";
                    else
                    C <= X"00000001";
                    end if;
    when others => C <= RD1 and mux; --ANDI
    --when "1001" => C <= RD1 and mux; --ANDI
--    when "1010" =>  if(signed(RD1) = signed(mux)) then
--                           C <= X"00000001";
--                     else
--                        C <= X"00000000";
--                     end if; 
--    when others => if(signed(RD1) > signed(numar_zero)) then
--                        C <= X"00000001";
--                    else
--                        C <= X"00000000";
--                    end if;
    
    end case;
  
end process;

process(C)
    begin
    if(C = X"00000000") then
        zero <= '1';
        NotZero <= '0';
    else
        zero <= '0';
        NotZero <= '1';
    end if;
end process;

ALURes <= C;

end Behavioral;
