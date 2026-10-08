DIR=dir
MALICIOUS_DIR=malicious_dir
INTERVAL=5

all: setup
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(INTERVAL)

restore: setup
	./restore.sh $(DIR) $(MALICIOUS_DIR)

setup:
	mkdir -p $(DIR)	$(MALICIOUS_DIR)
