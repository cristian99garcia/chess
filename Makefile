VALAC = valac
OPTIONS = --target-glib 2.32

VALAPKG = --pkg gtk+-3.0 \
          --pkg gdk-3.0 \
          --pkg gstreamer-0.10

VAME_SRC = src/vame/area.vala \
           src/vame/image.vala \
           src/vame/sprite.vala \
           src/vame/text.vala \
           src/vame/sound.vala \
           src/vame/utils.vala

SRC = src/chess.vala \
      src/board.vala \
      src/piece.vala \
      src/brain.vala \
      src/utils.vala

BIN = chess

all:
	$(VALAC) $(OPTIONS) $(VALAPKG) $(VAME_SRC) $(SRC) -o $(BIN)

clean:
	rm -f $(BIN)

