program vector;
const
	TAM=100;
type
	vetorInt=array[1..TAM] of integer;
	matrizInt=array[1..TAM,1..TAM] of integer;

procedure zerarVetor(var vetPR:vetorInt;dimenVec:integer);
var
	ind:integer;
         Begin
            For ind:=1 to dimenVec do
            Begin
               vetPR[ind]:=0;
            End;
         End;
procedure zerarMat(var matPR:matrizInt;dimenMat:integer);
var
indlin,indcol:integer;

	begin
		For indlin:=1 to dimenMat do
		begin
			For indcol:=1 to dimenMat do
			begin
				matPR[indlin,indcol]:=0;
			end;
		end;
	end;
procedure print_vet( vetPrin:vetorInt ; max:integer);
var
ind:integer;
	BEGIN
		for ind:=1 to max do
		begin
			write(vetPrin[ind]);
		end; 
		writeln();
	END;

procedure print_mat( matPrin:matrizInt; max:integer);
var
i,j:integer;
BEGIN
	for i:=1 to max do
	begin
		for j:=1 to max do
		begin
			write(matPrin[i,j]:6);
		end;
		writeln();
	end;
END;

procedure preencher_vetor( var vet_preencher:vetorInt; max:integer);
var
ind,valor:integer;

begin
	for ind:=1 to max do
	begin
		writeln('qual o valor na posiçao', ind);
		readln(valor);
		vet_preencher[ind]:=valor;
	end;
end;
procedure preencher_mat(var mat_preencher:matrizInt;max:integer);
var
i,j:integer;
valor:integer;
begin
	for i:=1 to max do
	begin
		for j:=1 to max do
		begin
			writeln('qual o valor na posiçao ',i ,',', j);
			readln(valor);
			mat_preencher[i,j]:=valor;
		end;
	end;
end;
procedure trans_mat(var mat_trans:matrizInt;max:integer);
var
i,j:integer;
aux:matrizInt;
Begin
	for i:=1 to max do
	begin
		for j:=1 to max do
		begin
			aux[i,j]:= mat_trans[i,j];
		end;
	end;
	
	for i:=1 to max do 
	begin
		for j:=1 to max do
		begin
			mat_trans[i,j]:=aux[j,i];
			write(mat_trans[i,j]:4);
		end;
		writeln();
	end;
End;
 			{PROGRAMA PRINCIPAL}
VAR
	option,dimenVec,dimenMat:integer;
	matPP:matrizInt;
	vetPP:vetorInt;
	choice:char;
BEGIN
	 Writeln('informe a dimensão do vetor');
      Readln(dimenVec);
      Writeln('informe a dimensão da matriz');
      Readln(dimenMat);
	option:=0;
	while( option <> 8) do
	begin
		
		Writeln ('escolha 1 opção');
		Writeln('1-zerar vetor');
		Writeln('2-zerar matriz');
		Writeln('3-imprimir vetor');
		writeln('4-imprimir matriz');
		writeln('5-preencher vetor');
		writeln('6-preencher matriz');
		writeln('7-fazer a transposta');
		writeln('8-sair');
		readln(option);
			
		Case option of
		
		1 : zerarVetor( vetPP,dimenVec);
		
		2 : zerarMat (  matPP,dimenMat);		

		3 : print_vet( vetPP,dimenVec);		

		4 : print_mat( matPP,dimenMat);				

		5: preencher_vetor( vetPP, dimenVec);

		6 : preencher_mat( matPP, dimenMat);

		7 : trans_mat( matPP, dimenMat);						
		8:
			begin
				writeln('tem certeza que deseja sair?');
				writeln('se sim digite s, se não digite n');
				readln(choice);
				if (choice='n') then
				begin
					option := 0;
				end;
		end; //end case
	end;

end;
END.
