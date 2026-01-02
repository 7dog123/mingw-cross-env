# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GNU Binutils
PKG             := binutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.28
$(PKG)_CHECKSUM := f8b033731f6baa437d429c60e2623570f1ef9d6b
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gnu.org/software/binutils/
$(PKG)_URL      := https://ftp.gnu.org/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := https://repository.timesys.com/buildsources/b/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'https://ftp.gnu.org/gnu/binutils/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="binutils-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --target='$(TARGET)' \
        --prefix='$(PREFIX)' \
        --disable-nls \
        --disable-werror \
        --disable-rpath \
        --enable-shared \
        --enable-static
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
