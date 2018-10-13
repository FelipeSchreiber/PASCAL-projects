program situacao;
var 
p1,p2,p3,mdecomp,mdenotas,m:real;
nfaltas,naulas,opcao:integer;
begin
	writeln ('informe o valor da nota 1');
	readln(p1);
	writeln('informe o valor da nota 2');
	readln(p2);
	writeln('informe o valor da nota 3');
	readln(p3);
	writeln('informe o número de aulas');
	readln(naulas);
	writeln('informe o número de faltas');
	readln(nfaltas);
	
	writeln('1 - Mostrar media ');
	writeln('2 - Mostrar porcentagem de presença ');
	writeln('3 - Mostrar maior nota ');
	writeln('4 - Mostrar situação ');
	readln(opcao);
	case opcao of
   1: begin
		mdenotas:= (p1+p2+p3)/3
		end;
   2: begin
		mdecomp:=(naulas-nfaltas)/ naulas;
		writeln(mdecomp)     
		end;
   3: begin
      	if p1>p2 then 
			begin
 		     m:=p1;
			end
	      else 
			begin
   		   m:=p2;
			end;
      	if m>p3 then
			begin
				writeln ('a maior nota é',m);
			end
			else
			begin
				writeln('a maior nota é', p3);
   		end;   

      end;
   4: begin
			mdecomp:=(naulas-nfaltas)/ naulas;
			mdenotas:=(p1 + p2 + p3)/ 3;
			if(mdecomp<0.75) then 
      
		  writeln ('o auluno está reprovado por falta')
		else
			if (mdenotas>7.0) then 
			writeln('o aluno está aprovado')
			else
				if (mdenotas>=3.0) then
				writeln('o aluno está em prova final')
				else
					writeln('o aluno está reprovado direto')
				end;
			end;
  
		end.

