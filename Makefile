# QUARTUS_PATH should be the root folder of the install

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


build: generate_hdl generate_ip
	$(QUARTUS_PATH)/quartus/bin/quartus_sh --flow compile project/otma_bringup

check_quartus_path:
	@if [ -z "$$QUARTUS_PATH" ]; then \
		echo "QUARTUS_PATH is not set. Please set the QUARTUS_PATH environment variable."; \
		exit 1; \
	fi
