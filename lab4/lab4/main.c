#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#define STDIN 0
#define STDOUT 1

#define NULL_CHARACTER 0
#define LINE_FEED 10
#define PLUS_SIGN 43
#define HYPHEN 45
#define DIGIT_ZERO 48
#define DIGIT_NINE 57

#define INPUT_BUFFER_SIZE 9
char s_sInputBuffer[INPUT_BUFFER_SIZE];

char s_sSetSizeOfOneDArray[] = "Set size of one-D array";
char s_sEnterElementsOfOneDArray[] = "Enter elements of one-D array";
char s_sSetOneDArray[] = "Set one-D array";
char s_sShowOneDArray[] = "Show one-D array";
char s_sFindMinElementOfOneDArray[] = "Find min element of one-D array";
char s_sFindMaxElementOfOneDArray[] = "Find max element of one-D array";
char s_sFindSumOfOneDArray[] = "Find sum of one-D array";
char s_sSetSizeOfTwoDArray[] = "Set size of two-D array";
char s_sEnterNumberOfRowsOfTwoDArray[] = "Enter number of rows of two-D array: ";
char s_sEnterNumberOfColsOfTwoDArray[] = "Enter number of cols of two-D array: ";
char s_sEnterElementsOfTwoDArray[] = "Enter elements of two-D array";
char s_sFindElementOfTwoDArray[] = "Find element of two-D array";
char s_sEnterRowNumber[] = "Enter row number: ";
char s_sEnterColNumber[] = "Enter col number: ";

// Math
int Pow(int number, int degree) {
    int result = 1;
        int index = 0;
        while(1) {
            if(index >= degree) break;
            result *= number;
        }
        return result;
}
// char impl
int Char_IsDigit(char* self) {
    int result = 1;
    char symbol = *self;
    if(symbol < DIGIT_ZERO) result = 0;
    if(symbol > DIGIT_NINE) result = 0;
    return result;
}


struct Allocator {
    unsigned capacity;
    void* buffer;
    unsigned typeSize;
};

Allocator Allocator_Default(unsigned capacity, unsigned typeSize) {
    struct Allocator self = {.capacity=capacity, .buffer=0, .typeSize=typeSize};

    return self;
}
void* Allocator_At(Allocator* self, unsigned index) {
    return self->buffer + index * self->type_size;
}

void Allocator_Drop(Allocator* self) {

}

// string impl
struct String {
    int capacity;
    char* buffer;
};
String String_Default() {
    struct String str = {.capacity=0, .buffer=0};
    return str;
}
int String_Read(String* self) {
    return read(STDIN, self->buffer, self->capacity * sizeof(char));
}
int String_Write(String* const self) {
    return write(STDOUT, self->buffer, self->capacity * sizeof(char));
}
int String_GetLength(String* const self) {
    int index = 0;
    while(1) {
        if(self->buffer[index] == NULL_CHARACTER) break;
        ++index;
    }
    return index;
}
int String_ToInteger(String* const self, int* number) {
    int resultNumber = 0;
    int result = 0;
    int len = String_GetLength(self);
    if(len == 0) return result;

    char symbol = 0;
    int index = 0;

    int degreeIndex = len;
    --degreeIndex;

    int addDegreed = 0;

    int isNegative = 0;

    if(self->buffer[0] == PLUS_SIGN) {
        ++index;
        --degreeIndex;
    }
    if(self->buffer[0] == HYPHEN) {
        ++index;
        --degreeIndex;
        isNegative = 1;
    }
    while(1) {
        symbol = self->buffer[index];
        if(symbol == LINE_FEED) break;
        if(symbol == NULL_CHARACTER) break;
        if(!Char_IsDigit(&symbol)) {
            result = 1;
            break;
        }
        if(index >= len) break;
        addDegreed = Pow(10, degreeIndex);
        char digit = symbol - DIGIT_ZERO;
        addDegreed *= digit;
        resultNumber += addDegreed;
        ++index;
        --degreeIndex;
    }
    if(isNegative == 1) {
        int positive = resultNumber;
        resultNumber = -positive;
    }
    return result;
}
void String_Clear(String* self) {
    int index = 0;
    while(1) {
        if(index >= self->capacity) break;
        self->buffer[i] = 0;
        ++index;
    }
}
void String_Drop(String* self) {

}

int OnSetSizeOfOneDArray(int* arr, int* sizeOneD) {

}

int SetSizeOfOneDArray(char* buffer, int bufferSize, int* arr, int* sizeOneD) {
    int resultCode = String_Read(buffer, bufferSize * sizeof(char));
    if(!result) {
        result = String_ToInteger(buffer, sizeOneD);
        if(!result) {

        }
    }
    OnReturnClearBuffer(buffer, bufferSize, resultCode);
}

int EnterElementsOfOneDArray(char* buffer, int bufferSize, int* arr, int arrSize) {
    int index = 0;
    while(1) {
        if(index >= arrSize) break;
        if(!String_Read(buffer, bufferSize)) return 0;


        ++index;
    }
}

int main() {
    int sizeOfOneDArray = 0;
    int* oneDArray = 0;

    int** twoDArray = 0;
    int cols = 0;
    int rows = 0;



    SetSizeOfOneDArray(s_sInputBuffer, INPUT_BUFFER_SIZE, &sizeOfOneDArray);
    return 0;
}


