#
# $Id: Makefile 68 2014-02-18 23:49:56Z nicb $
#
TARGET=ostinato-II.wav
SCO=$(TARGET:.wav=.sco)
ORC=o-II.orc
DATA=O-2.dat
CSOUND=csound -d
AWK=awk
SOUNDIN_LINKER=./link.sh

all: $(TARGET)

$(TARGET):  $(SCO)
	$(CSOUND) -Wo ./$(TARGET) $(ORC) $(SCO)

$(SCO): soundins
	$(AWK) -f o-II.awk $(DATA) > $@

soundins:
	$(RM) soundin.*
	$(SOUNDIN_LINKER)

clean:
	$(RM) $(TARGET) $(SCO) soundin.*
