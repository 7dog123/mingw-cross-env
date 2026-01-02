# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# gSOAP
PKG             := gsoap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.3.orig
$(PKG)_CHECKSUM := 2318037ecc449a05ba6db579bb645e98e9af92d0
$(PKG)_SUBDIR   := gsoap-$(call SHORT_PKG_VERSION,$(PKG))
$(PKG)_FILE     := gsoap_$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://gsoap2.sourceforge.net/
$(PKG)_URL      := https://old-releases.ubuntu.com/ubuntu/pool/universe/g/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/gsoap2/files/gSOAP/' | \
    $(SED) -n 's,.*gsoap_\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Native build to get tools wsdl2h and soapcpp2
    cd '$(1)' && ./configure

    # Parallel bulds can fail
    $(MAKE) -C '$(1)'/gsoap -j 1

    # Install the native tools manually
    $(INSTALL) -m755 '$(1)'/gsoap/wsdl/wsdl2h  '$(PREFIX)/bin/$(TARGET)-wsdl2h'
    $(INSTALL) -m755 '$(1)'/gsoap/src/soapcpp2 '$(PREFIX)/bin/$(TARGET)-soapcpp2'

    $(MAKE) -C '$(1)' -j '$(JOBS)' clean

    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'

    # Build for mingw. Static by default.
    # Prevent undefined reference to _rpl_malloc.
    # http://groups.google.com/group/ikarus-users/browse_thread/thread/fd1d101eac32633f
    cd '$(1)' && ac_cv_func_malloc_0_nonnull=yes ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --enable-gnutls

    # Building for mingw requires native soapcpp2
    ln -s '$(PREFIX)/bin/$(TARGET)-soapcpp2' '$(1)'/gsoap/src/soapcpp2

    # Parallel bulds can fail
    $(MAKE) -C '$(1)' -j 1 AR='$(TARGET)-ar'

    $(MAKE) -C '$(1)' -j 1 install
    # Apparently there is a tradition of compiling gsoap source files into applications.
    # Since we linked dom.cpp and dom.c into the libraries, this should not be necessary.
    # But we bend to tradition and install these sources into mingw-cross-env.
    $(INSTALL) -m644 '$(1)/gsoap/'*.c '$(1)/gsoap/'*.cpp '$(PREFIX)/$(TARGET)/share/gsoap'
endef
