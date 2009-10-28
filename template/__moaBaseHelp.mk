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

MOA_INCLUDE_HELP = yup

################################################################################
## Help structure
##
## All help / documentation is written in Markdown. The markdown is
## converted with pandoc to Man files for command line help, and also
## using pandoc to latex for the main manual.
##
## To generate the manual, the latest version of pandoc is
## required. Most users, however, will only generate manpages. If that
## is the case, pandoc 0.46 is also sufficient (which is the version
## under Ubuntu Jaunty)
##
## It is possible to define the location of the pandoc binary in:
##    $MOABASE/etc/moa.conf.mk
## with:
##    pandocbin=/path/to/pandoc
##
## Pandoc: see http://johnmacfarlane.net/pandoc/
## Markdown, see: http://daringfireball.net/projects/markdown/
##

.PHONY: help
help:
	@echo -e "$(call help_md)" 					\
		| sed "s/^ //g"  						\
		| sed "s/\[\[.*\]\]//g" 				\
		| sed "s/[ \t]*$$//"					\
		| $(pandocbin) -s -f markdown -t man	\
		| $(mancommand)

help_latex:
	@echo -e "$(call help_md)"				\
		| sed "s/^ //g"						\
		| sed "s/[ \t]*$$//"				\
		| sed "s/^#/##/"					\
		| $(pandocbin) -f markdown -t latex		\
		| sed "s/\[\[\(.*\)\]\]/\\\\citep\{\1\}/g" 	

help_man:
	@echo $(pandocbin)
	@echo -e "$(call help_md)" 				\
		| sed "s/^ //g"  					\
		| sed "s/\[\[.*\]\]//g" 			\
		| sed "s/[ \t]*$$//"				\
		| $(pandocbin) -s -f markdown -t man

help_markdown:
	@echo -e "$(call help_md)" 				\
		| sed "s/^ //g"  					\
		| sed "s/\[\[.*\]\]//g" 			\
		| sed "s/[ \t]*$$//"

empty:=
space:= $(empty) $(empty)
help_md = % $(subst $(space),_,$(moa_title)) \n\
% $(moa_author)							\n\
% $(shell date)							\n\
										\n\
$(moa_description)						\n\
										\n\
\#Targets								\n\
(empty)									\n\
:   Leaving the target unspecified 		\n\
:   executes the default target(s):     \n\
:	($(moa_ids)) 						\n\
clean									\n\
:	removes all results from this job   \n\
all										\n\
:	executes the default target and 	\n\
:   into subdirectories to execute any  \n\
:	other moa makefile it encounters	\n\
$(foreach id,$(moa_ids),				  \
$(id)									\n\
:	$($(id)_help)						\n\
)										\n\
$(foreach id,$(moa_additional_targets),	  \
$(id)									\n\
:	$(moa_$(id)_help)					\n\
)										\n\
										\n\
\#Parameters							\n\
\#\# Required parameters				\n\
$(foreach v,$(moa_must_define), 		  \
$(v)									\n\
:   $(if $($(v)_help),					\
		$($(v)_help),					\
		undefined)						\n\
)										\n\
\#\# Optional parameters				\n\
$(foreach v,$(moa_may_define), 			\
$(v)									\n\
:   $(if $($(v)_help),					\
		$($(v)_help),					\
		undefined)						\n\
)
