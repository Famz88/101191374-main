#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int n;
    do
    {
        //take user input
        n = get_int("Height: ");
    }
    while (n < 1 || n > 8);

    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            // Add blankspaces
            if (i + j < n - 1)
            {
                printf(" ");
            }
            else
            {
                // print hashes #
                printf("#");
            }
        }
        //To insert a new line
        printf("\n");
    }
}