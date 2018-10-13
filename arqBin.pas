program arquivo;
type 
	reg=record
		name:string;
		age:integer;
	end;
	arq=file of reg;

procedure criarAbrir(var turma:arq);

var
 nome:string;

Begin

	writeln('qual o nome do arquivo para criar/abrir ?');
	readln(nome);
	assign(turma,nome);
	{$I-}
	reset(turma);
	{$I+}
	If (ioresult = 2) then
	begin
		rewrite(turma);
		writeln('o arquivo foi criado');
	end
	
	else
		writeln('o arquivo foi aberto');
end;

procedure guardarReg(var turma:arq);

var
	aluno:reg;

begin

	writeln('qual o seu nome?');
	readln(aluno.name);
	writeln('qual sua idade?');
	readln(aluno.age);
	seek(turma,filesize(turma));
	write(turma,aluno);

end;

procedure printInfo(var turma:arq);

var
 aluno:reg;

begin
	
	seek(turma,0);
	repeat
	begin
		read(turma,aluno);
		writeln(aluno.name,' - ',aluno.age,' anos');
	end;
	until eof(turma);
end;

procedure printInfo2(var turma:arq; position:integer);
var
aluno:reg;
begin
	seek(turma,position);
	read(turma,aluno);
	writeln(aluno.name,' - ',aluno.age,'anos');
end;

function busca(var turma:arq):integer;

var
	nome:string;
	cadastro:reg;
	achou:integer;


begin
	
	achou:=0;
	writeln('qual o seu nome');
	readln(nome);
	repeat 
		read(turma,cadastro);
		if (cadastro.name = nome) then
		begin
			achou:=1;
			busca:=(filepos(turma)-1);
		end;
	until eof(turma) or (achou=1) ;
	if achou=0 then
	writeln('você não possui cadastro');

end;
	
procedure apagar(var turma:arq;position:integer);
var

	info:reg;

begin
	{$I-}
	seek(turma,position+1);

	while (not eof(turma)) do
	begin
		read(turma,info);
		seek(turma,filepos(turma)-2);
		write(turma,info);
		seek(turma,filepos(turma)+1);
	end;
		seek(turma,filesize(turma)-1);
	truncate(turma);
	{$I+}
end;

{Programa PRINCIPAL}
VAR

choice:integer;
registro:arq;
posi:integer;
BEGIN
	choice:=0;
	repeat	  
			writeln('escolha uma opção:');
			writeln('1-Criar/abrir arquivo');
			writeln('2-Guardar registro');
			writeln('3-imprimir info do arquivo');
			writeln('4-busca por nome no arquivo');
			writeln('5-Apagar um registro');
			writeln('6-Ordenar');
			readln(choice);
			if(choice<1) or (choice>6) then
			begin
				writeln('opção inválida, tente novamente');
				readln(choice);
			end;

			case choice of

			1:
			begin	
				 criarAbrir(registro);
			end;

			2:
			begin
				 guardarReg(registro);
			end;
			
			3:
			begin
				 printInfo(registro);
			end;
	
			4:
			begin
				posi:= busca(registro);
				 printInfo2(registro, posi);
			end;

			5:
			begin
				posi:= busca(registro);
				 apagar(registro,posi);
			end;
		
			6:
			begin
				close(registro);
			end;
		end;
	until (choice=6);
END.
