program guardarContato;
{Feito por Felipe Schreiber Fernandes                                            DRE 116 206 990
 Turma ELL170 EL3
Última modificação: 24/11/2016}
uses minhaEstante;
Const
	MAX=1000;{máximo de 2147483647}

	ALFANUM='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

type
	recContatos=record
				rName:string;
				rNum:longint;
	end;

	matContatos=array[1..MAX] of recContatos;

	fContatos=file of	recContatos;

procedure inicializarMatriz(var matrizInicial:matContatos);

var
	indice:integer;

begin

	for indice:=1 to MAX do
	begin

		matrizInicial[indice].rName:= '';

		matrizInicial[indice].rNum:=0;
	
	end;
end;

procedure copiar (var fAgenda:fContatos;var matAgenda:matContatos);

var

	indMat:integer;

{indMat é o indice para variar a posição da matriz ao copiar os dados do arquivo para ela}
Begin

		indMat:=1;

		while (not eof(fAgenda)) and (indMat<=MAX) do
		begin
		{esse laço garante que todos os dados do arquivo serão copiados}

			read(fAgenda,matAgenda[indMat]);

			indMat:=indMat+1;
			{a variável indMat garante que os dados serão copiados em diferentes posições da matriz}
			
		end;

end;

procedure inserirContato(var mAgenda:matContatos);

var
	ind:integer;

{ind é uma variável de controle das posições da matriz}

	posi:integer;

{posi é uma variável para descubrir o primeiro espaço livre na matriz para preencher os dados do contato}

Begin
	posi:=0;

	ind:=1; 

	repeat
	{esse laço é para encontrar a primeira posição não ocupada na matriz}

		if (mAgenda[ind].rNum<>0) then
		
		{como todos os registros da matriz no campo do número foram inicializados com um 0 (zero) então se o respectivo campo for diferente disso significa que tal posição da matriz já foi preenchido}
		begin
		
			ind:=ind+1;

		end

		else
		begin

			posi:=ind;
		{caso o referido campo esteja livre, ou seja, preenchido com um traço '-',então essa é a última posição ocupada da matriz e a variável posi armazenará o mesmo valor da ind, que é a variável de controle}

		end;	
	
	until (ind=MAX+1) or (posi<>0);
	{caso a última posição da matriz esteja preenchida, o índice que já está com o valor da constante MAX receberá mais um ao lê-la, ultrapassando o limite da matriz}
	if (posi<>MAX+1) then		
	{essa condição garante que tem espaço sobrando na matriz para preencher com dados}

	begin
	
		mAgenda[posi].rName:=lerString(1,255,ALFANUM,'insira nome do novo contato. Só pode conter no máximo 255 caaracteres');

		mAgenda[posi].rNum:=lerLongint(0,2147483647,'insira o número do contato.Ele deve ser um inteiro entre 0 e 2147483647');
		
		writeln('contato salvo com sucesso');

		writeln();

		writeln();

	end

	else

	begin
		writeln('não há mais espaço disponível para preencher os dados.', ' Se você desejar aumentar o número de contatos basta trocar o valor da constante');
		writeln();
		writeln();
	end;
end;

function busca(var mAgenda:matContatos):integer;

var
	ind:integer;

	nome:string;

begin
	busca:=0;
	nome:=lerString(1,255,ALFANUM,'digite o nome da pessoa.Só pode conter 255 caracteres');

	ind:=1;

	while (ind<=MAX) and (busca=0) do
	{só executará essa ação até atingir o limite da matriz ou quando encontrar o contato correspondente ao nome da pessoa na matriz}
	begin

		if (mAgenda[ind].rName = nome) then
		begin

			busca:=ind;

		end;
		
		ind:=ind+1;
	end;
	
	if (busca=0) then
	begin
	
		writeln('contato inexistente');
		
		writeln();

		writeln();

	end;

end;

procedure printAgenda(mAgenda:matContatos);
{esse procedimento imprime na tela todos os contatos}
var

	ind:integer;

begin

	ind:=1;
	
	while (ind<=MAX) and (mAgenda[ind].rName <> '') do
	
	begin
	 	
		{essa condição estabelece um limite de contatos a serem exibidos na tela.Como todos os elementos do record no campo designado para o nome foram inicializados com um traço '-' então se estiver preenchido com algo diferente indica apresença de um contato preenchido, evitando a necessidade de se exibir algo que ainda não foi preenchido}
		
			writeln(mAgenda[ind].rName);

			writeln(mAgenda[ind].rNum);
		
			ind:=ind+1;
	end;
		writeln('fim da exibição');

end;

procedure	printContato(mAgenda:matContatos;position:integer);
{esse procedimento exibe na tela apenas um contato}

Begin

	writeln(mAgenda[position].rName);

	writeln(mAgenda[position].rNum);

End;

procedure apagarContato(var mAgenda:matContatos; position:integer);
{esse procedimento apaga um contato diretamente do arquivo e então copia todos os dados para a matriz, de modo a sobreescrever o dados na matriz e apagar o último que estaria duplicado}

var
	 total:integer;
   {total é a variável que conta quantas vezes se efetuou a cópia de dados para a matriz, ou seja,a quantidade total de contatos situados após a posição da pessoa a ser apagada}

	indMat:integer;
	{variável de controle}

begin
   indMat:=position-1;
	{indica onde o processo de sobreescrever começa}
	total:=0;
	while (indMat<=MAX) and (mAgenda[indMat].rNum<>0) do
	{estabelece um limite para a ação, enquanto não chegar no fim da matriz ou quando não tiver contato preenchido}
	begin
		indMat := indMat + 1;
		mAgenda[indMat]:=mAgenda[indMat+1];
		{copia os dados situados à uma posição na frente para a atual dentro da matriz}
		total:=total+1;
	end;

{Como a última posição preenchida da matriz encontra-se duplicada, precisamos fazer com que ela receba os mesmos dados de quando foi inicializada}
	mAgenda[MAX-total].rName:='-';		
	mAgenda[MAX-total].rNum:=0;		

end;

procedure salvarAgenda(var	fAgenda:fContatos; mAgenda:matContatos);
{Esse procedimento copia os dados da matriz para o arquivo}
Var

ind:integer;

total:integer;

begin

	total:=0;

	seek(fAgenda,0);

	for ind:=1 to MAX do
	begin
		
 		if (mAgenda[ind].rNum <> 0) then
		{essa condição estabelece um limite de contatos a serem exibidos na tela.Como todos os elementos do record no campo designado para o númeero foram inicializados com zero (0) então se estiver preenchido com algo diferente indica apresença de um contato preenchido, evitando a necessidade de se passar para o arquivo algo que ainda não foi preenchido}
		begin	

			write(fAgenda,mAgenda[ind]);

			total:=total+1;
		
		end

	end;
	
	seek(fAgenda,total);
	{como a quantidade de contatos é designado pelo total, se houver alguma alteração nesse número é preciso atualizar o número de posições existentes no arquivo}
	truncate(fAgenda);

end;	

{Programa Principal}

VAR
	matrizPrincipal:matContatos;
	choice:integer;
	posi:integer;
	agendaPrincipal:fContatos;
BEGIN

	choice:=0;

	inicializarMatriz(matrizPrincipal);

	abrirCriar(agendaPrincipal);

	reset(agendaPrincipal);

	copiar(agendaPrincipal,matrizPrincipal);

	repeat	  

			writeln('escolha uma opção:');
			writeln('1-Guardar contato');
			writeln('2-exibir todos os contatos');
			writeln('3-buscar contato por nome');
			writeln('4-Apagar um contato');
			writeln('5-Fechar a agenda');

			choice:=lerInteiro(1,5,'escolha uma opção inteira entre 1 e 5');

			case choice of
	
			1:
			begin

				inserirContato(matrizPrincipal);
				 
			end;
			
			2:
			begin

				 printAgenda(matrizPrincipal);
				 
			end;
	
			3:
			begin

				posi:= busca(matrizPrincipal);
				if (posi=0) then
				begin
					writeln('esse contato não existe');
				end
				else
					printContato(matrizPrincipal,posi);

			end;	
			
			4:
			begin

				posi:= busca(matrizPrincipal);
				if (posi=0) then
				begin
					writeln('esse contato não existe');
				end
				else

				 apagarContato(matrizPrincipal, posi);

			end;
			
		
			5:
			begin

				salvarAgenda(agendaPrincipal,matrizPrincipal);

				writeln('agenda salva com sucesso');

				close(agendaPrincipal);

			end;
		end;{end do case}
	until (choice=5);
END.
