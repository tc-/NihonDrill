
love:
	zip nihondrill.love \
	images/*.png \
	images/hiragana/*.png \
	images/katakana/*.png \
	images/levels/*.png \
	images/special/*.png \
	sound/*.mp3 \
	voc/*.lua \
	*.lua \
	LICENSE \
	README \
	Tuffy.ttf \
	-x sound/aiueo.mp3

clean:
	rm *.love

