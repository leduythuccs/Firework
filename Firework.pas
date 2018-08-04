{$mode objfpc}
{$COperators on}
uses    wingraph,wincrt,gvector;
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
var
        pal:PaletteType;
procedure InitColor();
begin
      GetNamesPalette(pal);
end;
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
        x0:=xx; y0:=yy; a:=aa; t:=tt; v:=vv; if (mini) then cl:=c else cl:=pal.colors[c]; IsMini:=mini;
        lim:=round(v*sin(ToRadian(a))/g)*3;
end;
procedure TFirework.Show();
begin
        if IsMini then begin
                PutPixel(getmaxx-x-1,getmaxy-y,cl);
                PutPixel(getmaxx-x,getmaxy-y-1,cl);
                PutPixel(getmaxx-x+1,getmaxy-y,cl);
                PutPixel(getmaxx-x,getmaxy-y+1,cl);
                PutPixel(getmaxx-x,getmaxy-y,cl);
        end
        else begin
                SetFillStyle(1,cl);
                SetColor(cl);
                FillEllipse(getmaxx-x,getmaxy-y,3,3);
        end;
end;
procedure TFirework.Update();
var     tmp:real;
begin
        inc(t);
        tmp:=t/3;
        x:=x0+round(v*cos(ToRadian(a))*tmp);
        y:=y0+round(v*sin(ToRadian(a))*tmp-0.5*g*tmp*tmp);
end;
function TFirework.IsOutSide():boolean;
begin
        exit((x<0) or (y<0)) //or (x>GetMaxX) or (y>GetMaxY));
end;
function TFirework.IsHighest():boolean;
begin
        exit(t>lim);
end;
function TFirework.CreateMini():TFirework;
begin
        result:=TFirework.Create(x,y,ran(1,360),0,ran(0,30),cl,true);
end;
procedure Init();
var     gd,gm:smallint;
begin
//        setwindowSize(1360,704);
        gd:=nopalette; gm:=mFullscr;
        InitGraph(gd,gm,'Firework by leduykhongngu');
        ClearViewPort();
//        SetWindowText(GraphWindow,'Firework by leduykhongngu');
end;
var     tmp,mini:Tmyvector;
procedure Meo();
var
        i,j:int;
        cur:TFirework;
begin
        tmp:=Tmyvector.create();
        mini:=Tmyvector.create();
        for j:=1 to 5 do
                tmp.pushback(TFirework.create(ran(10,getmaxx-10),0,ran(80,100),0,ran(80,85),ran(0,255),false));
        repeat
                for j:=tmp.size-1 downto 0 do begin;
                        if (tmp[j].IsOutSide) then begin
                                tmp[j]:=TFirework.create(ran(10,getmaxx-10),0,ran(80,100),0,ran(80,85),ran(0,255),false);
                                continue;
                        end
                        else begin
                                if (tmp[j].x=-1) then continue;
                                tmp[j].update();
                                tmp[j].show();

                                if (not tmp[j].IsHighest) then
                                        tmp[j].show()
                                else begin
                                        for i:=1 to 150 do begin
                                                cur:=tmp[j].CreateMini();
                                                mini.pushback(cur);
                                        end;
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
                writeln(mini.size()*5);
                if (mini.size<=0) then
                delay(30)
                else delay(5);
                clearviewport();
        until keypressed or CloseGraphRequest();
end;
var     i:int;
begin
        randomize();
        Init();
        InitColor();
        Meo();
        CloseGraph();
end.
