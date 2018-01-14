LIBNAME    := libc.lib
CRUNTIMENAME   := cruntime.lib
SRC_DIRS   += common gruszka runtime
INC_DIRS   += include
ASM_INC_DIRS += asminc

SRCS         += $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.[cs]))

OBJS         += $(patsubst %.s,%.o,$(filter %.s,$(SRCS)))
OBJS         += $(patsubst %.c,%.o,$(filter %.c,$(SRCS)))

RUNTIME_OBJS += $(patsubst %.s,%.o,$(filter runtime/%.s,$(SRCS)))

INCLUDES  += $(addprefix -I ,$(INC_DIRS))
ASM_INCLUDES  += $(addprefix -I ,$(ASM_INC_DIRS))

C_FLAGS += --cpu 65c02

all: $(LIBNAME) $(CRUNTIMENAME)

$(LIBNAME): $(OBJS)
	ar65 r $@ $(OBJS)

$(CRUNTIMENAME): $(RUNTIME_OBJS)
	ar65 r $@ $(RUNTIME_OBJS)

common/%.o: common/%.c
	cl65 -c $(C_FLAGS) $(INCLUDES) $< -o $@

common/%.o: common/%.s
	ca65 $(C_FLAGS) $(ASM_INCLUDES) $< -o $@

gruszka/%.o: gruszka/%.c
	cl65 -c $(C_FLAGS) $(INCLUDES) $< -o $@

gruszka/%.o: gruszka/%.s
	ca65 $(C_FLAGS) $(ASM_INCLUDES) $< -o $@

runtime/%.o: runtime/%.c
	cl65 -c $(C_FLAGS) $(INCLUDES) $< -o $@

runtime/%.o: runtime/%.s
	ca65 $(C_FLAGS) $(ASM_INCLUDES) $< -o $@


clean:
	rm -f $(OBJS)
	rm -f $(LIBNAME)
	rm -f $(CRUNTIMENAME)
