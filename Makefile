PROJECT_DIR := $(abspath .)

.PHONY: all build test screenshot check-abla-only clean

all: check-abla-only build

build:
	cd ../ablac && ABLA_SYSROOT=$$(pwd) ./build/ablac build --project \
		$(PROJECT_DIR) -o $(PROJECT_DIR)/build/abla-doom --no-cache

test: check-abla-only build
	./tools/test.sh

screenshot: build
	./tools/screenshot.sh

check-abla-only:
	./tools/check-abla-only.sh

clean:
	@if [ -d "$(PROJECT_DIR)/build" ]; then gio trash "$(PROJECT_DIR)/build"; fi
