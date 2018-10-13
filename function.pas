program funcao;

function fatorial(n:integer):integer;

var 
	contaProc :integer;
	ind:integer;
begin
	conta:=1;
	for ind:= 1 to n do
	begin
		conta:= conta*(ind);
	end;
	fatorial := contaProc;
end;

{Programa principal}

var
	n:integer;
	conta:integer;
begin
	writeln('informe de qual número deseja fazer o fatorial');
	readln(n);
	conta:=fatorial(n);
	writeln('o fatorial é: ',conta);
end.
