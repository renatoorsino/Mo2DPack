PrismaticRevoluteJoint[
	body1_,
	node11_, 
	node12_, 
	body2_,
	node2_,
	force_:0,
	torque_:0]:=
Module[{bodyM,nodeM,bodyS,nodeS},

	(*Master and slave bodies*)
	If[body1<body2,bodyM=body1;bodyS=body2,bodyM=body2;bodyS=body1];
	If[node11<node12,nodeM=node11;nodeS=node12,nodeM=node12;nodeS=node11];

	(*Define new coordinate and new quasivelocity*)
	If[ValueQ[CoordinatesIndexes],{},CoordinatesIndexes={}];
	AppendTo[CoordinatesIndexes,
	{"P",bodyM,bodyS}];
	CoordinatesIndexes=DeleteDuplicates[CoordinatesIndexes];
	If[ValueQ[QuasivelocitiesIndexes],{},QuasivelocitiesIndexes={}];
	AppendTo[QuasivelocitiesIndexes,
	{"P",bodyM,bodyS}];
	QuasivelocitiesIndexes=DeleteDuplicates[QuasivelocitiesIndexes];

	(*Relating new coordinate with new quasivelocity*)
	If[ValueQ[QuasivelocitiesTransformations],0,QuasivelocitiesTransformations={}];
	AppendTo[QuasivelocitiesTransformations,#]&/@{Derivative[1][Subscript[q0,"P",bodyM,bodyS]][t]-Subscript[q1,"P",bodyM,bodyS][t]};
	QuasivelocitiesTransformations=DeleteDuplicates[QuasivelocitiesTransformations];
	QuasivelocitiesTransformations=DeleteCases[QuasivelocitiesTransformations,_Integer];

	(*Prismatic Joint constraint equations*)
	If[ValueQ[HolonomicConstraintEquations],0,HolonomicConstraintEquations={}];
	AppendTo[HolonomicConstraintEquations,#]&/@{Subscript[a,body1,nodeM,nodeS]Subscript[q0,"N",body2,2(node2-1)+1][t]-(Subscript[a,body1,nodeM,nodeS]-Subscript[q0,"P",bodyM,bodyS][t])Subscript[q0,"N",body1,2(nodeM-1)+1][t]-Subscript[q0,"P",bodyM,bodyS][t]Subscript[q0,"N",body1,2(nodeS-1)+1][t],Subscript[a,body1,nodeM,nodeS]Subscript[q0,"N",body2,2(node2-1)+2][t]-(Subscript[a,body1,nodeM,nodeS]-Subscript[q0,"P",bodyM,bodyS][t])Subscript[q0,"N",body1,2(nodeM-1)+2][t]-Subscript[q0,"P",bodyM,bodyS][t]Subscript[q0,"N",body1,2(nodeS-1)+2][t]};
	HolonomicConstraintEquations=DeleteDuplicates[HolonomicConstraintEquations];
	HolonomicConstraintEquations=DeleteCases[HolonomicConstraintEquations,_Integer];

	If[ValueQ[ConstraintEquations],0,ConstraintEquations={}];
	AppendTo[ConstraintEquations,#]&/@{(Subscript[q0,"N",body1,2(nodeM-1)+1][t]-Subscript[q0,"N",body1,2(nodeS-1)+1][t])Subscript[q1,"P",bodyM,bodyS][t]+Subscript[a,body1,nodeM,nodeS]Subscript[q1,"N",body2,2(node2-1)+1][t]-(Subscript[a,body1,nodeM,nodeS]-Subscript[q0,"P",bodyM,bodyS][t])Subscript[q1,"N",body1,2(nodeM-1)+1][t]-Subscript[q0,"P",bodyM,bodyS][t]Subscript[q1,"N",body1,2(nodeS-1)+1][t],(Subscript[q0,"N",body1,2(nodeM-1)+2][t]-Subscript[q0,"N",body1,2(nodeS-1)+2][t])Subscript[q1,"P",bodyM,bodyS][t]+Subscript[a,body1,nodeM,nodeS]Subscript[q1,"N",body2,2(node2-1)+2][t]-(Subscript[a,body1,nodeM,nodeS]-Subscript[q0,"P",bodyM,bodyS][t])Subscript[q1,"N",body1,2(nodeM-1)+2][t]-Subscript[q0,"P",bodyM,bodyS][t]Subscript[q1,"N",body1,2(nodeS-1)+2][t]};
	ConstraintEquations=DeleteDuplicates[ConstraintEquations];
	ConstraintEquations=DeleteCases[ConstraintEquations,_Integer];

	(*Generalized active and inertia forces associated to joint force*)
	Subscript[fa,"P",bodyM,bodyS][t]=Sign[node12-node11]force;
	Subscript[fi,"P",bodyM,bodyS][t]=0;

	If[TrueQ[torque==0],

	(*-TRUE-*)
	QuasivelocitiesIndexes=DeleteCases[QuasivelocitiesIndexes,{"R",bodyM,bodyS}];
	ConstraintEquations=DeleteCases[ConstraintEquations,Subscript[q1,"R",bodyM,bodyS][t]-(Subscript[q1,"B",bodyS,3][t]-Subscript[q1,"B",bodyM,3][t])];
	ConstraintEquations=DeleteCases[ConstraintEquations,_Integer];
	Quiet@If[ValueQ[Subscript[fa,"R",bodyM,bodyS][t]],Unset[Subscript[fa,"R",bodyM,bodyS][t]]];
	Quiet@If[ValueQ[Subscript[fi,"R",bodyM,bodyS][t]],Unset[Subscript[fi,"R",bodyM,bodyS][t]]];,

	(*-FALSE-*)
	(*Define new quasivelocity*)
	If[ValueQ[QuasivelocitiesIndexes],{},QuasivelocitiesIndexes={}];
	AppendTo[QuasivelocitiesIndexes,
	{"R",bodyM,bodyS}];
	QuasivelocitiesIndexes=DeleteDuplicates[QuasivelocitiesIndexes];

	(*Revolute Joint constraint equation*)
	If[ValueQ[ConstraintEquations],0,ConstraintEquations={}];
	AppendTo[ConstraintEquations,
	Subscript[q1,"R",bodyM,bodyS][t]-(Subscript[q1,"B",bodyS,3][t]-Subscript[q1,"B",bodyM,3][t])];
	ConstraintEquations=DeleteDuplicates[ConstraintEquations];
	ConstraintEquations=DeleteCases[ConstraintEquations,_Integer];

	(*Generalized active and inertia forces associated to joint torque*)
	Subscript[fa,"R",bodyM,bodyS][t]=Sign[body2-body1]torque;
	Subscript[fi,"R",bodyM,bodyS][t]=0;
	];
];