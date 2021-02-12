MODULE_big = plantuner
DOCS = README.md
REGRESS = plantuner
OBJS=plantuner.o

PGXS = $(shell pg_config --pgxs)
include $(PGXS)