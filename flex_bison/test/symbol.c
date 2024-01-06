#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 符号表中的条目结构
typedef struct {
    char* name;
    char* type;
} SymbolTableEntry;

// 符号表结构
typedef struct {
    SymbolTableEntry* entries;
    size_t size;
    size_t capacity;
} SymbolTable;

// 初始化符号表
void init_symbol_table(SymbolTable* symbol_table, size_t initial_capacity) {
    symbol_table->entries = (SymbolTableEntry*)malloc(initial_capacity * sizeof(SymbolTableEntry));
    symbol_table->size = 0;
    symbol_table->capacity = initial_capacity;
}

// 向符号表中添加条目
void add_entry(SymbolTable* symbol_table, const char* name, const char* type) {
    // 确保符号表容量足够
    if (symbol_table->size == symbol_table->capacity) {
        symbol_table->capacity *= 2;
        symbol_table->entries = (SymbolTableEntry*)realloc(symbol_table->entries, symbol_table->capacity * sizeof(SymbolTableEntry));
    }

    // 添加新条目
    SymbolTableEntry* entry = &symbol_table->entries[symbol_table->size];
    entry->name = strdup(name);
    entry->type = strdup(type);

    symbol_table->size++;
}

// 在符号表中查找条目
SymbolTableEntry* find_entry(SymbolTable* symbol_table, const char* name) {
    for (size_t i = 0; i < symbol_table->size; ++i) {
        if (strcmp(symbol_table->entries[i].name, name) == 0) {
            return &symbol_table->entries[i];
        }
    }
    return NULL; // 未找到
}

// 清理符号表
void cleanup_symbol_table(SymbolTable* symbol_table) {
    for (size_t i = 0; i < symbol_table->size; ++i) {
        free(symbol_table->entries[i].name);
        free(symbol_table->entries[i].type);
    }
    free(symbol_table->entries);
    symbol_table->size = 0;
    symbol_table->capacity = 0;
}

int main() {
    // 初始化符号表
    SymbolTable symbol_table;
    init_symbol_table(&symbol_table, 10);

    // 添加条目到符号表
    add_entry(&symbol_table, "myVar", "i32");
    add_entry(&symbol_table, "anotherVar", "i64");

    // 在符号表中查找条目
    SymbolTableEntry* entry = find_entry(&symbol_table, "myVar");
    if (entry != NULL) {
        printf("Found entry: Name=%s, Type=%s\n", entry->name, entry->type);
    } else {
        printf("Entry not found.\n");
    }

    // 清理符号表
    cleanup_symbol_table(&symbol_table);

    return 0;
}
