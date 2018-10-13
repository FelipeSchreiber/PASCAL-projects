program nImpares;
 	
VAR

	resto:real;
	fat,	n, op, contador:longint;
	
begin
	
	while op<>4  do
	begin
	writeln('1-mostrar os números ímpares');
	writeln('2-PIM');
	writeln('3-Fatorial');
	writeln('4-Sair');
	writeln;
	writeln('informe a opção que deseja');
	readln(op);
	case op of
	1:	
	begin 
	writeln('informe até que número deseja verificar: ');
	readln(n);
	for contador:= 1 to n do
		begin
			resto:=contador mod 2;	
			if (resto<>0) then
			begin
				writeln('o número ',contador,' é ímpar')
			end;
		end;
	end; 
	2:
	begin
		writeln('até que número deseja fazer o PIM');
		readln(n);
		contador:=1;
		repeat
		begin
			resto:=contador mod 4;
			if (resto = 0) then
			begin
				resto:=contador mod 6;
					if (resto= 0) then
						writeln(contador)
					else
						writeln('PIM');
			end
			else
				writeln(contador);
		end;
			contador:=contador + 1;
		until ( contador = n+1);
	end;
	3:
	begin
		writeln('deseja fazer o fatorial de qual número?');
		readln(n);
		contador:=n;
		fat:=1;
			while (contador >=n) do
			begin
				fat:=contador*fat;
				contador:=contador - 1;					
			end;
		writeln(fat);
	end;
	4:
	begin
		
	end;

	end;



end;
end.
