{$mode objfpc}
{$COperators on}
uses windows,graph,wincrt;
const   g=5;
type    int = longint;
        TFirework = class
                private
                        x0,y0,x,y,a,t,v,cl:int;
                        IsMini:boolean;
                public
                        constructor Create(xx,yy,aa,tt,vv,c:int; mini:boolean);
                        procedure Hide();
                        procedure Show();
                        procedure Update();
                        function IsOutSide():boolean;
//                        function CreateMini():TFirework;
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
        x0:=xx; y0:=yy; a:=aa; t:=tt; v:=vv; cl:=c; IsMini:=mini;
end;
procedure TFirework.Hide();
begin
        SetFillStyle(1,0);
        SetColor(0);
        FillEllipse(getmaxx-x,getmaxy-y,3,3);
end;
procedure TFirework.Show();
begin
        SetFillStyle(1,cl);
        SetColor(cl);
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
procedure Init();
var     gn,gm:smallint;
begin
        gn:=detect;
        gm:=0;
        InitGraph(gn,gm,'');
        ClearViewPort();
        SetWindowText(GraphWindow,'Firework by leduykhongngu');
end;
procedure Meo();
var     tmp:array[1..15] of TFirework;
        i,j:int;
begin
        for j:=1 to 15 do
                tmp[j]:=TFirework.create(ran(10,getmaxx-10),0,ran(70,120),0,ran(75,81),j,false);
        repeat
                for j:=1 to 15 do begin;
                        tmp[j].hide();
                        if (tmp[j].IsOutSide) then continue
                        else begin
                                tmp[j].update();
                                tmp[j].show();
                        end;
                end;
                delay(30);
        until keypressed;
end;
begin
        randomize();
        Init();
        Meo();
        CloseGraph();
end.
