library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
 
entity apb_ram is
  generic (
    A_WIDTH      : integer := 32;
    D_WIDTH      : integer := 32;
    DEPTH        : integer := 512;
    MADDR_WIDTH  : integer := 9
  );
  port (
    pclk            : in  std_logic;
    presetn         : in  std_logic;
    pwrite          : in  std_logic; -- Input valid signal from apb to write to serialized data
    psel            : in  std_logic; -- Input signal from apb to select spi to write and read data
    penable         : in  std_logic; -- Input valid signal from apb to enable write to serialized data
    paddr           : in  std_logic_vector(A_WIDTH-1 downto 0); -- input address to use to determine register to acess
    pwdata          : in  std_logic_vector(D_WIDTH-1 downto 0); -- Input data bus to be serialized from apb
    pready          : out std_logic;   --Valid signal from apb to write and read data, is always high
    prdata          : out std_logic_vector(D_WIDTH-1 downto 0); --output data bus in serial going to dac or adc
    perr            : out std_logic
  );

end apb_ram;
 
architecture rtl of apb_ram is
  signal addr_err   : std_logic;
  signal mem_addr   : std_logic_vector(MADDR_WIDTH-1 downto 0);
  signal word_addr  : std_logic_vector(MADDR_WIDTH-1 downto 0);
  signal mem_write  : std_logic;
begin
  pready <= '1';
  perr   <= '0';
  word_addr <= paddr(MADDR_WIDTH+1 downto 2);
  addr_err  <= '0' when unsigned(word_addr) <= DEPTH-1 else '1';
  mem_addr  <= (others => '0') when addr_err else word_addr;
  mem_write <= pwrite and psel and penable and not addr_err;

  u_ram: entity work.ram
  generic map(
    A_WIDTH     => MADDR_WIDTH,  -- integer := 4;
    D_WIDTH     => D_WIDTH,      -- integer := 32
    MEM_DEPTH   => DEPTH         -- integer := 16;
  )
    port map (
    i_wclk      => pclk      , -- in  std_logic;
    i_we        => mem_write , -- in  std_logic;
    i_waddr     => mem_addr  , -- in  std_logic_vector(A_WIDTH-1 downto 0);
    i_wdata     => pwdata    , -- in  std_logic_vector(D_WIDTH-1 downto 0);

    i_rclk      => pclk      , -- in  std_logic;
    i_raddr     => mem_addr  , -- in  std_logic_vector(A_WIDTH-1 downto 0);
    o_rdata     => prdata      -- out std_logic_vector(D_WIDTH-1 downto 0)
  );

end rtl;

