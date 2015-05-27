test:string.o
	clang++ ./test.cpp ./string.o -o ./test -std=c++0x
string.o:
	clang++ -c ./string.cpp -std=c++0x
check:
	./test
