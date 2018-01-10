static void forcefloat(float *p)
{
float f = *p;
forcefloat(&f);
}
 
 
void main()
{
// Get n
printf("Metoda Jacobiego\n");
printf("Rozwiazywanie ukladu n-rownan z n-niewiadomymi Ax=b\n");
printf("Podaj n\n");
scanf("%d", &num);
if ((num < 1) && (num > 100)) {
printf("Nieprawidlowa warosc parametru n\n");
return;
}
 
// Get values of A
for (i=0; i<num; i++)
for (j=0; j<num; j++) {
printf("A[%d][%d] = ", (i+1), (j+1));
scanf("%f", &A[i][j]);
if ((i == j) && (A[i][j] == 0)){
printf("Wartosci na przekatnej musza byc rozne od 0\n");
return;
}
}
 
// Get values of b
for (i=0; i<num; i++) {
printf("b[%d] = ", (i+1));
scanf("%f", &b[i]);
}
 
// Calculate N = D^-1
for (i=0; i<num; i++)
N[i] = 1/A[i][i];
 
// Calculate M = -D^-1 (L + U)
for (i=0; i<num; i++)
for (j=0; j<num; j++)
if (i == j)
M[i][j] = 0;
else
M[i][j] = - (A[i][j] * N[i]);
 
//Initialize x
for (i=0; i<num; i++)
x1[i] = 0;
 
printf("Ile iteracji algorytmu wykonac?\n");
scanf("%d", &iter);
 
for (k=0; k<iter; k++) {
for (i=0; i<num; i++) {
x2[i] = N[i]*b[i];
for (j=0; j<num; j++)
x2[i] += M[i][j]*x1[j];
}
for (i=0; i<num; i++)
x1[i] = x2[i];
}
 
printf("Wynik\n");
for (i=0; i<num; i++)
printf("x[%d] = %f\n", (i+1), x1[i]);
 
return;
 
}
