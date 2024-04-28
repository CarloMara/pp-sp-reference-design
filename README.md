# Bring-up project for Stratix V on OTMA board

Makefile with few targets:
1. `make gateware` generate IPs, make Verilog from qsys and buils the bitstream,
2. `make firmware` build sw image for nios,
3. `make flash` flash gateware, this might break beacuse .cdf files can't be generated automatically but only via gui. If the .sof file changes name it will fail,
4. `make flash_fw` flash nios image, 
5. `make nios_console` drops into NIOS serial console via JTAG.


This replaces a series of script and manual steps that were here before.
