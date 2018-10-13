unit unitArqBin; {CONTEM TRATAMENTOS DE ERRO PARA ABERTURA DE ARQUIVOS}

interface

uses
	unitEntradaDados; {CONTEM TRATAMENTOS DE ERRO PARA ENTRADA DE DADOS}

procedure abrirArqBin (var arqBin : file);



implementation

procedure abrirArqBin (var arqBin : file);
{IMPORTANTE : DAR RESET NO ARQUIVO APOS SER ABERTO POR ESTE PROCEDIMENTO, SENAO O ARQUIVO NAO SERA TIPADO!!!!! : ERROS DE LEITURA/EXIBICAO}

var
	nomeArq : string;
	opcao : char;

begin
	lerString(nomeArq , 1 , 20 , ALFANUM , 'Digite o nome do arquivo a ser criado ou aberto. (Maximo de 20 caracteres. Nao use caracteres especiais.)');
	lerNomeArq(nomeArq , 'bin'); {Esta funcao adiciona a extensao ao arq}
	assign(arqBin , nomeArq);
	{$I-}			
	reset(arqBin);
	{$I+}
	if (ioresult = 2) then
		begin
			lerCaractere(opcao , 's' , 'O arquivo nao existe, digite "s" para cria-lo.');
			if (opcao = 's') then
				begin
					rewrite(arqBin);
				end;
		end
	else
		begin
			lerCaractere(opcao , 'sx' , 'O arquivo escolhido ja existe, digite s para abri-lo ou x para escrever por cima. O arquivo sera apagado.');
			if (opcao = 'x') then
				begin
					rewrite(arqBin);
				end;
		end;
end;


END.
