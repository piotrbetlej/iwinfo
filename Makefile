IWINFO_CLI_LIBFLAGS += -L.

ifneq ($(filter wl,$(IWINFO_BACKENDS)),)
	IWINFO_CFLAGS  += -DUSE_WL
	IWINFO_LIB_OBJ += iwinfo_wl.o
endif

ifneq ($(filter madwifi,$(IWINFO_BACKENDS)),)
	IWINFO_CFLAGS  += -DUSE_MADWIFI
	IWINFO_LIB_OBJ += iwinfo_madwifi.o
endif

ifneq ($(filter nl80211,$(IWINFO_BACKENDS)),)
	IWINFO_CFLAGS      += -DUSE_NL80211
	IWINFO_CLI_LIBFLAGS += -lnl-genl-3
	IWINFO_LIB_LIBFLAGS += -lnl-genl-3
	IWINFO_LIB_OBJ     += iwinfo_nl80211.o
endif

IWINFO_BACKENDS    = $(BACKENDS)
IWINFO_CFLAGS      = $(CFLAGS) -std=gnu99 -fstrict-aliasing -Iinclude
IWINFO_LDFLAGS     = -lubox

IWINFO_LIB         = libiwinfo.so
IWINFO_LIB_LDFLAGS = $(LDFLAGS) -shared
IWINFO_LIB_OBJ     = iwinfo_utils.o iwinfo_wext.o iwinfo_wext_scan.o iwinfo_lib.o

IWINFO_CLI         = iwinfo
IWINFO_CLI_LDFLAGS = $(LDFLAGS)
IWINFO_CLI_OBJ     = iwinfo_cli.o

IWINFO_CLI_LIBFLAGS += -liwinfo

%.o: %.c
	$(CC) $(IWINFO_CFLAGS) $(FPIC) -c -o $@ $<

compile: clean $(IWINFO_LIB_OBJ) $(IWINFO_CLI_OBJ)
	$(CC) $(IWINFO_LDFLAGS) $(IWINFO_LIB_LDFLAGS) -o $(IWINFO_LIB) $(IWINFO_LIB_OBJ)
	$(CC) $(IWINFO_LDFLAGS) $(IWINFO_CLI_LDFLAGS) -o $(IWINFO_CLI) $(IWINFO_CLI_OBJ) $(IWINFO_CLI_LIBFLAGS)

clean:
	rm -f *.o $(IWINFO_LIB) $(IWINFO_CLI)
