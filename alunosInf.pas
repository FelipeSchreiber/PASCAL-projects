program alunoInf;

procedure contas(n1 , n2 : integer ; var resto , quo : integer);

begin
	resto:=n2-n1;
	quo:=1;
	while resto>=n2 do
		begin
			resto:= n2-resto;
			quo:=quo+1;
		end;
end;
{programa principal}
 var
	a,b:integer;
	qu:integer;
	rest:integer;
begin
	writeln('quais números deseja dividir?');
	readln(a,b);
	contas(a,b,rest,qu);
	writeln(' o quociente é:',qu);
	writeln(' o resto é:', rest);

	
end.
