t Metoda;
interface
uses
Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
StdCtrls, ComCtrls, Grids, Buttons;
type
TForm1 = class(TForm)
RichEdit1: TRichEdit;
Edit1: TEdit;
StringGrid1: TStringGrid;
Label1: TLabel;
BitBtn1: TBitBtn;
BitBtn2: TBitBtn;
BitBtn3: TBitBtn;
BitBtn4: TBitBtn;
Edit2: TEdit;
Label2: TLabel;
Button1: TButton;
Button2: TButton;
Label3: TLabel;
procedure Edit1Change(Sender: TObject);
procedure w_lewo(Sender: TObject);
procedure w_prawo(Sender: TObject);
procedure FormCreate(Sender: TObject);
procedure do_gory(Sender: TObject);
procedure na_dol(Sender: TObject);
procedure Button1Click(Sender: TObject);
procedure Oblicz_1(Sender: TObject);
procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
var CanSelect: Boolean);
private
{ Private declarations }
public
{ Public declarations }
end;
var
Form1: TForm1;
a,b,c,n:Integer;
prawo: Integer=1;
gora: Integer=1;
MA: Array of Array of real;
MB, MY, MX, MU: Array of real;
 
implementation
 
{$R *.DFM}
procedure OBLICZ(var blad:Byte);
var i,j:Integer;
s:    Real;
begin
SetLength(MY,n+1); SetLength(MU,n+1);  SetLength(MX,n+1);  //ustawienie tablic dynamicznych
for i:=1 to n do     //sprawdzenie czy macierz jest diagonalnie dominująca
begin
s:=0;
for j:=1 to n do
begin
if i=j then continue;
s:=s+Abs(MA[i,j]);
end;
if s>Abs(MA[i,i]) then begin blad:=1; exit; end;
end;
if MA[1,1]=0 then begin blad:=1; exit; end;
MY[1]:=MB[1]/MA[1,1];
MU[1]:=MA[1,2]/MA[1,1];
//obliczenie wektora U
for i:=2 to n-1 do MU[i]:=MA[i,i+1]/(MA[i,i]-(MU[i-1]*MA[i,i-1]));
//obliczenie wektora Y
for i:=2 to n do MY[i]:=(MB[i]-MA[i,i-1]*MY[i-1])/(MA[i,i]-MU[i-1]*MA[i,i-1]);
//Obliczenie ostatecznego wyniku
MX[n]:=MY[n];
for i:=n-1 downto 1 do MX[i]:=MY[i]-(MU[i]*MX[i+1]);
Finalize(MY); Finalize(MU);
end;
 
procedure TForm1.FormCreate(Sender: TObject);
begin
RichEdit1.Clear;
StringGrid1.Col:=1;
StringGrid1.Row:=1;
Edit1Change(Form1);
end;
 
//Zrobienie siatki i ustawienie tablic dynamicznych
procedure TForm1.Edit1Change(Sender: TObject);
var i,j:Integer;
begin
Finalize(MA); Finalize(MB);
n:=StrToInt(Edit1.Text);
StringGrid1.ColCount:=n+2;
StringGrid1.RowCount:=n+1;
SetLength(MA, n+1, n+1);
SetLength(MB, n+1);
for i:=0 to n+2 do for j:=1 to n+1 do StringGrid1.Cells[i,j]:='';
for i:=1 to n do StringGrid1.Cells[i,0]:='x'+IntToStr(i);
for i:=1 to n do StringGrid1.Cells[0,i]:='rownanie '+IntToStr(i);
StringGrid1.Cells[n+1,0]:='b'
end;
 
//Nawigacja
procedure TForm1.w_lewo(Sender: TObject);
begin
if prawo>1 then
begin
prawo:=prawo-1;
StringGrid1.Col:=prawo;
StringGrid1.Row:=gora;
end;
end;
procedure TForm1.w_prawo(Sender: TObject);
begin
if prawo<n+1 then
begin
prawo:=prawo+1;
StringGrid1.Col:=prawo;
StringGrid1.Row:=gora;
end;
end;
procedure TForm1.do_gory(Sender: TObject);
begin
if gora>1 then
begin
gora:=gora-1;
StringGrid1.Col:=prawo;
StringGrid1.Row:=gora;
end;
end;
procedure TForm1.na_dol(Sender: TObject);
begin
if gora<n then
begin
gora:=gora+1;
StringGrid1.Col:=prawo;
StringGrid1.Row:=gora;
end;
end;
procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol,
ARow: Integer; var CanSelect: Boolean);
begin
if (ARow>0) and (ACol>0) then
begin
prawo:=ACol;   gora:=ARow;
end;
end;
 
//wpis
procedure TForm1.Button1Click(Sender: TObject);
var i:Integer;
begin
if (prawo>gora+1) and (prawo<>n+1)then begin ShowMessage('Macierz musi by trójdiagonalna'); Exit; end;
if (prawo<gora-1) and (prawo<>n+1) then begin ShowMessage('Macierz musi by trójdiagonalna'); Exit; end;
if prawo=n+1 then Val(Edit2.Text,MB[gora],i) Else Val(Edit2.Text,MA[gora,prawo],i);
if i<>0 then ShowMessage('Blad podczas wpisu') Else StringGrid1.Cells[prawo,gora]:=Edit2.Text;
end;
 
//wpisanie rozwiazania do Rich Edit'a
procedure TForm1.Oblicz_1(Sender: TObject);
var i,j:Integer;
tmp: String;
blad: Byte;
begin
RichEdit1.Clear;
RichEdit1.Lines.Add('Uklad '+IntToStr(n)+' rownan z '+IntToStr(n)+' niewiadomymi: ');
RichEdit1.Lines.Add('*****************************************************');
for i:=1 to n do
begin
tmp:='';
for j:=1 to n do
if MA[i,j]=0 then continue Else
if (MA[i,j]>0) and (j<>1) then tmp:=tmp+' + '+FloatToStr(MA[i,j])+'x'+IntToStr(j) Else tmp:=tmp+' '+FloatToStr(MA[i,j])+'x'+IntToStr(j);
tmp:=tmp+' = '+FloatToStr(MB[i]);
RichEdit1.Lines.Add(tmp);
end;
OBLICZ(blad);
Form1.RichEdit1.Lines.Add('*************ROZWIĄZANIE***************');
if blad=1 then Form1.RichEdit1.Lines.Add('Macierz nie jest diagonalnie dominujaca');
if blad=2 then Form1.RichEdit1.Lines.Add('Macierz nie jest dodatnio okreslona');
if blad=0 then for i:=1 to n do Form1.RichEdit1.Lines.Add('x'+IntToStr(i)+' = '+FloatToStr(MX[i]));
end;
end.
