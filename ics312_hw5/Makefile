# make: will build the programs
# make run1: will run the first program
# make run2: will run the second program
# ...
# make clean: will remove all object and executable files

PROGRAM1=hw5_ex1
PROGRAM2=hw5_ex2
PROGRAM3=hw5_ex3
PROGRAM4=hw5_ex4

CC=gcc
CFLAGS=-m32
ASM=nasm
ASMFLAGS=-f elf -g

default: $(PROGRAM1) $(PROGRAM2) $(PROGRAM3) $(PROGRAM4) 

run1: $(PROGRAM1)
	@./$(PROGRAM1)

run2: $(PROGRAM2)
	@./$(PROGRAM2)

run3: $(PROGRAM3)
	@./$(PROGRAM3)

run4: $(PROGRAM4)
	@./$(PROGRAM4)

$(PROGRAM1): $(PROGRAM1).o driver.o asm_io.o
	$(CC) $(CFLAGS) $(PROGRAM1).o driver.o asm_io.o -o $(PROGRAM1)

$(PROGRAM2): $(PROGRAM2).o driver.o asm_io.o
	$(CC) $(CFLAGS) $(PROGRAM2).o driver.o asm_io.o -o $(PROGRAM2)

$(PROGRAM3): $(PROGRAM3).o driver.o asm_io.o
	$(CC) $(CFLAGS) $(PROGRAM3).o driver.o asm_io.o -o $(PROGRAM3)

$(PROGRAM4): $(PROGRAM4).o driver.o asm_io.o
	$(CC) $(CFLAGS) $(PROGRAM4).o driver.o asm_io.o -o $(PROGRAM4)

$(PROGRAM1).o: $(PROGRAM1).asm
	$(ASM) $(ASMFLAGS) $(PROGRAM1).asm -o $(PROGRAM1).o

$(PROGRAM2).o: $(PROGRAM2).asm
	$(ASM) $(ASMFLAGS) $(PROGRAM2).asm -o $(PROGRAM2).o

$(PROGRAM3).o: $(PROGRAM3).asm
	$(ASM) $(ASMFLAGS) $(PROGRAM3).asm -o $(PROGRAM3).o

$(PROGRAM4).o: $(PROGRAM4).asm
	$(ASM) $(ASMFLAGS) $(PROGRAM4).asm -o $(PROGRAM4).o

test3: $(PROGRAM3) test_hw5_ex3.expect
	./test_hw5_ex3.expect

test3b: $(PROGRAM3) test_hw5_ex3b.expect
	./test_hw5_ex3b.expect

asm_io.o: asm_io.asm
	$(ASM) $(ASMFLAGS) -d ELF_TYPE asm_io.asm -o asm_io.o

driver.o: driver.c
	$(CC) $(CFLAGS) -c driver.c -o driver.o

clean:
	/bin/rm -f *.o $(PROGRAM1) $(PROGRAM2) $(PROGRAM3) $(PROGRAM4)
