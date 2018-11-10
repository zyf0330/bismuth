PACKAGE_NAME = krohnkite
PACKAGE_VER  = 0.1
PACKAGE_FILE = $(PACKAGE_NAME)-$(PACKAGE_VER).kwinscript

PACKAGE_DIR = pkg

FILE_SCRIPT = $(PACKAGE_DIR)/contents/code/script.js
FILE_META   = $(PACKAGE_DIR)/metadata.desktop
FILE_QML    = $(PACKAGE_DIR)/contents/ui/main.qml

all: $(PACKAGE_DIR)

clean:
	@rm -vf script.json
	@rm -rvf $(PACKAGE_DIR)

package: $(PACKAGE_FILE)

$(PACKAGE_FILE): $(PACKAGE_DIR)
	@rm -f "$(PACKAGE_FILE)"
	@7z a -tzip $(PACKAGE_FILE) ./$(PACKAGE_DIR)/*

$(PACKAGE_DIR): $(FILE_SCRIPT) $(FILE_META) $(FILE_QML)
	@touch $@

$(FILE_SCRIPT): src/common.ts
$(FILE_SCRIPT): src/driver.ts
$(FILE_SCRIPT): src/engine.ts
$(FILE_SCRIPT): src/kwin.d.ts
$(FILE_SCRIPT): src/layout.ts
	@mkdir -vp `dirname $(FILE_SCRIPT)`
	tsc --outFile $(FILE_SCRIPT)

$(FILE_META): res/metadata.desktop
	@mkdir -vp `dirname $(FILE_META)`
	sed "s/0\.0/$(PACKAGE_VER)/" $< > $(FILE_META)

$(FILE_QML): res/main.qml
	@mkdir -vp `dirname $(FILE_QML)`
	@cp -v $< $@

.PHONY: all clean package
