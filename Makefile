BIN=processpool
SRC=processpool.cpp
CC=g++
LIB=-I./
FLAGS=-g -Wall

$(BIN):$(SRC)
	$(CC)    $^ -o $@  $(FLAGS)  $(LIB)
.PHONY:clean
clean:
	rm -rf $(BIN)