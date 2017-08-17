##############################################################################
#
# (c) Copyright IBM Corp. 2017
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

set(OMR_OS_DEFINITIONS 
	LINUX
	_FILE_OFFSET_BITS=64
)

if(OMR_ENV_DATA64)
	set(OMR_OS_COMPILE_OPTIONS
		-pthread
		-m64
	)
else()
	set(OMR_OS_COMPILE_OPTIONS
		-pthread
		-m32
		-msse2
	)
endif()

macro(omr_os_global_setup)
	if(OMR_ARCH_S390)
		enable_language(ASM-ATT)
	endif()
endmacro(omr_os_global_setup)
