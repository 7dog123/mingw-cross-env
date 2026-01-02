# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libiconv
PKG             := libiconv
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.2
$(PKG)_CHECKSUM := 41090f57ef638aaf531c964256cc91735e46438f
$(PKG)_SUBDIR   := libiconv-$($(PKG)_VERSION)
$(PKG)_FILE     := libiconv-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.gnu.org/software/libiconv/
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/libiconv/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gnu.org/software/libiconv/' | \
    grep 'libiconv-' | \
    $(SED) -n 's,.*libiconv-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's, sed , $(SED) ,g' '$(1)/windows/windres-options'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-nls
    $(MAKE) -C '$(1)/libcharset' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/lib'        -j '$(JOBS)' install
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/include/iconv.h.inst' '$(PREFIX)/$(TARGET)/include/iconv.h'
endef
