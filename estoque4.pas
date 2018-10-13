program controle;
{Feito por Felipe Schreiber Fernandes                                            DRE 116 206 990
 Turma ELL170 EL3
 última modificação:24/11/2016}


uses 
minhaEstante;

Const
	MAX=200;{define o limite da matriz}
	MIN=20;{essa constante delimita a quantidade de produtos a serem impressos na tela}
	ALFANUM='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

type
	recProdutos=record
				codigo:integer;
				nome:string;
				preco:real;
				qtd:real;
	end;

	matProdutos=array[0..MAX] of recProdutos;

	fProdutos=file of	recProdutos;

procedure inicializarMatriz(var matrizInicial:matProdutos);

var
	indice:integer;

begin

	for indice:=0 to MAX do
	begin
		
		matrizInicial[indice].codigo:=-1;
		
		matrizInicial[indice].preco:=-1;		

		matrizInicial[indice].nome:= '-';

		matrizInicial[indice].qtd:=0;
	
	end;

end;

procedure copiar(var fEstoque:fProdutos;var matEstoque:matProdutos);                   {começar a copiar os dados do arquivo para a matriz}
var
indMat:integer;
begin	

		indMat:=0;

		while (not eof(fEstoque)) and (indMat<=MAX) do

		begin
		{esse laço garante que todos os dados do arquivo serão copiados}

			read(fEstoque,matEstoque[indMat]);

			indMat:=indMat+1;
			{a variável indMat garante que os dados serão copiados em diferentes posições da matriz}
			
		end;

end;

procedure inserirProduto(var matEstoque:matProdutos);

var
ind:integer;

{ind é uma variável de controle das posições da matriz}

posi:integer;

{posi é uma variável para descubrir o primeiro espaço livre na matriz para preencher os dados do produto}

existe:boolean;
{essa variável é para confirmar se o produto já existe ou não}
Begin

	existe:=true;

	posi:=0;

	ind:=0; 

	while (ind<=MAX) and (matEstoque[ind].preco <> -1) do
	{quando o ind tiver o valor MAX estará na última posição da matriz e, caso esteja preenchida, possuirá o valor MAX+1 ao fim do bloco de comandos, daí é necessário que o se encerre o bloco de comandos visto que essa posição está além do limite da matriz}
	
	{esse laço é para encontrar a primeira posição não ocupada na matriz}
	begin
				
		{como todos os registros da matriz no campo do preco foram inicializados com menos um (-1) então se o respectivo campo for diferente disso significa que tal posição da matriz já foi preenchida}
				
		ind:=ind+1;

	end;		

			posi:=ind;
		{caso o referido campo esteja livre, ou seja, preenchido com menos um (-1),então essa é a primeira posição desocupada da matriz e a variável posi armazenará o valor da ind (que é a variável de controle), uma vez que quando for diferente chegará ao fim do incremento da ind}
 
	if (posi<>MAX+1) then		
	{essa condição garante que tem espaço sobrando na matriz para preencher com dados, para tal é preciso que o valor da variável posi seja menor que o limite da matriz}

	begin

		matEstoque[posi].nome:=lerString(1,20,ALFANUM,'Digite o nome do produto a ser inserido.Só pode conter letras e números, não usar caracteres especiais');

		matEstoque[posi].preco:=lerReal(1,1000000,'insira o preço do novo produto.O  valor tem que ser um real entre 0 e 1000000');

		lerInteiro(matEstoque[posi].codigo,0,3000,'Digite o código do produto.Ele deve ser um inteiro entre 0 e 3000.');

	while (existe) do
	{esse laço é para certificar de que o código digitado ainda não exite}
	begin

		for ind:=0 to posi-1 do 
		{como a última posição da matriz está sendo ocupada, só precisamos verificar até a posição que a antecede}
		begin
		
			if matEstoque[ind].codigo = matEstoque[posi].codigo then
			begin
	
				writeln('esse produto já existe, tente novamente');
				lerInteiro(matEstoque[posi].codigo,0,3000,'Digite o código do produto.Ele deve ser um inteiro entre 0 e 3000.');
				existe:=true;

			end

			else
			begin

				existe:=false;

			end;{end do if}

		end;{end do for}

	end;
				
		matEstoque[posi].qtd:=lerReal(0,32767,'informe a quantidade inicial a ser colocada no estoque.Ela deve ser um real  entre 0 e 32767');

		writeln();

		writeln('produto inserido com sucesso');

		writeln();

		writeln();

	end

	else

	begin
		writeln('não há mais espaço disponível para inserir produtos.', ' Se você desejar aumentar o número de contatos basta trocar o valor da constante');
		writeln();
		writeln();
	end;
end;

function busca_por_codigo(var matEstoque:matProdutos):integer;
var

ind:integer;
{variável para controlar as posições da matriz}
cod:integer;
{variável que armazena o código do produto}
begin

	cod:=0;

	busca_por_codigo:=MAX+1;
{Inicializei a função com um valor impossível, visto que a matriz só guarda até o valor da constante MAX, para poder identificar quando terá seu valor mudado. Observe que não poderia inicializar a função busca com 0 visto que zero é uma posição possível dentro da matriz}

	lerInteiro(cod,0,3000,'Digite o código do produto.Ele deve ser um inteiro entre 0 e 3000.');

	ind:=0;

	while (ind<=MAX) and (busca_por_codigo=MAX+1) do
	{só executará essa ação até atingir o limite da matriz ou quando encontrar o código correspondente a um produto na matriz, alterando o valor da função}
	begin

		if (matEstoque[ind].codigo = cod) then
		begin

			busca_por_codigo:=ind;

		end;
		
		ind:=ind+1;
	end;
	
	if (busca_por_codigo=MAX+1) then
	begin

		writeln();
	
		writeln('produto inexistente');
		
		writeln();

		writeln();

	end;
end;


function busca(var matEstoque:matProdutos):integer;

var
ind:integer;

name:string;

begin

	busca:=MAX+1;{inicializei a função com um valor impossível, visto que a matriz só guarda até o valor da constante MAX, para poder identificar quando terá seu valor mudado. Observe que não poderia inicializar a função busca com 0 visto que zero é uma posição possível}

	writeln();

	name:=lerString(1,255,ALFANUM,'digite o nome do produto,ele só pode conter 255 caracteres');

	ind:=0;

	while (ind<=MAX) and (busca=MAX+1) do
	{só executará essa ação até atingir o limite da matriz ou quando encontrar o nome correspondente a um produto na matriz}
	begin

		if (matEstoque[ind].nome = name) then
		begin

			busca:=ind;

		end;
		
		ind:=ind+1;
	end;
	
	if (busca=MAX+1) then
	begin

		writeln();
	
		writeln('produto inexistente');
		
		writeln();

		writeln();

	end;

end;

procedure printEstoque(var start,fim,procTotal:integer;matEstoque:matProdutos);
{esse procedimento imprime na tela todos os produtos do estoque e a informação referente a cada um}

{São passados por referência onde começa o procedimento, onde termina e a quantidade de vezes que o procedimento de imprimir na tela foi executado, visto que esses valores precisam ser atualizados a cada vez que essa ação é executada} 		var

ind:integer;

begin

		for ind:=start to fim do
		begin
		
 			if (matEstoque[ind].preco <> -1) then
		{essa condição estabelece um limite de produtos a serem exibidos na tela.Como todos os elementos do record no campo designado para o preço foram inicializados com menos um (-1) então se estiver preenchido com algo diferente indica a presença de um produto preenchido, evitando a necessidade de se exibir algo que ainda não foi preenchido}
			begin

				writeln('o código do produto é: ',matEstoque[ind].codigo:4);
	
				writeln('o nome do  produto é: ',matEstoque[ind].nome);

				writeln('o preço é de ',matEstoque[ind].preco:7:2,' reais');

				writeln('A quantidade disponível é: ',matEstoque[ind].qtd:5:2,' unidades');
				procTotal:=procTotal+1;

			end;
		end;{end do for}

end;

procedure printProduto(matEstoque:matProdutos;position:integer);
{esse procedimento exibe na tela apenas um produto}

Begin

	writeln('o código do produto é: ',matEstoque[position].codigo:4);

	writeln('o nome do produto é ',matEstoque[position].nome);

	writeln('o preço é de ',matEstoque[position].preco:7:2,' reais');

	writeln('A quantidade disponível é: ',matEstoque[position].qtd:5:2, ' unidades');

End;

procedure comprarVender(var matEstoque:matProdutos;position:integer);
var
quant:real;
{essa variável armazena a quantidade a ser alterada}
op:string;
{essa variável lê a opção escolhida pelo usuário}
begin
		
	quant:=lerReal(0,32767,'Informe a quantidade que deseja comprar/vender. A quantidade tem que ser um número entre 0 e 32676');

	op:=lerChar('cvCV','Deseja [C]omprar ou [V]ender ? ');

	case op of

	'C':
		Begin
			matEstoque[position].qtd:=matEstoque[position].qtd + quant;
		End;
	
	'V':
		Begin
			matEstoque[position].qtd:=matEstoque[position].qtd - quant;
		end;
	end;{end do case}

end;

procedure apagarProduto(var matEstoque:matProdutos; position:integer);
{esse procedimento apaga um produto diretamente na matriz, de modo a sobreescrever o dados na matriz e apagar o último que estaria duplicado}

var

	 total:integer;
   {total é a variável que conta quantas vezes se efetuou a cópia de dados para a matriz, ou seja,a quantidade total de produtos situados após a posição do produto a ser apagado}

	indMat:integer;
	{variável de controle}

begin

		if matEstoque[position].qtd=0 then
		{a condição para que o usuário possa apagar é que a quantidade seja zero}
		begin
  			indMat:=position;
				{indica onde o processo de sobreescrever começa}
			total:=0;
			while (indMat<=MAX-1) and (matEstoque[indMat].preco<>-1) do
			{estabelece um limite para a ação, enquanto não chegar no fim da matriz ou quando não tiver produto preenchido}
			begin

				 matEstoque[indMat]:=matEstoque[indMat+1];
					{copia os dados situados à uma posição na frente para a atual dentro da matriz}
				total:=total+1;

			end;

					{Como a última posição preenchida da matriz encontra-se duplicada, precisamos fazer com que ela receba os mesmos dados de quando foi inicializada}
			matEstoque[MAX-total].nome:='-';		
			matEstoque[MAX-total].codigo:=-1;		
			matEstoque[MAX-total].preco:=-1;
			matEstoque[MAX-total].qtd:=0;
		end
	
		else
		begin
			writeln();
			writeln('você não pode apagar esse produto pois ele não está zerado');
			writeln();
		end;{End do if}
end;

procedure alterarDados(var matEstoque:matProdutos;position:integer);
var
op:integer;

begin

	writeln('digite qual ação deseja realizar');
	writeln('digite 1 para alterar o nome do produto');
	writeln('digite 2 para alterar o preço do produto');
	writeln('digite 3 para alterar a quantidade do produto');
	lerInteiro(op,1,3,'Você deve digitar um inteiro entre 1 e 3');

	case op of

		1:
		Begin
			writeln('diga qual o novo nome do produto');
			readln(matEstoque[position].nome);
		End;
		2:
		Begin
			
			matEstoque[position].preco:=lerReal(0,1000000,'diga o novo preço do produto.Ele deve ser um número real entre 0 e 1000000');

		End;
		3:
		Begin
			
			matEstoque[position].qtd:=lerReal(0,32676,'informe a nova quantidade no estoque do produto.Ele deve ser um real entre 0 e 32676');
		End;
	End;{end do case} 
end;	
procedure salvarEstoque(var fEstoque:fProdutos; matEstoque:matProdutos);
{Esse procedimento copia os dados da matriz para o arquivo}
Var

ind:integer;

begin

	seek(fEstoque,0);

	for ind:=0 to MAX do
	begin
		
 		if (matEstoque[ind].preco <> -1) then
		{Como todos os elementos do record no campo designado para o preco foram inicializados com zero (0) então se estiver preenchido com algo diferente indica apresença de um produto preenchido, evitando a necessidade de se passar para o arquivo algo que ainda não foi preenchido}
		begin	

			write(fEstoque,matEstoque[ind]);
		
		end

	end;

end;	

{Programa Principal}

VAR
matrizPrincipal:matProdutos;
escolha:char;
posi,total,comeco,fim,choice:integer;
estoquePrincipal:fProdutos;
BEGIN
	choice:=0;
	inicializarMatriz(matrizPrincipal);
	abrirCriar(estoquePrincipal);
	reset(estoquePrincipal);
	{para evitar erros na manipulação do arquivo é necessário usar o reset após o procedimento de AbrirCriar da biblioteca, visto que ele não está tipado no procedimento da minhaEstante}
	copiar(estoquePrincipal, matrizPrincipal);
	repeat	  
			writeln('escolha uma opção:');
			writeln('1-Inserir Produto');
			writeln('2-Exibir os produtos');
			writeln('3-Buscar produto por nome');
			writeln('4-Buscar produto por código');
			writeln('5-Apagar produto');
			writeln('6-Alterar dados de um produto');
			writeln('7-Comprar/vender produtos');
			writeln('8-Sair do programa');
			
			lerInteiro(choice,1,8,'Escolha uma opção entre 1 e 8. Ela deve ser um inteiro');
				
			case choice of

				1:
				begin

					 inserirProduto(matrizPrincipal);
				 
				end;
			
				2:
				begin
	
					total:=0;
					{a variável total indica quantas vezes ocorreu o processo de exibr produtos na tela}

					comeco:=0;
					{indica o começo do processo de impressão na tela a partir da posição 0 da matriz}
					fim:=comeco + MIN-1;

					{como a matriz começa na posição 0, para que se exiba exatamente 20 produtos é preciso que se imprima na tela até a posição 19 da matriz, ou seja, a partir do ponto que se começou a imprimir mais a quantidade que se deseja imprimir na tela a cada vez(representada pela constante MIN) menos um já que os extremos são incluídos na contagem}

					escolha:='S';
					{na primeira impressão a variável de escolha que verifica se o usuário deseja continuar a impressão começa com 'S'}

					printEstoque(comeco,fim,total,matrizPrincipal);
					
					comeco:=comeco+total;
					{indica onde deverá começar a próxima impressão}

					fim:=comeco+MIN-1;
					{indica onde termina a próxima impressão. Por exemplo, se começar na posição 20, o programa deverá exibir até a posição 20(começo) + 20(quantidade de produtos exibidos de cada vez) - 1 = 39, o que está compatível com o desejado}

					while (escolha='S') and (total<MAX+1) and (matrizPrincipal[comeco].preco<> -1) do
					{estabelece as condições para que o bloco de comandos seja executado: Se o usuário escolher continuar, se não tiver chegado ao fim do vetor e se tiver produto preenchendo tal posiçao do posição do vetor. Observe que o número máximo de vezes que ocorrerá a exibição na tela é quando todas as posições do vetor estiverem preenchidas e, nesse caso, a quantidade será de MAX +1 vezes}
					
					begin
						escolha:= lerChar('snSN','Deseja continuar a exibição?Digite [S]im ou [N]ão');

						case escolha of
				
							'S':
							begin

								printEstoque(comeco,fim,total,matrizPrincipal);
					
								comeco:=comeco + total;

								fim:=comeco+MIN-1;

							end;

							'N':
							Begin

								writeln('fim da exibição');
							
							End;
					
						End;{end  do  case interno}
					end;{end do while}

				if (matrizPrincipal[comeco].preco = -1) or (total=MAX) then
				begin
				
					writeln('não há mais produtos a serem exibidos');

				end;
		end; {end da opção 3}
		
				3:
				begin

					posi:=busca(matrizPrincipal);
			
					if (posi<>MAX+1) then
					begin

						printProduto(matrizPrincipal,posi);
					
					end;

				end;	
			
				4:
				begin

					posi:= busca_por_codigo(matrizPrincipal);
	
					if (posi<>MAX+1) then
					begin
	
						printProduto(matrizPrincipal,posi);
					
					end;
				
	
				end;
			
		
				5:
				begin
				
					escolha:=lerChar('cnCN','escolha como deseja buscar o produto a ser apagado, por [C]ódigo ou por [N]ome');
					case escolha of
					
						'C':
						Begin
				
							posi:= busca_por_codigo(matrizPrincipal);
				
						end;
	
						'N':
						Begin
	
							posi:=busca(matrizPrincipal);
	
						End;	
					End;{end do case interno}

					 apagarProduto(matrizPrincipal,posi);

				end;

				6:
				Begin
	
					escolha:=lerChar('cnCN','escolha como deseja buscar o produto a ser alterado, por [C]ódigo ou por [N]ome');
					
					case escolha of
				
						'C':
						Begin
				
							posi:= busca_por_codigo(matrizPrincipal);
				
						end;
	
						'N':
						Begin
			
							posi:=busca(matrizPrincipal);
	
						End;	
					End;{end do case interno}

				alterarDados(matrizPrincipal,posi);

			End;

			7:
			Begin

					escolha:=lerChar('cnCN','escolha como deseja buscar o produto a ser comprado/vendido, por [C]ódigo ou por [N]ome');
					case escolha of
				
						'C':
						Begin
				
							posi:= busca_por_codigo(matrizPrincipal);
				
						end;
	
						'N':
						Begin
	
							posi:=busca(matrizPrincipal);
	
						End;	
					End;{end do case interno}
		
					if (posi<>MAX+1) then
					{só é possível comprar ou vender caso o produto esteja catalogado, ou seja, o valor da posi for diferente de MAX+1}
					begin

						comprarVender(matrizPrincipal,posi);
	
					end

					else
					begin

						writeln('você não pode comprar/vender produtos que não existem');
					end;
						
			End;

			8:
			Begin
				
				salvarEstoque(estoquePrincipal,matrizPrincipal);
			
				close(estoquePrincipal);

				writeln('estoque salvo com sucesso');

			End;
		end;{end do case externo}
	until (choice=8);
END.
