program recorde;

type

cadastro=record
			nome:string;
			dre:integer;
			notas:array[1..3] of integer;
			medias:real;
			situacao:string;

end;

turma=array[1..50] of cadastro;

procedure iniciar_reg(var el1:turma);

var
	ind:integer;
	ind2:integer;

begin
	for ind:=1 to 50 do
	begin
		el1[ind].dre:=-1;
		el1[ind].nome:='linux';
			for ind2:=1 to 3 do
			el1[ind].notas[ind2]:=-1;
		el1[ind].medias:=-1;
		el1[ind].situacao:='hahahaha';
	end;
end;

procedure posicao_aluno(var posicao:integer; el1:turma);

var
	ind:integer;

begin
	ind:=1;
	repeat
		begin
			if el1[ind].nome <>'linux' then
			begin
				posicao:=posicao + 1;
				ind:=ind + 1;
			end;
		end;
	until el1[ind].nome = 'linux';
end;
		
procedure inserir_aluno(var el1:turma; posicao:integer);

var
	ind:integer;
	name:string;
	nota:array[1..3] of integer;

begin
	writeln('qual o seu nome?');
	readln(name);
	for ind:=1 to 3 do
	begin
		writeln('informe sua ', ind,'nota');
		readln(nota[ind]);
	end;
	el1[posicao].nome:=name;
	el1[posicao].dre:=posicao;
	el1[posicao].notas[1]:=nota[1];
	el1[posicao].notas[2]:=nota[2];
	el1[posicao].notas[3]:=nota[3];
	el1[posicao].medias:=(nota[1] + nota[2] + nota[3])/3;
	
	if el1[posicao].medias>=7 then
	begin
		el1[posicao].situacao:='aprovado';
	end
	else
	begin
		if el1[posicao].medias>=3 then
		begin
			el1[posicao].situacao:='em prova final';
		end
		else
		begin
			el1[posicao].situacao:='reprovado';
		end;
	end;
end;

function  identificar_posicao(el1:turma):integer;

var
	name:string;
	posicao:integer;

begin
	posicao:=1;
	writeln('qual o seu nome?');
	readln(name);
	repeat 
		if el1[posicao].nome <> name then
		begin
			posicao:=posicao + 1;
		end;
	until el1[posicao].nome = name;
	identificar_posicao:= posicao;
end;

procedure apagar_aluno(var el1:turma;posicao:integer);

var
	ind:integer;

begin
	{identificar posicao antes}
	el1[posicao].nome:='linux';
	el1[posicao].dre:=-1;
	for ind:=1 to 3 do
	begin
		 el1[posicao].notas[ind]:=0;
	end;
	el1[posicao].medias:=-1;
	el1[posicao].situacao:='hahahaha';
end;

procedure imprimir_turma(el1:turma);

var
	ind,ind2:integer;

begin
	for ind:=1 to 50 do
	begin
		writeln(el1[ind].nome);
		for ind2:=1 to 3 do
		begin
			write(el1[ind].notas[ind2],' ');
		end;
		writeln(el1[ind].medias);
		writeln(el1[ind].dre);
		writeln(el1[ind].situacao);
	end;
end;

procedure imprimir_aluno(el1:turma;position:integer);

var
	ind:integer;

begin
	writeln(el1[position].nome);
	writeln(el1[position].dre);
		for ind:=1 to 3 do
		begin
			write(el1[position].notas[ind],' ');
		end;
	writeln(el1[position].medias);
	writeln(el1[position].situacao);
end;	
	
{Programa Principal} 

var
	t:turma;
	position:integer;
	op:integer;

begin
	op:=0;
	position:=1;
	iniciar_reg(t);
	while op<>5 do
		begin
			writeln('escolha uma opção:');
			writeln('digite 1 para se cadastrar');	
			writeln('digite 2 para apagar o cadastro');
			writeln('digite 3 para exibir a ficha de todos os alunos');
			writeln('digite 4 para exibir a ficha do aluno');
			writeln('digite 5 para sair');
			readln(op);
		case op of
		1:begin
			posicao_aluno(position,t);
			inserir_aluno(t,position);
	 	 end;	
		2:begin
			identificar_posicao(t);
			position:=identificar_posicao(t);
			apagar_aluno(t,position);

		  end;
		3:begin
			imprimir_turma(t);	
		  end;
		4:begin
			identificar_posicao(t);
			position:=identificar_posicao(t);
			imprimir_aluno(t,position);
		  end;
		end;
	end;
end.
