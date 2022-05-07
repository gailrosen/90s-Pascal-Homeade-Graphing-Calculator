{Written by Gail Rosen (C) 1994, 2022}
{3rd Place in Computer Science in 1994 Florida State Science Fair}
{This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.}


program Science(input,output);
{$M 50000,1000,655360}
uses graph,crt;

type
  op=array[1..6,1..15] of char;
  d2=array[1..100,1..100] of char;
  nmer=array[1..2,0..640] of longint;
  nreal=array[1..2,0..640] of real;
  d1=array[1..2,1..100] of string[30];
  d3=array[1..2,1..100] of real;
  st=string[100];

var
  grDriver : Integer;
  grMode   : Integer;
  ErrCode  : Integer;
  equ,fderv,qwer,asdf,holder:st;
  i:string[5];
  enmaxx,enminx,yenmax,yenmin,ennum,ennmb,num,encount,enon,rc,enyn,enyb,enynum:real;
  nminer:nreal;
  user,enhanced:char;
  change,code,back,ques,temp,dcount,icount,teXtcurs,hor,ver,counter,vert,horiz,deter,zoom,trace,tr,over,onnum:integer;
  X,y:longint;
  stuff:d2;
  mine:nmer;
  derv:d1;
  opers:op;

label Start,Finish,Grap;

procedure teXt;{TEXT RESET- INITIALIZES SCREEN}
begin
      clearviewport;
      setcolor(15);
      outtextxy(20,80,'          Press H for help!');
      outtextxy(20,100,'          Q- to Quit');
      rectangle(1,240,639,479);
      outteXtXy(10,teXtcurs,'Please enter equation of graph');
end;

procedure helpscreen;{EXPLAINS COMMANDS}
var i:char;
begin
  clearviewport;
  setcolor(11);
  rectangle(1,1,639,479);
  outtextxy(275,10,'HELP MENU');
  setcolor(4); outtextxy(10,30,'LIST OF FUNCTIONS AND THEIR ABBREVIATIONS'); setcolor(9);
  outtextxy(10,40,'S- Sine');
  outtextxy(10,50,'C- Cosine');
  outtextxy(10,60,'T- Tangent');
  outtextxy(10,70,'J- Cosecant');
  outtextxy(10,80,'E- Secant');
  outtextxy(10,90,'O- Cotangent');
  outtextxy(10,100,'?- Square Root');
  outtextxy(10,110,'N- Negative');
  outtextxy(10,120,'!- Absolute Value');
  setcolor(4); outtextxy(10,140,'FORMAT FOR ENTERING EQUATIONS'); setcolor(9);
  outtextxy(10,150,'You may enter many terms per equation.  Each term except for the last must be');
  outtextxy(10,160,'followed by a ")"  then by a simple operator (+,-,*,/).  In a term, a number');
  outtextxy(10,170,'which can be whole or decimal, the variable X, one of the high level functions,');
  outtextxy(10,180,'or a term such as (2 *X*X) can be entered.  When inputting a function, enter');
  outtextxy(10,190,'the one letter abbreviation of the function then it can be followed by a term.');
  outtextxy(10,200,'If you enter a number as a value, leave a space after it to make sure the');
  outtextxy(10,210,'program knows it is the end of the number.');
  outtextxy(10,230,'Note:  As well as polynomials, a simple derivative can be computed for basic');
  outtextxy(10,240,'square roots, sines, cosines, etc.');
  setcolor(15); outtextxy(10,260,'If you wish to enter a polynomial such as x^2+2x+1, enter each term');
  outtextxy(10,270,'seperately beginning with a "(".  EXAMPLE: (X*X)+(2 *X)+1');
  outtextxy(10,290,'Other examples include: "640 /X"');
  outtextxy(200,300,'"S1.029 *X)*100)+X"');
  outtextxy(200,310,'"(2 *X/4)"');
  outtextxy(200,320,'"5)/(X*X)"');
  outtextxy(200,330,'"N1)*TX"');
  outtextxy(200,340,'"CX)*X)*2"');
  outtextxy(200,350,'"!X+240"');
  outtextxy(200,360,'"?320 /X"');
  outtextxy(200,370,'"nX*X*X"');
  setcolor(4);outtextxy(10,390,'HELP WITH ZOOM AND ENHANCE FEATURES');
  setcolor(9);outtextxy(10,400,'FOR ZOOM IN REGULAR MODE,');
  setcolor(15);outtextxy(250,400,'+=Magnify');
  outtextxy(10,410,'-=Demagnify, I=shift upward, J=shift left, K=shift down, L=shift right');
  setcolor(9);outtextxy(10,430,'IN ENHANCED MODE -');
  setcolor(15);outtextxy(200,430,'J=Move trace left');
  outtextxy(10,440,'L=Move trace right, O=Turn Coordinates on, F=Turn Coordinates off');
  setcolor(11);outtextxy(10,460,'H- Always HELP! and Q- Always QUIT!');
  i:=readkey;
end;

procedure initnum(var arr:nreal);{INITIALIZES ARRAY}
var X,y:integer;
begin
  X:=0;
  y:=0;
  for y:=0 to 640 do
  begin
  for X:=1 to 2 do
  begin
      arr[X,y]:=999
  end
  end
end;

procedure initreal(var arr:d3);{INITIALIZES ARRAY}
var X,y:integer;
begin
  X:=0;
  y:=0;
  for y:=1 to 100 do
  begin
  for X:=1 to 2 do
  begin
      arr[X,y]:=999
  end
  end
end;

procedure initarry(var arr:d2);{INITIALIZES ARRAY}
var X,y:integer;
begin
  X:=0;
  y:=0;
  for y:=1 to 100 do
  begin
  for X:=1 to 100 do
  begin
      arr[X,y]:='Z'
  end
  end
end;

procedure initop(var arr:op);{INITIALIZES ARRAY}
var X,y:integer;
begin
  X:=0;
  y:=0;
  for y:=1 to 15 do
  begin
  for X:=1 to 6 do
  begin
      arr[X,y]:='Z'
  end
  end
end;

procedure usegraph(cha:integer;horiz:integer;vert:integer);
{DRAWS AXES AND NUMBERS ALONG EACH AXIS}
var u,t,q,p,b,c:integer;
    g,j:st;
begin
g:='';
j:='';
setcolor(15);
  line(1,horiz,639,horiz);
  line(vert,1,vert,479);
if cha>16 then
  begin
  q:=640 div cha;
  p:=480 div cha;
  b:=(horiz-240) div cha;
  c:=(vert-320) div cha;
  for u:=1 to q do
    begin
      str((-((q div 2)-u))-c,g);
      line(u*cha,horiz,u*cha,horiz+3);
      outteXtXy(u*cha,horiz+10,g);
    end;
  if (p mod 2)=0 then begin
  for t:=1 to p do
    begin
      str(((p div 2)-t)+b,j);
      line(vert,t*cha,vert+3,t*cha);
      outteXtXy(vert+10,t*cha,j)
      end
    end
  else if (p mod 2)>0 then begin
    for t:=0 to (p div 2) do
      begin
        str(t+b,j);
        line(vert,240-(t*cha),vert+3,240-(t*cha));
        outteXtXy(vert+10,240-(t*cha),j);
     end;
    for t:=-(p div 2) to 0 do
      begin
        str(t+b,j);
        line(vert,240+(-t*cha),vert+3,240+(-t*cha));
        outteXtXy(vert+10,240+(-t*cha),j)
      end
    end
  end
end;


procedure deriv(temp:st;var u:st);{TAKES THE SIMPLE DERIVATIVE}
var count,X,num,ac,code:integer;
exch,op:st;
i:string[100];
conv:real;
begin
  op:='';
  i:='';
  conv:=0;
  count:=1;
  u:='';
  ac:=0;
  exch:='';
  X:=0;
  num:=0;
  if (temp='X'+'*'+'X') or (temp='X*X') then begin u:='2*X'; end
  else
    begin
    temp:=temp+'Z';
    while (temp[count]<>'Z') do
      begin
        if temp[count]='X' then X:=1
        else if (temp[count]='1') or (temp[count]='2') or (temp[count]='3') or (temp[count]='4') or (temp[count]='5') or
        (temp[count]='6') or (temp[count]='7') or (temp[count]='8') or (temp[count]='9') or (temp[count]='0') or
        (temp[count]='.') then
          begin
           ac:=ac+1;
           if ac=1 then exch:=temp[count];
           if ac>1 then exch:=exch+temp[count];
           num:=1
          end
        else if (temp[count]='+') or (temp[count]='-') or (temp[count]='*') or (temp[count]='/') then
          op:=temp[count];
        count:=count+1;
        end;
      end;

  if (X=1) and (num=1) and (op='*') then u:=exch;
  if (X=1) and (num=1) and ((op='+') or (op='-')) then u:='1';
  if (X=1) and (num=1) and (op='/') and (temp[1]='X') then
    begin
      val(exch,conv,code);
      conv:=conv/(conv*conv);
      str(conv,i);
      u:=i;
    end;
  if (X=1) and (num=1) and (op='/') and (temp[1]<>'X') then
    begin
      val(exch,conv,code);
      conv:=-conv;
      str(conv,i);
      u:=i+'/'+'X*X'
    end;
  if (X=0) and (num=1) then u:='0';
end;


procedure gra(mine:nmer;user:integer;hore:integer;ver:integer;zoom:integer;tr:integer;over:integer);
{GRAPHS EQUATION AND DRAWS 4 CORNER POINTS}
var
  first,step:integer;
  X2,i,z,y2,m:longint;
  coordi:st;

begin
       step:=user;
       y2:=0;
       z:=0;
       first:=1;
       coordi:='';
       X2:=-step+1+over;
       i:=0;
       i:=((320-(320 div step))+ver);
       if zoom=1 then setcolor(14);
       str(i-320,coordi);
       if zoom=1 then outteXtXy(1,230,coordi);
       str(((480 div step) div 2)+(hore div step),coordi);
       if zoom=1 then outteXtXy(310,1,coordi);
       if zoom=1 then setcolor(11);
       repeat
       begin
        if tr>0 then tr:=tr+1;
        X2:=X2+step;
        i:=i+1;
        y2:=mine[1,i-1];
        if (mine[1,i-2]=999) and (first>1) then begin
                                 if (y2>0) and (y2<240) then z:=240-(y2*step) else z:=-((y2*step)-240)
                                 end
        else if (mine[1,i-2]>240) and (first>1) then begin
                                 if (y2>0) and (y2<240) then z:=240-(y2*step) else z:=-((y2*step)-240);
                                 end
        else if (mine[1,i-2]<-240) and (first>1) then begin
                                 if (y2>0) and (y2<240) then z:=240-(y2*step) else z:=-((y2*step)-240);
                                 end;
       m:=y2;
       y2:=y2*step;
       if (m>=-240) and (m<=0) and (mine[1,i-2]<>999) and (first>1) then line(X2-step,z+hore,X2,(-(y2-240))+hore);
       if (m>=0) and (m<=240) and (mine[1,i-2]<>999) and (first>1) then line(X2-step,z+hore,X2,(240-y2)+hore);
       if (m>=0) and (m<=240) and (mine[1,i-2]<>999) then
          begin
           if (mine[1,i-2]>240) and (first>1) then line(X2-step,1,X2-step,z+hore);
           if (mine[1,i-2]<-240) and (first>1) then line(X2-step,480,X2-step,z+hore);
           putpiXel(X2,(240-y2)+hore,3);
           z:=240-y2
          end
       else if (m>=-240) and (m<=0) and (mine[1,i-2]<>999) then
          begin
           if (mine[1,i-2]>240) and (first>1) then line(X2-step,1,X2-step,z+hore);
           if (mine[1,i-2]<-240) and (first>1) then line(X2-step,480,X2-step,z+hore);
           putpiXel(X2,(-(y2-240))+hore,3);
           z:=-(y2-240)
          end
       end;
       if (m<>999) and (m>240) and (mine[1,i-2]<240) and (mine[1,i-2]>-240) then line(X2-step,z+hore,X2-step,1)
  else if (m<-240) and (mine[1,i-2]>-240) and (mine[1,i-2]<240) and (mine[1,i-2]<>999) then line(X2-step,z+hore,X2-step,480);
       first:=first+1;
       if tr=4 then i:=998;
       until i>=ver+((320 div step)+320)+1;
       if zoom=1 then setcolor(14);
       str((-(480 div step)div 2)+(hore div step),coordi);
       if zoom=1 then outteXtXy(310,470,coordi);
       str(i-321,coordi);
       if zoom=1 then outteXtXy(615,230,coordi);
       setcolor(11);
end;

procedure trac(trace:integer;nminer:nreal;mine:nmer;onnum:integer);
{DRAWS THE TRACE POINTER AND PRINTS OUT THE COORDINATE VALUES}

var xcoor,ycoor:st;
    g,u,h,v,z,o:integer;
begin
  g:=1;
  u:=1; v:=trace; z:=0; h:=0;
  o:=trace;
  setcolor(13);
  gra(mine,u,h,v,z,g,o);
  str(nminer[1,trace],xcoor);
  str(nminer[2,trace],ycoor);
  if onnum=1 then outtextxy(1,1,'('+xcoor+','+ycoor+')');
end;


procedure dissect(var victim:st;var arr:op);
{BREAKS THE TERMS INTO SIMPLER COMPONENTS SO THEY CAN BE PRODUCED}
var X,y,counter,c:integer;
begin
  X:=0;
  y:=1;
  counter:=1;
  while victim[counter]<>'Z' do
    begin
      X:=X+1;
      arr[X,y]:=victim[counter];
      if (victim[counter]='+') or (victim[counter]='X') or (victim[counter]='-') or (victim[counter]='/') or
         (victim[counter]='*') then
        begin
          arr[X+1,y]:='Z';
          X:=0;
          y:=y+1
        end
      else if (victim[counter]='1') or(victim[counter]='2') or(victim[counter]='3') or(victim[counter]='4')
      or(victim[counter]='5') or (victim[counter]='6') or(victim[counter]='7') or(victim[counter]='8')
      or(victim[counter]='9') or(victim[counter]='0')
          then
          begin
          arr[X,y]:=victim[counter];
           counter:=counter+1;
           c:=counter;
            while (victim[c]<>'Z') and (victim[c]<>' ') do
              begin
               X:=X+1;
               arr[X,y]:=victim[c];
               c:=c+1;
              end;
            if victim[c]=' ' then c:=c+1;
            arr[X+1,y]:='Z';
            X:=0;
            y:=y+1;
            counter:=c-1;
         end;
      counter:=counter+1
    end
end;

procedure produce(var arr:op;var term:real;var num:real);
{EVALUATES A TERM BY CALCULATING THE SMALLER COMPONENTS}
var X,y,m,c,b,code,checker:integer;
    hld,st,exch:string[20];
    alter:d1;
    g,n,conv:real;

begin
  code:=0;
  conv:=0;
  n:=0;
  g:=0;
  X:=1;
  y:=1;
  term:=0;
  checker:=0;
  st:='';
  exch:='';
  str(num,st);
  while arr[X,y]<>'Z' do
    begin
      if (arr[X,y]='X') then
        alter[X,y]:=st
      else if (arr[X,y]='1') or (arr[X,y]='2') or(arr[X,y]='3') or(arr[X,y]='4') or(arr[X,y]='5') or(arr[X,y]='6')
           or(arr[X,y]='.') or (arr[X,y]='7') or(arr[X,y]='8') or(arr[X,y]='9') or(arr[X,y]='0') then
            begin
             m:=1;
              exch[m]:=arr[X,y];
              while arr[X+1,y]<>'Z' do
                begin
                  X:=X+1;
                  m:=m+1;
                  exch[m]:=arr[X,y];
                end;
               hld:='';
               for b:=1 to m do
                 hld:=hld+exch[b];
               X:=1;
               alter[X,y]:=hld;
            end
      else if (arr[X,y]='+') or (arr[X,y]='-') or (arr[X,y]='*') or (arr[X,y]='/')
        then alter[X,y]:=arr[X,y];
      y:=y+1;
    end;
  X:=1;
  y:=2;
  c:=1;
  while arr[X,y]<>'Z' do
    begin
      if c=1 then val(alter[X,y-1],g,code);
      val(alter[X,y+1],n,code);
      if (alter[X,y]='*') and (term<>999) then
        begin
          if c=1 then term:=g*n
          else term:=term*n;
        end
      else if (alter[X,y]='+') and (term<>999) then
        begin
          if c=1 then  term:=g+n  
          else  term:=term+n
        end
      else if (alter[X,y]='-') and (term<>999) then
        begin
          if c=1 then term:=g-n
          else term:=term-n
        end
      else if (alter[X,y]='/') and (term<>999) and (n<>0) then
        begin
          if c=1 then term:=g/n
          else term:=(term/n);
        end
      else if (alter[X,y]='/') and (n=0) then term:=999;
    y:=y+1;
    c:=c+1;
    checker:=1
    end;
    if checker=0  then begin val(hld,conv,code); term:=conv end
end;

procedure dcomp(var opers:op;var derv:d1;var fderv:st;var deter:integer);
{TAKES THE DERIVATIVE OF POLYNOMIALS BY USING THE DERIV PROCEDURE
TO TAKE THE DERIVATIVE OF THE SMALLER COMPONENT}
var icount,loop,plus,neg,mult,dv,code,keep:integer;
    holder,after,j,prev,suc:st;
    i:real;

begin
fderv:='';
i:=0;
keep:=0;
prev:='';
suc:='';
j:='';
code:=0;
icount:=2;
holder:='';
after:='';
plus:=0;
neg:=0;
mult:=0;
dv:=0;
if deter=0 then begin
  while opers[1,icount]<>'Z' do
    begin
      if opers[1,icount]='+' then plus:=plus+1;
      if opers[1,icount]='-' then neg:=neg+1;
      if opers[1,icount]='*' then mult:=mult+1;
      if opers[1,icount]='/' then  begin keep:=icount; dv:=dv+1 end;
      icount:=icount+1;
    end;
if dv=0 then keep:=icount-1;
icount:=icount-1;
if plus+neg=icount-1 then
  begin
    for loop:=1 to icount do
      begin
        if loop>1 then fderv:=fderv+opers[1,loop];
        fderv:=fderv+derv[1,loop]
      end
  end
else if (mult=1) or (mult=2) or (mult=3) or (dv=1) or (dv=2) or (dv=3) or (dv=4) then
  begin
    if (mult=1) then
    begin
      holder:=derv[2,1]+opers[1,2]+derv[2,2];
      deriv(holder,after);
      fderv:=after
    end;
    if mult=2 then
    begin
      if derv[2,1]='X' then  begin after:='3*X*X'; fderv:=after end
      else
      begin
       val(derv[2,1],i,code);
       i:=i*2;
       str(i,j);
       after:=j+'*'+'X';
       fderv:=after;
      end;
    end;
    if mult=3 then
      begin
        val(derv[2,1],i,code);
        i:=i*3;
        str(i,j);
        after:=j+'*X*X';
        fderv:=after
      end;
    if (mult>=1) and (icount-1>mult+dv) then
     begin
     for loop:=(mult+dv+2) to (keep-1) do
       begin
         fderv:=fderv+opers[1,loop];
         fderv:=fderv+derv[1,loop];
       end;
     end;

    if dv=1 then
      begin
      str(keep,j);
        if (keep=2) and (icount=keep) then
          begin
           holder:=derv[2,1]+opers[1,2]+derv[2,2];
           deriv(holder,after);
           fderv:=after
          end
        else begin
               prev:=derv[2,1];
               for loop:=2 to (keep-1) do
               begin
                 prev:=prev+opers[1,loop];
                 prev:=prev+derv[2,loop];
               end;
               for loop:=keep to icount do
               begin
                 if loop>keep then suc:=suc+opers[1,loop];
                 suc:=suc+derv[2,loop];
                 end;
              deriv(suc,after);
              fderv:='('+suc+'*'+fderv+')'+'-'+'('+prev+'*'+after+')'+'/'+suc+'*'+suc
              end
          end
        end
    end
end;

procedure finalone(var snum:d3;var opers:op;var overall:real);
{EVALUATES THE EQUATION BY CALCULATING THE TERMS THAT HAVE BEEN DETERMINED
BY THE DISSECT AND PRODUCE PROCEDURES}
var y,d:integer;
    adder:real;

begin
  adder:=0;
  y:=2;
  d:=0;
  while opers[1,y]<>'Z' do
    begin
    d:=d+1;
      if y=2 then
        begin
          if (opers[1,y]='+') and (snum[1,1]<>999) and (snum[1,2]<>999) then adder:=snum[1,1]+snum[1,2]
          else if (opers[1,y]='-') and (snum[1,1]<>999) and (snum[1,2]<>999) then adder:=snum[1,1]-snum[1,2]
          else if (opers[1,y]='*') and (snum[1,1]<>999) and (snum[1,2]<>999) then adder:=snum[1,1]*snum[1,2]
          else if (opers[1,y]='/') and (snum[1,2]<>0) and (snum[1,1]<>999) and (snum[1,2]<>999) then adder:=snum[1,1]/snum[1,2]
          else if (snum[1,2]=0) or (snum[1,2]=999) or (snum[1,1]=999) then adder:=999
        end
      else if y>2 then
        begin
          if (opers[1,y]='+') and (adder<>999) and (snum[1,y]<>999) then adder:=adder+snum[1,y]
          else if (opers[1,y]='-') and (adder<>999) and (snum[1,y]<>999) then adder:=adder-snum[1,y]
          else if (opers[1,y]='*') and (adder<>999) and (snum[1,y]<>999) then adder:=adder*snum[1,y]
          else if (opers[1,y]='/') and (snum[1,y]<>0) and (snum[1,y]<>999) and (adder<>999) then adder:=adder/snum[1,y]
          else if (snum[1,y]=0) or (snum[1,y]=999) or (snum[1,y]=999) then adder:=999;
        end;
      y:=y+1;
    end;
  overall:=adder;
end;

procedure compute(var arr:d2;var mine:nmer;var num:real;var icount:integer;var derv:d1;var dc:integer;var opers:op;
var deter:integer; var ebb:real;var nminer:nreal);

{SEARCHES FOR FUNCTIONS SUCH AS SINE, COSINE, ETC. AND EVALUATES THE TERM
FOLLOWING THE FUNCTION. IT ALSO CALCULATES THE DERIVATIVE FOR SELECT
FUNCTIONS. IT ALSO KEEPS TRACK OF THE OPERATORS AND TERMS.}

var X,y,t,c,count,m,g,code:integer;
    temp,holder,pop,u,ahold,bhold:st;
    term,overall,conv:real;
    secop,oper:op;
    stone:d3;
    drv:d1;

begin
  deter:=0;
  conv:=0;
  X:=1;
  y:=1;
  holder:='';
  temp:='';
  pop:='';
  u:='';
  count:=1;
  overall:=0;
  term:=0;
  initop(opers);
  initreal(stone);
       if (arr[1,1]='X') and (arr[2,1]='Z') and (arr[1,2]='Z') then begin
       if (ebb>1) or (ebb<1) then
                       begin
                         nminer[1,icount]:=num;
                         {str(round(overall*ebb),bhold);
                         str(num,bhold);
                         outtextxy(1,1,bhold);
                         i:=readkey;}
                         nminer[2,icount]:=num
                       end;
                       overall:=num*ebb;derv[1,1]:='1'; derv[2,1]:='X';
       count:=2 end
         else
         while arr[1,y]<>'Z' do
         begin

           if arr[X,y]='(' then
             begin
              if arr[X+2,y]<>'Z' then
                begin
                t:=2;
                c:=0;
                  while arr[t,y]<>'Z' do
                    begin
                      c:=c+1;
                      temp[c]:=arr[t,y];
                      t:=t+1;
                    end;
                for g:=1 to c do
                  holder:=holder+temp[g];
                temp[c+1]:='Z';
                dissect(temp,secop);
                produce(secop,term,num);
                end
              else if arr[X+1,y]='X' then term:=num
              else if arr[X+1,y]<>'X' then begin val(arr[X+1,y],conv,code); term:=conv end;
             if (term<>num) and (dc=1) then begin
                                              ahold:='';
                                              c:=1;
                                              t:=1;
                                              while temp[c]<>'Z' do
                                              begin
            if temp[c]=' ' then {}
       else if temp[c]='+' then begin if ahold='X' then drv[1,t]:='1' else drv[1,t]:='0';
       drv[2,t]:=ahold; ahold:=''; t:=t+1; oper[1,t]:='+' end
         else if temp[c]='-' then begin if ahold='X' then drv[1,t]:='1' else drv[1,t]:='0';
         drv[2,t]:=ahold; ahold:=''; t:=t+1; oper[1,t]:='-' end
         else if temp[c]='*' then begin if ahold='X' then drv[1,t]:='1' else drv[1,t]:='0';
         drv[2,t]:=ahold; ahold:=''; t:=t+1; oper[1,t]:='*' end
         else if temp[c]='/' then begin if ahold='X' then drv[1,t]:='1' else drv[1,t]:='0';
         drv[2,t]:=ahold; ahold:=''; t:=t+1; oper[1,t]:='/' end
           else ahold:=ahold+temp[c];
       c:=c+1;
    end;
  if ahold='X' then drv[1,t]:='1' else drv[1,t]:='0';
  drv[2,t]:=ahold;
  oper[1,t+1]:='Z';
  dcomp(oper,drv,u,deter);
  end;
             if (term=num) and (dc=1) THEN begin holder:='X'; u:='1'; end;
             if dc=1 then derv[1,count]:=u;
             if dc=1 then derv[2,count]:=holder;
             if term<>999 then stone[1,count]:=term
             else stone[1,count]:=term;
             count:=count+1;
             end

           else if arr[X,y]='S' then
             begin
              if arr[X+2,y]<>'Z' then
                begin
                t:=2;
                c:=0;
                  while arr[t,y]<>'Z' do
                    begin
                      c:=c+1;
                      temp[c]:=arr[t,y];
                      t:=t+1;
                    end;
                for g:=1 to c do
                  holder:=holder+temp[g];
                temp[c+1]:='Z';
                dissect(temp,secop);
                produce(secop,term,num);
                end
              else if arr[X+1,y]='X' then term:=num
              else if arr[X+1,y]<>'X' then begin val(arr[X+1,y],conv,code); term:=conv end;
             if (term<>num) and (dc=1) then deriv(holder,u);
             if (term=num) and (dc=1) THEN begin holder:='X'; u:='1'; end;
             if dc=1 then derv[1,count]:='cos('+holder+')'+'*('+u+')';
             if dc=1 then derv[2,count]:=holder;
             if term<>999 then stone[1,count]:=sin(term)
             else stone[1,count]:=term;
             count:=count+1;
             end

         else if arr[X,y]='C' then
             begin
             if arr[X+2,y]<>'Z' then
                begin
                t:=2;
                c:=0;
                  while arr[t,y]<>'Z' do
                    begin
                      c:=c+1;
                      temp[c]:=arr[t,y];
                      t:=t+1;
                    end;
                for g:=1 to c do
                  holder:=holder+temp[g];
                temp[c+1]:='Z';
                dissect(temp,secop);
                produce(secop,term,num);
                end
             else if arr[X+1,y]='X' then term:=num
             else if arr[X+1,y]<>'X' then begin val(arr[X+1,y],conv,code); term:=conv end;
             if (term<>num) and (dc=1) then deriv(holder,u);
             if (term=num) and (dc=1) THEN begin holder:='X'; u:='1'; end;
             if (dc=1) then derv[1,count]:='-sin('+holder+')'+'*('+u+')';
             if dc=1 then derv[2,count]:=holder;
             if term<>999 then stone[1,count]:=cos(term)
             else stone[1,count]:=term;
             count:=count+1;
             end

         else if arr[X,y]='T' then
             begin
                if arr[X+2,y]<>'Z' then
                begin
                t:=2;
                c:=0;
                  while arr[t,y]<>'Z' do
                    begin
                      c:=c+1;
                      temp[c]:=arr[t,y];
                      t:=t+1;
                    end;
                for g:=1 to c do
                  holder:=holder+temp[g];
                temp[c+1]:='Z';
                dissect(temp,secop);
                produce(secop,term,num);
                end
              else if arr[X+1,y]='X' then term:=num
              else if arr[X+1,y]<>'X' then begin val(arr[X+1,y],conv,code); term:=conv end;
             if (term<>num) and (dc=1) then deriv(holder,u);
             if (term=num) and (dc=1) THEN begin holder:='X'; u:='1'; end;
             if dc=1 then derv[1,count]:='sec^2('+holder+')'+'*'+'('+u+')';
             if dc=1 then derv[2,count]:=holder;
             if term<>999 then stone[1,count]:=sin(term)/cos(term)
             else stone[1,count]:=term;
             count:=count+1;
             end

           else if arr[X,y]='J' then
             begin
               if arr[X+2,y]<>'Z' then
                begin
                t:=2;
                c:=0;
                  while arr[t,y]<>'Z' do
                    begin
                      c:=c+1;
                      temp[c]:=arr[t,y];
                      t:=t+1;
                    end;
                for g:=1 to c do
                  holder:=holder+temp[g];
                temp[c+1]:='Z';
                dissect(temp,secop);
                produce(secop,term,num);
                end
              else if arr[X+1,y]='X' then term:=num
              else if arr[X+1,y]<>'X' then begin val(arr[X+1,y],conv,code); term:=conv end;
             if (term<>num) and (dc=1) then deriv(holder,u);
             if (term=num) and (dc=1) THEN begin holder:='X'; u:='1'; end;
             if dc=1 then derv[1,count]:='-csc('+holder+')'+'*'+'cot('+holder+')'+'*'+u;
             if dc=1 then derv[2,count]:=holder;
             if (sin(term)<>0) and (term<>999) then stone[1,count]:=1/sin(term);
             if (sin(term)=0) or (term=999) then begin stone[1,count]:=999; end;
             count:=count+1
             end

           else if arr[X,y]='E' then
             begin
               if arr[X+2,y]<>'Z' then
                begin
                t:=2;
                c:=0;
                  while arr[t,y]<>'Z' do
                    begin
                      c:=c+1;
                      temp[c]:=arr[t,y];
                      t:=t+1;
                    end;
                for g:=1 to c do
                  holder:=holder+temp[g];
                temp[c+1]:='Z';
                dissect(temp,secop);
                produce(secop,term,num);
                end
              else if arr[X+1,y]='X' then term:=num
              else if arr[X+1,y]<>'X' then begin val(arr[X+1,y],conv,code); term:=conv end;
             if (term<>num) and (dc=1) then deriv(holder,u);
             if (term=num) and (dc=1) THEN begin holder:='X'; u:='1'; end;
             if dc=1 then derv[1,count]:='sec('+holder+')'+'*'+'tan('+holder+')'+'*'+u;
             if dc=1 then derv[2,count]:=holder;
             if term<>999 then stone[1,count]:=1/cos(term)
             else stone[1,count]:=term;
             count:=count+1
             end

           else if arr[X,y]='O' then
             begin
               if arr[X+2,y]<>'Z' then
                begin
                t:=2;
                c:=0;
                  while arr[t,y]<>'Z' do
                    begin
                      c:=c+1;
                      temp[c]:=arr[t,y];
                      t:=t+1;
                    end;
                for g:=1 to c do
                  holder:=holder+temp[g];
                temp[c+1]:='Z';
                dissect(temp,secop);
                produce(secop,term,num);
                end
              else if arr[X+1,y]='X' then term:=num
              else if arr[X+1,y]<>'X' then begin val(arr[X+1,y],conv,code); term:=conv end;
             if (term<>num) and (dc=1) then deriv(holder,u);
             if (term=num) and (dc=1) THEN begin holder:='X'; u:='1'; end;
             if dc=1 then derv[1,count]:='-csc^2('+holder+')'+'*'+u;
             if dc=1 then derv[2,count]:=holder;
             if (term<>999) and (cos(term)<>0) and ((sin(term)/cos(term)<>0)) then stone[1,count]:=1/(sin(term)/cos(term));
             if (term=999) or (cos(term)=0) or ((sin(term)/cos(term))=0) then begin stone[1,count]:=999; end;
             count:=count+1
             end

           else if arr[X,y]='?' then
             begin
               if arr[X+2,y]<>'Z' then
                begin
                t:=2;
                c:=0;
                  while arr[t,y]<>'Z' do
                    begin
                      c:=c+1;
                      temp[c]:=arr[t,y];
                      t:=t+1;
                    end;
                for g:=1 to c do
                  holder:=holder+temp[g];
                temp[c+1]:='Z';
                dissect(temp,secop);
                produce(secop,term,num);
                end
              else if arr[X+1,y]='X' then term:=num
              else if arr[X+1,y]<>'X' then begin val(arr[X+1,y],conv,code); term:=conv end;
             if (term<>num) and (dc=1) then deriv(holder,u);
             if (term=num) and (dc=1) THEN begin holder:='X'; u:='1'; end;
             if dc=1 then derv[1,count]:='.5*'+'(1'+'/'+'?'+'('+holder+'))*'+u;
             if dc=1 then derv[2,count]:=holder;
             if (term<>999) and (term>=0) then stone[1,count]:=sqrt(term);
             if (term<0) or (term=999) then begin stone[1,count]:=999; end;
             count:=count+1
             end

           else if arr[X,y]='N' then
             begin
             if arr[X+2,y]<>'Z' then
                begin
                t:=2;
                c:=0;
                  while arr[t,y]<>'Z' do
                    begin
                      c:=c+1;
                      temp[c]:=arr[t,y];
                      t:=t+1;
                    end;
                for g:=1 to c do
                  holder:=holder+temp[g];
                temp[c+1]:='Z';
                dissect(temp,secop);
                produce(secop,term,num);
                end
              else if arr[X+1,y]='X' then term:=num
              else if arr[X+1,y]<>'X' then begin val(arr[X+1,y],conv,code); term:=conv end;
             if (term<>num) and (dc=1) then deriv(holder,u);
             if (term=num) and (dc=1) THEN begin holder:='X'; u:='1'; end;
             if dc=1 then derv[1,count]:='-'+u;
             if dc=1 then derv[2,count]:=holder;
             if (term<>999) then stone[1,count]:=-(term)
             else stone[1,count]:=term;
             count:=count+1
             end

           else if arr[X,y]='!' then
             begin
               if arr[X+2,y]<>'Z' then
                begin
                t:=2;
                c:=0;
                  while arr[t,y]<>'Z' do
                    begin
                      c:=c+1;
                      temp[c]:=arr[t,y];
                      t:=t+1;
                    end;
                for g:=1 to c do
                  holder:=holder+temp[g];
                temp[c+1]:='Z';
                dissect(temp,secop);
                produce(secop,term,num);
                end
              else if arr[X+1,y]='X' then term:=num
              else if arr[X+1,y]<>'X' then begin val(arr[X+1,y],conv,code); term:=conv end;
             if (term<>999) then stone[1,count]:=abs(term)
             else stone[1,count]:=term;
             count:=count+1;
             deter:=1
             end

           else if arr[X,y]='X' then
             begin
               if dc=1 then derv[1,count]:='1';
               if dc=1 then derv[2,count]:='X';
               stone[1,count]:=num;
               count:=count+1
             end

           else if arr[X,y]='+' then
             opers[1,count]:='+'

           else if arr[X,y]='-' then
             opers[1,count]:='-'

           else if arr[X,y]='*' then begin
             deter:=1;
             opers[1,count]:='*'
             end

           else if arr[X,y]='/' then begin
             deter:=1;
             opers[1,count]:='/'
             end

           else if (arr[X,y]='1') or(arr[X,y]='2') or(arr[X,y]='3') or(arr[X,y]='4') or(arr[X,y]='5') or(arr[X,y]='6')
                or(arr[X,y]='.') or(arr[X,y]='7') or(arr[X,y]='8') or(arr[X,y]='9') or(arr[X,y]='0') then
            begin
             c:=1;
             pop[c]:=arr[X,y];
              while arr[X+1,y]<>'Z' do
                begin
                 X:=X+1;
                 c:=c+1;
                 pop[c]:=arr[X,y];
                end;
               holder:='';
               for m:=1 to c do
                 holder:=holder+pop[m];
               if dc=1 then derv[1,count]:='0';
               if dc=1 then derv[2,count]:=holder;
               val(holder,conv,code);
               stone[1,count]:=conv;
               count:=count+1;
               X:=1;
             end;

         y:=y+1
         end;
         if y>2 then begin finalone(stone,opers,overall); if (ebb>1) or (ebb<1) then
                       begin
                         nminer[1,icount]:=num;
                         nminer[2,icount]:=overall
                       end;
                         overall:=overall*ebb
                       end
           else if y=2 then begin if (ebb>1) or (ebb<1) then
                       begin
                         nminer[1,icount]:=num;
                         nminer[2,icount]:=(stone[1,count-1])
                       end;
                         overall:=(stone[1,count-1])*ebb
                         end;
         mine[1,icount]:=round(overall);
         if dc=1 then derv[1,count]:='Z';
         if dc=1 then derv[2,count]:='Z'
end;

{*****************START OF MAIN************************}
begin
   grDriver := Detect;
  InitGraph(grDriver,grMode,'');
  ErrCode := GraphResult;
  if ErrCode = grOk then
  Start: begin

       {INITIALIZES AND ASKS FIRST QUESTION}
       teXtcurs:=255;
       zoom:=1;
       X:=0;
       y:=1;
       back:=0;
       counter:=0;
       dcount:=0;
       num:=0;
       teXt;
       initarry(stuff);
       ques:=248;
       setcolor(12);

       {READING IN LINE AND SORTING TERMS}

       repeat
        begin
         X:=X+1;
         counter:=counter+1;
         equ[counter]:=readkey;
         equ[counter]:=upcase(equ[counter]);
         if equ[counter]=chr(8) then begin if X=1 then begin X:=back-1; y:=y-1 end else X:=X-2 end;
         if equ[counter]<>chr(8) then stuff[X,y]:=equ[counter];
         if stuff[1,1]='H' then begin helpscreen; goto Start end;
         if stuff[1,1]='Q' then goto Finish;
         if stuff[X,y]=')' then
           begin
             outteXtXy(ques+(counter*10),teXtcurs,equ[counter]);
             stuff[X,y]:='Z';
             back:=X;
             X:=0;
             y:=y+1
           end
         else if (X=1) and ((stuff[X,y]='+') or (stuff[X,y]='-') or (stuff[X,y]='*') or (stuff[X,y]='/')) then
           begin
             outteXtXy(ques+(counter*10),teXtcurs,equ[counter]);
             stuff[X+1,y]:='Z';
             back:=X;
             X:=0;
             y:=y+1
           end;
         if equ[counter]<>chr(8) then outteXtXy(ques+(counter*10), teXtcurs, equ[counter]);
         if equ[counter]=chr(8) then begin setcolor(0); outteXtXy(ques+((counter-1)*10),teXtcurs,chr(219)); counter:=counter-2;
          setcolor(12)  end
        end;
       until (equ[counter]=chr(13)) or (equ[counter]=chr(16));
       stuff[X,y]:='Z';
       setcolor(0);
       outteXtXy(ques+(counter*10),teXtcurs,chr(219));
       setcolor(15);
       equ[counter]:=chr(255);
       textcurs:=textcurs+20;

       {ASKS QUESTION AND GET INFO BOUT ENHANCED MODE}

       outtextxy(10,textcurs,'Would you like use enhanced mode?(Y/N)');
       enhanced:=readkey;
       enhanced:=upcase(enhanced);
       if enhanced='Y' then begin
         ques:=400;
         qwer:='';
         holder:='';
         asdf:='';
         enmaxx:=0;
         enminx:=0;
         yenmax:=0;
         yenmin:=0;
         counter:=0;
         textcurs:=textcurs+20;

         outtextxy(10,textcurs,'We now need information about the window size.  Please enter the maximum X coordinate.');
         repeat
           begin
           counter:=counter+1;
           qwer:=readkey;
           asdf:=asdf+qwer;
           outtextxy(ques+(counter*10),textcurs,qwer)
           end;
         until (qwer=chr(13)) or (qwer=chr(16));
         for temp:=1 to (counter-1) do
            holder:=holder+asdf[temp];
         val(holder,enmaxx,code);
         textcurs:=textcurs+20;
         counter:=0;
         asdf:='';
         holder:='';

         outtextxy(10,textcurs,'Please enter the mininmum X coordinate');
         repeat
           begin
           counter:=counter+1;
           qwer:=readkey;
           asdf:=asdf+qwer;
           outtextxy(ques+(counter*10),textcurs,qwer)
           end;
         until (qwer=chr(13)) or (qwer=chr(16));
         for temp:=1 to (counter-1) do
            holder:=holder+asdf[temp];
         val(holder,enminx,code);
         textcurs:=textcurs+20;
         counter:=0;
         asdf:='';
         holder:='';

         outtextxy(10,textcurs,'Please enter the maximum Y coordinate');
         repeat
           begin
           counter:=counter+1;
           qwer:=readkey;
           asdf:=asdf+qwer;
           outtextxy(ques+(counter*10),textcurs,qwer);
           end
         until ((qwer=chr(13)) or (qwer=chr(16)));
         for temp:=1 to (counter-1) do
            holder:=holder+asdf[temp];
         val(holder,yenmax,code);
         textcurs:=textcurs+20;
         counter:=0;
         asdf:='';
         holder:='';

         outtextxy(10,textcurs,'Please enter the mininmum Y coordinate');
         repeat
           begin
           counter:=counter+1;
           qwer:=readkey;
           asdf:=asdf+qwer;
           outtextxy(ques+(counter*10),textcurs,qwer);
           end
         until ((qwer=chr(13)) or (qwer=chr(16)));
         for temp:=1 to (counter-1) do
            holder:=holder+asdf[temp];
         val(holder,yenmin,code);
         textcurs:=textcurs+20;
         counter:=0;
         asdf:='';
         holder:='';

         {CALCULATES MAGNIFICATION, COMPUTES THE VALUES, AND CONVERTS THE AXIS TO MEET
          ENHANCE REQUIREMENTS}

         ennum:=640/(enmaxx-enminx);
         ennmb:=1/ennum;
         num:=enminx;
         enyn:=yenmax-yenmin;
         enyb:=479/enyn;
         enynum:=1/enyb;
         enon:=999;
         encount:=999;

         icount:=0;
         repeat
           dcount:=dcount+1;
           compute(stuff,mine,num,icount,derv,dcount,opers,deter,enyb,nminer);
           if round(mine[1,icount])=0 then begin encount:=666; rc:=mine[1,icount] end;
           if abs(yenmax)>abs(yenmin) then mine[1,icount]:=mine[1,icount]-(((trunc(yenmax-1))*trunc(479/(yenmax-yenmin)))div
           round((yenmax-yenmin)/2));
           if abs(yenmin)>abs(yenmax) then mine[1,icount]:=mine[1,icount]+(((trunc(abs(yenmin)-1))*trunc(479/(yenmax-yenmin)))
           div round((yenmax-yenmin)/2));
           if encount=666 then encount:=mine[1,icount]+(2*(rc-mine[1,icount]))+240;
           num:=num+ennmb;
           if (abs(num)>abs(num-ennmb)) and (enon=999) and (round(num-ennmb)=0) then enon:=icount;
           icount:=icount+1;
         until icount=640;
         if (abs(yenmax-yenmin)>abs(yenmax)) or (abs(yenmax-yenmin)>abs(yenmin)) then
           encount:=((yenmax-0)*(479/(yenmax-yenmin)));
         horiz:=round(encount);
         vert:=round(enon);
         zoom:=0;
         goto Grap;
       end
       else textcurs:=textcurs+20;

       {COMPUTES EQUATION- RUNS THROUGH THE LOOP 640 TIMES GETTING EACH
       COORDINATE AND DERIVATIVE}

       i:='';
       zoom:=1;
       ennum:=1;
       outteXtXy(10,teXtcurs,'Please Wait... Computing');
       for icount:=0 to 640 do
          begin
           dcount:=dcount+1;
           num:=icount-320;
           str(640-icount,i);
           setcolor(15);
           outteXtXy(10,teXtcurs+25,i);
           compute(stuff,mine,num,icount,derv,dcount,opers,deter,ennum,nminer);
           setcolor(0);outteXtXy(10,teXtcurs+25,chr(219)+chr(219)+chr(219));setcolor(11);
         end;
       vert:=320;
       horiz:=240;

       {COMPUTE DERIVATIVE- TAKES THE DERIVATIVE ARRAY AND COMPUTES THE
       WHOLE DERIVATIVE FOR THE EQUATION AND PRINTS IT}
       dcomp(opers,derv,fderv,deter);
       setcolor(15);
       outteXtXy(75,150,'Derivative equals= '+fderv);


       outteXtXy(20,20,'ON GRAPH- To magnify and demagnify,  type + or -.');
       outteXtXy(20,40,'          I-shift up, K- shift down, J-shift left, L- shift right');
       outteXtXy(20,60,'          Press E to enter another equation');
       outtextxy(20,80,'          Press H for help!');
       outtextxy(20,100,'          Q- to Quit');
       i:=readkey;

       {GRAPHING AND ALLOWS THE USER TO ZOOM AND MOVE AROUND, OR TRACE THE GRAPH}
   Grap:

   setcolor(11);
    change:=1;
    hor:=0;
    ver:=0;
    trace:=0;
    onnum:=1;
   repeat
     begin
     tr:=0;
     over:=0;
      clearviewport;
      usegraph(change,horiz,vert);
      setcolor(11);
      gra(mine,change,hor,ver,zoom,tr,over);
      if zoom=0 then trac(trace,nminer,mine,onnum);
      user:=readkey;
      user:=upcase(user);
      if (user='L') and (zoom=0) then
            trace:=trace+1;
      if (user='J') and (zoom=0) then
            trace:=trace-1;
      if (user='F') and (zoom=0) then
             onnum:=0;
      if (user='O') and (zoom=0) then
             onnum:=1;

      if (user='I') and (zoom=1) then
        begin
          horiz:=horiz+change;
          hor:=hor+change;
        end;
      if (user='K') and (zoom=1) then
        begin
          horiz:=horiz-change;
          hor:=hor-change;
        end;
      if (user='L') and (zoom=1) then
        begin
          vert:=vert-change;
          ver:=ver+1
        end;
      if (user='J') and (zoom=1) then
        begin
          vert:=vert+change;
          ver:=ver-1;
        end;
      if (user='+') and (zoom=1) then
        begin
          vert:=320;
          horiz:=240;
          ver:=0;
          hor:=0;
          if change=8 then change:=10
          else if change=10 then change:=16
          else if change=16 then change:=20
          else if change=20 then change:=32
          else if change=32 then change:=40
          else if change=40 then change:=64
          else if change=64 then begin sound(2600);delay(100); nosound end
          else change:=change*2
        end;
      if (user='-') and (zoom=1)  then
        begin
          vert:=320;
          horiz:=240;
          ver:=0;
          hor:=0;
          if change=1 then begin sound(2600);delay(100); nosound end
          else if change=10 then change:=8
          else if change=16 then change:=10
          else if change=20 then change:=16
          else if change=32 then change:=20
          else if change=40 then change:=32
          else if change=64 then change:=40
          else change:=change div 2
        end;
      if user='E' then
        Goto Start;
      if user='H' then helpscreen;
     end;
   until user='Q';
Finish:  CloseGraph;
    end
  else
    WriteLn('Graphics error:',
            GraphErrorMsg(ErrCode));
end.



