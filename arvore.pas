program agendaArvore;
{Objetivo:Guardar numa estrutura não linear uma agenda em ordem alfabética
 Responsável:Felipe Schreiber Fernandes
 DRE: 116 206 990
 Data:14/12/2016}

uses
	minhaBiblioteca;

Type

	noAgenda=^regAgenda;	

	regAgenda=record
				nome:string;
				tel:string;
				esq,dir:noAgenda;
				
			end;

Const

	MAX=30;
	
function menu():integer;
var

	opcao:integer;

Begin

	Writeln('Escolha uma dessas opções:');
	writeln('1-Incluir novo contato');
	writeln('2-Alterar os dados de um contato');
	writeln('3-Consultar');
	writeln('4-Listar todos os contatos');
	writeln('5-Sair');
	opcao:=lerInteiro(1,5,'Digite uma das opções acima.Só pode ser um inteiro entre 1 e 5');
	menu:=opcao;

End;

procedure achar(atual:noAgenda;name:string);
Begin
	
	if atual=nil then
	begin
		writeln();
		writeln('Nome não encontrado');
	end
	else
	begin
		
		if name=atual^.nome then
		begin
			writeln('Contato achado:');
			writeln();
			writeln('Nome: ',atual^.nome,#9,'Telefone: ',atual^.tel);
		end
		else
		begin
			if atual^.nome<> name then
			begin
				if name > atual^.nome then
				begin
					if atual^.dir <> nil then
					begin
						achar(atual^.dir,name);
					end
					else
					begin
						writeln('Nome não encontrado');
						atual:=nil;
					end;
				end
				else
				begin
					if atual^.esq <> nil then
					begin
						achar(atual^.esq,name);
					end
					else
					begin
						writeln('Nome não encontrado');
						atual:=nil;
					end;
				end;
			end;
		end;
	end;
end;	

procedure alterar(var contatoAlterar:noAgenda);
Var
	option:integer;
	choice:char;
Begin

	writeln('O contato que você deseja alterar é: ',contatoAlterar^.nome,' - ',contatoAlterar^.tel);
	writeln();
	choice:=lerChar('sSnN','Tem certeza que deseja alterar esse contato? Digite [S]im ou [N]ão');
	choice:=upcase(choice);
	if choice='S' then
	begin

		option:=lerInteiro(1,2,'Digite 1 se você quiser alterar o nome do contato ou 2 para alterar o número dele');
		if option = 1 then
		begin

		contatoAlterar^.nome:=lerString(1,MAX,ALFABETO+SPACE,'Digite o novo nome do contato.Só podem conter letras e no máximo 30 caracteres');	
			writeln();
			writeln('Nome alterado com sucesso');
		
		end
		else
		begin

			contatoAlterar^.tel:=lerString(1,16,NUM,'Digite o novo número do contato.Só podem conter no máximo 16 números');
			writeln();
			writeln('Número modificado com sucesso');

		end;
	end;
End;


procedure modificar(atual:noAgenda;name:string);
Begin
	
	if atual=nil then
	begin
		writeln();
		writeln('Nome não encontrado');
		writeln();
	end
	else
	begin
		
		if name=atual^.nome then
		begin
			alterar(atual);
		end
		else
		begin
			if atual^.nome<> name then
			begin
				if name > atual^.nome then
				begin
					if atual^.dir <> nil then
					begin
						modificar(atual^.dir,name);
					end
					else
					begin
						writeln('Nome não encontrado');
						atual:=nil;
					end;
				end
				else
				begin
					if atual^.esq <> nil then
					begin
						modificar(atual^.esq,name);
					end
					else
					begin
						writeln('Nome não encontrado');
						atual:=nil;
					end;
				end;
			end;
		end;
	end;
end;	

procedure buscar(var atual:noAgenda;novo:noAgenda;var existe:boolean);
Begin
	
	if atual=nil then
	begin
		existe:=false;
		atual:=novo;
	end
	else
	begin
		
		if novo^.nome=atual^.nome then
		begin
			existe:=true;			
		end
		else
		begin
			if novo^.nome > atual^.nome then
			begin
				buscar(atual^.dir,novo,existe);
			end
			else
			begin
				buscar(atual^.esq,novo,existe);
			end;
		end;
	end;
End;

procedure incluir(var raiz:noAgenda);
var

	atual,novo:noAgenda;
	existe:boolean;
	choice:char;

Begin

	atual:=raiz;
	new(novo);
	existe:=true;
	choice:='S';
repeat

	while (existe) do
	begin

		existe:=false;	
		novo^.nome:=lerString(1,MAX,ALFABETO+SPACE,'Digite o nome do contato a ser inserido.Só podem conter letras e no máximo 30 caracteres');
		novo^.nome:=upcase(novo^.nome);
		writeln();
		novo^.tel:=lerString(1,16,NUM,'Digite o número do contato a ser inserido.Só podem conter no máximo 16 números');
		novo^.esq:=nil;
		novo^.dir:=nil;
		if raiz=nil then
		begin
			raiz:=novo;
		end
		else
		begin
			buscar(atual,novo,existe);
		end;
		if existe then
		begin

			writeln('Esse contato já existe.');
			choice:=lerChar('SsNn','Deseja tentar novamente?Digite [S]im ou [N]ão');
			choice:=upcase(choice);

		end
		else
		begin
			atual:=novo;
			choice:='N';
		end;
	end;
until choice='N';	
End;

procedure listar(atual:noAgenda);
Begin

	if atual<>nil then
	begin

		listar(atual^.esq);
		writeln('Contato: ',atual^.nome,#9,'Telefone: ',atual^.tel);
		listar(atual^.dir);

	end;
End;


procedure executar(var raiz:noAgenda);
var
	opcao:char;
	option:integer;{armazena o valor da função menu}
	nome:string;
Begin
	repeat

		repeat 

			option:=menu();
			case option of
			1:
			Begin
				incluir(raiz);
			End;
		
			2:
			Begin
				repeat 

					nome:=lerString(1,MAX,ALFABETO+SPACE,'Digite o nome do contato que deseja alterar.Só podem conter letras e no máximo 30 caracteres');
					nome:=upcase(nome);
					writeln();
					modificar(raiz,nome);
					
					opcao:=lerChar('sSnN','Deseja fazer outra alteração? Digite [S]im ou [N]ão');
					opcao:=upcase(opcao);
								
				until opcao='N';
			
			End;

			3:
			Begin
					
				repeat

					nome:=lerString(1,MAX,ALFABETO+SPACE,'Digite o nome do contato.Só podem conter letras e no máximo 30 caracteres');
					nome:=upcase(nome);
					writeln();
					achar(raiz,nome);
					opcao:=lerChar('sSnN','Deseja fazer outra busca? Digite [S]im ou [N]ão');
					opcao:=upcase(opcao);
					
				until opcao='N';

			End;

			4:
			Begin
				listar(raiz);
			End;
		End;{case}
		Until (option=5);

		opcao:=lerChar('sSnN','Deseja realmente sair? Digite [S]im ou [N]ão');
      opcao:=upcase(opcao);	

	until opcao='S';
End;
{Programa Principal}
Var 
	root:noAgenda;{raiz da árvore}
Begin
	root:=nil;
	executar(root);			
End.
