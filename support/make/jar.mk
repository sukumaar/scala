############################################################-*-Makefile-*-####
# JAR - Build Java Archive
##############################################################################
# $Id$

##############################################################################
# Usage
#
#   make jar [target=<target>] {<VARIABLE>=<value>}
#
##############################################################################
# Variables
#
# JAR			 = archive command
# JAR_FLAGS		+= archive flags
# JAR_ARCHIVE		 = archive file
# JAR_MANIFEST		 = manifest file
# JAR_INPUTDIR		 = directory containing the files to archive
# JAR_FILES		+= paths (relative to INPUTDIR) of the files to archive
#
# All variables may have target specific values which override the
# normal value. Those values are specified by variables whose name is
# prefixed with the target name. For example, to override the value of
# the variable JAR_ARCHIVE with target PROJECT, one may define the
# variable PROJECT_JAR_ARCHIVE
#
##############################################################################
# Examples
#
# Build the PROJECT java archive
#
#   make jar target=PROJECT
#
#
# Build a java archive containing all files in ./classes
#
#   make jar JAR_ARCHIVE=test.jar JAR_INPUTDIR=./classes JAR_FILES=.
#
##############################################################################

##############################################################################
# Defaults

CYGWIN_PATH		?= $(1)
CYGWIN_FILE		?= $(1)
JAR			?= jar

##############################################################################
# Values

jar			 = $(call JAR_LOOKUP,JAR)
jar_FLAGS		 = $(call JAR_LOOKUP,JAR_FLAGS)
jar_ARCHIVE		 = $(call JAR_LOOKUP,JAR_ARCHIVE)
jar_MANIFEST		 = $(call JAR_LOOKUP,JAR_MANIFEST)
jar_INPUTDIR		 = $(call JAR_LOOKUP,JAR_INPUTDIR)
jar_inputdir		 = $(jar_INPUTDIR:%=-C $(call CYGWIN_FILE,%))
jar_FILES		 = $(call JAR_LOOKUP,JAR_FILES)

##############################################################################
# Command

jar			+= c$(jar_FLAGS)f$(jar_MANIFEST:%=m)
jar			+= $(jar_ARCHIVE:%=$(call CYGWIN_FILE,%))
jar			+= $(jar_MANIFEST:%=$(call CYGWIN_FILE,%))
jar			+= $(jar_FILES:%=$(jar_inputdir) $(call CYGWIN_FILE,%))

##############################################################################
# Functions

JAR_LOOKUP		 = $(if $($(target)_$(1)),$($(target)_$(1)),$($(1)))

##############################################################################
# Rules

jar:
	@[ -d "$(dir $(jar_ARCHIVE))" ] || $(MKDIR) -p "$(dir $(jar_ARCHIVE))"
	$(strip $(jar)) || ( $(RM) $(jar_ARCHIVE) && exit 1 )

.PHONY		: jar

##############################################################################
