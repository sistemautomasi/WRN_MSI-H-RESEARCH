# Phase 6 MD — Makefile
# Usage:
#   make prep-C727R     — prep single system through equilibration
#   make prod-C727R     — run 100 ns production for single system
#   make analyze-C727R  — post-production analyses
#   make prep-all       — prep all 3 systems
#   make prod-all       — production for all 3 systems (sequential)
#   make analyze-all    — analyses + figures for all 3 systems
#   make report         — produce Phase 6 report markdown
#   make clean-<system> — remove all output files for a system

SHELL := /bin/bash
PHASE6_ROOT := $(shell pwd)
SYSTEMS := C727R_9S18_HRO761 WT_9S18_HRO761 C727A_9S18_HRO761

# --- Individual system rules ---
define SYSTEM_RULES
prep-$(1):
	@echo ">>> [$(1)] prep pipeline"
	cd inputs/$(1) && python3 $(PHASE6_ROOT)/scripts/00_prep_ligand.py --system $(1)
	cd inputs/$(1) && bash $(PHASE6_ROOT)/scripts/01_prep_protein.sh
	cd inputs/$(1) && bash $(PHASE6_ROOT)/scripts/02_build_system.sh
	cd inputs/$(1) && bash $(PHASE6_ROOT)/scripts/03_minimize.sh
	cd inputs/$(1) && bash $(PHASE6_ROOT)/scripts/04_equilibrate.sh
	@echo ">>> [$(1)] prep DONE"

prod-$(1):
	@echo ">>> [$(1)] production 100 ns"
	cd inputs/$(1) && bash $(PHASE6_ROOT)/scripts/05_production.sh
	@echo ">>> [$(1)] production DONE"

analyze-$(1):
	@echo ">>> [$(1)] analyses"
	cd inputs/$(1) && bash $(PHASE6_ROOT)/scripts/06_analyze.sh
	cd inputs/$(1) && bash $(PHASE6_ROOT)/scripts/07_mmpbsa.sh
	@echo ">>> [$(1)] analyses DONE"

check-$(1):
	cd inputs/$(1) && bash $(PHASE6_ROOT)/scripts/check_pipeline.sh

clean-$(1):
	@echo ">>> [$(1)] cleaning outputs"
	cd inputs/$(1) && rm -f *.tpr *.trr *.xtc *.edr *.log *.cpt *.gro.bak \
	    em.* nvt.* npt.* prod.* ions.* index.ndx topol.top ligand_H.* \
	    rmsd_*.xvg rmsf_*.xvg gyrate.xvg hbond_*.xvg dist_*.xvg \
	    contact_residues.ndx mut727_lig.ndx mmpbsa* check.log
	cd inputs/$(1) && rm -rf LIG.acpype
endef

$(foreach sys,$(SYSTEMS),$(eval $(call SYSTEM_RULES,$(sys))))

# --- Aggregate rules ---
prep-all: $(patsubst %,prep-%,$(SYSTEMS))
	@echo ">>> All systems prepped"

prod-all: $(patsubst %,prod-%,$(SYSTEMS))
	@echo ">>> All systems production DONE"

analyze-all: $(patsubst %,analyze-%,$(SYSTEMS))
	@$(MAKE) figures
	@echo ">>> All systems analyzed + figures"

figures:
	python3 scripts/08_make_figures.py \
	    --systems $(SYSTEMS) \
	    --run-root inputs/ \
	    --out-dir figures/

check-all: $(patsubst %,check-%,$(SYSTEMS))
	@echo ">>> All systems checked"

report:
	@echo "Aggregating results into phase6_report.md"
	@echo "# Phase 6 MD Results" > phase6_report.md
	@echo "" >> phase6_report.md
	@for s in $(SYSTEMS); do \
	    echo "## $$s" >> phase6_report.md; \
	    if [ -f inputs/$$s/check.log ]; then \
	        echo "\`\`\`" >> phase6_report.md; \
	        cat inputs/$$s/check.log >> phase6_report.md; \
	        echo "\`\`\`" >> phase6_report.md; \
	    fi; \
	done
	@echo ">>> phase6_report.md written"

clean-all: $(patsubst %,clean-%,$(SYSTEMS))
	rm -rf figures/ phase6_report.md
	@echo ">>> Cleaned all systems"

.PHONY: prep-all prod-all analyze-all check-all figures report clean-all \
        $(patsubst %,prep-%,$(SYSTEMS)) \
        $(patsubst %,prod-%,$(SYSTEMS)) \
        $(patsubst %,analyze-%,$(SYSTEMS)) \
        $(patsubst %,check-%,$(SYSTEMS)) \
        $(patsubst %,clean-%,$(SYSTEMS))
