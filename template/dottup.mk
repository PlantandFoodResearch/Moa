# 
# Copyright 2009 Mark Fiers, Plant & Food Research
# 
# This file is part of Moa - http://github.com/mfiers/Moa
# 
# Moa is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your
# option) any later version.
# 
# Moa is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
# License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Moa.  If not, see <http://www.gnu.org/licenses/>.
# 
moa_ids += dottup
moa_title_dottup = EMBOSS Dottup
moa_description_dottup = Use dottup (from EMBOSS) to compare two sets			\
of sequences

#targets
dottup_help = Run dottup

#variables
moa_must_define += dottup_input_dir_a
dottup_input_dir_a_help = This set is compared to the sequences in input_dir_b.
dottup_input_dir_a_type = directory

moa_must_define += dottup_input_dir_b
dottup_input_dir_b_help = The set to compare against
dottup_input_dir_b_type = directory


moa_may_define += dottup_input_extension
dottup_input_extension_default = fasta
dottup_input_extension_help = Extension of the dottup input files
dottup_input_extension_type = string

moa_may_define += dottup_wordsize
dottup_wordsize_default = 8
dottup_wordsize_help = Wordsize used to discover similarities between sequences
dottup_wordsize_type = integer


include $(shell echo $$MOABASE)/template/moaBase.mk


ix = $(dottup_input_extension)
dottup_input_files_a = $(addprefix a__,\
	$(wildcard $(dottup_input_dir_a)/*.$(dottup_input_extension)))
dottup_input_files_b = \
	$(wildcard $(dottup_input_dir_b)/*.$(dottup_input_extension))

.PHONY: dottup_prepare
dottup_prepare:

.PHONY: dottup_post
dottup_post: 

.PHONY: dottup
dottup: $(dottup_input_files_a)

$(dottup_input_files_a): a__%: $(dottup_input_files_b)
	@for to in $?; do \
		if [ "$*" == "$$to" ]; then \
			continue ;\
		fi ;\
		$(call echo, running dottup for $* against $$to) ;\
		prefix=`basename $* .$(ix)`__`basename $$to .$(ix)` ;\
		dottup -asequence $* -bsequence $$to -wordsize $(dottup_wordsize) \
			-graph png -goutfile $$prefix \
			-gtitle "$$prefix" ;\
	done 

clean: dottup_clean

dottup_clean:
	rm -f *.png *.pdf *.ps