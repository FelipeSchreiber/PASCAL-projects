program	arvore_para_pilha;
{Objetivo: transformar uma lista não linear em uma linear e ir imprimindo na tela os contatos em ordem alfabética
 Responsável:Felipe Schreiber Fernandes
 Data:15/12/2016}
uses

	minhaBiblioteca;

type

	noAgenda=^regAgenda;
	
	pPilha=^pilha;
	
	regAgenda=record
				nome:string;
				tel:string;
				esq,dir:noAgenda;

			end;
	
	pilha=record
		nome:string;
		tel:string;
		anterior,proximo:pPilha;
		tree:noAgenda;

	end;

function menu():integer;
var

	opcao:integer;

Begin

	Writeln('Escolha uma dessas opções:');
	writeln();
	writeln('1-Incluir novo contato');
	writeln('2-Listar todos os contatos');
	writeln('3-Sair');
	opcao:=lerInteiro(1,3,'Digite uma das opções acima.Só pode ser um inteiro entre 1 e 3');
	menu:=opcao;

End;			

procedure incluir(raiz:noAgenda;novo:noAgenda);
var
	incluiu:boolean;
	atual:noAgenda;
	aux:pPilha;{a variável auxiliar serve para fazer uma lista paralela que guarda a referência do anterior ao atual na árvore}
	primeiro,ultimo:pPilha;
begin

	primeiro:=nil;
	ultimo:=nil;
	new(atual);
	atual:=raiz;
	incluiu:=false;
	repeat

		if atual=nil then
		begin
			if novo^.nome > ultimo^.nome then{compara se o novo deve ser inserido à esquerda ou à direita do último nó da árvore}
			begin
				ultimo^.tree^.dir:=novo;{o ultimo da pilha possui a referência do último nó da árvore, assim basta irmos para ele e inserir o novo}
			end
			else
			begin
				ultimo^.tree^.esq:=novo;{mesma lógica, só que para o caso em que ele tiver que ser inserido na esquerda}
			end;
			incluiu:=true;
			writeln('Contato inserido com sucesso');
		end
		else
		begin
			incluiu:=false;
			if novo^.nome > atual^.nome then
			begin
				new(aux);
				aux^.tree:=atual;
				aux^.proximo:=nil;
				aux^.anterior:=nil;
		{cria uma nova variável auxiliar que será inserida na lista paralela e assim guardar a referência do nó atual da árvore}
				if primeiro=nil then
				begin
					primeiro:=aux;
					ultimo:=aux;
				end
				else
				begin
					ultimo^.proximo:=aux;
					aux^.anterior:=ultimo;
					ultimo:=aux;
					{coloca a nova variável auxiliar no final da lista}
				end;
				atual:=atual^.dir;
			end
			else
			begin
				{mesma lógica, só que para o caso em que tiver que ir para a esquerda}
				new(aux);
				aux^.tree:=atual;
				aux^.proximo:=nil;
				aux^.anterior:=nil;
				if primeiro=nil then
				begin
					primeiro:=aux;
					ultimo:=aux;
				end
				else
				begin
					ultimo^.proximo:=aux;
					aux^.anterior:=ultimo;
					ultimo:=aux;
				end;
				atual:=atual^.esq;
			end;
		end;			
	until	incluiu;
end;


procedure coletarDados(var raiz:noAgenda);
var

	novo:noAgenda;
	choice:char;

Begin

	repeat 
		new(novo);
		novo^.nome:=lerString(1,30,ALFABETO+SPACE,'Digite o nome do contato a ser inserido.Só podem conter letras e no máximo 30 caracteres');
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
			incluir(raiz,novo);
		end;
		
		writeln();
		choice:=lerChar('snSN','Deseja inserir outro contato?Digite [S]im ou [N]ão');
		choice:=upcase(choice);
	until	choice='N';
End;	

	
procedure exibir(raiz:noAgenda);
var
	atualArvore:noAgenda;{esse ponteiro percorre a árvore e passa o dados para o ponteiro auxiliar}
	aux:pPilha;{esse ponteiro armazena o telefone, o nome da pessoa, o próximo e o anterior da pilha bem como o seu correspondente na árvore}
	primeiro,ultimo:pPilha;{onde começa e onde termina a pilha}

begin

	atualArvore:=raiz;
	primeiro:=nil;
	ultimo:=nil;

	if atualArvore=nil then
	begin
		writeln('Não há contatos na lista');
	end
	else
	begin
		repeat

			if atualArvore<>nil then
			begin
				
				new(aux);
				aux^.tree:=atualArvore;
				aux^.nome:=atualArvore^.nome;
				aux^.tel:=atualArvore^.tel;
				aux^.proximo:=nil;
				aux^.anterior:=nil;

				if primeiro=nil then
				begin
					primeiro:=aux;
					ultimo:=aux;
				end
				else
				begin
					ultimo^.proximo:=aux;
					aux^.anterior:=ultimo;
					ultimo:=aux;
				end;

				if atualArvore^.esq<>nil then
				begin
					atualArvore:=atualArvore^.esq;
				end
				else
				begin
					if atualArvore^.dir<>nil then
					begin
					{quando apenas o ponteiro da direita é nil devemos desempilhar o nó da lista e ir para o seguinte, ou seja, o filho da direita}
						writeln('Nome: ',atualArvore^.nome,#9,'Tel: ',atualArvore^.tel);{imprime os dados do nó}
						ultimo:=aux^.anterior;
						dispose(aux);{retira o último da pilha, que é o que acabou de ser colocado}
						ultimo^.proximo:=nil;
						atualArvore:=atualArvore^.dir;
					end
					else
					begin
						writeln('Nome: ',aux^.nome,'Tel: ',aux^.tel);
						atualArvore:=aux^.anterior^.tree;{volta para a posição da árvore para a qual o anterior da pilha aponta.Observe que se o ladoesquerdo já foi desempilhado, então subiremos dois níveis na árvore}
						ultimo:=aux^.anterior;
						dispose(aux);{desempilha o último da pilha, que é o que acabou de ser colocado}
						ultimo^.proximo:=nil;

						{quando ambos os ponteiros esquerda e direita são nil temos que exibir o último que foi posto na pilha e também o nó}
						{Depois tirá-los da pilha}

						writeln('Nome: ',ultimo^.nome,'Tel: ',ultimo^.tel);{imprime os dados do nó}
						new(aux);{esse novo espaço criado é apenas para auxiliar no processo de rearranjar a pilha}
						aux:=ultimo;
						ultimo:=aux^.anterior;
						if ultimo <> nil then
						begin
							ultimo^.proximo:=nil;
						end
						else
						begin
							primeiro:=nil;{caso o último seja nil significa que chegamos ao topo da árvore}
						end;
						dispose(aux);{retira da pilha}
						if atualArvore^.dir<>nil then{após subir dois níveis da árvore é necessário checar se há filho há direita da posição atual}
						begin
							atualArvore:=atualArvore^.dir;{agora descemos para o lado direito do nó}
						end
						else
						begin
							atualArvore:=ultimo^.tree;{sobe mais um nível}
						end;
					end;
				end;
			end;	
		until atualArvore=nil;
	end;	
end;		

	
procedure executar(var raiz:noAgenda);
var
	option:integer;{armazena o valor retornado pela função menu}
	escolha:char;
begin

	repeat 
		repeat
			option:=menu();
			case option of
			1:
			Begin
				coletarDados(raiz);
			End;

			2:
			Begin
				exibir(raiz);
			End;
	
			end; 
		until option=3;
		writeln();
		escolha:=lerChar('snSN','Deseja sair do programa?Digite [S]im ou [N]ão');
		escolha:=upcase(escolha);
		
	until	escolha='S';
end;		

{Programa Principal}
var
	root:noAgenda;
BEGIN
	root:=nil;
	executar(root);
END.







    
