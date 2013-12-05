#include <stdlib.h>
#include <stdio.h>
#include <string.h>


void align(FILE *file, FILE  *out){
    char words[1024];
    char *next_word = words;

    size_t total_length = 0;
    size_t num_words = 0;

    fscanf(file, "%s", next_word);
    int column_size = atoi(next_word);	

    while(fscanf(file, "%s", next_word) == 1){
        size_t word_length = strlen(next_word);
	next_word += word_length + 1;//1 for newline character
        ++num_words;

	total_length += word_length;

        if(total_length + num_words > column_size){

            size_t need_spaces = column_size - (total_length - word_length);

            int min_spaces = 1;
            if(num_words > 2) // check if two words fit on a line
                min_spaces = need_spaces / (num_words - 2);

            char * word_print = words;

            size_t chars_printed = fprintf(out, "%s",word_print);
            word_print += strlen(word_print) + 1;//newline character
            size_t spaces_printed = 0;
            size_t words_to_print = num_words - 2;

            fflush(out);//flush out buffer

            while(words_to_print > 0){
                int spaces_to_print = min_spaces;//=1
                if(((need_spaces - spaces_printed) % words_to_print) * 2 >=
words_to_print) // spreads spaces out along the line
                    ++spaces_to_print;
                spaces_printed += spaces_to_print;
                --words_to_print;
                chars_printed += fprintf(out, "%*c%s", spaces_to_print, ' ',
word_print);//print char string
                word_print += strlen(word_print) + 1;
                fflush(out);
            }
            fprintf(out, "\n");

            memmove(words, word_print, (total_length = strlen(word_print)) + 1);
            num_words = 1;
            next_word = words + total_length + 1;//1 for newline character
        }
    }

    char *word_print = words;
    while(word_print != next_word){
        word_print += fprintf(out, "%s ", word_print);
    }

    fprintf(out, "\n");
}

int main(int argc, char **argv){
    FILE *file = stdin;

    file = fopen(argv[1], "r");//first argument is the filename
    
    if(argc < 2){
	printf("please enter a filename\n");
	printf("[program name] [filename]\n");
	return -1;
    }

    align(file, stdout);//set stdout to FILE *out
}
