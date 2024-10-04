CC = gcc
CFLAGS = -Iinclude -Wall
SRC = src/main.c src/menu.c
OBJ = $(SRC:.c=.o)
EXEC = languagelearning

all: $(EXEC)

$(EXEC): $(OBJ)
	$(CC) -o $(EXEC) $(OBJ)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(EXEC)

.PHONY: all clean
