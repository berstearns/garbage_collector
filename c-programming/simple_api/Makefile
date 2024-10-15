CC = gcc
CFLAGS = -Wall -g -I/usr/include -I/usr/include/cjson
LIBS = -lmicrohttpd -lcjson

all: simple_api

simple_api: src/simple_api.o
	$(CC) -o simple_api src/simple_api.o $(LIBS)

src/simple_api.o: src/simple_api.c
	$(CC) $(CFLAGS) -c src/simple_api.c -o src/simple_api.o

clean:
	rm -f src/*.o simple_api
