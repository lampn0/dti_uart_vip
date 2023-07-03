module uart_receiver
#(
  parameter SYS_FREQ        = 50000000                   ,
  parameter BAUD_RATE       = 9600                       ,
  parameter SAMPLE          = 16                         ,
  parameter CLOCK           = SYS_FREQ/(BAUD_RATE)       ,
  parameter BAUD_DV         = SYS_FREQ/(SAMPLE*BAUD_RATE),
  parameter DATA_SIZE       = 8                          ,
  parameter BIT_COUNT_SIZE  = $clog2(DATA_SIZE+1)        
)(
  input                      clk        ,    // Clock
  input                      reset_n    ,  // Asynchronous reset active low
  input                      rx         ,
  output reg [DATA_SIZE-1:0] dout       ,
  output reg                 recv_req   ,
  input                      recv_ack   
);
`protected

    MTI!#[VpJRo}vlX2DoX~kRH=T5-';>[aJ7ml,=3Q>wS,?m<N@sQ+FQ+GOseVV3^Wlz@$#}?\*f1H
    K{}a}5j7*n0f-V=YCsnV}G#>u1p7'mB>AD{xu{4}e3YN@aDn7,7z&kRlK2A-^TxkuYGKl|#Reoks
    m~Z1!vXxI*{$kCA\{,Q']Ekj]ik<Av}#3+)=GpYZ{3\61EunU5[[!nZR}m~*QY~Y=VwJl+IaBZ;G
    C<Z~!BTn-X{s<S;x1io!]^giUsBzzVewE{_5io2jn>2rBj'X1Z7jlQ{vr3l5]=VT57>GCR^wjrBE
    ^?vZYROs{+!Z$_Wa$x[.Fk{GOY^a{Xw3$1irm'lD\&QBkz:xRu1pOR+q7mvj'7l^7B5E1[*<Hz[<
    JEX=@'Ws5o7rwT,5}I5X=z?Ou1'ntI{lI*AlKlu7k#+r7\H{]Iz[^JqY~=RC'BmlY3~Yk=<E_!77
    3RD~DnH@BHBc\3Q#X5>,;5Q3QRjvA*+^)'@B}yAXX2G;o+0OW**EiYE5AV=zkm[D~ee[no[,3}<$
    ,<BB_iui>+KG'kUUVr;+Rk$/~=jCE#>Rxu!5Q{GZH]m~T]J+W_<O7mQ[CkY2-'$wxG5aB'oOD$xQ
    awosDDk#sx21]\[;1}<A-]i-r<Ixo*pmwo7#a5I<H[#p,J;\Nf$>[}&-^]i)5AT[mG@HFY#,\oi}
    R,HEY=s;azsH<!\YoJ}#vw*Yit7j-#j*=B|vvOIHCjVA>K[GIcQ{57H}GvuzZkeD=CxlD,f*~B!<
    <OvZ^(lA!#VcU^~{Y+}}I>Ez3}@{*Vxn1n1O_D'TrauY21}BDZeR$>W;IiRwkH}r\i<^1;BJ7!W+
    HG#3ZRK!OjK5'C@j^Bw'T7I-E}>lVU$$_]'!;s;n[_v$vWE$[Up3\A1oI<3YK51l-CrKYQeUx!7a
    rGJ1I$$R->Ql}@1_I?a[WsQ^@\x{53nVwXI[")UY+VYC'[;wv~I!lG]rZ\?E>ajelEEGYR?C7s&-
    *O]4K{-r-z5mjo5!CRTo^vkU[l,eUBv-3T_\-.]I^}Z*#^rvY!|,TXnCWs7_RV\^OeGe]2@}YU<T
    TDWlvaO5v~r1_C'K,+!2]~xgoaK}*;sOEex12$RR([CRsVuvD#IUTiV-e\mYnD'1sGGj'[UuVa*<
    pI]!OSf,>!pE!nsG^+sA[slGY+7_WE+kVQX}Z^JE55_X,B<UG}x'D>pav*3CeXY:e]wwVIX,$m@H
    azTG@sV;BZ}]pmRk\Y]u$raH6Y~2JyIrzGenzXEq-C~D-GoR]m[-2jZ$~>eabXp~{!*x7pEv<nB3
    @_\[G[*R\>{sDW7A]]e^1R5n3J^;}A7n[o7JmUlpJp>A~VUBRY$FpKDONCCjI7n[E9~wwOU=[1EV
    !7kj7oA<7,soJjQ,$Y'w->I4\_*]@QY-\pT$=U!kK+zBPxU2AVx\$VXpX1ne\Jv1ee#ua's<OE5a
    =k$l~CC;'Q5=x,_O=7'i}[BD@pYK?p}CGU,*eGp#;lwU_EjD,}\@lD@<\Oz7;DAQIH*}Kzwo3k>u
    e7xiC1,R[exGQl_=\A=ZzR3{#>5j3E}#V/pEplzxnBX\Hl!aUBX-U3V}=pQ$!3=-1m:{5W-Cwo2B
    z[!1QioC2_u}iJCJw@Q=VIuL_Uv@*e?wlJDv3G{-+>W@r!_Shl2UKZ*HD
`endprotected
