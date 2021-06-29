## project.Makefile
## This is ICI3D/RTutorials

current: target
-include target.mk

-include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

Sources += $(wildcard *.R)

######################################################################

## Processing machinery

Ignore += batch
batch:
	$(mkdir)
Sources += batch.pl
.PRECIOUS: batch/%.R
batch/%.R: %.R %.answers.R batch.pl
	$(MAKE) batch
	$(PUSHRO)

## batch/ICI3D_RTutorial_1.R: batch.pl
%.batch.Rout: batch/%.R
	$(pipeR)

Sources += batch.md

## ICI3D_RTutorial_1.batch.Rout: ICI3D_RTutorial_1.R batch.pl
## ICI3D_RTutorial_1.batch.Rout: ICI3D_RTutorial_1.answers.R

## ICI3D_RTutorial_2.batch.Rout: ICI3D_RTutorial_2.R ICI3D_RTutorial_2.answers.R

## ICI3D_RTutorial_4_VisualizingData.Rout: ICI3D_RTutorial_4_VisualizingData.R ICI3D_RTutorial_4_VisualizingData.answers.R

ICI3D_RtvTutorial_4.batch.Rout: ICI3D_RtvTutorial_4.R ICI3D_RtvTutorial_4.answers.R

######################################################################

### Makestuff

## Makefile gutted 2021 Jun 21 (Mon)
Sources += Makefile content.mk

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls makestuff/Makefile

-include makestuff/os.mk

-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
