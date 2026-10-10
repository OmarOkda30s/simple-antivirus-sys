DIR ?= monitored_dir
MAL_DIR ?= quarantined_dir
INTERVAL ?= 5

.PHONY: all setup run_daemon run_restore clean

all: setup run_daemon

setup:
	@echo "Running pre-build setup..."
	mkdir -p $(DIR)
	mkdir -p $(MAL_DIR)
	touch whitelist.txt
	chmod +x antivirusd.sh restore.sh antivirus-cron.sh 2>/dev/null || true

run_daemon: setup
	./antivirusd.sh $(DIR) $(MAL_DIR) $(INTERVAL)

run_restore: setup
	./restore.sh $(DIR)$(MAL_DIR)

clean:
	rm -rf $(DIR)$(MAL_DIR) directory-info.* whitelist.txt