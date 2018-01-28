SRCS = $(wildcard src/*.[sc])

SRC_DIR = src
DRIVERS_DIR = src/drivers
UTILS_DIR = src/utils
SYS_DIR = src/sys

SRCS = $(wildcard src/*.[cs])

OBJS += $(patsubst %.s,%.o,$(wildcard $(SRC_DIR)/*.s))
OBJS += $(patsubst %.c,%.o,$(wildcard $(SRC_DIR)/*.c))

OBJS += $(patsubst %.s,%.o,$(wildcard $(UTILS_DIR)/*.s))
OBJS += $(patsubst %.c,%.o,$(wildcard $(UTILS_DIR)/*.c))

OBJS += $(patsubst %.s,%.o,$(wildcard $(SYS_DIR)/*.s))
OBJS += $(patsubst %.c,%.o,$(wildcard $(SYS_DIR)/*.c))

OBJS += $(patsubst %.s,%.o,$(wildcard $(DRIVERS_DIR)/*.s))

HEADERS += $(wildcard $(SRC_DIR)/*.h)
HEADERS += $(wildcard $(DRIVERS_DIR)/*.h)

RUNTIME_LIB = libc/cruntime.lib

CL_FLAGS += -t none --cpu 65c02 -Isrc/include --asm-include-dir src/include --bin-include-dir userland

rom.bin: $(OBJS) mem.cfg
	cl65 $(CL_FLAGS) -C mem.cfg -m map.txt -o "$@" $(OBJS) $(RUNTIME_LIB)

$(SRC_DIR)/%.o: $(SRC_DIR)/%.c mem.cfg $(HEADERS)
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

$(SRC_DIR)/%.o: $(SRC_DIR)/%.s mem.cfg
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

$(DRIVERS_DIR)/%.o: $(DRIVERS_DIR)/%.s mem.cfg
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

$(UTILS_DIR)/%.o: $(UTILS_DIR)/%.s mem.cfg
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

$(UTILS_DIR)/%.o: $(UTILS_DIR)/%.c mem.cfg
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

$(SYS_DIR)/%.o: $(SYS_DIR)/%.s mem.cfg
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

$(SYS_DIR)/%.o: $(SYS_DIR)/%.c mem.cfg
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

clean:
	rm -f $(OBJS)
	rm -f rom.bin
