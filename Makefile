# QUARTUS_PATH should be the root folder of the install
NIOS_SDK := $(QUARTUS_PATH)/nios2eds/sdk2/bin/
NIOS_EDS := $(QUARTUS_PATH)/nios2eds/bin/
NIOS_GCC := $(QUARTUS_PATH)/nios2eds/bin/gnu/H-x86_64-pc-linux-gnu/bin/


generate_hdl: check_quartus_path
	$(QUARTUS_PATH)/quartus/sopc_builder/bin/qsys-generate \
		$(CURDIR)/qsys/system.qsys \
		--block-symbol-file \
		--output-directory=$(CURDIR)/qsys/system \
		--family="Stratix V" \
		--part=5SGSMD5K1F40C1 \

# Ugly hack to avoid regenerating the ip more than once, since it will fail
generate_ip:
	if [ ! -f "$(CURDIR)/ip_variations/fortygig_eth_mac/fortygig_eth_mac.ppf" ]; then \
		$(QUARTUS_PATH)/quartus/bin/mw-regenerate $(CURDIR)/ip_variations/fortygig_eth_mac/fortygig_eth_mac.v; \
	fi

	if [ ! -f "$(CURDIR)/ip_variations/fortygig_eth_pll/fortygig_eth_pll.ppf" ]; then \
	   	$(QUARTUS_PATH)/quartus/bin/mw-regenerate $(CURDIR)/ip_variations/fortygig_eth_pll/fortygig_eth_pll.v; \
	fi


gateware: generate_hdl generate_ip
	$(QUARTUS_PATH)/quartus/bin/quartus_sh --flow compile project/otma_bringup

bsp:
	PATH=$(NIOS_SDK):$$PATH nios2-bsp hal $(CURDIR)/software/otma_bringup_bsp $(CURDIR)/project/system.sopcinfo --cpu-name nios2_gen2_0 --type-version 18.1

firmware: bsp
	cd $(CURDIR)/software/otma_bringup; PATH=$(NIOS_SDK):$(NIOS_EDS):$(NIOS_GCC):$$PATH make all

all: gateware firmware

check_quartus_path:
	@if [ -z "$$QUARTUS_PATH" ]; then \
		echo "QUARTUS_PATH is not set. Please set the QUARTUS_PATH environment variable."; \
		exit 1; \
	fi
