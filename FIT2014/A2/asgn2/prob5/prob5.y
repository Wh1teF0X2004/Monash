/*  yacc  file for PLUS-TIMES-POWER expressions, for copying and then
    modification (of the copy) to make a calculator for quantum
    expressions.
    It already contains C functions for use by that calculator.
    Graham Farr, Monash University
    Last updated:  11 September 2023
*/

        /*   declarations   */


%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <limits.h>
#include "quant.h"
int yylex(void);
void yyerror(char *);
int yydebug=0;   /*  set to 1 if using with yacc's debug/verbose flags   */
int  printMatrix(Matrix x);
Matrix  identity();
Matrix  had();
Matrix  pauliX();
Matrix  pauliZ();
Matrix  cNot();
Matrix  toffoli();
Matrix  productMxMx(Matrix a, Matrix b);
Matrix  kroneckerProductMx(Matrix a, Matrix b);
int  printRegister(Register x);
Register  ket0();
Register  ket1();
Register  productMxReg(Matrix a, Register v);
Register  kroneckerProductReg(Register v, Register w);
%}

%union {
    int  iValue;
    char *str;
    Matrix  qmx;
    Register  qreg;
    double num;
};

%token  <str>  k0
%token  <str>  k1
%token  <str>  I
%token  <str>  H
%token  <str>  X
%token  <str>  Z
%token  <str>  CNOT
%token  <str>  TOF
%token  <str>  KRONECKERPROD

%left '*'
%left KRONECKERPROD

%type <qmx> start
%type <qmx> expr
%type <qmx> line
%type <qmx> regs
%type <qreg> expt
%type <qreg> rgst

%start  start

%%       /*   rules section   */



start    :    line  '\n'       {  }
         |    start  line  '\n'          {  }
         ;

line     :    expr   {  printMatrix($1);   }
         |    expt   {  printRegister($1);  }
         |    /*  allow "empty" expression  */           {     }
         ;

expr     :    regs { $$ = $1; }
         |    expr '*' expr    {  $$ = productMxMx($1, $3);  }
         |    '(' expr ')'    {  $$ = $2;  }
         |    expr KRONECKERPROD expr    {  $$ = kroneckerProductMx($1, $3);  }
         ;

expt     :    rgst { $$ = $1; }
         |    expr '*' expt    {  $$ = productMxReg($1, $3);  }
         |    '(' expt ')'    {  $$ = $2;  }
         |    expt KRONECKERPROD expt    {  $$ = kroneckerProductReg($1, $3);  }
         ;

regs     :    I    { $$ = identity(); }
         |    H    { $$ = had(); }
         |    X    { $$ = pauliX(); }
         |    Z    { $$ = pauliZ(); }
         |    CNOT    {  $$ = cNot();  }
         |    TOF    {  $$ = toffoli();  }
         ;

rgst     :    k0    { $$ = ket0(); }
         |    k1    { $$ = ket1(); }
         ;

%%      /*   programs   */



int  printMatrix(Matrix a)
/*  print the matrix  a  */
{
  int  printfReturnValue;
  int  sumPrintfReturnValue = 0;
  int  minPrintfReturnValue = INT_MAX;
  int  n = 1<<a.dim;

  if  (a.dim == -1)
  {
    return  printf("Undefined matrix product used.\n");
  }

  printfReturnValue = printf("%dx%d matrix:\n", n, n);
  sumPrintfReturnValue += printfReturnValue;
  minPrintfReturnValue = (printfReturnValue < minPrintfReturnValue ?
                          printfReturnValue : minPrintfReturnValue);
  for  (int i=0; i<n; i++)
  {
    for  (int j=0; j<n; j++)
    {
      printfReturnValue = printf("  %9.6lf", a.mx[i][j]);
      sumPrintfReturnValue += printfReturnValue;
      minPrintfReturnValue = (printfReturnValue < minPrintfReturnValue ?
                              printfReturnValue : minPrintfReturnValue);
    }
    printfReturnValue = printf("\n");
    sumPrintfReturnValue += printfReturnValue;
    minPrintfReturnValue = (printfReturnValue < minPrintfReturnValue ?
                            printfReturnValue : minPrintfReturnValue);
  }
  if  (minPrintfReturnValue < 0)
  {
    return  minPrintfReturnValue;
  }
  else
  {
    return  sumPrintfReturnValue;
  }
}


Matrix  identity()
/*  returns the 2x2 identity matrix ((1 0) (0 1))
*/
{
  Matrix  id;
  double  idmx[2][2] = {
                        { 1.0,  0.0 },
                        { 0.0,  1.0 }
                      };

  id.dim = 1;
  id.mx = malloc(2*sizeof(double*));
  id.mx[0] = malloc(2*sizeof(double));
  id.mx[1] = malloc(2*sizeof(double));
  id.mx[0][0] = idmx[0][0];
  id.mx[0][1] = idmx[0][1];
  id.mx[1][0] = idmx[1][0];
  id.mx[1][1] = idmx[1][1];

  return  id;
}


Matrix  had()
/*  returns the 2x2 Hadamard matrix (1/sqrt(2)) * ((1 1) (1 -1))
*/
{
  Matrix  h;
  double  hmx[2][2] = {
                        { 1./sqrt(2),  1./sqrt(2) },
                        { 1./sqrt(2), -1./sqrt(2) }
                      };

  h.dim = 1;
  h.mx = malloc(2*sizeof(double*));
  h.mx[0] = malloc(2*sizeof(double));
  h.mx[1] = malloc(2*sizeof(double));
  h.mx[0][0] = hmx[0][0];
  h.mx[0][1] = hmx[0][1];
  h.mx[1][0] = hmx[1][0];
  h.mx[1][1] = hmx[1][1];

  return  h;
}


Matrix  pauliX()
/*  returns the 2x2 Pauli X matrix ((0 1) (1 0))
*/
{
  Matrix  x;
  double  xmx[2][2] = {
                        { 0.0,  1.0 },
                        { 1.0,  0.0 }
                      };

  x.dim = 1;
  x.mx = malloc(2*sizeof(double*));
  x.mx[0] = malloc(2*sizeof(double));
  x.mx[1] = malloc(2*sizeof(double));
  x.mx[0][0] = xmx[0][0];
  x.mx[0][1] = xmx[0][1];
  x.mx[1][0] = xmx[1][0];
  x.mx[1][1] = xmx[1][1];

  return  x;
}


Matrix  pauliZ()
/*  returns the 2x2 Pauli Z matrix ((1 0) (0 -1))
*/
{
  Matrix  z;
  double  zmx[2][2] = {
                        { 1.0,  0.0 },
                        { 0.0, -1.0 }
                      };

  z.dim = 1;
  z.mx = malloc(2*sizeof(double*));
  z.mx[0] = malloc(2*sizeof(double));
  z.mx[1] = malloc(2*sizeof(double));
  z.mx[0][0] = zmx[0][0];
  z.mx[0][1] = zmx[0][1];
  z.mx[1][0] = zmx[1][0];
  z.mx[1][1] = zmx[1][1];

  return  z;
}


Matrix  cNot()
/*  returns the 4x4 matrix of the CNOT gate
*/
{
  Matrix  c;
  double  cmx[4][4] =
      { {1.0, 0.0, 0.0, 0.0},
        {0.0, 1.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 1.0},
        {0.0, 0.0, 1.0, 0.0},
      };

  c.dim = 2;
  c.mx = malloc(4*sizeof(double*));
  for  (int i=0; i<4; i++)
  {
    c.mx[i] = malloc(4*sizeof(double));
    for  (int j=0; j<4; j++)
    {
      c.mx[i][j] = cmx[i][j];
    }
  }

  return  c;
}


Matrix  toffoli()
/*  returns the 8x8 matrix of the Toffoli gate
*/
{
  Matrix  t;
  double  tmx[8][8] =
      { {1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0}
      };

  t.dim = 3;
  t.mx = malloc(8*sizeof(double*));
  for  (int i=0; i<8; i++)
  {
    t.mx[i] = malloc(8*sizeof(double));
    for  (int j=0; j<8; j++)
    {
      t.mx[i][j] = tmx[i][j];
    }
  }

  return  t;
}


Matrix  productMxMx(Matrix a, Matrix b)
/*  multiply two square matrices representing quantum circuits  */
{
  Matrix c;
  int  n = 1<<a.dim;
  double  sum;

  if  (a.dim == b.dim && a.dim >= 0)
  {
    c.dim = a.dim;
    c.mx = malloc(n*sizeof(double*));
    for  (int i=0; i<n; i++)
    {
      c.mx[i] = malloc(n*sizeof(double));
      for  (int j=0; j<n; j++)
      {
        sum = 0.0;
        for  (int k=0; k<n; k++)
        {
          sum += a.mx[i][k] * b.mx[k][j];
        }
        c.mx[i][j] = sum;
      }
    }
  }
  else   /*  matrix product undefined   */
  {
    c.dim = -1;
    c.mx = malloc(sizeof(double*));
  }

  return  c;
}


Matrix  kroneckerProductMx(Matrix a, Matrix b)
/*  compute the Kronecker product of two square matrices representing
    quantum circuits
*/
{
  Matrix c;
  int  na;
  int  nb;
  int  n;

  if  (a.dim >= 0 && b.dim >= 0)
  {
    na = 1<<a.dim;
    nb = 1<<b.dim;
    c.dim = a.dim+b.dim;
    n = 1<<c.dim;
    c.mx = malloc(n*sizeof(double*));
    for  (int ia=0; ia<na; ia++)
    {
      for  (int ib=0; ib<nb; ib++)
      {
        c.mx[ia*nb+ib] = malloc(n*sizeof(double));
        for  (int ja=0; ja<na; ja++)
        {
          for  (int jb=0; jb<nb; jb++)
          {
            c.mx[ia*nb+ib][ja*nb+jb] = a.mx[ia][ja] * b.mx[ib][jb];
          }
        }
      }
    }
  }
  else   /*  at least one of  a, b  is undefined   */
  {
    c.dim = -1;
    c.mx = malloc(sizeof(double*));
  }

  return  c;
}


int  printRegister(Register v)
/*  print the register  v  */
{
  int  printfReturnValue;
  int  sumPrintfReturnValue = 0;
  int  minPrintfReturnValue = INT_MAX;
  int  n = 1<<v.dim;

  if  (v.dim == -1)
  {
    return  printf("Undefined product used.\n");
  }

  printfReturnValue = printf("%d-qubit register, %d-element vector:\n", v.dim, n);
  sumPrintfReturnValue += printfReturnValue;
  minPrintfReturnValue = (printfReturnValue < minPrintfReturnValue ?
                          printfReturnValue : minPrintfReturnValue);
  for  (int i=0; i<n; i++)
  {
      printfReturnValue = printf("  %9.6lf\n", v.reg[i]);
      sumPrintfReturnValue += printfReturnValue;
      minPrintfReturnValue = (printfReturnValue < minPrintfReturnValue ?
                              printfReturnValue : minPrintfReturnValue);
  }
  if  (minPrintfReturnValue < 0)
  {
    return  minPrintfReturnValue;
  }
  else
  {
    return  sumPrintfReturnValue;
  }
}


Register  ket0()
/*  returns the column vector with entries  ( 1 0 ),  representing
    the elementary register with one qubit often denoted by  |0>,
    treated as an array of two elements indexed by 0 & 1.
*/
{
  Register  v;

  v.dim = 1;
  v.reg = malloc(2*sizeof(double));
  v.reg[0] = 1.0;
  v.reg[1] = 0.0;

  return  v;
}


Register  ket1()
/*  returns the column vector with entries  ( 0 1 ),  representing
    the elementary register with one qubit often denoted by  |1>,
    treated as an array of two elements indexed by 0 & 1.
*/
{
  Register  v;

  v.dim = 1;
  v.reg = malloc(2*sizeof(double));
  v.reg[0] = 0.0;
  v.reg[1] = 1.0;

  return  v;
}


Register  productMxReg(Matrix a, Register v)
/*  multiply the matrix  a, representing a quantum circuit, by the
    vector  v, representing a quantum register.
*/
{
  Register  u;
  int  n = 1<<a.dim;
  double  sum;

  if  (a.dim == v.dim && a.dim >= 0)
  {
    u.dim = a.dim;
    u.reg = malloc(n*sizeof(double));
    for  (int i=0; i<n; i++)
    {
        sum = 0.0;
        for  (int k=0; k<n; k++)
        {
          sum += a.mx[i][k] * v.reg[k];
        }
        u.reg[i] = sum;
    }
  }
  else   /*  matrix product undefined   */
  {
    u.dim = -1;
    /*u.reg = malloc(sizeof(double*));*/
  }

  return  u;
}


Register  kroneckerProductReg(Register v, Register w)
/*  compute the Kronecker product of two vectors representing
    quantum registers
*/
{
  Register  u;
  int  nv;
  int  nw;
  int  n;

  if  (v.dim >= 0 && w.dim >= 0)
  {
    nv = 1<<v.dim;
    nw = 1<<w.dim;
    u.dim = v.dim+w.dim;
    n = 1<<u.dim;
    u.reg = malloc(n*sizeof(double));
    for  (int iv=0; iv<nv; iv++)
    {
      for  (int iw=0; iw<nw; iw++)
      {
        u.reg[iv*nw+iw] = v.reg[iv] * w.reg[iw];
      }
    }
  }
  else   /*  at least one of  v, w  is undefined   */
  {
    u.dim = -1;
/*    u.reg = malloc(sizeof(double));*/
  }

  return  u;
}




/*
void yyerror(char *s) {
      fprintf(stderr, "%s\n", s);
      fprintf(stderr, "line %d: %s\n", yylineno, s);
}
*/


int main(void) {
    yyparse();
    return 0;
}
