unit minhaBiblioteca;
{Biblioteca pertecente a Felipe Schreiber Fernandes
 DRE 116206990
 Última modificação: 14/12/2016}

Interface
CONST

ALFANUM='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
ALFABETO='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
SPACE=' ';
ESPECIAIS='@#$%&*!>:?<+=?/||\';
NUM='1234567890';

procedure abrirCriar(var arq:file);

function lerReal(MIN,MAX:real;msgm:string):real;

function lerInteiro(MIN,MAX:integer;msgm:string):integer;{-32677,+32676}

function lerLongint(MIN,MAX:longint;msgm:string):longint;

function lerString(MIN,MAX:integer;validos,msgm:string):string;{MAX 255 caracteres}

function lerChar(validos,msgm:string):char;


Implementation
uses crt;
function lerReal(MIN,MAX:real;msgm:string):real;

var
  num:real;
  correto:boolean;
begin
	correto:=false;
	repeat
		textcolor(lightblue);
		writeln(msgm);
		textcolor(white);
		{$I-}
		readln(num);
		{$I+}
		if (ioresult<>0) then
		begin
			correto:=false;
			textcolor(yellow);
			writeln(msgm);
			textcolor(white);
		end
		else
		begin

			if	(num<MIN) or (num>MAX) then
			begin

				correto:=false;
				if num<MIN then
				begin
					textcolor(red);
					writeln('o limite mínimo não foi respeitado, tente novamente');
					textcolor(white);
				end
				else
				begin
					textcolor(red);
					writeln('O limite máximo não foi respeitado');
					textcolor(white);
				end;

			end
			else
				correto:=true;
		end;

	until (correto);
	lerReal:=num;
end;

function lerInteiro(MIN,MAX:integer;msgm:string):integer;

var
  num:integer;
  correto:boolean;
begin
	correto:=false;
	repeat
		textcolor(lightblue);
		writeln(msgm);
		textcolor(white);
		{$I-}
		readln(num);
		{$I+}
		if (ioresult<>0) then
		begin
			correto:=false;
			textcolor(yellow);
			writeln(msgm);
			textcolor(white);
		end
		else
		begin
			if	(num<MIN) or (num>MAX) then
			begin
				correto:=false;
				if num<MIN then
				begin
					textcolor(red);
					writeln('o limite mínimo não foi respeitado, tente novamente');
					textcolor(white);
				end
				else
				begin
					textcolor(red);
					writeln('O limite máximo não foi respeitado');
					textcolor(white);
				end;
			end
			else
				correto:=true;
		end;
	until (correto);
	lerInteiro:=num;
end;

function lerLongint(MIN,MAX:longint;msgm:string):longint;

var
  num:longint;
  correto:boolean;
begin
	correto:=false;
	repeat
		textcolor(lightblue);
		writeln(msgm);
		textcolor(white);
		{$I-}
		readln(num);
		{$I+}
		if (ioresult<>0) then
		begin
			correto:=false;
			textcolor(yellow);
			writeln(msgm);
			textcolor(white);
		end
		else
		begin
			if	(num<MIN) or (num>MAX) then
			begin

				correto:=false;
				if num<MIN then
				begin
					textcolor(red);
					writeln('o limite mínimo não foi respeitado, tente novamente');
					textcolor(white);
				end
				else
				begin
					textcolor(red);
					writeln('O limite máximo não foi respeitado');
					textcolor(white);
				end;

			end
			else
				correto:=true;
		end;
	until (correto);
	lerLongint:=num;
end;

function lerString(MIN,MAX:integer; validos:string;msgm:string):string;

var

	temp:string;
	{variável que armazena temporariamente uma string}

	correto:boolean;

	indice:integer;

Begin

	repeat
	
		correto:=true;
		textcolor(lightblue);
		writeln(msgm);
		textcolor(white);
		readln(temp);
		if (length(temp)<MIN) or (length(temp)>MAX) then
		begin
			correto:=false;
			if (length(temp)) < MIN then
			begin
				textcolor(yellow);
				writeln('o limite de caracteres mínimo não foi respeitado, tente novamente');
				textcolor(white);
			end
			else
			begin
				textcolor(yellow);
				writeln('O limite máximo de caracteres não foi respeitado');
				textcolor(white);
			end;
		end
		else
		begin
			for indice:=1 to length(temp) do
			begin
				if pos(temp[indice],validos)=0 then
		{a função pos retorna a posição em que determinado caractere aparece na string de validos, se o caractere na posição indice não estiver dentro de validos, então a função retorna zero}
				begin
					textcolor(red);
					writeln('Você inseriu algum caractere não permitido');
					textcolor(white);
					correto:=false;
				end;
			end;{end do for}
		end;{end do else}
	until (correto);
	lerString:=temp;
End;

function lerChar(validos,msgm:string):char;
var
	temp:char;
	{variável que armazena temporariamente um char}
	correto:boolean;
Begin
	correto:=true;
	repeat
		textcolor(red);
		writeln(msgm);
		textcolor(white);
		temp:=readkey;
		if pos(temp,validos)=0 then
		{a função pos retorna a posição em que determinado caractere aparece na string de validos, se o caractere na posição indice não estiver dentro de validos, então a função retorna zero}
		begin
			correto:=false;
		end
		else
			correto:=true;
	until (correto);
	lerChar:=temp;
End;

procedure abrirCriar(var arq:file);
{Sempre dar reset no arquivo após executar esse procedimento e assign para não dar erros na tipagem do arquivo}
var
	option:char;
begin
	{$I-}
	reset(arq);
	{$I+}
	If (ioresult = 2) then
	begin
		rewrite(arq);
		textcolor(yellow);
		writeln('Um novo arquivo foi criado');
		textcolor(white);
	end
	else
	begin
		option:=lerChar('asAS','Esse arquivo já existe.Você deseja [A]brir ou [S]obrescrever?');
		option:=upcase(option);
		if option = 'S' then
		begin
			rewrite(arq);
			textcolor(red);
			Writeln('o arquivo foi sobrescrito');
			textcolor(white);
		end
		else
		begin
			textcolor(lightblue);
			writeln('o arquivo foi aberto');
			textcolor(white);
		end;
	end;
end;

end.{end da biblioteca}
