# Makefile for RISC-V MNIST Baseline (Bare-Metal)

CC = riscv64-unknown-elf-gcc
CFLAGS = -O2 -Wall -nostdlib -nostartfiles -ffreestanding -mcmodel=medany
INCLUDES = -I./include
LDFLAGS = -T linker.ld -Wl,--no-relax

# Source files
SRCS = crt0.S mnist/mnist.c mnist/neural_net.c
OBJS = $(SRCS:.S=.o)
OBJS := $(OBJS:.c=.o)
TARGET = mnist_baseline

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f mnist/*.o $(TARGET)

.PHONY: all clean