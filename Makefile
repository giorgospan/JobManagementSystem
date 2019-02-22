# source files
COORD_SOURCE   := $(wildcard ./coordinator/*.c)
CONSOLE_SOURCE := $(wildcard ./console/*.c)
POOL_SOURCE    := $(wildcard ./pool/*.c)

# object files
COORD_OBJS     := $(COORD_SOURCE:%.c=%.o)
CONSOLE_OBJS   := $(CONSOLE_SOURCE:%.c=%.o)
POOL_OBJS      := $(POOL_SOURCE:%.c=%.o)

# headers
HEADERS	       := $(wildcard include/*.h)

# build directory
BUILDDIR       := ./build

# targets
COORD		       := $(BUILDDIR)/coord
CONSOLE		     := $(BUILDDIR)/console
POOL		       := $(BUILDDIR)/pool

CC 		         := gcc
CFLAGS 		     := -I./include -g

JMS_IN 		     := jms_in
JMS_OUT		     := jms_out
DIRPATH 	     := ./
OPFILE 		     := optest
JOBS_POO	     := 20

all:$(COORD) $(CONSOLE) $(POOL)


############## COORDINATOR ##############

run_coord:$(COORD)
	# ./${COORD} -l $(DIRPATH) -w $(JMS_OUT) -r $(JMS_IN) -n $(JOBS_POOL) &

$(COORD):$(COORD_OBJS) | $(BUILDDIR)
	$(CC) $(CFLAGS) -o $@ $(COORD_OBJS)

$(COORD_OBJS):./coordinator/%.o : ./coordinator/%.c
	$(CC) $(CFLAGS) -c $< -o $@

############## CONSOLE ##############

run_cons:$(CONSOLE)
	# ./${CONSOLE} -w $(JMS_IN) -r $(JMS_OUT) -o $(OPFILE)

$(CONSOLE):$(CONSOLE_OBJS) | $(BUILDDIR)
	$(CC) $(CFLAGS) -o $@ $(CONSOLE_OBJS)

$(CONSOLE_OBJS):./console/%.o : ./console/%.c
		$(CC) $(CFLAGS) -c $< -o $@


############## POOL ##############

$(POOL):$(POOL_OBJS) | $(BUILDDIR)
	$(CC) $(CFLAGS) -o $@ $(POOL_OBJS)

$(POOL_OBJS):./pool/%.o : ./pool/%.c
			$(CC) $(CFLAGS) -c $< -o $@

# this rule will be triggered in case build dir is not created yet
$(BUILDDIR):
	@mkdir $@

# count
.PHONY: count
count:
	@wc $(COORD_SOURCE) $(CONSOLE_SOURCE) $(POOL_SOURCE) $(HEADERS)


# cleanup
.PHONY: clean
clean:
	@rm -f $(COORD_OBJS) $(CONSOLE_OBJS) $(POOL_OBJS) $(COORD) $(CONSOLE) $(POOL)
	@echo Cleanup completed