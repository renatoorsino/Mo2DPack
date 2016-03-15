BaseBody[
	bodyidnumber_, 
	nodalcoordinates_
	]:=
Block[{nodeid},
	(nodeid=#;
	If[NumericQ[#],0,#[t_]=0]&/@{(*Subscript[q0,"N",bodyidnumber,2(nodeid-1)+1],
	Subscript[q0,"N",bodyidnumber,2(nodeid-1)+2],*)
	Subscript[q1,"N",bodyidnumber,2(nodeid-1)+1],
	Subscript[q1,"N",bodyidnumber,2(nodeid-1)+2]};
	If[NumericQ[#],0,#[t_]=(0.+(#/.(nodalcoordinates/.(Equal-> Rule))))]&/@{Subscript[q0,"N",bodyidnumber,2(nodeid-1)+1],
	Subscript[q0,"N",bodyidnumber,2(nodeid-1)+2]};
	)&/@(Flatten@Reap[Sow[#2,#1]&@@@NodesIndexes,bodyidnumber][[2]]);
	Subscript[q1,"B",bodyidnumber,3][t]=0;
];

