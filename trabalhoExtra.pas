program algoritmoEstoque;

{algoritmo para guardar movimentação de um estoque; data: 1/11/16; responsável: Paulo Henrique Caetano}

uses
	crt;

type
	tControleEstoque= record
		codigo:integer;
		qtd:real;
		ES: char;
	end;
	tMatEstoque= array [1001..9999] of tControleEstoque;
	tArqEstoque= file of tControleEstoque;

function funMenu():integer;{Funcao que mostra o menu}

var
	opcao: integer;
	repeteMenu: boolean;

begin
	repeteMenu:= false;
	repeat
		writeln('Digite o numero de uma das opcoes abaixo:');
		writeln();
		writeln('1- Realizar operacao no estoque');
		writeln('2- Ordenar por codigo');
		writeln('3- Copiar para arquivo binario');
		writeln('4- Separar arquivo em entradas e saidas');
		writeln('5- Juntar arquivos concatenando');
		writeln('6- Realizar um merge');
		writeln('7- Sair');
	
		{$I-}
		readln(opcao);
		if (ioresult <> 0) then
		begin
			opcao:= 0;
		end;
		{$I+}
		if (opcao >= 1) and (opcao <= 8) then
		begin
			repeteMenu:= true;
		end
		else
		begin
			writeln('Opcao invalida. Digite uma das opcoes');
		end;
	until (repeteMenu = true);
	funMenu:= opcao;
end;

function funConfirmar(mens:string):char;

var 
	carac:char;
begin
	repeat
		writeln(mens,'Confirme ou nao a sua opcao com S ou N');
		carac:=(upcase(readkey));
		if (carac <> 'S') and (carac <> 'N') then
		begin
			writeln('Opcao invalida. Tente novamente');
		end;
	until (carac = 'S') or (carac = 'N');
	funConfirmar := carac;
end;

{Funcao que lê o arquivo e informa o tamanho}
function lerArquivo( var arq: tArqEstoque; var matriz: tMatEstoque): integer;

var
	index: integer;
begin
	reset(arq);
	index:= 1000;
	while not (eof(arq)) do 
	begin
		index:= index +1;
		read(arq,matriz[index]);
	end;
	close(arq);
	lerArquivo:= index-1000;
end;


{Zerar entradas e saidas do estoque. Deve ser feito no inicio de cada arquivo de controle}
procedure zerarEstoque ( var matriz: tmatEstoque);

var 
	index1: integer;

begin
	for index1:= 1001 to 9999 do
	begin
		matriz[index1].qtd:= 0; {0 de zero qauntidade}
		matriz[index1].ES:= 'n'; {n de nem entrada nem saida}
			
	end;
end;

{Procedimento de criar um arquivo}
procedure criarArq( var arq: tArqEstoque);

var
	erro: integer;
	nomeArq: string;

begin
	repeat
		writeln('Escreva o nome do arquivo');
		readln(nomeArq);
		assign(arq,nomeArq + '.bin');
		{$I-}
		reset(arq);
		{$I+}
		erro:= ioresult;
		if (erro = 0) then
		begin
			if funConfirmar('O arquivo já existe: Deseja subsescrever o arquivo ou escolher outro nome?') = 'S' then
			begin
				rewrite(arq);
			end
			else
			begin
				erro:=1;
			end;
		end
		else
		begin
		rewrite(arq);
		erro:= 0;
		end;
	until (erro = 0);
	close(arq);
end;

{Procedimento de operar o estoque}
procedure operacaoEstoque( var matriz: tMatEstoque; var posicao: integer);

var
	codigoProd:integer;
	index,opcao:integer;
	quantidade:real;
	especie: char;
	continuar:boolean;
begin	
	index:= posicao;
	continuar:= false;
	repeat		
		while (index>=1001) and (index<=9999) and (continuar= false) do 
		begin
			writeln('Digite o codigo do produto');	{codigo do produto so pode variar de 1001 a 9999, porque sao os cadastrados}
			readln(codigoProd);
			if (codigoProd<1001) or (codigoProd>9999) then
			begin
				writeln('Codigo invalido. Produto nao encontrado');
			end
			else
			begin
				matriz[index].codigo := codigoProd;
				writeln('Digite a quantidade, independente se for de entrada ou saida');
				readln(quantidade);
				if (quantidade<0) then
				begin
					writeln('Quantidade invalida');
				end
				else
				begin
					matriz[index].qtd:= quantidade;
					writeln('Digite E para entrada ou S para saida');
					especie:= (upcase(readkey));
					if (especie <> 'E') and (especie <> 'S') then
					begin
						writeln('Comando invalido');
					end
					else
					begin
						matriz[index].ES := especie;
					end;
				end;
			end;
			writeln('Para continuar, digite 1. Para sair, digite 2.');
			readln(opcao);
			if (opcao=1) then
			begin
				index:= index + 1;
			end
			else
			begin
				continuar:= true;
			end;
		end;
	until (continuar=true);
	posicao:= index;
end;


{Procedimento que ordena o estoque}	
procedure ordenaEstoque( var matriz: tMatEstoque; posicao: integer);

var
	index, index2, aux:integer;
	aux2:char;
	aux3:real;
begin
	for index:=1001 to (posicao-1) do
	begin
		for index2:=(index+1) to posicao do
		begin
			if (matriz[index].codigo >= matriz[index2].codigo) then
			begin
				if (matriz[index].codigo > matriz[index2].codigo) then
				begin
					aux:= matriz[index].codigo;
					matriz[index].codigo:= matriz[index2].codigo;
					matriz[index2].codigo:= aux;
				end
				else
				begin
					if (matriz[index].ES >= matriz[index2].ES) then
					begin
						if (matriz[index].ES > matriz[index2].ES) then
						begin
							aux2:= matriz[index].ES;
							matriz[index].ES:= matriz[index2].ES;
							matriz[index2].ES:= aux2;
						end
						else
						begin
							if (matriz[index].qtd > matriz[index2].qtd) then
							begin
								aux3:= matriz[index].qtd;
								matriz[index].qtd:= matriz[index2].qtd;
								matriz[index2].qtd:= aux3;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	for index:=1001 to posicao do
	begin
		writeln('-codigo: ',matriz[index].codigo,'-tipo(entrada ou saida): ',matriz[index].ES,'-quantidade: ',matriz[index].qtd:4:2);
	end; 
end;

procedure copiarBinario( var matriz: tMatEstoque; var arq: tArqEstoque; posicao:integer);

var
	varControle: tControleEstoque;
	index:integer;
begin
	for index:= 1001 to posicao do 
	begin
		varControle:= matriz[index];
		reset(arq);
		seek(arq,filesize(arq));
		write(arq,varControle);
	end;
	close(arq);
end;

{Procedimento de separaçao do arquivo principal e dois arquivos(entradas e saidas)}
procedure dividirArquivo( var arq_Entradas: tArqEstoque; var arq_Saidas: tArqEstoque; matriz: tMatEstoque; posicao:integer);

var
	index:integer;
begin
	rewrite(arq_Entradas);
	reset(arq_Entradas);
	rewrite(arq_Saidas);
	reset(arq_Saidas);
	for index:=1001 to posicao do
	begin
		if (matriz[index].ES = 'E') then
		begin
			seek(arq_Entradas,filesize(arq_Entradas));
			write(arq_Entradas, matriz[index]);
		end
		else
		begin
			seek(arq_Saidas,filesize(arq_Saidas));
			write(arq_Saidas, matriz[index]);
		end;
	end;
	close(arq_Entradas);
	close(arq_Saidas);
end;

{Procedimento de concatenacao dos arquivos de entradas e saidas}
procedure concatenarArquivo( var arq_Resultado: tArqEstoque; var arq_Entradas: tArqEstoque; var arq_Saidas: tArqEstoque);

var
	index,tamanhoArquivoEntrada,tamanhoArquivoSaida:integer;
	matriz_entrada,matriz_saida: tMatEstoque;
	
begin
	reset(arq_Resultado);
	tamanhoArquivoEntrada:= lerArquivo(arq_Entradas,matriz_entrada);
	tamanhoArquivoSaida:= lerArquivo(arq_saidas,matriz_saida);
	for index:=1 to tamanhoArquivoEntrada do
	begin
		seek(arq_Resultado,filesize(arq_Resultado));
		write(arq_Resultado,matriz_entrada[(index+1000)]);
	end;
	for index:=1 to tamanhoArquivoSaida do
	begin
		seek(arq_Resultado,filesize(arq_Resultado));
		write(arq_Resultado,matriz_saida[(index+1000)]);
	end;
	close(arq_Resultado);
end;

var
	matControle,matrizMerge: tMatEstoque;
	arqControle: tArqEstoque;
	op, primPos, tamanhoMerge, index: integer;
	arqEntradas , arqSaidas, arqResultado, arqFinalMerge: tArqEstoque;
	copia, separacao: boolean;

{-------------------Programa Principal----------------------------------------------------}
begin
	primPos:= 1001; {variavel que representa a primeira posicao livre(quando inicia o programa) ou a ultima preenchida}
	zerarEstoque(matControle);
	copia:= false;
	separacao:= false;
	repeat
		op := funMenu();
		case op of
			1:begin {realizar operacao no estoque}
				operacaoEstoque(matControle,primPos);
			end;
			2:begin {ordernar estoque por codigo}
				ordenaEstoque(matControle, primPos);
			end;
			3:begin {copiar matriz para arquivo binario}
				criarArq(arqControle);  {o arquivo so é criado na opcao 3 do menu}
				copiarBinario(matControle,arqControle,primPos);
				copia:= true;
			end;
			4:begin {separar arquivo em entradas e saidas}
				if (copia = false) then
				begin
					writeln('Você deve criar primeiro um arquivo binario da matriz de controle(item 3)');
					writeln('Digite qualquer letra  para voltar ao menu');
					readkey();
				end
				else
				begin 
					writeln('Você irá criar o arquivo de entradas agora.');
					writeln();
					criarArq(arqEntradas);
					writeln();
					writeln('Você irá criar o arquivo de saidas agora.');
					writeln();
					criarArq(arqSaidas);
					
					dividirArquivo(arqEntradas,arqSaidas,matControle, primPos);
					separacao:= true;
				end;
			end;
			5:begin {juntar arquivos de entradas e saidas concatenando}
				if (separacao = false) then
				begin
					writeln('Você deve criar primeiramente dois arquivos, um de entradas e outro de saidas(item 4).');
					writeln('Digite qualquer letra para voltar ao menu');
					readkey();
				end
				else
				begin
					writeln('Você irá criar o arquivo resuldado da concatenacao');
					writeln();
					criarArq(arqResultado);
					{-----------}
					concatenarArquivo(arqResultado,arqEntradas,arqSaidas);
				end;
			end;
			6:begin {realizar um merge}
				if (separacao = false) then
				begin
					writeln('Você deve criar primeiramente dois arquivos, um de entradas e outro de saidas(item 4).');
					writeln('Digite qualquer letra para voltar ao menu');
					readkey();
				end
				else
				begin
					writeln('Você irá criar o arquivo final do merge');
					writeln();
					criarArq(arqFinalMerge);
								
					concatenarArquivo(arqFinalMerge,arqEntradas,ArqSaidas);
					tamanhoMerge:= lerArquivo(arqFinalMerge,matrizMerge);
					ordenaEstoque(matrizMerge,tamanhoMerge);
					
					{-------------------------}
					rewrite(arqFinalMerge);
					reset(ArqFinalMerge);
					for index:=1 to tamanhoMerge do
					begin
						seek(arqFinalMerge,filesize(arqFinalMerge));
						write(arqFinalMerge,matrizMerge[index+1000]);
					end;
					close(arqFinalMerge);
					lerArquivo(arqfinalMerge,matrizMerge);
				end;
			end;
		end;
	until (op=7);
end.
