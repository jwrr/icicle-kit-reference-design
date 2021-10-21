# PolarFire&reg; SoC Icicle Kit Reference Design Generation Tcl Scripts - Libero&reg; SoC v2021.2

## Description

This repository can be used to generate a reference design for the PolarFire SoC Icicle Kit. This reference design will have the same or extended functionality compared to the pre-programmed FPGA design on the Icicle Kit.

A Libero SoC Tcl script is provided to generate the reference design using Libero SoC along with device specific I/O constraints. For Tcl scripts supporting previous versions of Libero SoC see [Releases](https://github.com/polarfire-soc/icicle-kit-reference-design/releases).

This repository supports Libero SoC v2021.2, which is available for download [here](https://www.microsemi.com/product-directory/design-resources/1750-libero-soc#downloads).

## Using the reference design generation Tcl script

#### Standard design generation

To generate the standard reference design which is capable of running the majority of bare metal example applications and run Linux&reg; the following flow can be used:

1. Clone or download the repository
2. Open Libero v2021.2
3. Open the execute script dialog (CTRL + U)
4. Execute the "MPFS_ICICLE_KIT_REFERENCE_DESIGN.tcl" script
5. Configure the design if required
6. Run the Libero SoC design flow to program a device

#### Argument based design generation

Some bare metal examples and tutorials require a specific fabric configuration which cannot be achieved in the standard base design, for example to test I2C loopback the MSS must be reconfigured to route I2C1 to the fabric and bi directional buffers then need to be instantiated along with additional constraints. These configurations are achieved by passing an argument to Libero when generating the design. Arguments will generate a standard base design and apply design changes on top of that configuration. Supported arguments are:

| Argument | Description |
|---|---|
| I2C_LOOPBACK | Routes I2C0 and I2C1 to the fabric and connects them to bibufs routed to Raspberry Pi® I/Os. <br>Associates I2C loopback constraints for I/O. <br>This design can be used with the I2C loopback bare metal example project and will still boot Linux but the PAC1934 will be inaccessible. <br>I2C0_SCL is routed to pin 29 and I2C1_SCL is routed to pin 31 of the Raspberry Pi I/O header. <br>I2C0_SDA is routed to pin 35 and I2C1_SDA is routed to pin 37 of the Raspberry Pi I/O header. <br>Connecting / closing pins 29 and 31 and pins 35 and 37 of the Raspberry Pi I/O header will achieve I2C loopback. |
| SPI_LOOPBACK | Disables QSPI and enables SPI1 which is connected to MSS I/Os bank 2 and directly to the mikroBUS header. <br>Associates SPI loopback constraints for I/O.<br>SPI_0 MOSI is routed to RPi I/O pin 19 and SPI_1 MOSI is routed to mikroBUS pin 6.<br>SPI_0 MISO is routed to RPi I/O pin 21 and SPI_1 MISO is routed to mikroBUS pin 5.<br>SPI_0 SCLK is routed to RPi I/O pin 23 and SPI_1 MISO is routed to mikroBUS pin 4.<br>SPI_0 CE is routed to RPi I/O pin 24 and SPI_1 CE is routed to mikroBUS pin 3.<br>Using this configuration SPI0 and SPI1 can be connected for loop back. |
| BFM_SIMULATION | Generates a smart design test bench based on the reference design and imports custom BFM scripts to generate transactions on MSS FICs. <br>A custom DO file is also imported to add waves and run the simulation |

Arguments in the table above can only be used exclusively - i.e you cannot pass "I2C_LOOPBACK" and "BFM_SIMULATION" as arguments.

Additional arguments are also supported to modify or configure aspects of the design flow that will be run. Supported arguments are:

| Argument | Description |
|---|---|
| HSS_UPDATE | Downloads the HSS release hex file associated with this release of the reference design. <br>The hex file is added as an eNVM client in Libero. <br>This argument requires wget to be installed. <br>This is installed by default on most Linux systems, on Windows® wget should be installed and added to the system path, steps are shown in the following [guide](https://www.addictivetips.com/windows-tips/install-and-use-wget-in-windows-10/) |
| SYNTHESIZE | Runs the synthesis step after design generation has completed |
| PLACEROUTE | Runs the synthesis and place and route steps after design generation has completed |
| VERIFY_TIMING | Runs the synthesis, place and route and timing verification steps after design generation has completed |
| GENERATE_PROGRAMMING_DATA | Generates the files required to generate a bitstream for programming a device |
| PROGRAM | Runs the full design flow after generating a design and programs a connected device. <br>Note: the device must be connected when the "Run PROGRAM Action" stage of the design flow is reached and only one device should be connected |
| EXPORT_FPE | Runs the full design flow after generating a design and exports a FlashPro Express file to the local directory |
| EXPORT_FPE:PATH | Runs the full design flow after generating a design and exports a FlashPro Express file to a specified path e.g EXPORT_FPE:/home/user/jobs/ |

**Note:** The arguments listed in the table above can be used with other arguments - i.e you can pass "I2C_LOOPBACK", "HSS_UPDATE" and "PROGRAM" as arguments.

The design flow for using arguments is the same as the standard flow, ensuring the argument is passed at script execution time:

1. Clone or download the repository
2. Open Libero v2021.2
3. Open the execute script dialog (CTRL + U)
4. Execute the "MPFS_ICICLE_KIT_REFERENCE_DESIGN.tcl" script
6. Add any required arguments (e.g "I2C_LOOPBACK HSS_UPDATE PROGRAM")

**Note:** arguments should not be put in quotes and are separated by a space when using the GUI.

7. Configure the design if required
8. Run the Libero SoC design flow to program a device

#### Generating designs from the command line - no GUI

Libero has support to run Tcl scripts without launching a GUI, this can significantly reduce design generation time. Arguments can also be passed when generating from the command line.

To generate a design from the command line:

1. Clone or download the repository
2. Open a terminal in the directory containing the design generation scripts
3. Execute the command (example arguments shown):
[path to Libero]/libero script:MPFS_ICICLE_KIT_REFERENCE_DESIGN.tcl SCRIPT_ARGS:I2C_LOOPBACK+HSS_UPDATE+PROGRAM logfile: MPFS_ICICLE_KIT_REFERENCE_DESIGN.log

**Note:** Arguments are separated by a "+" symbol when using the command line.

**Note:** The script will automatically generate an MSS component, using the PolarFire SoC MSS Configurator in batch mode, then, generate, instantiate and connect components and top level I/Os. Constraints are imported for top level I/O and floor planning which associated with Place and Route. Timing constraints are then generated and associated with Synthesis, Place and Route and Timing Verification. Some arguments may require part of the design flow to be run while executing the script.

## Design description

### Block diagrams

The diagram below outlines the top level configuration of the FPGA fabric and shows MSS I/Os used in this design:

![Block diagram](./block_diagram.svg)

The diagram below shows the Inter Hart Communication (IHC) subsystem configuration used in the reference design:

![IHC subsystem block diagram](./IHC_SUBSYSTEM_block_diagram.svg)

### MSS peripherals
The following MSS peripherals are enabled:

| MSS Peripheral|Route to Device I/O| Board peripheral | Board Interface                     | Notes                                                        |
|---------------|-------------------|------------------|-------------------------------------|--------------------------------------------------------------|
| eMMC          | MSS I/Os BANK 4   | eMMC device      | N/A                                 |See<br> "eMMC and SD card switching"                          |
| USB           | MSS I/Os BANK 2   | USB OTG Phy      | J16 (Micro USB)                     |                                                              |
| SD/SDIO       | MSS I/Os BANK 4   | SD card socket   | N/A                                 |See<br> "eMMC and SD card switching"                          |
| GEM0          | SGMII I/Os BANK 5 | VSC8662 PHY Port0| J1 (RJ45 connector)                 |                                                              |
| GEM1          | SGMII I/Os BANK 5 | VSC8662 PHY Port1| J2 (RJ45 connector)                 |Management through<br> MSS I/Os BANK 2 B                      |
| QSPI          | Fabric / MSS I/Os | N/A              | J8/J44 (mikroBUS&trade; socket)     |DATA I/Os [3:2] to fabric.<br> Remaining signals <br>to MSS I/Os Bank 2|
| SPI0          | Fabric            | N/A              | J26 (Raspberry Pi connector)        |                                                              |
| MMUART0       | Fabric            | USB-UART PHY     | J11 (Micro USB)                     |                                                              |
| MMUART1       | Fabric            | USB-UART PHY     | J11 (Micro USB)                     |                                                              |
| MMUART2       | Fabric            | USB-UART PHY     | J11 (Micro USB)                     |                                                              |
| MMUART3       | Fabric            | USB-UART PHY     | J11 (Micro USB)                     |                                                              |
| MMUART4       | Fabric            | N/A              | J8/J44 (mikroBUS socket)            |                                                              |
| I2C0          | Fabric            | N/A              | J8/J44 (mikroBUS socket)            |                                                              |
| I2C1          | MSS I/Os BANK 2 B | PAC1934 sensor   | N/A                                 |                                                              |
| CAN0          | Fabric            | N/A              | J27 (Jumper)                        |                                                              |
| CAN1          | MSS I/Os BANK 2 B | N/A              | J25 (Jumper)                        |                                                              |
| GPIO2         | Fabric            | LEDs and Switches| N/A                                 |See block diagram for<br> enabled GPIOs                       |

**Note:** “Raspberry Pi is a trademark of the Raspberry Pi Foundation”.

### Memory map

| Initiator                 | Bus                        | Target                    | Address range                     |
|-------------------------  |--------------------------  |-------------------------  |-------------------------------    |
| MSS: FIC0                 | AXI4_mslave0               | PF_PCIE_C0_0              | 0x20_0000_0000 -> 0x2F_FFFF_FFFF  |
| MSS: FIC0                 | AXI4_mslave1               | MSS_LSRAM                 | 0x6100_0000 -> 0x6100_1000        |
| MSS: FIC0                 | AXI4_mslave2               | DMA_CONTROLLER            | 0x6002_0000 -> 0x6002_FFFF        |
| MSS: FIC3                 | APBmslave1                 | PWM                       | 0x4100_0000 -> 0x41FF_FFFF        |
| MSS: FIC3                 | APBmslave2                 | CoreGPIO                  | 0x4200_0000 -> 0x42FF_FFFF        |
| MSS: FIC3                 | APBmslave16                | RECONFIGURATION_INTERFACE | 0x4300_0000 -> 0x43FF_FFFF        |
| MSS: FIC3                 | APBmslave16                | RECONFIGURATION_INTERFACE | 0x4800_0000 -> 0x48FF_FFFF        |
| MSS: FIC3                 | APBmslave15                | SDIO_register             | 0x4F00_0000 -> 0x4FFF_FFFF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_E51_TO_U54_1:A    | 0x5000_0000 -> 0x5000_00FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_E51_TO_U54_2:A    | 0x5000_0100 -> 0x5000_01FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_E51_TO_U54_3:A    | 0x5000_0200 -> 0x5000_02FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_E51_TO_U54_4:A    | 0x5000_0300 -> 0x5000_03FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | E51_IRQ_AGGREGATOR        | 0x5000_0400 -> 0x5000_04FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_E51_TO_U54_1:B    | 0x5000_0500 -> 0x5000_05FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_1_TO_U54_2:A  | 0x5000_0600 -> 0x5000_06FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_1_TO_U54_3:A  | 0x5000_0700 -> 0x5000_07FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_1_TO_U54_4:A  | 0x5000_0800 -> 0x5000_08FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | U54_1_IRQ_AGGREGATOR      | 0x5000_0900 -> 0x5000_09FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_E51_TO_U54_2:B    | 0x5000_0A00 -> 0x5000_0AFF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_1_TO_U54_2:B  | 0x5000_0B00 -> 0x5000_0BFF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_2_TO_U54_3:A  | 0x5000_0C00 -> 0x5000_0CFF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_2_TO_U54_4:A  | 0x5000_0D00 -> 0x5000_0DFF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | U54_2_IRQ_AGGREGATOR      | 0x5000_0E00 -> 0x5000_0EFF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_E51_TO_U54_3:B    | 0x5000_0F00 -> 0x5000_0FFF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_1_TO_U54_3:B  | 0x5000_1000 -> 0x5000_10FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_2_TO_U54_3:B  | 0x5000_1100 -> 0x5000_11FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_3_TO_U54_4:A  | 0x5000_1200 -> 0x5000_12FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | U54_3_IRQ_AGGREGATOR      | 0x5000_1300 -> 0x5000_13FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_E51_TO_U54_4:B    | 0x5000_1400 -> 0x5000_14FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_1_TO_U54_4:B  | 0x5000_1500 -> 0x5000_15FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_2_TO_U54_4:B  | 0x5000_1600 -> 0x5000_16FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | CHANNEL_U54_3_TO_U54_4:B  | 0x5000_1700 -> 0x5000_17FF        |
| MSS: FIC3                 | IHC_SUBSYSTEM: APB3mmaster | U54_4_IRQ_AGGREGATOR      | 0x5000_1800 -> 0x5000_18FF        |
| PF_PCIE_C0_0              | AXI4_mslave0               | MSS: FIC0                 | 0x6000_0000 -> 0xBFFF_FFFF        |
| PF_PCIE_C0_0              | AXI4_mslave1               | PCIE_LSRAM                | 0x0 -> 0xFFF                      |
| DMA_CONTROLLER            | AXI4_mslave0               | MSS: FIC1                 | 0xC000_0000 -> 0xCFFF_FFFF        |

### Interrupt map

| Source                    | IRQ                    |
|-----------------------    |--------------------    |
| MSS_GPIO_2_28 \| SW1      | MSS_INT_FTM[0]         |
| PF_PCIE                   | MSS_INT_FTM[1]         |
| DMA_CONTROLLER             | MSS_INT_FTM[2]         |
| IHC_SUBSYSTEM:E51_IRQ      | MSS_INT_FTM[63]     |
| IHC_SUBSYSTEM:U54_1_IRQ    | MSS_INT_FTM[62]     |
| IHC_SUBSYSTEM:U54_2_IRQ    | MSS_INT_FTM[61]     |
| IHC_SUBSYSTEM:U54_3_IRQ    | MSS_INT_FTM[60]     |
| IHC_SUBSYSTEM:U54_4_IRQ    | MSS_INT_FTM[59]     |
| MSS_GPIO_2_26 \| SW2      | MSS_GPIO_2_INT[30]     |
| MSS_GPIO_2_27 \| SW3      | MSS_GPIO_2_INT[31]     |

## Programming the FPGA

Once the script has completed the design can be configured further if needed and the Libero SoC design flow can be run by double clicking on a stage in the design flow on the left hand side of Libero. Selecting an option requiring previous steps to be completed will run the full flow, i.e double clicking "Run Program Action" will run any required steps, such as, "Synthesize", "Place and Route", etc and then program the device.

## Board configuration

For Icicle Kit jumper configurations used by this design and Linux images for eMMC and SD Cards see: [Updating PolarFire SoC Icicle-Kit FPGA Design and Linux Image](https://github.com/polarfire-soc/polarfire-soc-documentation/blob/master/boards/mpfs-icicle-kit-es/updating-icicle-kit/updating-icicle-kit-design-and-linux.md).

## MSS Configuration

The Microprocessor Subsystem (MSS) is configured using the PolarFire SoC MSS Configurator.
This software tool takes user inputs and generates an MSS configuration file (.xml) along with an MSS component file (.cxz).
The XML file is used by the PolarFire SoC Configuration Generator to generate configuration header files for bare metal applications.
The MSS component file can be imported into a Libero SoC design and used in the FPGA design flow.

A saved configuration for the PolarFire SoC MSS Configurator is available in the "script_support" folder and can be opened by the PolarFire SoC MSS Configurator. These configurations will match the MSS configuration used in the design and can be used to regenerate XML and a Libero component. For argument based designs, MSS configuration files will be generated in the script_support/additional_configurations/[configuration name] directory when a design is generated.

## XML

The Microcontroller Subsystem (MSS) configuration is captured in an XML file that is then used by the PolarFire SoC Configuration Generator to generate configuration header files. These header files are compiled as part of the MPFS HAL startup code to configure the system at power on.

XML generated for all available configurations is provided in the "XML" folder.

## BFM Simulation

A SmartDesign test bench can be generated along with the SmartDesign containing the reference design by passing the "BFM_SIMULATION" argument when generating the design. This test bench will allow the user to run BFM simulations of the PolarFire SoC MSS. A custom wave.do file is imported to add signals and updated BFM scripts are also imported. To run a BFM simulation:
1. Open the "Stimulus Hierarchy" in Libero SoC
2. Right click on "Test_bench" from the hierarchy
3. Select "Simulate Pre-Synth Design" and "Open Interactively"

Commands for BFM simulations can be updated by editing the ".vec" files in the Simulation folder which is accessible under the "Files" tab of Libero SoC.

## Setting the boot mode and programming the eNVM

### Boot mode 0

Boot mode 0 will put all of the MSS cores into WFI (Wait For Interrupt) mode on power on, the cores will not boot until debugged. SoftConsole v6.5 or later can be used to set the PolarFire SoC boot mode to 0:
1. Connect the board to the PC using the embedded FlashPro6 or an external FlashPro and power on the board
2. In SoftConsole select the "External Tool" drop down menu
3. Select the "PolarFire SoC idle boot mode 0" configuration and run

### Boot mode 1

Boot mode 1 configures all of the MSS cores to boot from the eNVM, when setting the boot mode to 1 an eNVM client must also be provided An eNVM client can be a zero stage boot loader, such as the HSS, or a bare metal application. SoftConsole v6.4 and above or Libero SoC v12.6 and above can be used to set the boot mode and program the eNVM.

Build the bare metal application using the reference XML provided to configure the MPFS HAL (XML will also be generated in the script_support/components/[target] folder when an MSS component is generated as part of the flow).

#### Boot mode 1: SoftConsole

To set the PolarFire SoC boot mode to 1 and program an eNVM client in SoftConsole:
1. Select the project folder of the application to be used as an eNVM client in the project explorer
2. Connect the board to the PC using the embedded FlashPro6 or an external FlashPro and power on the board
3. In SoftConsole select the "External Tool" drop down menu
4. Select the "PolarFire SoC non-secure boot mode 1" configuration and run

#### Boot mode 1: Libero SoC

To set the PolarFire SoC boot mode to 1 and program and eNVM client in Libero:
1. Run the Libero SoC design flow so that "Generate FPGA Array Data" has completed and open the "Configure Design Initialization Data and Memories" tool
2. Select the "eNVM" tab
3. Select the "Add ..." option and select "Add Boot Mode 1" client
4. Navigate to the binary file to be used as a client and select ok
5. Save and add the client
6. Run the remainder of the Libero SoC design flow and program the device

Linux® is the registered trademark of Linus Torvalds in the U.S. and other countries.
Raspberry Pi is a trademark of the Raspberry Pi Foundation.
All other trademarks are the property of their respective owners.
