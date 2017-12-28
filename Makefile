SRCS = $(wildcard src/*.[sc])

SRC_DIR = src
RUNTIME_DIR = src/runtime
DRIVERS_DIR = src/drivers

C_RUNTIME_DIR := src/runtime
C_RUNTIME_SRCS += $(wildcard $(C_RUNTIME_DIR)/*.s)
C_RUNTIME_OBJECTS += $(patsubst %.s,%.o,$(filter %.s,$(C_RUNTIME_SRCS)))

SRCS = $(wildcard src/*.[cs])

OBJS += $(patsubst %.s,%.o,$(wildcard $(SRC_DIR)/*.s))
OBJS += $(patsubst %.c,%.o,$(wildcard $(SRC_DIR)/*.c))

OBJS += $(patsubst %.s,%.o,$(wildcard $(RUNTIME_DIR)/*.s))

OBJS += $(patsubst %.s,%.o,$(wildcard $(DRIVERS_DIR)/*.s))

HEADERS += $(wildcard $(SRC_DIR)/*.h)
HEADERS += $(wildcard $(DRIVERS_DIR)/*.h)

CL_FLAGS += -t none --cpu 65c02 -Isrc/include --asm-include-dir src/include

rom.bin: $(OBJS) mem.cfg
	cl65 $(CL_FLAGS) -C mem.cfg -m map.txt -o "$@" $(OBJS)

$(SRC_DIR)/%.o: $(SRC_DIR)/%.c mem.cfg $(HEADERS)
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

$(SRC_DIR)/%.o: $(SRC_DIR)/%.s mem.cfg
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

$(RUNTIME_DIR)/%.o: $(RUNTIME_DIR)/%.s mem.cfg
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

$(DRIVERS_DIR)/%.o: $(DRIVERS_DIR)/%.s mem.cfg
	cl65 $(CL_FLAGS) -c -o "$@" "$<"

clean:
	rm -f $(OBJS)
	rm -f rom.bin

#$(C_RUNTIME_DIR)/%.o: $(C_RUNTIME_DIR)/%.s $(LINK_CONFIG)
#	$(CL65) $(CL65_FLAGS) -c -o "$@" "$<"

