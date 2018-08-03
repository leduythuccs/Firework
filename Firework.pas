{$mode objfpc}
{$COperators on}
uses windows,graph,wincrt,gvector;
const   g=5;
type    int = longint;
        TFirework = class
                private
                        x0,y0,x,y,a,t,v,cl,lim:int;
                        IsMini:boolean;
                public
                        constructor Create(xx,yy,aa,tt,vv,c:int; mini:boolean);
                        procedure Show();
                        procedure Update();
                        function IsOutSide():boolean;
                        function IsHighest():boolean;
                        function CreateMini():TFirework;
        end;
        Tmyvector= specialize Tvector<TFirework>;
function ran(l,r:int):int;
begin
        exit(l+random(r-l+1));
end;
function ToRadian(a:int):real;
begin
        exit(a*pi/180);
end;
constructor TFirework.Create(xx,yy,aa,tt,vv,c:int; mini:boolean);
begin
        x:=xx; y:=yy;
        x0:=xx; y0:=yy; a:=aa; t:=tt; v:=vv; cl:=c; IsMini:=mini;
        lim:=round(v*sin(ToRadian(a))/g);
end;
procedure TFirework.Show();
begin
        SetFillStyle(1,cl);
        SetColor(cl);
        if IsMini then
                PutPixel(getmaxx-x,getmaxy-y,cl)
        else
                FillEllipse(getmaxx-x,getmaxy-y,3,3);
end;
procedure TFirework.Update();
var     tmp:real;
begin
        inc(t);
        tmp:=t/1.5;
        x:=x0+round(v*cos(ToRadian(a))*tmp);
        y:=y0+round(v*sin(ToRadian(a))*tmp-0.5*g*tmp*tmp);
end;
function TFirework.IsOutSide():boolean;
begin
        exit((x<0) or (y<0) or (x>GetMaxX) or (y>GetMaxY));
end;
function TFirework.IsHighest():boolean;
begin
        exit(t>lim);
end;
function TFirework.CreateMini():TFirework;
begin
        result:=TFirework.Create(ran(x-100,x+100),ran(y-100,y+100),ran(a-10,a+10),ran(0,5),30,cl,true);
end;
procedure Init();
var     gn,gm:smallint;
begin
        gn:=detect;
        gm:=0;
        InitGraph(gn,gm,'');
        ClearViewPort();
        SetWindowText(GraphWindow,'Firework by leduykhongngu');
end;
var     tmp,mini:Tmyvector;
procedure Meo();
var
        i,j:int;
begin
        tmp:=Tmyvector.create();
        mini:=Tmyvector.create();
        for j:=1 to 5 do
                tmp.pushback(TFirework.create(ran(10,getmaxx-10),0,ran(70,120),0,ran(75,81),ran(10,14),false));
        repeat
                for j:=tmp.size-1 downto 0 do begin;
                        if (tmp[j].IsOutSide) then begin
                                tmp[j]:=TFirework.create(ran(10,getmaxx-10),0,ran(70,120),0,ran(75,81),ran(10,14),false);
                                continue;
                        end
                        else begin
                                if (tmp[j].x=-1) then continue;
                                tmp[j].update();
                                if (not tmp[j].IsHighest) then
                                        tmp[j].show()
                                else begin
                                        for i:=1 to 200 do
                                                mini.pushback(tmp[j].CreateMini());
                                        tmp[j].x:=-1;

                                end;
                        end;
                end;
                for j:=mini.size-1 downto 0 do begin
                        if (Mini[j].IsOutSide()) then begin
                                mini.erase(j);
                                continue
                        end
                        else begin
                                Mini[j].update();
                                Mini[j].show();
                        end;
                end;
                if (mini.size=0) then
                delay(30)
                else delay(20);
                clearviewport();
        until keypressed;
end;
begin
        randomize();
        Init();
        Meo();
        CloseGraph();
end.

