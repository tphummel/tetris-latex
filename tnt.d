# vim: ft=make
.PHONY: tnt._graphics
tnt.aux tnt.aux.make tnt.d tnt.pdf: $(call path-norm,/usr/local/texlive/2012/texmf-dist/tex/latex/base/book.cls)
tnt.aux tnt.aux.make tnt.d tnt.pdf: $(call path-norm,/usr/local/texlive/2012/texmf-dist/tex/latex/base/makeidx.sty)
tnt.aux tnt.aux.make tnt.d tnt.pdf: $(call path-norm,/usr/local/texlive/2012/texmf-dist/tex/latex/psnfss/mathptmx.sty)
tnt.aux tnt.aux.make tnt.d tnt.pdf: $(call path-norm,copy/preface.tex)
tnt.aux tnt.aux.make tnt.d tnt.pdf: $(call path-norm,tnt.tex)
.SECONDEXPANSION:
