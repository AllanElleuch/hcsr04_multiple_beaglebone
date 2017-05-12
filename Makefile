CC = gcc
CFLAGS = -Wall
PRU_ASM = pasm
DTC = dtc

all: hcsr04-00A0.dtbo hcsr04.bin hcsr04

hcsr04-00A0.dtbo: hcsr04.dts
	@echo "\n>> Compiling Driver"
	$(DTC) -O dtb -o hcsr04-00A0.dtbo -b 0 -@ hcsr04.dts

hcsr04.bin: hcsr04.p
	@echo "\n>> Generating PRU binary"
	$(PRU_ASM) -b hcsr04.p

hcsr04: hcsr04.c
	@echo "\n>> Compiling HC-SR04 example"
	$(CC) $(CFLAGS) -c -o hcsr04.o hcsr04.c
	$(CC) -lpthread -lprussdrv -o hcsr04 hcsr04.o

clean:
	rm -rf hcsr04 hcsr04.o hcsr04.bin hcsr04-00A0.dtbo

install: hcsr04-00A0.dtbo hcsr04.bin hcsr04
	cp hcsr04-00A0.dtbo /lib/firmware/hcsr04-00A0.dtbo
	echo hcsr04 > /sys/devices/bone_capemgr.9/slots
	cat /sys/devices/bone_capemgr.9/slots

c:
	@echo "\n>> Generating PRU binary 7_8"
	$(PRU_ASM) -b src/hcsr04_pin7_8.p
	@echo "\n>> Compiling HC-SR04 7_8"
	$(CC) $(CFLAGS) -c -o src/hcsr04_pin7_8.o src/hcsr04_pin7_8.c
	$(CC) -lpthread -lprussdrv -o src/hcsr04_pin7_8 src/hcsr04_pin7_8.o
