program registro_de_movimentacoes;
{Feito por Felipe Schreiber Fernandes															DRE 116 206 990
 Turma ELL170 EL3
 última modificação:24/11/2016}
uses minhaEstante;
const

	MAX=200;
	ALFANUM='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

type

	cadastro=record 
			EP:char;
			cod:integer;
			qtd:real;
			nome:string;
	end;
	
	matrix=array[1..MAX] of cadastro;

	fEntradaSaida=file of cadastro;



procedure inicializarMatriz(var matrizInicial:matrix);

var

	indice:integer;

begin

	for indice:=0 to MAX do
	begin
		
		matrizInicial[indice].nome:='-';
		
		matrizInicial[indice].cod:=-1;		

		matrizInicial[indice].EP:= '-';

		matrizInicial[indice].qtd:=0;

	
	end;

end;

procedure abrirCriar(var fHistorico,fEntrada,fSaida,fConcatenado,fMerge:fEntradaSaida;var matHistorico:matrix);
{Esse procedimento cria ou abre cinco arquivos de uma só vez, um com todas as transações, um de entrada, um de saída,um concatenado e por fim o do merge} 
var
	nome,nomeBase:string;

{nome do arquivo salvo ou que será criado na parte externa do programa}

	indMat:integer;

{indMat é o indice para variar a posição da matriz ao copiar os dados do arquivo para ela}
Begin

	writeln('informe o nome do arquivo a ser aberto ou criado');
	
	readln(nomeBase);

	assign(fHistorico,nomeBase);

	nome:=nomeBase + '_Entrada';
	
	assign(fEntrada,nome);

	nome:=nomeBase + '_Saida';

	assign(fSaida,nome);

	nome:=nomeBase + '_Concatenado';

	assign(fConcatenado,nome);

	nome:=nomeBase + '_Merge';

	assign(fMerge,nome);
	
	{$I-}

	reset(fHistorico);

	reset(fEntrada);

	reset(fSaida);

	reset(fConcatenado);

	reset(fMerge);
	
	{$I+}
	If (ioresult = 2) then
	begin

	
		rewrite(fHistorico);

		rewrite(fEntrada);

		rewrite(fSaida);

		rewrite(fConcatenado);

		rewrite(fMerge);
	

		writeln('o histórico foi criado');
		
	end
	
	else
	begin

		writeln('o histórico foi aberto');

	end;

	
	{começar a copiar os dados do arquivo para a matriz}
	
		indMat:=1;

		while (not eof(fHistorico)) and (indMat<=MAX) do
		begin
		{esse laço garante que todos os dados do arquivo serão copiados}

			read(fHistorico,matHistorico[indMat]);

			indMat:=indMat+1;
			{a variável indMat garante que os dados serão copiados em diferentes posições da matriz}
			
		end;

		if (filepos(fHistorico) <> filesize(fHistorico)) then
		{se por um acaso a cópia de dados terminar antes de se chegar ao fim do arquivo, ou seja, o indMat possui um limite inferior à quantidade de posições, exibirá tal mensagem ao usuário}
		begin

			writeln('nem todos os arquivos foram copiados para a matriz, aumente o valor da constante');

		end; 

end;

procedure gravarMovimentacao(var matProc:matrix);

var
ind:integer;

{ind é uma variável de controle das posições da matriz}

posi:integer;

{posi é uma variável para descubrir o primeiro espaço livre na matriz para preencher os dados da movimentação}

Begin

	posi:=0;

	ind:=1; 

	while (ind<=MAX) and (matProc[ind].cod <> -1) do
	{quando o ind tiver o valor MAX estará na última posição da matriz e, caso esteja preenchida, possuirá, ao final do bloco de comandos, o valor MAX+1, daí é necessário que o se encerre o bloco de comandos visto que essa posição está além do limite da matriz}
	
	{esse laço é para encontrar a primeira posição não ocupada na matriz}
	begin
				
		{como todos os registros da matriz no campo do codigo foram inicializados com menos um (-1) então se o respectivo campo for diferente disso significa que tal posição da matriz já foi preenchida}
				
		ind:=ind+1;

	end;		

			posi:=ind;
		{caso o referido campo esteja livre, ou seja, preenchido com menos um (-1),então essa é a primeira posição desocupada da matriz e a variável posi armazenará o valor da ind (que é a variável de controle), uma vez que quando for diferente chegará ao fim do incremento da ind}
 
	if (posi<>MAX+1) then		
	{essa condição garante que tem espaço sobrando na matriz para preencher com dados, para tal é preciso que o valor da variável posi esteja dentro  do limite da matriz}
	{Na situação limite, quando todos as posições da matriz estiverem preenchidas, a variável ind terá o valor de MAX+1}

	begin

		matProc[posi].nome:=lerString(1,20,ALFANUM,'Digite o nome do produto a ser inserido.Só pode conter letras e números, não usar caracteres especiais');

		lerInteiro(matProc[posi].cod,1001,9999,'insira o código do produto.O valor tem que ser um inteiro entre 1001 e 9999');
				
		matProc[posi].qtd:=lerReal(0,32767,'diga a quantidade de entrada/saída. Ela deve ser um real entre 0 e 32767');

  		matProc[posi].EP:=lerChar('epEP','Informe se a transação foi de [E]ntrada ou [S]aída.Digite em letra maiúscula E para Entrada ou P para Saída.Só pode conter um caractere');

		writeln('produto inserido com sucesso');

		writeln();

		writeln();

	end

	else

	begin
		writeln('não há mais espaço disponível para inserir movimentações.', ' Se você desejar aumentar o número de transações guardadas basta trocar o valor da constante');
		writeln();
		writeln();
	end;
end;

procedure ordenar_por_codigo(var matProc:matrix);
{algoritmo do tipo BubbleSort}
var

ind1,ind2:integer;

aux:cadastro;

Begin

	For ind1:=1 to MAX-1 do
	Begin

		For ind2:=1 to MAX-1 do
		Begin

			if (matProc[ind2].cod > matProc[ind2+1].cod) then
			Begin

				aux:=matProc[ind2];

				matProc[ind2]:=matProc[ind2+1];

				matProc[ind2+1]:=aux;		

			End;

		End;	
	
	End;

end;

procedure printMerge(var fMerge:fEntradaSaida);
var

cadastroTemp:cadastro;
controle:integer;

begin

	controle:=0

	seek(fMerge,0);

	while (not eof(fMerge)) do
	begin

		controle:=1;

		read(fMerge,cadastroTemp);
		{copia os dados temporariamente para uma variável} 
		if (cadastroTemp.cod<>-1) then
		{esse laço evita a exibição de movimentações não preenchidas}
		begin
		
			writeln('o código do produto é: ',cadastroTemp.cod);

   		writeln('o nome do item é ',cadastroTemp.nome);
			
			case cadastroTemp.EP of
			
			'E':
			Begin

				writeln('Entraram ',cadastroTemp.qtd:5:3, 'unidades');

			end;

			'P':
			Begin

				writeln('Saíram ', cadastroTemp.qtd:5:3,' unidades');

			End;
		
			end;{end do case}

		end;{end do if}

	end;{end do while}

	if (controle=0) then
 	begin

		writeln('o arquivo merge está vazio');
	
	end

	else
	begin

			writeln('fim da exibição');

	end;
end;

procedure printEntrada(var fEntrada:fEntradaSaida);
{esse procedimento exibe apenas as movimentações de Entrada}
var

cadastroTemp:cadastro;
controle:integer;

begin
	
	controle:=0;

	seek(fEntrada,0);

	while not eof(fEntrada) do
	begin

		read(fEntrada,cadastroTemp);

		if (cadastroTemp.cod<>-1) then
		begin
		
			writeln('o código do produto é: ',cadastroTemp.cod:4);

   		writeln('o nome do item é ',cadastroTemp.nome);
		
			writeln('Entraram ',cadastroTemp.qtd:5:3, 'unidades');
			
			controle:=1;
		
		end;

	end;
	if (controle=0) then
	begin

		writeln('não houve transações de entrada ou você ainda não efetuou a separação do arquivo em entrada e saída');

	end

	else
	begin

		writeln('fim da exibição');

	end;

end;		

procedure printConcatenado(var fConcatenado:fEntradaSaida);
{esse procedimento exibe apenas o arquivo concatenado}
var

cadastroTemp:cadastro;
controle:integer;{essa variável serve para saber se o arquivo concatenado existe}
begin

	controle:=0;
	
	seek(fConcatenado,0);

	while not eof(fConcatenado) do
	begin

		controle:=1;

		read(fConcatenado,cadastroTemp);

		if (cadastroTemp.cod<>-1) then
		begin
		
			writeln('o código do produto é: ',cadastroTemp.cod:4);

   		writeln('o nome do item é ',cadastroTemp.nome);

			if cadastroTemp.EP= 'E' then
			begin

				writeln('Entraram ',cadastroTemp.qtd:5:3, 'unidades');

			end

			else
			begin
	
				writeln('Saíram ',cadastroTemp.qtd:5:3,' unidades');

			end;

		end;

	end;

	if (controle = 0) then
	begin	
		
		writeln('o arquivo concatenado está vazio');

	end

	else
	begin

		writeln('fim da exibição');

	end;
end;

procedure printSaida(var fSaida:fEntradaSaida);
{esse procedimento imprime apenas as movimentações de saída}
var

cadastroTemp:cadastro;
controle:integer;
{essa variável serve para controlar se houve ou não transações}
begin
	
	controle:=0;

	seek(fSaida,0);
	
	while not eof(fSaida) do
	begin

		read(fSaida,cadastroTemp);

		if (cadastroTemp.cod<>-1) then
		begin
		
			writeln('o código do produto é: ',cadastroTemp.cod:4);

   		writeln('o nome do item é ',cadastroTemp.nome);
		
			writeln('Saíram ',cadastroTemp.qtd:5:3, 'unidades');
			
			controle:=1;

		end;

	end;

	if (controle=0) then
	begin

		writeln('não houve transações de saída ou você ainda não efetuou a separação do arquivo em entrada e saída');
	end

	else
	begin

		writeln('fim da exibição');

	end;

end;

procedure printMovimentacoes(matProc:matrix);
{esse procedimento imprime apenas as movimentações de determinado produto}
var

codigo,ind:integer;
name:string;
op:char;

Begin

	op:=lerChar('cnCN','como deseja buscar as transações do produto, por código ou por nome?Digite apenas uma letra, C para código ou N para nome');
	case op of

	'C':
	Begin
	lerInteiro(codigo,1001,9999,'Digite o código do produto.Ele deve ser um inteiro entre 1001 e 9999.');

		for ind:=1 to MAX do
		begin

			if (matProc[ind].cod = codigo) then
			begin

			  writeln('o código do produto é: ',matProc[ind].cod:4);

     		  writeln('o nome do item é ',matProc[ind].nome);
         
		  	  case matProc[ind].EP of
	
        		    'E':
        		    Begin

             		writeln('Entrada de ',matProc[ind].qtd:5:3,' unidades');

       		    End;

			       'P':
                Begin

                  writeln('Saída de ',matProc[ind].qtd:5:3,' unidades');

           	    End;
				end;{end do case interno}
		   end;{end do if}
		end;{end do for}
	end;{end do case 'C'}

	'N':
	Begin

	  writeln('qual o nome do produto?');
	
	  readln(name);

		for ind:=1 to MAX do
		begin

			if (matProc[ind].nome = name) then
			begin

			  writeln('o código do produto é: ',matProc[ind].cod:4);

     		  writeln('o nome do item é ',matProc[ind].nome);
         
		  	  case matProc[ind].EP of
	
        		    'E':
        		    Begin

           			writeln('Entrada de ',matProc[ind].qtd:5:3,' unidades');

           	    End;

			  	    'P':
            	 Begin

              	   writeln('Saída de ',matProc[ind].qtd:5:3,' unidades');

           		 End;
				end;{end do case interno}
	    end;{end do if}
     end;{end do for}
	 end;{end do case 'N'}
	end;{end do case externo}
end;{end do procedure}

procedure printHistorico(matProc:matrix);
{esse procedimento imprime na tela todos as transações e suas respectivas informações}
var

ind,controle:integer;

begin

		controle:=0;
		{a variável de controle serve para saber se o arquivo está vazio ou não}

		for ind:=1 to MAX do
		begin
		
 			if (matProc[ind].cod <> -1) then
		{essa condição estabelece um limite de transações a serem exibidas na tela.Como todos os elementos do record no campo designado para o código foram inicializados com menos um (-1) então se estiver preenchido com algo diferente indica a presença de uma transação, evitando a necessidade de se exibir algo que ainda não foi preenchido}
			begin
				
				controle:=1;

				writeln('o código do produto é: ',matProc[ind].cod:4);

				writeln('o nome do item é ',matProc[ind].nome);
				case matProc[ind].EP of 

				'E':
				Begin

					writeln('Entrada de ',matProc[ind].qtd:5:3,' unidades');

				End;

				'P':
				Begin

					writeln('Saída de ',matProc[ind].qtd:5:3,' unidades');

				End;

				end;{end do case}
			
			end;{end do if}

		end;{end do for}		

	if (controle=0) then
	begin

		writeln('o arquivo está vazio');

	end

	else
	begin

		writeln('fim da exibição');		
	
	end;	
end;

procedure salvar(var fHistorico:fEntradaSaida; matHistorico:matrix);
{Esse procedimento copia os dados da matriz para o arquivo e salva todos os arquivos}
Var

ind:integer;

begin

	seek(fHistorico,0);
	for ind:=1 to MAX do
	begin
		
 		if (matHistorico[ind].qtd <> -1) then
		{Como todos os elementos do record no campo designado para a quantidade foram inicializados com menos um (-1) então se estiver preenchido com algo diferente indica apresença de um produto preenchido, evitando a necessidade de se passar para o arquivo algo que ainda não foi preenchido}
		begin	

			write(fHistorico,matHistorico[ind]);
		
		end

	end;

end;	

procedure separar_em_entrada_ou_saida(var fHistorico,fEntradas,fSaidas:fEntradaSaida);
var

historicoTemp:cadastro;
{essa variável armazena temporariamente os dados do arquivo}
Begin

	seek(fHistorico,0);
	seek(fEntradas,0);
	seek(fSaidas,0);
	while (not eof(fHistorico)) do
	begin
	
		read(fHistorico,historicoTemp);
		if (historicoTemp.EP = 'E') then
		begin

			write(fEntradas,historicoTemp);
	
		end

		else
		begin

			write(fSaidas,historicoTemp);

		end;
	
	end;

end;

procedure concatenar(var fConcatenado,fEntrada,fSaida:fEntradaSaida);
var

cadastroTemp:cadastro;
{armazena temporariamente os dados dos arquivos}

Begin

	seek(fConcatenado,0);

	seek(fEntrada,0);

	seek(fSaida,0);

	while (not	eof(fEntrada)) do
	{primeiro lê todos os dados do arquivo de entrada, passa para uma variável e aí passa para o arquivo concatenado}
	begin

		read(fEntrada,cadastroTemp);
		
		write(fConcatenado,cadastroTemp);

	end;

	while (not eof(fSaida)) do
	{o mesmo processo é realizado, só que com o arquivo de saída}
	begin

		read(fSaida,cadastroTemp);

		write(fConcatenado,cadastroTemp);

	end;	
	
end;

procedure fazer_merge(var fMerge,fEntrada,fSaida:fEntradaSaida);
var

cadastroS,cadastroE:cadastro;

Begin

	seek(fEntrada,0);

	seek(fSaida,0);

	seek(fMerge,0);

	while (not eof(fEntrada)) and (not eof(fSaida)) do
	{até que se chegue ao final de um dos arquivos o merge ocorrerá normalmente}
	Begin
		{copia os dados de cada arquivo para armazenamentos temporários para possibilitar a respectiva comparação}

		read(fEntrada,cadastroE);

		read(fSaida,cadastroS);

		{começa a copiar para o merge o menor dos dois códigos comparados}
		if (cadastroS.cod > cadastroE.cod) then
		Begin

			write(fMerge,cadastroE);
				
			seek(fSaida,filepos(fSaida)-1);			

			{é necessário voltar uma posição no arquivo cujo dado não foi copiado para realizar a próxima comparação}
		End

		Else
		{o mesmo processo é realizado, só que no caso oposto}
		Begin

			write(fMerge,cadastroS);

			seek(fEntrada,filepos(fEntrada)-1);
	
		End;
	
	End;{end do while}

	if (filepos(fEntrada) = filesize(fEntrada)) then
	{essa condição é para ver qual arquivo chegou ao fim primeiro, visto que é impossível que ambos cheguem ao mesmo tempo}
	begin

		while not eof(fSaida) do
		{se o de entrada chegou ao fim primeiro, então significa que o de saída não foi totalmente passado para o arquivo merge}
		begin

			read(fSaida,cadastroS);
			
			write(fMerge,cadastroS);

		end;
	
	End

	Else
	{mesmo procedimento anterior, só que para o caso oposto}
	Begin

		while not eof(fEntrada) do
		begin

			read(fEntrada,cadastroE);
			
			write(fMerge,cadastroE);

		end;{end do while}

	end;{end do else}
	
End;{end do procedure}
{Programa Principal}

VAR
matrizPrincipal:matrix;
Historico,Entrada,Saida,Concatenado,Merge:fEntradaSaida;
choice:integer;
BEGIN
	choice:=0;
	inicializarMatriz(matrizPrincipal);
	abrirCriar(Historico,Entrada,Saida,Concatenado,Merge,matrizPrincipal);
	repeat	  
			writeln('escolha uma opção:');
			writeln();
			writeln('1-Fazer Movimentação');
			writeln();
			writeln('2-Buscar movimentações pelo nome ou pelo código');
			writeln();
			writeln('3- Ordenar movimentações por código');
			writeln();
			writeln('4-Dividir o arquivo em entrada e saída');			
			writeln();
			writeln('5-Concatenar os arquivos de entrada e saída');
			writeln();
			writeln('6-Fazer um merge dos arquivos de entrada e saída');
			writeln();
			writeln('7-Exibir todas as movimentações ');
			writeln();
			writeln('8-Exibir as movimentações de entrada');
			writeln();
			writeln('9-Exibir as movimentações de saída');
			writeln();
			writeln('10-Exibir as movimentações do arquivo concatenado');
			writeln();
			writeln('11-Exibir as movimentações do arquivo merge');
			writeln();
			writeln('12-Sair do programa');
			writeln();
			lerInteiro(choice,1,12,'Escolha uma opção entre 1 e 12. Ela deve ser um inteiro');
				
			case choice of

				1:
				begin

					gravarMovimentacao(matrizPrincipal);
					salvar(Historico,matrizPrincipal);
				 
				end;
			
				2:
				begin
	
					 printMovimentacoes(matrizPrincipal);
				
				end;	

				3:
				begin

					ordenar_por_codigo(matrizPrincipal);
					salvar(Historico,matrizPrincipal);

				end;	
			
				4:
				begin

					 separar_em_entrada_ou_saida(Historico,Entrada,Saida);
					writeln();

					writeln('os arquivos de entrada e de saida foram criados');
					
					writeln();

				end;
				
				5:
				begin
					
					ordenar_por_codigo(matrizPrincipal);				
					separar_em_entrada_ou_saida(Historico,Entrada,Saida);									 concatenar(Concatenado,Entrada,Saida);

				end;

				6:
				Begin

					ordenar_por_codigo(matrizPrincipal);				
					salvar(Historico,matrizPrincipal);
					separar_em_entrada_ou_saida(Historico,Entrada,Saida);				
					{Para fazer o merge é necessário que antes os arquivos de entradae saída estejam ordenados e estejam preenchidos}
					 fazer_merge(Merge,Entrada,Saida);

					 writeln('o arquivo merge foi criado');

				End;

				7:
				Begin

					 printHistorico(matrizPrincipal);
				
				End;

				8:
				Begin
					
					printEntrada(Entrada);
														
				End;

				9:
				Begin

					printSaida(Saida);
			
				End;


				10:
				Begin

					printConcatenado(Concatenado);
					
				End;				

				11:
				Begin

					printMerge(Merge);

				End;
		
				12:
				Begin

					salvar(Historico,matrizPrincipal);

					close(Entrada);

					close(Saida);

					close(Concatenado);

					close(Merge);

					writeln('arquivos salvos com sucesso');

				End;
			end;{end do case}
	until (choice=12);
END.

