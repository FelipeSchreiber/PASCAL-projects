program ponteiros;
{
objetivos
1 - insere aluno
2 - imprime
3 - procura
4 - apaga
5 - ordenar
} 

uses biblioteca_unificada, crt;

type
	p_cadastro = ^cadastro;
	cadastro = record
					nome: string;
					idade: integer;
					proximo: p_cadastro;
				end;

procedure add_aluno(var p_inicio: p_cadastro; var p_ultimo: p_cadastro);

var
	aluno: p_cadastro;
begin
	new(aluno);
	aluno^.nome := entra_str('Digite o nome', 1, 15);
	aluno^.idade := entra_int('Digite a idade', 1, 200);
	aluno^.proximo := nil;
	if p_inicio = nil then
	begin
		p_inicio := aluno;
	end
	else
	begin
			p_ultimo^.proximo := aluno;
	end;
	p_ultimo := aluno;
end;

procedure exibir(var p_inicio:p_cadastro);

var
	p_intermed: p_cadastro;

begin
	p_intermed := p_inicio;
	while p_intermed <> nil do
	begin
			writeln('| ',p_intermed^.nome,' | ',p_intermed^.idade,' |');	
			p_intermed := p_intermed^.proximo;
	end;
end;

procedure procura(p_inicio: p_cadastro;nome:string);
var
	p_intermed: p_cadastro;
	encontrado: boolean;
begin
		p_intermed := p_inicio;
		encontrado := false;
		while p_intermed <> nil do
		begin
			if p_intermed^.nome = nome then
			begin
				writeln('Aluno encontrado: ');
				writeln('| ',p_intermed^.nome,' | ',p_intermed^.idade,' |');
				encontrado := true;
			end;
			p_intermed := p_intermed^.proximo;
		end;
		if not encontrado then
		begin
			writeln('Aluno nao encontrado');
		end;
end;
		
procedure apagar(var p_inicio:p_cadastro;var p_final:p_cadastro; nome:string);

var
	p_intermed,p_anterior: p_cadastro;
	apagado: boolean;
begin
	p_intermed := p_inicio;
	p_anterior := nil;
	apagado := false;
	while p_intermed <> nil do
	begin		
		if p_intermed^.nome = nome then
		begin
			if p_anterior = nil then
			begin
				p_inicio := p_inicio^.proximo;				
			end
			else 
			begin
				p_anterior^.proximo := p_intermed^.proximo;
			end;
			if p_final = p_intermed then
			begin
				p_final := p_anterior;
			end;
			dispose(p_intermed);
			writeln('Nome encontrado e apagado');
			apagado := true;						
		end;
		p_anterior := p_intermed;
		p_intermed := p_intermed^.proximo;
	end;
	if not apagado then
	begin
		writeln('Nome nao encontrado');
	end;
end;

procedure ordenar(var p_inicio:p_cadastro;var p_final:p_cadastro);

var
	p_intermed,p_temp,p_anterior,p_ultimo,p_ex: p_cadastro;
	trocou: Boolean;
begin
	if p_inicio <> nil then
	begin
		if p_inicio^.proximo <> nil then
		begin
			repeat
				trocou := false;
				new(p_ex);	
				p_intermed := p_inicio;
				p_ex^.proximo := p_intermed;
				p_ultimo := p_inicio^.proximo;
				p_anterior := p_ex;
				while p_ultimo <> nil do
				begin
					if p_ultimo^.nome < p_intermed^.nome then
					begin
						if (p_inicio = p_intermed) then
						begin
							p_inicio := p_ultimo;
						end;			
						p_intermed^.proximo := p_ultimo^.proximo;
						p_ultimo^.proximo := p_intermed;
						p_anterior^.proximo := p_ultimo;
						p_temp := p_ultimo;						
						p_ultimo := p_intermed;
						p_intermed := p_temp;
						trocou := true;
					end;					
					p_anterior := p_anterior^.proximo;							
					p_intermed := p_intermed^.proximo;
					p_ultimo := p_ultimo^.proximo;										
				end;
				p_final := p_intermed;
				dispose(p_ex);			
			until (trocou = false);
		end;
	end;
end;

{Programa principal}
var
	p_inicio, p_final : p_cadastro;
	opcao: integer;
	opcs_menu: opcoes_menu; 
	nome: string;	
begin
	new(p_inicio);
	new(p_final);
	p_inicio := nil;
	p_final := nil;
	opcs_menu[1] := 'Inserir Aluno';
	opcs_menu[2] := 'Exibir Alunos';
	opcs_menu[3] := 'Procurar Aluno';
	opcs_menu[4] := 'Apagar aluno';
	opcs_menu[5] := 'Ordenar a Lista';
	opcs_menu[6] := 'Sair';
	repeat 
		opcao := menu(opcs_menu);
		case opcao of
			1: add_aluno(p_inicio,p_final);
			
			2: begin
				exibir(p_inicio);
				readkey();
				end;
			
			3: begin
					nome:= entra_str('Insira o nome a ser procurado: ',1,20);
					procura(p_inicio,nome);
					readkey();		
				end;
			4: begin
					nome := entra_str('Insira o nome a ser apagado: ',1,20);
					apagar(p_inicio,p_final,nome);
					readkey();
				end;
			5: begin
					ordenar(p_inicio,p_final);
				end;	
		end;
	until opcao = 6;
end.
