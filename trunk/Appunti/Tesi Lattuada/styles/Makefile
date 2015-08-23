THESISDIR=$(PWD)
PAPERSIZE = a4
VERSIONDATE = `date +%m%d.%k%M`
TARNAME = thesis--$(VERSIONDATE)
OUTPUTDIR = output

TEX2DVIFLAGS = -II styles -II figures -II code -I styles -I figures -I code --verbose
TEX2PDFFLAGS = $(TEX2DVIFLAGS)

TEX2DVI = pool_size=700000 sh styles/tex_compile --etex
TEX2PDF = $(TEX2DVI) --pdf
DVIPS = dvips
PS2PDF= ps2pdf
EPSTOPDF = epstopdf

TEX2DVIFLAGS = -II styles -II figures -II code -I styles -I figures -I code --verbose
TEX2PDFFLAGS = $(TEX2DVIFLAGS)
DVIPSFLAGS =  -Pcmz -t$(PAPERSIZE)
PS2PDFFLAGS =

TEXINPUTS = ./figures

CODE = code/interesting_channel_code.cc \
	code/interesting_consumer_code.cc \
	code/interesting_producer_code.cc
CODEEPS = $(patsubst %, %.eps, $(CODE))
CODEPDF = $(patsubst %, %.pdf, $(CODE))

INPUTS = thesis.tex

all: pdf_no_pdftex
#dvi
#ps
#pdf

thesis.dvi: thesis.tex ack.tex ch_ir.tex ch_casestudy.tex \
	thesis.bib styles/thesis.cls $(CODEEPS) figures/*.eps

thesis.pdf: thesis.tex ack.tex ch_ir.tex ch_casestudy.tex \
	thesis.bib styles/thesis.cls $(CODEPDF) figures/*.pdf

DVIFILES = $(patsubst %.tex, %.dvi, $(INPUTS))
PSFILES = $(patsubst %.tex, %.ps, $(INPUTS))
PDFFILES = $(patsubst %.tex, %.pdf, $(INPUTS))
PDFFILES_NO_PDFTEX = $(PDFFILES)

pdf: $(PDFFILES)
pdf_no_pdftex: $(PDFFILES_NO_PDFTEX)
ps: $(PSFILES)
dvi: $(DVIFILES)

code/%.eps: code/%
	enscript --media=A4 --language=PostScript --pretty-print=cpp --no-header -o $<.ps $<
	ps2epsi $<.ps $@
	rm $<.ps

%.dvi: %.tex
	$(TEX2DVI) $(TEX2DVIFLAGS) $<
	mv $@ $(OUTPUTDIR)/$@

%.ps: %.dvi
	$(DVIPS) $(OUTPUTDIR)/$< -o$(OUTPUTDIR)/$@

$(PDFFILES): %.pdf: %.tex
	$(TEX2PDF) $(TEX2PDFFLAGS) $<

%.pdf: %.ps
	$(EPSTOPDF) --filter < $< > $@

%.pdf: %.eps
	$(EPSTOPDF) --filter < $< > $@

$(PDFFILES_NO_PDFTEX): %.pdf: %.ps
	$(PS2PDF) $< $@

mostlyclean:
	-rm -rf tex_compile_tmp *.toc *.aux *.log *.out

clean: mostlyclean
	-rm -f *.pdf *.ps *.dvi *.*pk *.tfm *.stamp

hardclean: 
	-rm -f `ls -1F | egrep -v '.*(\.tex|\.sty|\.bib|\.cls|Makefile|/)'` *~ \#*\#

outputclean :	
	-rm -f $(OUTPUTDIR)/*

tar:
	-tar cvfz $(TARNAME).tar.gz --exclude $(TARNAME).tar.gz --exclude *gz $(THESISDIR)

.PHONY: clean mostlyclean hardclean all dvi ps pdf_no_latex
