#include <stdio.h>
#include <unistd.h>

char s_sSetSizeOfOneDArray[] = "Set size of one-D array";
char s_sSetOneDArray[] = "Set one-D array";
char s_sShowOneDArray[] = "Show one-D array";
char s_sFindMinElementOfOneDArray[] = "Find min element of one-D array";
char s_sFindMaxElementOfOneDArray[] = "Find max element of one-D array";
char s_sFindSumOfOneDArray[] = "Find sum of one-D array";
char s_sSetSizeOfTwoDArray[] = "Set size of two-D array";
char s_sEnterNumberOfRowsOfTwoDArray[] = "Enter number of rows of two-D array: ";
char s_sEnterNumberOfColsOfTwoDArray[] = "Enter number of cols of two-D array: ";
char s_sFindElementOfTwoDArray[] = "Find element of two-D array";
char s_sEnterRowNumber[] = "Enter row number: ";
char s_sEnterColNumber[] = "Enter col number: ";

#define STDIN 0
#define STDOUT 1

#define NULL_CHARACTER 0
#define LINE_FEED 10
#define PLUS_SIGN 43
#define HYPHEN 45
#define DIGIT_ZERO 48
#define DIGIT_NINE 57

#define INPUT_BUFFER_SIZE 9
char inputBuffer[INPUT_BUFFER_SIZE];

int Pow(int number, int degree) {
    int result = 1;
    int index = 0;
    while(1) {
        if(index >= degree) break;
        result *= number;
        ++index;
    }
    return result;
}

int IsDigit(char symbol) {
    int result = 1;
    if(symbol < DIGIT_ZERO) result = 0;
    if(symbol > DIGIT_NINE) result = 0;
    return result;
}

int Strlen(char* buffer, char endCharacter) {
    int index = 0;
    while(1) {
        if(buffer[index] == endCharacter) break;
        ++index;
    }
    return index;
}

int ConvertStringToInteger(char* buffer, int* number) {
    *number = 0;
    int result = 1;
    int len = Strlen(buffer, NULL_CHARACTER);
    if(len == 0) return result;

    char symbol = 0;
    int index = 0;

    int degreeIndex = len;
    --degreeIndex;

    int addDegreed = 0;

    int isNegative = 0;

    if(buffer[0] == PLUS_SIGN) {
        ++index;
        --degreeIndex;
    }
    if(buffer[0] == HYPHEN) {
        ++index;
        --degreeIndex;
        isNegative = 1;
    }
    while(1) {
        symbol = buffer[index];
        if(symbol == LINE_FEED) break;
        if(symbol == NULL_CHARACTER) break;
        if(!IsDigit(symbol)) {
            result = 0;
            break;
        }
        if(index >= len) break;
        addDegreed = Pow(10, degreeIndex);
        char digit = symbol - DIGIT_ZERO;
        addDegreed *= digit;
        *number += addDegreed;
        ++index;
        --degreeIndex;
    }
    if(isNegative == 1) {
        int positive = *number;
        *number = -positive;
    }
    return result;
}

int SetSizeOfOneDArray(char* buffer, int bufferSize, int* sizeOneD) {
    if(!read(STDIN, buffer, bufferSize * sizeof(char))) return 0;
    return ConvertStringToInteger(buffer, sizeOneD);
}

int main() {
    int sizeOfOneDArray = 0;
    int* oneDArray = 0;

    int** twoDArray = 0;
    int cols = 0;
    int rows = 0;

    SetSizeOfOneDArray(inputBuffer, INPUT_BUFFER_SIZE, &sizeOfOneDArray);
    return 0;
}
