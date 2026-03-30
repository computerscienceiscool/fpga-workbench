# Makefile for IceSugar iCE40UP5K blinky project
# Toolchain: yosys + nextpnr-ice40 + icepack (open-source)
# Simulation: iverilog + vvp

PROJ     = blinky
PCF      = icesugar.pcf
DEVICE   = up5k
PACKAGE  = sg48

# iCELink shows up as a USB mass-storage device; find its mount point
ICELINK_DIR = $(shell df 2>/dev/null | grep iCELink | awk '{print $$6}')

# ---- Synthesis & place-and-route ----

all: $(PROJ).bin

$(PROJ).json: $(PROJ).v
	yosys -p "synth_ice40 -top top -json $@" $<

$(PROJ).asc: $(PROJ).json $(PCF)
	nextpnr-ice40 \
		--$(DEVICE) \
		--package $(PACKAGE) \
		--json $< \
		--pcf $(PCF) \
		--asc $@

$(PROJ).bin: $(PROJ).asc
	icepack $< $@

# ---- Programming ----

# Program via iCELink (drag-and-drop style)
prog: $(PROJ).bin
	@if [ -d "$(ICELINK_DIR)" ]; then \
		cp $< "$(ICELINK_DIR)"; \
		echo "Programmed via iCELink at $(ICELINK_DIR)"; \
	else \
		echo "ERROR: iCELink USB drive not found. Is the board plugged in?"; \
		exit 1; \
	fi

# ---- Simulation ----

sim: $(PROJ)_tb.vcd
	@echo "Waveform written to $(PROJ)_tb.vcd"
	@echo "View with: gtkwave $(PROJ)_tb.vcd"

$(PROJ)_tb: $(PROJ).v $(PROJ)_tb.v
	iverilog -o $@ $^

$(PROJ)_tb.vcd: $(PROJ)_tb
	vvp $<

# ---- Utilities ----

# Show resource usage after synthesis
stats: $(PROJ).json
	@echo "--- Resource usage is printed during synthesis above ---"

timing: $(PROJ).asc
	icetime -d $(DEVICE) -mtr $(PROJ).rpt $<
	@cat $(PROJ).rpt

clean:
	rm -f $(PROJ).json $(PROJ).asc $(PROJ).bin
	rm -f $(PROJ)_tb $(PROJ)_tb.vcd
	rm -f $(PROJ).rpt

.PHONY: all prog sim stats timing clean
