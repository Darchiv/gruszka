

hello.o65: main.o
	ld65 -C ../gruszka.cfg -m map.txt -o hello.o65 main.o ../../libc/libc.lib

main.o: main.c
	cl65 -t none -c --cpu 65c02 -o main.o main.c

clean:
	rm main.o
	rm hello.o65