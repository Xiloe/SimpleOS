# Makefile is located in SimpleOS/bin/
#-------------------------------------

# Create the OS.bin file (use 'Make OS')
OS: bootSector.bin fileTable.bin kernel.bin
		cat bootSector.bin fileTable.bin kernel.bin > OS.bin

# Create bootsector binary file (use 'Make bootSector.bin')
bootSector.bin:
		fasm ../src/asm/bootSector.asm
		mv ../src/asm/bootSector.bin ./

# Create fileTable binary file (use 'Make fileTable.bin')
fileTable.bin:
		fasm ../src/asm/fileTable.asm
		mv ../src/asm/fileTable.bin ./

# Create kernel binary file (use 'Make kernel.bin')
kernel.bin:
		fasm ../src/asm/kernel.asm
		mv ../src/asm/kernel.bin ./

# Clean up binary files (use 'Make clean')
clean:
		rm *.bin