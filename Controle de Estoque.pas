program estoque;
{Salvar o arquivo .pas em encoding UTF-8.}
{Por Henrique Bruno Fantauzzi de Almeida}
{DRE: 116 193 618}
{Primeira versão, 06/11/2016}
type
historicoIndividual = record
	codigo:integer;
	entradaSaidaEP:char;
	quantidadeAlterada:real;
end;
tipoMatriz = array[1..255] of historicoIndividual;

procedure ordenaMatriz (var matriz: tipoMatriz; numMax:byte);
var
	i, j: byte;
	aux: historicoIndividual;
begin
	for i:= 1 to numMax-1 do                    {início da ordenação pelo código}
	begin
		for j:= 1 to numMax-1 do
		begin
			if (matriz[j].codigo > matriz[j+1].codigo) then
			begin
				aux:= matriz[j+1];
				matriz[j+1]:= matriz[j];
				matriz[j]:= aux;
			end;
		end;
	end; 
end;

var
	matrizHistorico: tipoMatriz;
	numeroHistoricos, escolha, escolha2, i: byte;
	erro: boolean;
	historicoIndividualTemp: historicoIndividual;
	arq, arq2, arq3: file of historicoIndividual;
	nomeArquivo: string;

Begin
	numeroHistoricos:= 0;
	erro:= false;
	repeat
		writeln ('########################################');
		writeln ('#       CONTROLE DE ESTOQUE v1.0       #');
		writeln ('# "1" - Nova entrada no histórico      #');
		writeln ('# "2" - Ordenar e salvar o histórico   #');
		writeln ('# "3" - Exibir histórico salvo         #');
		writeln ('# "4" - Importar histórico salvo       #');
		writeln ('# "5" - Limpar memória do programa     #');
		writeln ('# "6" - Ajuda                          #');
		writeln ('# "7" - Sair                           #');
		writeln ('########################################');
		writeln; {pula linha}

		readln (escolha);
		writeln; {pula linha}
		case (escolha) of

			1:
			begin
				numeroHistoricos:= numeroHistoricos + 1;
				writeln ('Digite o código do produto com o estoque alterado (1001 até 9999)');
				repeat
					readln (matrizHistorico[numeroHistoricos].codigo);
					writeln; {pula linha}
					if ((matrizHistorico[numeroHistoricos].codigo < 1001) or (matrizHistorico[numeroHistoricos].codigo > 9999)) then
					begin
						erro:= true;
						writeln ('Código inválido. O código tem que ser entre 1001 e 9999. Digite novamente.');
					end
					else
						erro:= false;
				until (erro = false);
				writeln ('Digite "E" se foi uma entrada ou "P" se foi uma saída de produtos');
				repeat
					readln (matrizHistorico[numeroHistoricos].entradaSaidaEP);
					matrizHistorico[numeroHistoricos].entradaSaidaEP:= upcase (matrizHistorico[numeroHistoricos].entradaSaidaEP); {transforma em maiúsculo, caso não fosse}
					writeln; {end}
					if not ((matrizHistorico[numeroHistoricos].entradaSaidaEP = 'E') or (matrizHistorico[numeroHistoricos].entradaSaidaEP = 'P')) then
					begin
						writeln ('Caractere inválido. Digite "E" para entrada ou "P" para saída do produto. Digite novamente.');
						erro:= true;
					end
					else
						erro:=false;
				until (erro = false);
				writeln ('Digite o módulo da quantidade deste produto alterado');
				readln (matrizHistorico[numeroHistoricos].quantidadeAlterada);
				writeln; {pula linha}
				writeln ('Informação adicionada ao histórico.');
				writeln; {pula linha}
			end;     {Fim do Nova entrada no Histórico}

			2:  {Ordenar e salvar}
			begin
				if (numeroHistoricos > 0) then {Só executará a ordenação e o salvamento caso há conteúdo para o mesmo.}
				begin
					ordenaMatriz (matrizHistorico, numeroHistoricos);  
					assign (arq, 'Log Estoque Ordenado Geral.bin');   {Início do Salvar o arquivo ordenado pelo codigo}
					rewrite (arq);
					for i:= 1 to numeroHistoricos do
						write (arq, matrizHistorico[i]);
					close (arq);                                       {---Fim do Salvar o arquivo ordenado pelo codigo}         
					assign (arq, 'Log Estoque Ordenado Entradas.bin');    {início da separação de entradas/saídas}{Gera os arquivos de entradas/saídas}
					rewrite (arq);
					assign (arq2, 'Log Estoque Ordenado Saidas.bin');
					rewrite (arq2);
					for i:= 1 to numeroHistoricos do
					begin
						if (matrizHistorico[i].entradaSaidaEP = 'E') then
							write (arq, matrizHistorico[i])
						else
							write (arq2, matrizHistorico[i])
					end;                                              {---Fim da separação e geração dos arquivos de entrada/saídas}
					close (arq);             {Salva e fecha os arquivos de Entrada e Saida}
					close (arq2);
					assign (arq, 'Log Estoque Ordenado Entradas.bin');     {Início da concatenação de arquivos}
					assign (arq2, 'Log Estoque Ordenado Saidas.bin');                                               
					assign (arq3, 'Log Estoque Ordenado Concatenado.bin');     
					rewrite (arq3);
					reset (arq);
					while not eof (arq) do                                     {Escreve todo o conteúdo das entradas no conc.}
					begin
						read (arq, historicoIndividualTemp);
						write (arq3, historicoIndividualTemp);
					end;               
					reset (arq2);
					while not eof (arq2) do                                     {Escreve todo o conteúdo das saidas no conc.}
					begin
						read (arq2, historicoIndividualTemp);
						write (arq3, historicoIndividualTemp);
					end;
					close (arq);
					close (arq2);
					close (arq3);                                            {---Fim da concatenação de arquivos}
					assign (arq, 'Log Estoque Ordenado Concatenado.bin');     {Início do Merge / Abre o arquivo concatenado para transformá-lo em Merge}
					reset (arq);
					numeroHistoricos:= 0;
					while not eof (arq) do                {importa todo o conteúdo para a memória}
					begin
						numeroHistoricos:= numeroHistoricos + 1;
						read (arq, matrizHistorico[numeroHistoricos]);
					end;
					ordenaMatriz (matrizHistorico, numeroHistoricos);         {ordena o conteúdo}
					close (arq);
					assign (arq, 'Log Estoque Ordenado Merge.bin');
					rewrite (arq);                          {apaga conteúdo anterior}
					for i:= 1 to numeroHistoricos do
						write (arq, matrizHistorico[i]);      {escreve no arquivo Merge}
					close (arq);                              {Salva e fecha o arquivo Merge}
					writeln ('Foram gerados os arquivos:');
					writeln ('Log Estoque Ordenado Geral.bin');
					writeln ('Log Estoque Ordenado Entradas.bin');
					writeln ('Log Estoque Ordenado Saidas.bin');
					writeln ('Log Estoque Ordenado Concatenado.bin');
					writeln ('Log Estoque Ordenado Merge.bin');
				end
				else
					writeln ('Não há dados para ordenar e salvar.');
				writeln;
			end;  {---Fim do ordenar e salvar}
		
			3:          {Abrir histórico salvo}
			begin
				repeat
					writeln ('Escolha como você quer escolher o arquivo para ser exibido');
					writeln;
					writeln (' "1" - Exibir o histórico do estoque ordenado pelo código - geral');
					writeln (' "2" - Exibir o histórico do estoque ordenado pelo código - entradas');
					writeln (' "3" - Exibir o histórico do estoque ordenado pelo código - saídas');
					writeln (' "4" - Exibir o histórico do estoque ordenado pelo código - concatenado');
					writeln (' "5" - Exibir o histórico do estoque ordenado pelo código - merge');
					writeln (' "6" - Exibir arquivo de histórico pelo nome');
					writeln (' "7" - Voltar ao Menu principal');
					writeln;
					readln (escolha2);
					writeln;
					case (escolha2) of
						1: assign (arq, 'Log Estoque Ordenado Geral.bin');
						2: assign (arq, 'Log Estoque Ordenado Entradas.bin');
						3: assign (arq, 'Log Estoque Ordenado Saidas.bin');
						4: assign (arq, 'Log Estoque Ordenado Concatenado.bin');
						5: assign (arq, 'Log Estoque Ordenado Merge.bin');
						6:
						begin
							writeln ('Digite o nome do arquivo com as movimentações do estoque, com o .bin no final.');
							readln (nomeArquivo);
							assign (arq, nomeArquivo);
							writeln;
						end;
						7: {Opção de sair, não faz nada}
						else
						begin
							writeln ('Opção inexistente.');
							writeln;
						end;
					end; {---Fim do case(escolha2)}
				until ((escolha2 > 0) and (escolha2 < 8));
				if (escolha2 < 7) then {Se a opção Voltar ao Menu principal não foi selecionada...}
				begin
					reset (arq);
					while not eof (arq) do
					begin
						read (arq, historicoIndividualTemp);
						writeln ('Código: ', historicoIndividualTemp.codigo);
						writeln ('Entrada ou Saida (E/P): ', historicoIndividualTemp.entradaSaidaEP);
						writeln ('Quantidade Alterada: ', historicoIndividualTemp.quantidadeAlterada:4:2);
						writeln;
					end;
					close (arq);
				end;
			end;   {---Fim do Abrir histórico salvo}
		
			4:          {Importar histórico salvo}
			begin
				repeat
					writeln ('Escolha como você quer escolher o arquivo para ser importado');
					writeln;
					writeln (' "1" - Importar histórico do estoque ordenado pelo código - geral');
					writeln (' "2" - Importar histórico do estoque ordenado pelo código - entradas');
					writeln (' "3" - Importar histórico do estoque ordenado pelo código - saídas');
					writeln (' "4" - Importar histórico do estoque ordenado pelo código - concatenado');
					writeln (' "5" - Importar histórico do estoque ordenado pelo código - merge');
					writeln (' "6" - Importar arquivo de histórico pelo nome');
					writeln (' "7" - Voltar ao Menu principal');
					writeln;
					readln (escolha2);
					writeln;
					case (escolha2) of
						1: assign (arq, 'Log Estoque Ordenado Geral.bin');
						2: assign (arq, 'Log Estoque Ordenado Entradas.bin');
						3: assign (arq, 'Log Estoque Ordenado Saidas.bin');
						4: assign (arq, 'Log Estoque Ordenado Concatenado.bin');
						5: assign (arq, 'Log Estoque Ordenado Merge.bin');
						6:
						begin
							writeln ('Digite o nome do arquivo com as movimentações do estoque, com o .bin no final.');
							readln (nomeArquivo);
							assign (arq, nomeArquivo);
							writeln;
						end;
						7: {Opção de sair, não faz nada}
						else
						begin
							writeln ('Opção inexistente.');
							writeln;
						end;
					end; {---Fim do case(escolha2)}
				until ((escolha2 > 0) and (escolha2 < 8));
				if (escolha2 < 7) then {Se a opção Voltar ao Menu principal não foi selecionada...}
				begin
					numeroHistoricos:= 0;
					reset (arq);
					while not eof (arq) do
					begin
						numeroHistoricos:= numeroHistoricos + 1;
						read(arq, matrizHistorico[numeroHistoricos]);
					end;
					close (arq);
					writeln ('O arquivo foi importado.');
					writeln;
				end;
			end;       {---Fim do importar histórico}
			
			5: 
			begin
				numeroHistoricos:= 0;
				writeln ('Memória limpa. Todos os dados guardados no programa foram limpos.');
				writeln;
			end;
			6:
			begin
				writeln ('  Ao selecionar para ordenar e salvar, o programa gerará 5 arquivos, todos');
				writeln ('ordenados pelo código dos produtos. O primeiro arquivo, o Geral, apresenta');
				writeln ('todas as informações entradas previamente. O segundo e o terceiro arquivo,');
				writeln ('apresentam somente as informações de Entrada e Saída, respectivamente. Já');
				writeln ('o quarto arquivo, é a concatenação do segundo com o terceiro arquivo.');
				writeln ('Por último, quinto arquivo é um Merge do segundo com o terceiro arquivo,');
				writeln ('que apresentará um conteúdo parecido com o do primeiro arquivo.');
				writeln;
				writeln ('  Existem as opções de exibir o conteúdo salvo e de importar um arquivo,');
				writeln ('onde neste último o conteúdo de um arquivo salvo anteriormente irá para o');
				writeln ('programa, assim com a possibilidade de adicionar mais informações à ele.');
				writeln;
			end;

			7: {não faz nada}
		
			else
			begin
				writeln ('Opção inexistente');
				writeln;
			end;
		end;            {---Fim do case}
	until (escolha = 7);  {O programa irá finalizar}
End.
