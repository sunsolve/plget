CFLAGS += -g -Wall
LDFLAGS += -lm

CC=$(CROSS_COMPILE)gcc

all: plget

ALL_SOURCES := echo_lat.c pkt_gen.c plget_args.c plget.c result.c rtt.c \
rx_lat.c stat.c tx_lat.c

ifdef AFXDP

AFXDP_SOURCES := xdp_prog_load.c xdp_sock.c
ALL_SOURCES += ${AFXDP_SOURCES}
CFLAGS += -DCONF_AFXDP

endif

plget: %: $(ALL_SOURCES:.c=.o)
	@echo "CC " $@
	@$(CC) -o $@ $^ $(LDFLAGS)

# Option -MD needed to generate .d files in order to include them
%.o: %.c
	@echo "CC " $@
	@$(CC) -c -MD $< -o $@ $(CFLAGS)

#include targets for all headers, generated by -MD command
include $(wildcard *.d)

clean:
	rm -f *.o *.d plget

distclean: clean
	rm -rf cscope* tags

.PHONY: clean distclean
