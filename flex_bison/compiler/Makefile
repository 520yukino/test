BUILD_DIR = ./build
FLEX_FILE = $(BUILD_DIR)/flex.lex.c
BISON_FILE = $(BUILD_DIR)/bison.yac.c
TARGET_FILE = ./compiler.out
$(shell mkdir -p $(BUILD_DIR))

$(TARGET_FILE): main.c $(FLEX_FILE) $(BISON_FILE) #可执行文件编译，使用-I包含h.h
	gcc $^ -o $@ -lm -I .
$(FLEX_FILE): flex.l #flex编译
	flex -o $@ $^
$(BISON_FILE): bison.y #bison编译，-d表示同时生成bison.tab.h头文件
	bison -d -o $@ $^

clear:
	rm $(TARGET_FILE) $(FLEX_FILE) $(BISON_FILE) $(BUILD_DIR)/bison.yac.h
	rmdir $(BUILD_DIR)