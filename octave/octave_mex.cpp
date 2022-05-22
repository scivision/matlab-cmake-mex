#include <iostream>
#include <oct.h>


// https://octave.org/doc/latest/Standalone-Programs.html
int main()
{
int n = 2;

Matrix a_matrix = Matrix (n, n);
for (octave_idx_type i = 0; i < n; i++)
  {
    for (octave_idx_type j = 0; j < n; j++)
      {
        a_matrix (i, j) = (i + 1) * 10 + (j + 1);
      }
  }

std::cout << "OK: Octave C++" << std::endl;

return 0;
}
