library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
 
entity ram is
  generic (
    A_WIDTH    : integer := 4;
    MEM_DEPTH  : integer := 16;
    D_WIDTH    : integer := 40
  );
  port (
    i_wclk      : in  std_logic;
    i_we        : in  std_logic;
    i_waddr     : in  std_logic_vector(A_WIDTH-1 downto 0);
    i_wdata     : in  std_logic_vector(D_WIDTH-1 downto 0);
    i_rclk      : in  std_logic;
    i_raddr     : in  std_logic_vector(A_WIDTH-1 downto 0);
    o_rdata     : out std_logic_vector(D_WIDTH-1 downto 0)
  );
end ram;

architecture rtl of ram is
  type   array_of_slv is array (0 to MEM_DEPTH-1) of std_logic_vector(D_WIDTH-1 downto 0);
  signal ram_array       : array_of_slv;
 
  attribute syn_ramstyle : string;
  attribute syn_ramstyle of ram_array : signal is "low_power";
 
begin
 
  process (i_wclk)
  begin
    if rising_edge(i_wclk) then
      if i_we then
        ram_array(to_integer(unsigned(i_waddr))) <= i_wdata;
      end if;
    end if;
  end process;
 
  process (i_rclk)
  begin
    if rising_edge(i_rclk) then
      o_rdata <= ram_array(to_integer(unsigned(i_raddr)));
    end if;
  end process;
 
end rtl;

