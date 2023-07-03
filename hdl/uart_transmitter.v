module uart_transmitter
#(
  parameter SYS_FREQ        = 50000000                   ,
  parameter BAUD_RATE       = 9600                       ,
  parameter SAMPLE          = 16                         ,
  parameter CLOCK           = SYS_FREQ/(BAUD_RATE)       ,
  parameter BAUD_DV         = SYS_FREQ/(SAMPLE*BAUD_RATE),
  parameter DATA_SIZE       = 8,
  parameter BIT_COUNT_SIZE  = $clog2(DATA_SIZE+1)
)(
  input                      clk     ,    // Clock
  input                      reset_n ,  // Asynchronous reset active low
  input      [DATA_SIZE-1:0] din     ,
  output                     tx      ,
  input                      send_req,
  output reg                 send_ack
);
`protected

    MTI!#[4_~,;belep<x%u$^Z^l';>[aJ7moJ=3Q>wS"**pXoOCTm'$,B1}#[ZBUYnO^2Xl[E~Z@3=
    aU$^+K\=DQnSG^O#21C=Kv,]nna#+v;^4jBXE'o?OSQxuU+wo7>XwFvKop2=kTXHAs7~~JAGXYi]
    A2tKD>IWXKGoK7*[o7#7DY]mEvX;$@k>n<>=Vz+JBK]Ww\[o;-mLzYVi1#*pYCRTr>'Wkal=f'Xm
    ?*I<jeB'G7VDuj7<}pK$TsuA^Y2~2=>@}q+<C,)Jn~Xp?V_P[#JEY';,p\5sZIBB+[-uEr3v*]o<
    j3,RN#<jpK\,$<R?Kd^CirCokKy7O0lH1Rkww1VR;\+,,>3]QTquA1}zz3-SN:-{mp&T*s~]e\jV
    CKw5I2;O,K7Q\3?T[#H.j1#;av1amVQ+'uO,"XQCzslwv'E2$:E^!$Q*z2Oz$'7;7_mriK^+KB]W
    've?2e]2JTzETB2-}G=#oJF>Q;3]U5lXY,[EB5^rBYw/IQ!!rDnQ|o_AO0aj#K7?Q\s+{m+DX\%g
    Z}rp"le[n2j7v8"[F>U[zQ^Oux3ew*!'1mn\rG_!^m]]@Es$Jr\vv<v2\UrknzQ5@K&7@lWw^x#I
    $D[_!vK;a^UBx$5l,}abV|[25x\vARt03e*!7T<!p!\vzY~p'm<$7A1#TXoAL3'jVN1?nnVer^G_
    p}Y_2{HV!seB,#ei}~9^@@\osBvrxk3$a_$a[~A\5ijaEsYp]V7cuA}iP>nn7xX-YXnClx5lUx<7
    K7kXB3evOskT$,<2A1LZDWY*UYo.JnEYv~wQ1B~A8r>->3xk#0K5Yx=;,~dWRR$OV1[B?7#C2!KT
    Q@}r?mVq[7Z@f~H-lx;{5r;;s7E{Tx+_uUQx31-JDHEK3li-2]W,TGJ_{avx-iA\-A-O7pTej<rO
    {2AYvspeJV<*J+e@a2XZrjR\D['jK3OE=2a$nBusATl-U}?Yc2CB~Y_;[E?vR"lcG@m5WY;pekC<
    5ZzDAjK5YkVsBpn<<-IGj+JooG1oBroK9Q"eBr]}a>H?oi;z_JRzW3EG!vT}Ijx]=nsBx'nZ,H#p
    Z>o^[<'d>wlRB?n{{rm71O,QK}RJ_T'usxuYGu}{tw}U<3o<B'am3pXHKr}1Y-V3V$BQ]1_12pUY
    GAC=YAoXwxCmEol[_!*~+x+ZKOom]G2mo<RAa@7i^mT$-nRT?~H!p;Y!{I}*nfz{+j[+u*kxmmc~
    'n{5{A['[}kZpO12s2m27X*AouDF;A2VK_]3]xZTI?;aHa+j-aV*a$E7X}J$q=jrBsh=Q~2GA*Ql
    JEm+5XJR@Yi?YQ}Gse^UYJwOapDUl7CA_RjV^m2}C+OBZm+x>r5Q;Q*BD~7k$[<5HOK]2![IE\7<
    ]aJa$nY7+'-neZGG~zE-]Z!^[@XEAnT=Kw-GA'pf+ATaIC^w,1$u*IQ$@{Vx-t]*g=2\J3-p~K<
`endprotected

