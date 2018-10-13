program prova;
uses minhaEstante;
{Objetivo permitir que o usuário insira arquivos para consultas posteriores ou apague-os
 Data 6/12/2016
 Nome:Felipe Schreiber Fernandes
 DRE:116 206 990}
type

		registro=record

			title:string;{título}
			autors:string;{autores}
			plot:string;{descrição do conteúdo do arquivo}
			tipo:string;{Romance, científico etc}
			tamanho:integer;{quantas páginas}
			local:integer;{onde o arquivo está guardado fisicamente, em qual número da gaveta está armazenado.Suponho que todos os arquivos estejam guardados em um escaninho que possui várias gavetas e só podem ser guardados 1 único texto}

		end;

		arq=file of registro;

function buscaTitulo(var arqProc:arq;var existe:boolean; nome:string):integer;{essa função retorna a posição que determinado registro está no arquivo binário e informa se existe ou não esse registro no arquivo.A busca é feita pelo título }

Var

	{ existe é uma variável que indica se o registro procurado existe ou não e ele é passado por paramêtro para poder sofrer alterações}
	aux:registro;{variável que armazena temporariamente um cadastro do arquivo para realizar a comparação}
Begin

	existe:=false;
	nome:=upcase(nome);
	seek(arqProc, 0);{começar a busca na posição 0 do arquivo}
	while not eof(arqProc) and existe=false do
	Begin
		read(arqProc,aux);
		aux.title:=upcase(aux.title);
		if pos(nome,aux.title)<>0 then
		begin

			existe:=true;
			buscaTitulo:=filepos(arqProc)-1;{ao ler o registro a posição atual andou uma casa, logo a posição correspondente é a anterior}
		end
	
	end;
	if existe=false then
	begin
	
		buscaTitulo:=filesize(arqProc);
		{se não for encontrado, a função busca retorna a primeira posição livre do arquivo}
	end;
end;

function buscaGaveta(var arqProc:arq;var existe:boolean; gaveta:integer): integer;{essa função retorna a posição que determinado registro está no arquivo binário e informa se existe ou não esse registro no arquivo binário.A busca é feita pelo número da gaveta em que está guardado o arquivo }

Var

	{ existe é uma variável que indica se o registro procurado existe ou não e ele é passado por paramêtro para poder sofrer alterações}
	aux:registro;{variável que armazena temporariamente um cadastro do arquivo para realizar a comparação}
Begin

	existe:=false;
	seek(arqProc, 0);{começar a busca na posição 0 do arquivo}
	while not eof(arqProc) and existe=false do
	Begin

		read(arqProc,aux);
		if aux.local=gaveta then
		begin

			existe:=true;
			buscaGaveta:=filepos(arqProc)-1;{ao ler o registro a posição atual andou uma casa, logo a posição correspondente é a anterior}
		end;
	
	end;
	if existe=false then
	begin
	
		buscaGaveta:=filesize(arqProc);
		{se não for encontrado, a função busca retorna a primeira posição livre do arquivo}
	end;
procedure inserirOrdenado(var arqProc:arq);

Var
	
	controle:integer;{essa variável serve para identificar quando que achou a posição em que deve ser inserido o registro}
	exist:boolean;{essa variável é passada por referência para o procedimento de busca no arquivo}
	resultado:integer;{essa variável guarda o resultado da busca feita pelo arquivo}
	aux1:registro;{Variável temporária que armazena os dados digiatados pelo usuário}
	aux2:registro;{Variável que guarda um determinado registro do arquivo binário para realizar a comparação e inserir ordenado}
	aux3:registro;{essa variável serve para que, quando achar a posição que deve ser inserido o registro, os demais registros sejam salvos temporariamente nele e vai se realizando a cópia de um a um para ele e depois passados devolta para o arquivo deslocados de uma posição}
Begin

	controle:=0;
	{Início do processo que requere os dados do usuário}
	aux1.title:=lerString(1,40,ALFANUM,'Diga qual o título do arquivo que deseja incluir.Só podem conter 40 caracteres e apenas letras e números');
	aux1.autors:=lerString(1,60,ESPECIAIS+ALFABETO,'Diga qual o nome dos autores do arquivo.Só podem conter no máximo 60 caracteres.Pode colocar vírgula, ponto, ponto vírgula e barra para separar os nomes');
	aux1.plot:=lerString(1,120,ALFANUM+ESPECIAIS,'Diga qual a descrição do conteúdo. Só podem conter até 120 caracteres.Pode conter números, letras e caracteres especiais');
	aux1.tipo:=lerString(1,40,ALFABETO,'Diga qual o tipo do arquivo.Ex:Romance,científico, etc.Só podem conter 40 caracteres');
	aux1.tamanho:=lerInteiro(0,32676,'Diga quantas páginas tem o arquivo desejado.Só pode conter no máximo 32676 páginas e deve ser um valor inteiro');
	aux1.local:=lerInteiro(0,32676,'Informe em qual gaveta deseja incluir o arquivo mencionado.Deve ser um inteiro entre 0 e 32676');

	resultado:=busca(arqProc,exist,aux1.local);

	while (resultado <> filesize(arqProc)) do
	begin

		writeln('essa gaveta está ocupada, tente novamente');
		aux1.local:=lerInteiro(0,32676,'Informe em qual gaveta deseja incluir o arquivo mencionado.Deve ser um inteiro entre 0 e 32676');
		resultado:=busca(arqProc,exist,aux1.local);

	end;  	
	resultado:=busca(arqProc,exist,aux1.title);
	while (resultado <> filesize(arqProc)) do
	begin

		writeln('esse título já existe, digite outro');
		aux1.local:=lerString(1,40,ALFANUM,'Informe o título do arquivo desejado.Pode conter letras e números, e no máximo 40 caracteres');
		resultado:=busca(arqProc,exist,aux1.title);

	end;
		
		{início do processo de inserir ordenado}

	while not eof(arqProc) and controle=0 do 
	begin

		read(arqProc,aux2);
		if aux1.title < aux2.title then
		begin
		
			seek(arqProc,filepos(arqProc)-1);{ao ler o registro do arquivo para a variável aux2 andou-se uma casa.Como desejamos colocar uma casa antes devemos voltar uma posição em relação a atual em que se está no arquivo}
			write(arqProc,aux1);{aqui sobreescreve o registro que estava inserido na posição em que desejamos colocar}
			
			while not eof(arqProc) do
			begin
				
				read(arqProc,aux3);{copia o próximo registro para uma outra variável}
				seek(arqProc,filepos(arqProc)-1);{retorna uma posição em relação à atual para sobreescrever o registro}
				write(arqProc,aux2);{o penúltimo arquivo lido é escrito por cima do último}
			end;

			controle:=1;{significa que o arquivo já foi inserido numa posição}
		end;{end do if}
	end;{end do while}
	
	if	controle=0 then{significa que chegou ao final do arquivo e o cadastro não foi inserido em nenhuma posição intermediária}
	begin
		
		write(arqProc,aux1);

	end;	
end;{final do procedimento de inserir}			 

procedure apagar(var arqProc:arq, position:integer);{position é o valor retornado pela funçaão busca}
var

	aux:registro;

Begin

	seek(arqProc,position+1);{position é o lugar que se encontra o registro a ser apagado, logo é necessário ir para uma posição após essa}
	while not eof(arqProc) do
	begin

		read(arqProc,aux);
		seek(arqProc,filepos(arqProc)-2);
		write(arqProc,aux);
		seek(arqProc,filepos(arqProc)+1);				
	
	end;
	
	seek(arqProc,Filesize(arqProc)-1);{o úoltimo encontra-se duplicado, logo preccisa-se apagá-lo}
	truncate(arqProc);

end;

procedure exibir(var arqProc:arq,position:integer,var indice:integer);
var
	
	aux:registro;
	choice:char;{o usuário escolhe se deseja continuar a exibição}
	ind:integer;{identifica o registro aberto comm um indíce}

Begin
	
repeat

	ind:=1;
	seek(arqProc,position);
	read(arqProc,aux);
	writeln('Arquivo',ind,'aberto');
	writeln('título:',aux.title);
	writeln('autores:',aux.autors);
	writeln('tipo:',aux.tipo);
	writeln('tamanho:',aux.tamanho);
	writeln('descrição:',aux.plot);
	writeln('local:',aux.local);
	choice:=lerChar('sSnN','Deseja continuar a exibição?Digite sim ou não');
	case choice of
	'S':
	Begin
	
		ind:=ind+1;

	end;
	end;

until choice= 'N';

End;
	
	

end;
function menu():integer;
var
	escolha:integer;

begin

	writeln('escolha uma dessas opções');
	writeln('1-Inserir Arquivo');
	writeln('2-Apagar Arquivo');
	writeln('3-Consultar Arquivo');
	writeln('4-Sair do programa');
	escolha:=lerInteiro(1,4,'Escolha uma opção de 1 a 4.Ela deve ser um inteiro');	

end;
{Programa principal}
Var

	Consulta:arq;
	name:string;
	numeroGaveta:integer;
	option:integer;{essa variável guarda a opção escolhida pelo usuário}
	exists:boolean;
	search:integer;{aramazena o resultado da busca}
	ind:integer;{identifica o registro aberto com um indíce}
Begin

	abrirCriar(Consulta);
	reset(Consulta);
	repeat 

		option:=menu;
		case option of
	
		1:
		Begin

			 inserirOrdenado(Consulta);
		
		end;

		2:
		Begin

			name:=lerString(1,40,ALFANUM,'Digite parte do título ou o título inteiro do arquivo que deseja excluir.Só pode ter no máximo 40 caracteres');
 			search:=buscaTitulo(Consulta,exists,name) integer;{essa função retorna a posição que determinado registro está no arquivo binário e informa se existe ou não esse registro no arquivo.A busca é feita pelo título }
			
			apagar(Consulta,search);

		end;

		3:
		begin
			
			name:=lerString(1,40,ALFANUM,'Digite parte do título ou o título inteiro do arquivo que deseja car.Só pode ter no máximo 40 caracteres');
 			search:=buscaTitulo(Consulta,exists,name);
			exibir(Consulta,search,ind);

		end;

	end;{case}
	until option=4;
End.
