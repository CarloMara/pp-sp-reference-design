# QUARTUS_PATH should be the root folder of the install


generate_hdl: check_quartus_path
	$(QUARTUS_PATH)/quartus/sopc_builder/bin/qsys-generate \
		$(CURDIR)/qsys/system.qsys \
		--block-symbol-file \
		--output-directory=$(CURDIR)/qsys/system \
		--family="Stratix V" \
		--part=5SGSMD5K1F40C1 \


check_quartus_path:
	@if [ -z "$$QUARTUS_PATH" ]; then \
		echo "QUARTUS_PATH is not set. Please set the QUARTUS_PATH environment variable."; \
		exit 1; \
	fi
