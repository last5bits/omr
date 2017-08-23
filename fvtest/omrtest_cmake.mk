###############################################################################
#
# (c) Copyright IBM Corp. 2015, 2017
#
#  This program and the accompanying materials are made available
#  under the terms of the Eclipse Public License v1.0 and
#  Apache License v2.0 which accompanies this distribution.
#
#      The Eclipse Public License is available at
#      http://www.eclipse.org/legal/epl-v10.html
#
#      The Apache License v2.0 is available at
#      http://www.opensource.org/licenses/apache2.0.php
#
# Contributors:
#    Multiple authors (IBM Corp.) - initial implementation and documentation
###############################################################################

top_srcdir := .

######################J9 Lab specific settings#################################

all: test

omr_algotest:
	./omralgotest -avltest:fvtest/algotest/avltest.lst
	
omr_gctest:
	./omrgctest --gtest_filter="gcFunctionalTest*"

# jitbuilder can run different sets of tests on linux_x86 and osx than on other platforms
# until we common this up, run "testall" on linux_x86 and osx but run "test" everywhere else
omr_jitbuilderexamples:
ifeq (,$(findstring linux_x86,$(SPEC)))
	make -C jitbuilder/release testall
else ifeq (,$(findstring osx,$(SPEC)))
	make -C jitbuilder/release testall
else
	make -C jitbuilder/release test
endif

omr_jitbuildertest:
	./omrjitbuildertest

omr_jittest:
	./testjit
	
omr_porttest:
	./omrporttest
ifneq (,$(findstring cuda,$(SPEC)))
	./omrporttest --gtest_filter="Cuda*" -earlyExit
endif
	@echo ALL $@ PASSED

omr_rastest:
	./omrrastest
	./omrsubscribertest --gtest_filter=-RASSubscriberForkTest.*
	./omrtraceoptiontest
	@echo ALL $@ PASSED
	
omr_subscriberforktest:
	./omrsubscribertest --gtest_filter=RASSubscriberForkTest.*
	
omr_sigtest:
	./omrsigtest

omr_threadextendedtest:
	./omrthreadextendedtest

omr_threadtest:
	./omrthreadtest
	./omrthreadtest --gtest_also_run_disabled_tests --gtest_filter=ThreadCreateTest.DISABLED_SetAttrThreadWeight
ifneq (,$(findstring linux,$(SPEC)))
	./omrthreadtest --gtest_filter=ThreadCreateTest.*:$(GTEST_FILTER) -realtime
endif
	@echo ALL $@ PASSED

omr_utiltest:
	./omrutiltest
	
omr_vmtest:
	./omrvmtest

.NOTPARALLEL:
test: omr_algotest omr_utiltest omr_vmtest omr_gctest omr_rastest omr_subscriberforktest
ifeq (1,$(OMR_TEST_COMPILER))
test: omr_jittest
endif
ifeq (1,$(OMR_JITBUILDER))
test: omr_jitbuildertest omr_jitbuilderexamples
endif
ifeq (1,$(OMR_PORT))
test: omr_porttest
endif
ifeq (1,$(OMR_THREAD))
test: omr_threadtest omr_threadextendedtest
endif
ifeq (1,$(OMR_OMRSIG))
test: omr_sigtest
endif

.PHONY: all test omr_algotest omr_gctest omr_jitbuilderexamples omr_jitbuildertest omr_jittest omr_porttest omr_rastest omr_subscriberforktest omr_sigtest omr_threadextendedtest omr_threadtest omr_utiltest omr_vmtest 
