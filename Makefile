# Portable CUDA makefile
# Override architecture for your GPU, e.g. make ARCH=sm_80  (A100) or sm_90 (H100)
ARCH ?= sm_70
NVCC ?= nvcc
CXXFLAGS = -std=c++17 -O3 -lineinfo
NVCCFLAGS = $(CXXFLAGS) -arch=$(ARCH) -Iinclude
LDFLAGS = -lcublas -lcuda

BIN_DIR = bin
SRC_DIR = src

.PHONY: all clean dirs

dirs:
	mkdir -p $(BIN_DIR)

clean:
	rm -rf $(BIN_DIR)

LDFLAGS =
TARGETS = 01_stream_events_axpy 02_chunked_pipeline_newton 03_newton_baseline

all: dirs $(addprefix $(BIN_DIR)/,$(TARGETS))

$(BIN_DIR)/%: $(SRC_DIR)/%.cu
	$(NVCC) $(NVCCFLAGS) $< -o $@

run-demo: all
	$(BIN_DIR)/01_stream_events_axpy 20
	$(BIN_DIR)/02_chunked_pipeline_newton 20 4
