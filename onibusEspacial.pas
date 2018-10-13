program reserva;

type
assentos=array[1..3,1..11] of string;

procedure inicializar_assentos(var matAssentos:assentos);
var 
linha,coluna:integer;
begin
	for linha:=1 to 3 do
	begin
		for coluna:=1 to 11 do
		begin
			matAssentos[linha,coluna]:='_';
		end;
	end;
	matAssentos[1,1]:='0';
	matAssentos[1,2]:='1';
	matAssentos[1,3]:='2';
	matAssentos[1,4]:='3';
	matAssentos[1,5]:='4';
	matAssentos[1,6]:='5';
	matAssentos[1,7]:='6';
	matAssentos[1,8]:='7';
	matAssentos[1,9]:='8';
	matAssentos[1,10]:='9';
	matAssentos[1,11]:='10';
	matAssentos[2,1]:='E';
	matAssentos[3,1]:='D';
end;
procedure escolher_lado(var lado:char);

begin
	writeln('escolha um lado do onibus em que deseja sentar: [E]squerda,	 [D]ireita ');
	readln(lado);
	while (lado <> 'E') and (lado<>'D') do
	begin
		writeln('Digite E para escolher o lado esquerdo ou D para escolher o lado direito, tente novamente');
		readln(lado);
	end;
end;

procedure identificarPassageiro(var P:string);
begin
	writeln('qual o seu nome?');
	readln(P);
end;

procedure ocupar_assentos(P:string;var matAssentos:assentos;lado:char);

var
ind:integer;
linha:integer;
lugar:integer;
begin
	lugar:=0;
	if (lado='E') then
	begin
 
		linha:=2;
	end
	else
	begin
		linha:=3;
	end;
	
	repeat
		for ind:=1 to 11 do
	
		begin
			Write(matAssentos[1,ind]:3);
		end;
			writeln();
		for ind:=1 to 11 do
		begin
			if (matAssentos[linha ,ind] = '_')  or (matAssentos[linha,ind]= lado) then
			begin
				write(matAssentos[linha,ind]:3);
			end
			else
			begin
				write('X');
			end;

		end;
	writeln('escolha qual assento deseja reservar');
	readln(lugar);
	lugar:=lugar + 1;	
		while (lugar<2) or (lugar>11) do
		begin
			writeln('digite o número correspondente ao assento');
			writeln('o lugar só pode ser um número inteiro entre 1 e 10');
			readln(lugar);
			lugar:=lugar+1;
		end;	
	until (matAssentos[linha,lugar]='_') or (matAssentos[linha,lugar]=P);
	matAssentos[linha,lugar]:=P;
	writeln('operação feita com sucesso');
end;
	
procedure cancelar_reserva(P:string;var matAssentos:assentos);

VAR
verifica:boolean;
side:char;
lado:string;
posicao,linha,coluna,total:integer;
begin

	total:=0;
	for linha:=2 to 3 do
	begin
		for coluna:=2 to 11 do
		begin
			if matAssentos[linha,coluna] = P then
			begin	
				case linha of
				2:
				 begin
					lado:='esquerdo';
				 end;
				3:
				 begin
					lado:='direito';
				 end;
				end;
				total:=total + 1;
				verifica:=(total=0);	
					writeln('você tem uma reserva no lado ',lado,' na posição ', coluna-1);
			
			end;
			if total=0 then
			begin
				writeln('você não possui nenhuma reserva');
			end;
		
		end;
	end;

case verifica of
	false:begin
		writeln('digite o lado em que está a cadeira a ser cancelada,[E]squerda,[D]direita');
		readln(side);
			case side of
			'E':linha:=2;
			'D':linha:=3;
			end;
		writeln('digite a posicao da cadeira');
		readln(posicao);
		posicao:=posicao+1;
		while matAssentos[linha,posicao]<>P do
			begin
				writeln('esse assento pertence a outra pessoa');
				writeln('tente de novo');
				writeln('digite o lado em que está a cadeira a ser cancelada,[E]squerda,[D]direita');
				readln(side);
				case side of
					'E':linha:=2;
					'D':linha:=3;
				end;
				writeln('digite a posicao da cadeira');
				readln(posicao);
				posicao:=posicao+1;
			end;
		matAssentos[linha,posicao]:='_';
		end;				
	true: begin
		writeln('você não pode cancelar a reserva pois não possui nenhuma');
		end;
	end;	
end;
	

{Programa Principal}
Var 
MatPP:assentos;
Nome:string;
l:char;
choice:integer;
Begin
	choice:=0;
	inicializar_assentos(MatPP);
	while choice<>4 do 
	begin
			writeln('escolha uma opção:');
			writeln('digite 1 para se identificar:');
			writeln('digite 2 para fazer a reserva');
			writeln('digite 3 para cancelar a reserva');
			writeln('digite	4 para encerrar o programa');
			readln(choice);
		while (choice<1) or (choice>4) do
		begin
			writeln('opção inválida, tente novamente');
			readln(choice);
		end;
	end;{end do while}
		case choice of

		1:begin
			identificarPassageiro(Nome);
		  end;	
		2:begin
			escolher_lado(l);
			ocupar_assentos(Nome,MatPP,l);
		  end;
		3:begin
			cancelar_reserva(Nome,MatPP);
		  end;
		4:begin
			writeln();
		  end;
		end;{end do case}
	{end do while}
END.

	




