program matriz1;

var
	 frequencia:array [1..10] of integer;
  	 matrizn:array[1..60] of integer;
    media:real;	
	 ind,ind2:integer;	
    nota:integer;
	 soma:integer;
	 nalunos:integer;


																{PROGRAMA PRINCIPAL}




BEGIN
   
	for ind2 :=1 to 10 do
	begin
		frequencia[ind2] := 0;
	end;
	writeln('informe a quantidade de alunos');
   readln(nalunos);
	BEGIN
     
		if (nalunos>60) then
		BEGIN
			writeln('o número tem que ser menor que 60');
      END      
     else
	  BEGIN
			ind:=1;
	 		for ind:=1 to nalunos do
			begin
				begin
			  matrizn[ind]:=0;
				end;
			  writeln('informe a nota do aluno ',ind);
		 	  readln(matrizn[ind]);
      		  
			end;
	  END;
	END;
	  for ind2:=1 to 10 do
	  BEGIN
          for ind:= 1 to nalunos do					
	    if(matrizn[ind]=ind2) then
	      begin
    	      frequencia[ind2]:= frequencia[ind2] + 1;
	      end;
	    end;
	for ind2:=1 to 10 do
   	begin
			writeln('a frequencia da nota ',ind2,' é ',frequencia[ind2]);
      							     
	  END;

	  for ind:=1 to nalunos do
     begin
       soma:=soma + matrizn[ind];
     end;	
     writeln('a soma é ',soma);
     
   

END.
	
