# Compilation
CC      = gcc
CFLAGS  = $(INCDIRS) $(STRIPDEFS) -O0 -g3 -Wall -fmessage-length=0
LDFLAGS =

# Shell commands
MKDIR = mkdir -p
RM    = rm -rf


# Keywords in code that are stripped out
STRIPPED_KW = far \
              _seg \
              huge \
              near
STRIPDEFS = $(patsubst %,-D%=,$(STRIPPED_KW))


# Source files
SRCDIR   = src
SOURCES  = $(SRCDIR)/wl_main.c \
           $(SRCDIR)/wl_act1.c \
           $(SRCDIR)/wl_act2.c \
           $(SRCDIR)/wolfhack.c \
           $(SRCDIR)/wl_agent.c \
           $(SRCDIR)/wl_draw.c \
           $(SRCDIR)/wl_game.c \
           $(SRCDIR)/wl_state.c \
           $(SRCDIR)/wl_scale.c
#           $(SRCDIR)/contigsc.c \
#           $(SRCDIR)/detect.c \
#           $(SRCDIR)/id_ca.c \
#           $(SRCDIR)/id_in.c \
#           $(SRCDIR)/id_mm.c \
#           $(SRCDIR)/id_pm.c \
#           $(SRCDIR)/id_sd.c \
#           $(SRCDIR)/id_us_1.c \
#           $(SRCDIR)/id_vh.c \
#           $(SRCDIR)/id_vl.c \
#           $(SRCDIR)/munge.c \
#           $(SRCDIR)/oldscale.c \
#           $(SRCDIR)/wl_debug.c \
#           $(SRCDIR)/wl_inter.c \
#           $(SRCDIR)/wl_menu.c \
#           $(SRCDIR)/wl_play.c \
#           $(SRCDIR)/wl_text.c

# Include folders
INCLUDES = $(SRCDIR)

# Output directories
OBJDIR=obj
OUTDIR=out


# Work variables
OBJDIRS   = $(shell echo "$(dir $(OBJECTS))"  | xargs -n 1 echo | sort -u)
OBJECTS   = $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(SOURCES))
INCDIRS   = $(patsubst %,-I%,$(INCLUDES))


# Rules
.PHONY: all clean

all: $(OUTDIR)/wolf3d

# Include generated header dependencies for each source file
-include $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.d,$(SOURCES))

$(OUTDIR)/wolf3d: $(OBJECTS) | $(OUTDIR)
	@printf "LD\t$(notdir $@)\n"
#	@$(CC) $(OBJECTS) $(UI_OBJS) $(CSS_OBJS) $(LDFLAGS) -o $@
# Dont try to link now, too many errors for nothing
	@touch $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@printf "CC\t$(notdir $<)\n"
	@$(CC) $(CFLAGS) -M -MF $(patsubst %.o,%.d,$@) -MT $@ $<
	@$(CC) $(CFLAGS) -c -o $@ $<

$(OBJECTS): | $(OBJDIRS)

$(OBJDIRS):
	@$(MKDIR) $@

$(OUTDIR):
	@$(MKDIR) $@

clean:
	@$(RM) $(OBJDIR) $(OUTDIR)
