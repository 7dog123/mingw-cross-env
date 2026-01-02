# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libxslt
PKG             := libxslt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.26
$(PKG)_CHECKSUM := 7812715d5dce844a697e2e8780af00307fcd5e6a
$(PKG)_SUBDIR   := libxslt-$($(PKG)_VERSION)
$(PKG)_FILE     := libxslt-$($(PKG)_VERSION).tar.xz
$(PKG)_WEBSITE  := http://xmlsoft.org/XSLT/
$(PKG)_URL      := https://download.gnome.org/sources/libxslt/1.1/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libxml2 libgcrypt

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/libxslt/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=v\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --without-debug \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-libxml-prefix='$(PREFIX)/$(TARGET)' \
        LIBGCRYPT_CONFIG='$(PREFIX)/$(TARGET)/bin/libgcrypt-config' \
        --without-python \
        --without-plugins
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
