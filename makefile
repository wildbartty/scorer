CC = gcc
FILES = characters.o demo.o printstack.o
MAIN = main.o
LIBS = `pkg-config --libs --cflags lua ncurses`

%.o: %.c 
	$(CC) -g -c -o $@ $< $(LIBS)

make: $(MAIN) $(FILES)
	$(CC) -g -o scorer $(FILES) $(MAIN) $(LIBS)

clean: 
	rm *.o scorer

run: clean make
	./scorer
