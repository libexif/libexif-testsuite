images = \
	canon-powershot-g2-001.jpg	\
	canon-powershot-a400-001.jpg

EXTRA_DIST = $(images)

.PHONY: upload
upload: libexif-test-image-list
	rsync -avz libexif-test-image-list h:es/

libexif-test-image-list: $(srcdir)
	(cd $(srcdir) && ls -1 *.jpg *.tif) > $@ || true
	chmod 0644 $@
