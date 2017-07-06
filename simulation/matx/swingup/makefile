RTMATC=/usr/local/MaTX/bin/rtmatc -v

sample: sample.o pinit.o hardware.o
	$(RTMATC) sample.o pinit.o hardware.o

pinit.o: pinit.c
	$(RTMATC) -c pinit.c

sample.o: sample.c
	$(RTMATC) -c sample.c

sample.c: sample.mm
	$(RTMATC) -mm sample.mm

hardware.o: hardware.c
	$(RTMATC) -c hardware.c

hardware.c: hardware.mm
	$(RTMATC) -mm hardware.mm

clean:
	rm -f sample.c
	rm -f *.o
	rm -f sample

