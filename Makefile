GO_EASY_ON_ME = 1
DEBUG=0
FINALPACKAGE=1

THEOS_DEVICE_IP = 127.0.0.1 -p 2222

ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TOOL_NAME = changerootfs preparerootfs
TARGET := iphone:clang:11.2:11.2

LIB_DIR := lib

preparerootfs_FILES = preparerootfs.m kernel.m libdimentio.c vnode_utils.c
preparerootfs_CFLAGS = $(CFLAGS) -fobjc-arc -Wno-error=unused-variable -Wno-error=unused-function -D USE_DEV_FAKEVAR
preparerootfs_FRAMEWORKS = IOKit

changerootfs_FILES = changerootfs.m kernel.m libdimentio.c vnode_utils.c
changerootfs_CFLAGS = $(CFLAGS) -fobjc-arc -Wno-error=unused-variable -Wno-error=unused-function
changerootfs_FRAMEWORKS = IOKit

ifdef USE_JELBREK_LIB
	preparerootfs_LDFLAGS = $(LIB_DIR)/jelbrekLib.dylib
	changerootfs_LDFLAGS = $(LIB_DIR)/jelbrekLib.dylib
endif

include $(THEOS_MAKE_PATH)/tool.mk

ifdef USE_JELBREK_LIB
before-package::
	$(THEOS)/toolchain/linux/iphone/bin/ldid -S./ent.plist $(THEOS_STAGING_DIR)/usr/lib/jelbrekLib.dylib
endif

before-package::
	mkdir -p $(THEOS_STAGING_DIR)/usr/lib/
	cp $(LIB_DIR)/jelbrekLib.dylib $(THEOS_STAGING_DIR)/usr/lib
	ldid -S./ent.plist $(THEOS_STAGING_DIR)/usr/bin/changerootfs
	ldid -S./ent.plist $(THEOS_STAGING_DIR)/usr/bin/preparerootfs

SUBPROJECTS += zzzzzzzzznotifychroot
include $(THEOS_MAKE_PATH)/aggregate.mk
