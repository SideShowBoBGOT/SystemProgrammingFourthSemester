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

extern void asm_main();


int main() {
    //asm_main();
    int arr[] = {9, 8, 7, 6, 5, 4, 3, 2, 1, 0};
    for(int i=0;i<10;++i) {
        for(int j=i;j<10;++j) {
            if(arr[i] > arr[j]) {
                int temp = arr[j];
                arr[j] = arr[i];
                arr[i] = temp;
            }
        }
    }
    for(int i=0;i<10;++i) {
        printf("%i ", arr[i]);
    }
    return 0;
}


















