

sh.o65: main.o
	ld65 -C ../gruszka.cfg -m map.txt -o sh.o65 main.o ../../libc/libc.lib

main.o: main.c
	cl65 -c --cpu 65c02 -o main.o main.c