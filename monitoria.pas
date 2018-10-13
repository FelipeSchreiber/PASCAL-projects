program m;

type
	matrix = array [1..4,1..3] of integer;

procedure preencher(var matriz:matrix);

var 
	contc,contl:integer;

begin
	for contc:=1 to 3 do
	begin
		for contl:=1 to 4 do
		begin
			matriz[contl,contc]:=0;
		end;
	end;
end;
procedure ordenar(matriz:matrix);
var 
lin,col:integer;

begin 
	 for lin:=1 to 4 do
	 begin	
		for col:=1 to 3 do
		begin
			write(matriz[lin,col],' ');
		end;
	writeln();
	end;
end;
var
	A:matrix;
  
BEGIN
	preencher(A);
	ordenar(A);		
END.
			
									 	
