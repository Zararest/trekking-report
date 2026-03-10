# Makefile for tour-report-project
# default target
.PHONY: all pdf xelatex clean distclean placeholders

LATEXMK := $(shell command -v latexmk 2> /dev/null)
PDFLATEX := pdflatex
XELATEX := xelatex
MAIN := main.tex
OUT := main.pdf

all: pdf

# Use latexmk if present (recommended)
pdf:
ifeq ($(LATEXMK),)
	@echo "latexmk not found — falling back to pdflatex (3 runs)"
	$(PDFLATEX) -interaction=nonstopmode -file-line-error $(MAIN)
	$(PDFLATEX) -interaction=nonstopmode -file-line-error $(MAIN)
	$(PDFLATEX) -interaction=nonstopmode -file-line-error $(MAIN)
else
	latexmk -pdf -pdflatex="$(PDFLATEX) -interaction=nonstopmode -file-line-error" $(MAIN)
endif

# Compile with xelatex (for fontspec / system fonts)
xelatex:
ifeq ($(LATEXMK),)
	$(XELATEX) -interaction=nonstopmode -file-line-error $(MAIN)
	$(XELATEX) -interaction=nonstopmode -file-line-error $(MAIN)
else
	latexmk -pdf -pdflatex="$(XELATEX) -interaction=nonstopmode -file-line-error" -pdfxe $(MAIN)
endif

clean:
	latexmk -c || (rm -f *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk)

distclean: clean
	-rm -f $(OUT)

# optional: create simple placeholder images (requires ImageMagick 'convert')
# run: make placeholders
placeholders:
	@if command -v convert >/dev/null 2>&1; then \
	  mkdir -p figures; \
	  convert -size 1200x800 xc:lightgray -gravity center -pointsize 36 -annotate 0 "plan_route.png (placeholder)" figures/plan_route.png; \
	  convert -size 1200x800 xc:lightgray -gravity center -pointsize 36 -annotate 0 "actual_route.png (placeholder)" figures/actual_route.png; \
	  convert -size 1200x800 xc:lightgray -gravity center -pointsize 36 -annotate 0 "plan_map_large.png (placeholder)" figures/plan_map_large.png; \
	  convert -size 1200x400 xc:lightgray -gravity center -pointsize 36 -annotate 0 "height_profile.png (placeholder)" figures/height_profile.png; \
	else \
	  echo "ImageMagick 'convert' not found — cannot create placeholders."; \
	fi