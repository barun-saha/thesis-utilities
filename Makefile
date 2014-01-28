#
# Makefile for Thesis
#
# This automates the build of the thesis -- as well as, any or all of the 
# individual chapters of the thesis -- from the Tex and image files.
# This can be used in three ways:
#	1) make				# It will create the PDF file for the thesis
#	2) make i			# Will create the PDF file only for the ith chapter;
#						  i is an integer corresponding to the desired chapter
#						  number
#	3) make chapters	# Will create the PDF files for each chapter
#
# For the rule #s 2 and 3, the CHAPTERS list defined below should be updated
# with all the desired chapter numbers.
#
# You may need to execute make 2-3 times in order to reflect the
# correct reference numbers in the output PDF files.
#
# @author: Barun Kumar Saha
# @date: 02 January 2013
# @licence: GNU GPL v3
#

PROJECT     = Thesis
LATEX       = latex
TEX         = pdflatex
BIBTEX      = bibtex
BUILDLATEX  = $(LATEX) $(PROJECT).tex
BUILDTEX    = $(TEX) $(PROJECT).tex
# The following script is used instead of dvips to overcome some problems faced
# while including EPS images generted with GnuPlot
# http://www.sergioller.com/2011-07-07-gnuplot-breaks-LaTeX-pdf-title.md
DVIPS       = ./_fixdvipsgnuplot.sh
DVIPS_CHAPTER = ../_fixdvipsgnuplot.sh
PS2PDF      = ps2pdf

# A custom variable to indicate that only the chapter(s) should be build. This
# variable is to be used in the Tex files for the chapters.
BUILD_CHAPTER = onlychapter
# List of all the chapter numbers in the thesis
CHAPTERS      = 1 2 3 4 5 6


all:
	$(BUILDLATEX)
	$(BIBTEX) $(PROJECT)
	$(BIBTEX) $(PROJECT)
	$(BUILDLATEX)
	#$(DVIPS) -Ppdf -G0 -o $(PROJECT).ps $(PROJECT).dvi
	$(DVIPS) $(PROJECT)
	$(PS2PDF) -dCompatibilityLevel=1.3 $(PROJECT).ps $(PROJECT).pdf


abstract:
	cd ./Abstract && latex "\documentclass[11pt,a4paper]{report} \begin{document} \input{Abstract.tex} \end{document}" && mv report.dvi Abstract.dvi && dvips -Ppdf -G0 -o Abstract.ps Abstract.dvi && $(PS2PDF) -dCompatibilityLevel=1.3 Abstract.ps Abstract.pdf

1 2 3 4 5 6:
	cd ./Chapter$@ && latex "\def\$(BUILD_CHAPTER){} \input{Chapter$@.tex}" && $(BIBTEX) Chapter$@ && $(DVIPS_CHAPTER) Chapter$@ && $(PS2PDF) -dCompatibilityLevel=1.3 Chapter$@.ps Chapter$@.pdf


chapters:
	$(foreach chapter, $(CHAPTERS), echo "Making Chapter "$(chapter); make $(chapter);)


clean-all:
	rm -f *.dvi *.log *.bak *.aux *.bbl *.blg *.idx *.ps *.eps *.pdf *.toc *.out *~


clean:
	rm -f *.log *.bak *.aux *.bbl *.blg *.idx *.toc *.out *~
