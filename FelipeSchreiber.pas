program diarioDeNotas;
{Objetivo: fazer um diario de notas de diferentes turmas, cada qual exibindo, para cada aluno, nome, DRE,notas de duas provas, média,número de faltas e status.
 Nome:Felipe Schreiber Fernandes
 DRE:116 206 990
última modificação:11/12/2016}

uses minhaBiblioteca;

type

	registro=record
				nome:string;
				dre:integer;
				notas:array[1..2]of real;
				media:real;
				faltas:integer;
				status:string;

			end;

	regFile=file of registro;

	pDescritorArq= ^descritorArq;

	descritorArq=record
				turma:regFile;
				nomeTurma:string;
				proximo:pDescritorArq;
				anterior:pDescritorArq;
			end;

function fazerMedia(aluno:registro):real;
var

	med:real;
		
Begin

	med:=(aluno.notas[1] + aluno.notas[2])/2;
	fazerMedia:=med;

End;

function fazerStatus(media:real):string;
Begin

	if media>= 7.0 then
	begin

		fazerStatus:='Aprovado';

	end
	else
	begin

		fazerStatus:='Reprovado';

	end;

end;

procedure existeDRE(var arqProc:regFile;var DRE:integer);{esse procedimento serve para verificar se, ao incluir um aluno na turma, o dre já existe ou não}	
var

	existe:boolean;
	regTemp:registro;{registro que armazena os dados de uma certa posição do arquivo para realizar a comparação}
	
Begin

	If filesize(arqProc)<>0 then
	Begin

		seek(arqProc,0);
		existe:=true;
		while existe do
		begin

			existe:=false;
			read(arqProc,regTemp);
			if regTemp.dre = DRE then
			begin 

				writeln();
				writeln('esse DRE já pertence à outra pessoa, tente novamente');
				writeln();
				DRE:=lerInteiro(1,32676,'Digite o número do dre do aluno inserido.Só pode ser um número entre 1 e 32676');
				writeln();
				existe:=true;

			end;

		end;

	end;

End;

procedure existeNome(var arqProc:regFile;var name:string);{esse procedimento serve para verificar se, ao incluir um aluno na turma, o nome já existe ou não}	
var

	existe:boolean;
	regTemp:registro;{registro que armazena os dados de uma certa posição do arquivo para realizar a comparação}
	
Begin

	if filesize(arqProc)<>0 then
	begin

		seek(arqProc,0);
		existe:=true;
		while existe and not eof(arqProc)do
		begin

			existe:=false;
			read(arqProc,regTemp);
			if regTemp.nome = name then
			begin 

				writeln();
				writeln('Já existe um aluno com esse nome, tente novamente');
				writeln();
				name:=lerString(1,60,ALFABETO,'Digite o nome do aluno a ser incluído na turma.Só podem conter letras e no máximo 60 caracteres');
				writeln();
				existe:=true;

			end;
		
		end;
	
	end;	
End;

{Eu modularizei as etapas de ordenação.Sugiro que você veja na seguinte ordem:
inserirOrdenado->ordenar3->ordenar2->ordenar1->ordenar0}

procedure ordenar0(var arqProc:regFile; var regTemp1,regTemp2:registro;var controle:integer);
Begin

	If regTemp2.dre=0 then{se o regTemp2 está zerado significa que essa variável chegou primeiro ao fim do arquivo, encerrando o loop do procedimento ordenar1.Perceba que, quando chegar ao fim do arquivo uma das duas variáveis não terá os dados copiados do arquivo para elas, pois não será executado o comando read, continuando com o valor do dre nulo.Portanto, nesse caso,a outra variável regTemp1 não estará com o dre zerado, o que significa que falta copiá-la para o arquivo.}
	begin

		write(arqProc,regTemp1);

	end
	else{como necessariamente uma das duas variáveis(regTemp1, regTemp2) chegou ao fim primeiro, alguma delas estará com o campo do dre zerado.Se não for a primeira então necessariamente será a segunda}
	
	begin

		write(arqProc,regTemp2);

	end;

	controle:=1;{essa é apenas uma variável de controle para indicar que o processo de encontrar a posição e inserir ordenado já foi realizada, otimizando o programa que não precisará percorrer até o final do arquivo à toa(ver loop do ordenar3)} 

End;
procedure ordenar1(var arqProc:regFile;var regTemp1,regTemp2:registro);
Begin

	while not eof(arqProc) do
	begin
	
		read(arqProc,regTemp2);{precisa-se salvar o conteúdo da próxima posição para sobreescrevê-lo}
		
		if filepos(arqProc)=filesize(arqProc) then
		begin
	
			seek(arqProc,filepos(arqProc)-1);{após ler os dados para uma variável a posição andou uma casa, logo precisa-se retornar uma posição para sobreescrever}

			write(arqProc,regTemp1);{sobreescreve os dados armazenados no arquivo}

			regTemp1.dre:=0;{esse é apenas um mecanismo de controle para saber qual das duas variáveis chegou ao fim primeiro(regTemp1 ou regTemp2).Mais adiante explicarei melhor}

			{write(arqProc,regTemp2);}

		end
		else
		begin

			seek(arqProc,filepos(arqProc)-1);{após ler os dados para uma variável a posição andou uma casa, logo precisa-se retornar uma posição para sobreescrever}

			write(arqProc,regTemp1);{sobreescreve os dados armazenados no arquivo}


			read(arqProc,regTemp1);{muda os dados armazenados na variável, salvando os da próxima posição}
	
			seek(arqProc,filepos(arqProc)-1);{volta-se uma posição para copiar os dados da outra variável}

			write(arqProc,regTemp2);{copia-se os dados e o processo volta a se repetir}
			regTemp2.dre:=0;{da mesma forma que fiz para a variável regTemp1}

		end;

	end;

		{quando chegar ao fim do arquivo ainda estará faltando copiar os dados de uma das variáveis.Para saber qual que está faltando ser copiada basta saber qual que não está com o dre zerado.Não há nenhum risco de se perder o dre de um aluno qualquer pois ele foi zerado somente após o processo de cópia para o arquivo}

End;
procedure ordenar2(var arqProc:regFile;var regTemp1,regTemp2:registro;var controle:integer);
Begin

	If filepos(arqProc) = filesize(arqProc) then{esse é um teste para caso já esteja no fim do arquivo após copiar os dados do alunoNovo para ele}
	Begin

		write(arqProc,regTemp1);{os dados, antes de serem sobreescritos, foram salvos na variável regTemp1 justamente para fazer a comparação(ver o procedimento ordenar 3)}

		controle:=1;

	end
	else{significa que, após passarmos os dados do alunoNovo para o arquivo(ver ordenar 3) aindanão estamos no fim, ou seja, devemos sobreescrever um a um até chegar no final do arquivo}	
	Begin

		ordenar1(arqProc,regTemp1,regTemp2);

	End;

End;

procedure ordenar3(var arqProc:regFile;var controle:integer;alunoNovo:registro);
var

	regTemp1,regTemp2:registro;{variáveis do tipo registro que amarzena temporariamente os dados de uma determinada posição do arquivo para realizar a comparação e possibilitar o processo de sobreescrita no arquivo}
	
Begin

	while (not eof(arqProc)) and (controle=0) do
	Begin

		read(arqProc,regTemp1);
		if regTemp1.nome > alunoNovo.nome then{compara os nomes para ver se deve vir depois ou antes}
		begin

			seek(arqProc,filepos(arqProc)-1);{ao ler os dados contidos em uma posição do arquivo a posição atual também andou.Como queremos que seja inserido antes, devemos retornar uma posição}
			write(arqProc,alunoNovo);{aqui sobreescreve o que estava antes situado na posição em que se deseja inserir,observe que os dados que foram sobreescritosestão salvos na variável regTemp1}
			ordenar2(arqProc,regTemp1,regTemp2,controle);
			ordenar0(arqProc,regTemp1,regTemp2,controle);

		end;
	
	End;

	if controle=0 then{só há um caso em que o valor da variável controle não será mudado:quando o nome a ser inserido tem que se posicionar na última posição.}
	begin

		seek(arqProc,filesize(arqProc));
		write(arqProc, alunoNovo);
		
	end;

end;
procedure inserirOrdenado(var arqProc:regFile;alunoNovo:registro);
var

	controle:integer;{essa variável é apenas para parar o loop quando já for inserido o aluno}

Begin

	controle:=0;
	seek(arqProc,0);
	if filesize(arqProc)=0 then {para o caso do primeiro colocado}
	begin

		write(arqProc,alunoNovo);
		
	end
	else
	Begin

		ordenar3(arqProc,controle,alunoNovo);

	End;	

End;

procedure coletarDados(var arqProc:regFile;var alunoNovo:registro);{esse procedimento apenas coleta os dados do novo aluno a ser inserido}
Begin
	
	{Coleta os dados fornecidos pelo usuário}
	alunoNovo.nome:=lerString(1,60,ALFABETO,'Digite o nome do aluno a ser incluído na turma.Só podem conter letras e no máximo 60 caracteres');

	existeNome(arqProc,alunoNovo.nome);	

	alunoNovo.dre:=lerInteiro(1,32676,'Digite o número do dre do aluno inserido.Só pode ser um número entre 1 e 32676');

	existeDRE(arqProc,alunoNovo.dre);

	alunoNovo.notas[1]:=lerReal(0,10,'Informe a nota da P1.Só pode ser um número real entre 0 e 10');

	alunoNovo.notas[2]:=lerReal(0,10,'Informe a nota da P2.Só pode ser um número real entre 0 e 10');

	alunoNovo.media:=fazerMedia(alunoNovo);

	alunoNovo.faltas:=lerInteiro(0,50,'Informe o número de faltas do aluno.Só pode ser um inteiro entre 0 e 50');

	alunoNovo.status:=fazerStatus(alunoNovo.media);

End;

function buscarNome(var arqProc:regFile):integer;
var

	auxTemp:registro;
	name:string;

Begin

	buscarNome:=filesize(arqProc);{inicializei a função com um valor correspondente ao caso do nome do aluno não estiver incluído no arquivo}
	name:=lerString(1,60,ALFABETO,'Digite o nome do aluno.Só podem conter no máximo 60 caracteres');
	name:=upcase(name);{apenas para não tornar a busca sensível a maiúsculas e minúsculas, visto que o usuário pode cometer erros}
	seek(arqProc,0);
	while (not eof(arqProc)) and (buscarNome=filesize(arqProc)) do
	{caso o valor a ser retornado pela função mude, o procedimento chegará ao fime não precisará continuar}
	begin

		read(arqProc,auxTemp);
		auxTemp.nome:=upcase(auxTemp.nome);
		if auxTemp.nome = name then
		begin

			buscarNome:=filepos(arqProc)-1;{ao ler os dados para a variável auxiliar a posição atual dentro do arquivo também andou}
		end;

	end;

End;	

procedure apagarAluno(var arqProc:regFile);
var

	regTemp:registro;{armazena temporariamente os dados de uma posição}
	position:integer;
	choice:char;

Begin

	position:=buscarNome(arqProc);
	seek(arqProc,position+1);{tem que copiar os dados de uma posição à frente em relação a que está o registro a ser apagado}
	choice:=lerChar('snSN','Tem certeza que deseja apagar?Digite [S]im ou [N]ão.Uma vez apagado não tem como desfazer essa ação');
	choice:=upcase(choice);
	if choice='S' then
	begin
	
		while not eof(arqProc) do
		begin

			read(arqProc,regTemp);
			seek(arqProc, filepos(arqProc)-2);{deve-se retornar à posição que queremos sobreescrever}
			write(arqProc,regTemp);
			seek(arqProc,filepos(arqProc)+1);{deve-se pular a posição que já foi copiada, e o processo se repete}

		end;
		seek(arqProc,filesize(arqProc)-1);{o último encontra-se duplicado}
		truncate(arqProc);
		{corre-se o risco de só haver apenas um único aluno na lista e, nesse caso,o processo dentro do loop não se efetuará.Contudo, após o loop eu vou para a penúltima posição e aplico o truncate para liberá-la.Caso o arquivo só tenha 1 único registro, ainda assim o procedimento será feito corretamente}
	end;
end;				

function menuEditar():integer;{essa função retorna ao usuário as opções que ele tem na parte de editar os dados de um aluno}
var

	escolha:integer;

Begin
	
	writeln('Escolha uma dessas opções');
   writeln('1-Editar Notas');
   writeln('2-Editar faltas');
   writeln('3-Sair');
   escolha:=lerInteiro(1,3,'Escolha uma opção de 1 a 3.Ela deve ser um inteiro');
	menuEditar:=escolha;

End;

procedure editarNotas(var regTemp:registro);
var

	escolha:integer;

Begin

	escolha:=lerInteiro(1,2,'Escolha qual das duas notas deseja editar:Digite 1 para a P1 e 2 para a P2.');
	if escolha=1 then
	begin

		regTemp.notas[1]:=lerReal(0,10,'Informe a nota da P1 editada.Só pode ser um número real entre 0 e 10');

	end
	else
	begin

		regTemp.notas[2]:=lerReal(0,10,'Informe a nota da P2 editada.Só pode ser um número real entre 0 e 10');

	end;
	writeln('Edição de notas feita com sucesso');

end;

procedure editarFaltas(var regTemp:registro);
Begin

	regTemp.faltas:=lerInteiro(0,50,'Digite o novo número de faltas do aluno.Deve ser um número innteiro entre 0 e 50.');
	writeln('Edição de faltas feita com sucesso');

End; 		
procedure editarDados(var arqProc:regFile);
var

	regTemp:registro;
	position:integer;{armazena	o resultado da busca pelo aluno, em que posição ele está no arquivo}
	option:integer;{escolha do usuário}
	choice:char;{escolha do usuário}

Begin

	repeat

		position:=buscarNome(arqProc);
		if position = filesize(arqProc) then{a função de busca retorna a posição correspondente ao fim do arquivo quando não é encontrada a pessoa}
		begin

			writeln('Esse aluno não está cadastrado nessa turma');
					
		end
		else
		begin

			seek(arqProc,position);
			read(arqProc,regTemp);
			option:=menuEditar();
			Case option of
			1:
			begin

				 editarNotas(regTemp);

			end;
	
			2:
			begin

				editarFaltas(regTemp);

			end;

			End;{fim do case}
		end;{fim do else}
			seek(arqProc,filepos(arqProc)-1);{após feitas as mudanças no registro temporário é necessário salvá-las no arquivo}
			write(arqProc,regTemp);
			choice:=lerChar('snSN','Você deseja fazer outra edição de dados?Digite [S]im para continuar e [N]ão para sair.');

	until (choice='N');			
End;

function menuConsulta():integer;{essa função retorna ao usuário as opções que ele tem na parte de consultar os dados de um aluno}
var

	escolha:integer;

Begin
	
	writeln('Escolha uma dessas opções');
	writeln();
   writeln('1-Consulta por aluno');
   writeln('2-Consulta por alunos aprovados');
   writeln('3-Consulta por alunos reprovados');
	writeln('4-Listagem de todos os alunos da turma');
   writeln('5-Sair');
   escolha:=lerInteiro(1,5,'Escolha uma opção de 1 a 5.Ela deve ser um inteiro');
	menuConsulta:=escolha;

end;

procedure consulta(var arqProc:regFile);
var

	regTemp:registro;	
	choice:char;{o usuário escolhe se deseja continuar a exibição}
	option:integer;{armazena o valor retornado pela função do menu consulta}
	position:integer;{armazena o valor retornado pela função de buscar o aluno pelo nome}
	indicador:integer;{indica se houve ou não exibição na tela}

Begin

	indicador:=0;
	choice:='N';
	repeat

		option:=menuConsulta();
		case option of
		1:
		Begin

			position:=buscarNome(arqProc);
			if position=filesize(arqProc) then{a função buscarNome retorna o tamanho do arquivo quando não encontra o nome do aluno}
			begin

				writeln('Aluno não encontrado.Tente novamente.');

			end
			else
			begin

				seek(arqProc,position);
				read(arqProc,regTemp);
				writeln('Nome: ',regTemp.nome,#9,'DRE: ',regTemp.dre,#9,'Notas: ','P1-',regTemp.notas[1]:2:2,' ','P2-',regTemp.notas[2]:2:2,#9,'Faltas: ',regTemp.faltas,#9,'Status: ',regTemp.status);
				writeln();
	
			end;

		End;

		2:
		Begin
			
			seek(arqProc,0);
			if filesize(arqProc)=0 then
			begin
			
				writeln('A lista está vazia');

			end
			else
			begin

				while not eof(arqProc) do
				begin
		
					read(arqProc,regTemp);
					if regTemp.status='Aprovado' then
					begin

						writeln('Nome: ',regTemp.nome,#9,'DRE: ',regTemp.dre,#9,'Notas: ','P1-',regTemp.notas[1]:2:2,' ','P2-',regTemp.notas[2]:2:2,#9,'Faltas: ',regTemp.faltas,#9,'Status: ',regTemp.status);
						writeln();
						indicador:=1;

					end;
				end;
			end;
			if indicador = 0 then
			begin

				writeln('Não há alunos aprovados');

			end;
		End;

		3:
		Begin
			
			seek(arqProc,0);
			If filesize(arqProc)=0 then
			begin

				writeln('A lista está vazia');
			
			end
			else
			begin

				while not eof(arqProc) do
				begin
	
					read(arqProc,regTemp);
					if regTemp.status='Reprovado' then
					begin

						writeln('Nome: ',regTemp.nome,#9,'DRE: ',regTemp.dre:4,#9,'Notas: ','P1-',regTemp.notas[1]:2:2,' ','P2-',regTemp.notas[2]:2:2,#9,'Faltas: ',regTemp.faltas:2,#9,'Status: ',regTemp.status);
						writeln();

						indicador:=1;

					end;
				end;
			end;	

			if indicador= 0 then
			begin

				writeln('Não houve alunos reprovados');

			end;

		End;	
		
		4:
		Begin
			
			seek(arqProc,0);
			if filesize(arqProc) = 0 then
			begin

				writeln('O arquivo está vazio');

			end
			else
			begin
	
				while not eof(arqProc) do
				begin
		
					read(arqProc,regTemp);
					if (regTemp.status='Reprovado') or (regTemp.status='Aprovado') then
					begin

						writeln('Nome: ',regTemp.nome,#9,'DRE: ',regTemp.dre:5,#9,'Notas: ','P1-',regTemp.notas[1]:2:2,' ','P2-',regTemp.notas[2]:2:2,#9,'Faltas: ',regTemp.faltas:2,#9,'Status: ',regTemp.status);
						writeln();

					end;

				end;
			end;

		End;	
		
		End;{end do case}
		choice:=lerChar('snSN','Deseja continuar a exibição?Digite [S]im ou [N]ão');

	until choice='N';

End;

function menuArq():integer;
var

	escolha:integer;

Begin

	writeln('Escolha uma dessas opções:');
	writeln();
   writeln('1-Incluir um  aluno na turma');
   writeln('2-Remover um aluno da turma');
   writeln('3-Editar notas ou faltas de um aluno');
	writeln('4-Consultar dados da turma');
   writeln('5-Sair');
   escolha:=lerInteiro(1,5,'Escolha uma opção de 1 a 5.Ela deve ser um inteiro');
	menuArq:=escolha;

End;

procedure executarEscolha(var arqProc:regFile;name:string);
var

	escolha:integer;
	option:char;
	novoAluno:registro;

Begin

	writeln();
	writeln('Você acessou o arquivo ',name);
	repeat

		assign(arqProc,name);
		escolha:=menuArq();
		case escolha of
		1:
		Begin

			reset(arqProc);				
			coletarDados(arqProc,novoAluno);
			inserirOrdenado(arqProc,novoAluno);
			close(arqProc);

		End;

		2:
		Begin

			reset(arqProc);
			apagarAluno(arqProc);
			close(arqProc);
		
		End;

		3:
		Begin
	
			reset(arqProc);
			editarDados(arqProc);
			close(arqProc);

		End;

		4:
		Begin

			reset(arqProc);
			consulta(arqProc);
			close(arqProc);

		End;
	END;{FIM do case}
	option:=lerChar('snSN', 'Deseja sair desse arquivo?Digite [S]im ou [N]ão');		
	until option='S';

End; 
	
procedure inserirAtiva(var primeiro,ultimo:pDescritorArq;name:string);

var

	pNovo:pDescritorArq;
	pAtual:pDescritorArq;{esse é para realizar as comparações e identificar onde inserir na lista ativa}
	pAux:pDescritorArq;

begin

	new(pNovo);
	pNovo^.nomeTurma:=name;
	assign(pNovo^.turma,pNovo^.nomeTurma);
	abrirCriar(pNovo^.turma);
	reset(pNovo^.turma);
	pNovo^.anterior:=nil;
	pNovo^.proximo:=nil;
	if primeiro = nil then
	begin
		primeiro:=pNovo;
		ultimo:=pNovo;
	end
	else
	begin
		pAtual:=primeiro;{confere se o a inserção deve ser feita no começo ou no meio}
		if pAtual^.nomeTurma > pNovo^.nomeTurma then
		begin

			pNovo^.proximo:=pAtual;
			pAtual^.anterior:=pNovo;
			pNovo^.anterior:=nil;
			primeiro:=pNovo;

		end
		else
		begin

			repeat 
				if pAtual^.nomeTurma > pNovo^.nomeTurma then
				begin
					pNovo^.anterior:=pAtual^.anterior;
					pAtual^.anterior:=pNovo;
					pNovo^.proximo:=pAtual;
					pAux:=pNovo^.anterior;
					pAux^.proximo:=pNovo;
				end
				else
				begin
					pAtual:=pAtual^.proximo;
				end;
			until (pAtual<>ultimo) or (pNovo^.anterior <> nil);{isso cria uma condição para a execução do loop:enquanto o arquivo não for inserido na lista de ativos, ou seja, seu ponteiro(anterior) estiver apontando para nil.Observe que, como já foi feito o teste se ele devia ser inserido no começo, então o seu ponteiro anterior não pode apontar para nil}
			if (pNovo^.anterior = nil) then{Ocorre o risco de o arquivo ter que ser inserido no final da lista.Nesse caso, após a execução do loop anterior ambos os ponteiros continuarão apontando para nil}
			Begin
				pNovo^.anterior:=ultimo;
				pNovo^.proximo:=nil;
				ultimo^.proximo:=pNovo;
				ultimo:=pNovo;
			End; 
		end;{fim do else}
	end;{fim do outro else}
end;

function buscarNaLista(primeiro:pDescritorArq;nomeArq:string;var existe:boolean):pDescritorArq;{essa função retorna o lugar em que está guardado o arquivo na lista.nomeArq é o nome do arquivo que se deseja buscar}
var

	pAux:pDescritorArq;{variável que armazena temporariamente os dados para realizar a comparação}
	
Begin

	existe:=false;
	writeln();
	buscarNaLista:=nil;{se não for encontrado o nome do arquivo na lista, então a função retorna nil}
	pAux:=primeiro;
	if primeiro= nil then
	begin

		writeln('A lista ainda está vazia');

	end
	else
	begin

		if pAux^.nomeTurma = nomeArq then{testa se o arquivo está logo na primeira posição, evitando a necessidade de percorrer a lista inteira}
		begin
			
			existe:=true;
			buscarNaLista:=pAux;
				
		end
		else
		begin

			while (pAux<>nil) and (buscarNaLista=nil) do{estabelece limites para a execução do loop, enquanto o pAux não estiver apontando para nil e o valor da função não mudar} 
     		 begin

         	if pAux^.nomeTurma=nomeArq then
     			begin
			
					existe:=true;
					buscarNaLista:=pAux;

				end;

         	pAux:=pAux^.proximo;
		
			end;
	 	end; 			
	end;
End;

procedure apagarArq(var primeiro:pDescritorArq);
var

	pAux:pDescritorArq;{armazena os dados do descritor que se deseja apagar}
	pAuxPrev:pDescritorArq;{precisa -se de um outro ponteiro que guarde os dados do anterior ao que se deseja apagar}
	pAuxNext:pDescritorArq;{precisa-se de um outro ponteiro que guarde os dados do posterior ao que se deseja apagar}
	nomeArq:string;
	existe:boolean;

Begin

	existe:=false;
	nomeArq:=lerString(1,60,ALFANUM,'Digite o nome do arquivo que deseja apagar.O nome do arquivo só pode conter letras, números e no máximo 60 caracteres');
	pAux:=buscarNaLista(primeiro,nomeArq,existe);
	if (existe = false) then
	begin

		writeln('O arquivo não existe ou não foi inserido na lista de ativas');

	end
	else
	begin

		
		assign(pAux^.turma,pAux^.nomeTurma);
		reset(pAux^.turma);
		close(pAux^.turma);{para poder apagar um arquivo tem que fechá-lo antes}
		if pAux^.nomeTurma = primeiro^.nomeTurma then{testa se o arquivo é logo o primeiro da lista}
		begin

			primeiro:=primeiro^.proximo;
			erase(pAux^.turma);
			dispose(pAux);
			writeln('Arquivo apagado com sucesso');

		end
		else
		begin

			pAuxPrev:=pAux^.anterior;
			pAuxNext:=pAux^.proximo;
			pAuxPrev^.proximo:=pAux^.proximo;{o ponteiro que aponta para o próximo do  descritor anterior ao que se deseja apagar tem que apontar para o que vinha em seguida do descritor a ser apagado}
			pAuxNext^.anterior:=pAux^.anterior;{o ponteiro que aponta para o anterior do descritor que vinha depois do que se deseja apagar tem que apontar para o que vinha antes do descritor a ser apagado} 
			erase(pAux^.turma);
			dispose(pAux);
			writeln('arquivo apagado com sucesso');
		end;{fim do else interno}
	end;
End;

procedure exibirLista(var primeiro:pDescritorArq);
Var

	pAux:pDescritorArq;

Begin

	pAux:=primeiro;
	if pAux=nil then
	begin

		writeln('A lista está vazia');

	end
	else 
	begin
	
		writeln('Arquivos abertos:');
		writeln();
  		repeat

			writeln();		
   		writeln(pAux^.nomeTurma);
   		pAux := pAux^.proximo;

	   until pAux=nil;
	end;

End;

function menuPrincipal():integer;
var

	escolha:integer;

Begin

	writeln('Escolha uma dessas opções:');
	writeln();
   writeln('1-Incluir nova turma na lista');
   writeln('2-Abrir um arquivo');
   writeln('3-Apagar um arquivo');
	writeln('4-Sair');
   escolha:=lerInteiro(1,4,'Escolha uma opção de 1 a 4.Ela deve ser um inteiro');
	menuPrincipal:=escolha;

End;

procedure executarPrincipal(var primeiro,ultimo:pDescritorArq);	
var

	opcao:integer;
	pAux:pDescritorArq;{aramzena os dados retornados da função buscarNaLista}
	nomeArquivo:string;
	existe:boolean;

Begin

	repeat

		writeln();
		exibirLista(primeiro);
		writeln();
		opcao:=menuPrincipal();
		case opcao of
		1:
		Begin

			nomeArquivo:=lerString(1,60,ALFANUM,'Digite o nome do arquivo que deseja inserir.O nome do arquivo só pode conter letras, números e no máximo 60 caracteres');
			pAux:=buscarNaLista(primeiro,nomeArquivo,existe);
			if pAux <> nil then
			begin
	
				writeln('Esse arquivo já consta na lista');
		
			end
			else
			begin
 
				inserirAtiva(primeiro,ultimo,nomeArquivo);
				
			end;

		End;

		2:
		Begin
		
			nomeArquivo:=lerString(1,60,ALFANUM,'Digite o nome do arquivo que deseja abrir.O nome do arquivo só pode conter letras, números e no máximo 60 caracteres');
			pAux:=buscarNaLista(primeiro,nomeArquivo,existe);
			if existe=false then
			begin

				writeln();
				writeln('Esse arquivo ainda não foi inserido na lista.Para inserí-lo basta pressionar a tecla 1');

			end
			else
			begin

				executarEscolha(pAux^.turma,pAux^.nomeTurma);
				
			end;
						
		End;

		3:
		Begin
	
			apagarArq(primeiro);

		End;
		END;{FIM do case}
	
	until opcao=4;
	
End; 
{Programa Principal}

Var

	First,Last:pDescritorArq;

Begin

	First:=nil;
	Last:=nil;
	executarPrincipal(First,Last);	

End.
