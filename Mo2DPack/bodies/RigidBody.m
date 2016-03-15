RigidBody[ 
	xBodyId_,
	xNoNodes_,
	xCenterOfMassData_,
	xMass_, 
	xMomentOfInertia_,
	xGravity_:{0,0},
	xForceSystem_:{0,0,0}
	] := 
Module[{},

	(*Define new body*)
	If[ValueQ[BodiesIndexes],{},BodiesIndexes={}];
	AppendTo[BodiesIndexes,xBodyId];
	BodiesIndexes=DeleteDuplicates[BodiesIndexes];

	(*Define new nodes*)
	If[ValueQ[NodesIndexes],{},NodesIndexes={}];
	AppendTo[NodesIndexes,{xBodyId,#}]&/@Range[xNoNodes];
	NodesIndexes=DeleteDuplicates[NodesIndexes];
	(Subscript[n,xBodyId,#]=Function[{t},{Subscript[q0,"N",xBodyId,2(#-1)+1][t],Subscript[q0,"N",xBodyId,2(#-1)+2][t]}])&/@Range[xNoNodes];

	(*Define new coordinates and new quasivelocities*)
	If[ValueQ[CoordinatesIndexes],{},CoordinatesIndexes={}];
	AppendTo[CoordinatesIndexes,
	{"N",xBodyId,#}]&/@Range[2 xNoNodes];
	CoordinatesIndexes=DeleteDuplicates[CoordinatesIndexes];
	If[ValueQ[QuasivelocitiesIndexes],{},QuasivelocitiesIndexes={}];
	AppendTo[QuasivelocitiesIndexes,
	{"N",xBodyId,#}]&/@Range[2 xNoNodes];
	AppendTo[QuasivelocitiesIndexes,
	{"B",xBodyId,#}]&/@{3};
	QuasivelocitiesIndexes=DeleteDuplicates[QuasivelocitiesIndexes];

	(*Relating new coordinate with new quasivelocity*)
	If[ValueQ[QuasivelocitiesTransformations],0,QuasivelocitiesTransformations={}];
	AppendTo[QuasivelocitiesTransformations,Derivative[1][Subscript[q0,"N",xBodyId,#]][t]-Subscript[q1,"N",xBodyId,#][t]]&/@Range[2 xNoNodes];
	QuasivelocitiesTransformations=DeleteDuplicates[QuasivelocitiesTransformations];
	QuasivelocitiesTransformations=DeleteCases[QuasivelocitiesTransformations,_Integer];

	(*Rigid Body holonomic constraint equations*)
	If[ValueQ[HolonomicConstraintEquations],0,HolonomicConstraintEquations={}];
	AppendTo[HolonomicConstraintEquations,(Subscript[a,xBodyId,#1,#2])^2-(Subscript[q0,"N",xBodyId,2(#2-1)+1][t]-Subscript[q0,"N",xBodyId,2(#1-1)+1][t])^2-(Subscript[q0,"N",xBodyId,2(#2-1)+2][t]-Subscript[q0,"N",xBodyId,2(#1-1)+2][t])^2]&@@@DeleteCases[Flatten[Outer[If[#1< #2,{#1,#2},0]&,#,#]&@Range[xNoNodes],1],0];
	HolonomicConstraintEquations=DeleteDuplicates[HolonomicConstraintEquations];
	HolonomicConstraintEquations=DeleteCases[HolonomicConstraintEquations,_Integer];

	If[ValueQ[ParameterReplace],0,ParameterReplace={}];
	AppendTo[ParameterReplace,((Subscript[q0,"N",xBodyId,2(#2-1)+1][t]-Subscript[q0,"N",xBodyId,2(#1-1)+1][t])^2+(Subscript[q0,"N",xBodyId,2(#2-1)+2][t]-Subscript[q0,"N",xBodyId,2(#1-1)+2][t])^2)-> (Subscript[a,xBodyId,#1,#2])^2]&@@@DeleteCases[Flatten[Outer[If[#1< #2,{#1,#2},0]&,#,#]&@Range[xNoNodes],1],0];
	ParameterReplace=DeleteDuplicates[ParameterReplace];
	ParameterReplace=DeleteCases[ParameterReplace,_Integer->_];

	(*Rigid Body constraint equations*)
	If[ValueQ[ConstraintEquations],0,ConstraintEquations={}];
	AppendTo[ConstraintEquations,#]&/@Flatten[{Subscript[q1,"N",xBodyId,2(#-1)+1][t],Subscript[q1,"N",xBodyId,2(#-1)+2][t],0}-{Subscript[q1,"N",xBodyId,1][t],Subscript[q1,"N",xBodyId,2][t],0}-{0,0,Subscript[q1,"B",xBodyId,3][t]}\[Cross]({Subscript[q0,"N",xBodyId,2(#-1)+1][t],Subscript[q0,"N",xBodyId,2(#-1)+2][t],0}-{Subscript[q0,"N",xBodyId,1][t],Subscript[q0,"N",xBodyId,2][t],0})&/@Range[2,xNoNodes]];
	ConstraintEquations=DeleteDuplicates[ConstraintEquations];
	ConstraintEquations=DeleteCases[ConstraintEquations,_Integer];

	(*Generalized active and inertia forces*)
	Module[{node1=xCenterOfMassData[[1,1]],node2=xCenterOfMassData[[1,2]],a1=xCenterOfMassData[[2,1]],a2=xCenterOfMassData[[2,2]],centerofxMassvelocity,gx=xGravity[[1]],gy=xGravity[[2]],fx=xForceSystem[[1]],fy=xForceSystem[[2]],tz=xForceSystem[[3]]},

	centerofxMassvelocity=Delete[(1-a1){Subscript[q1,"N",xBodyId,2(node1-1)+1][t],Subscript[q1,"N",xBodyId,2(node1-1)+2][t],0}+a1{Subscript[q1,"N",xBodyId,2(node2-1)+1][t],Subscript[q1,"N",xBodyId,2(node2-1)+2][t],0}+a2 {0,0,1}\[Cross]({Subscript[q1,"N",xBodyId,2(node2-1)+1][t],Subscript[q1,"N",xBodyId,2(node2-1)+2][t],0}-{Subscript[q1,"N",xBodyId,2(node1-1)+1][t],Subscript[q1,"N",xBodyId,2(node1-1)+2][t],0}),3];

	If[NumericQ[Subscript[q1,"N",xBodyId,#][t]],0,
	(Subscript[fa,"N",xBodyId,#][t]=FullSimplify[{fx+xMass gx,fy+xMass gy}.D[centerofxMassvelocity,Subscript[q1,"N",xBodyId,#][t]]]);
	(Subscript[fi,"N",xBodyId,#][t]=FullSimplify[-xMass D[centerofxMassvelocity,t].D[centerofxMassvelocity,Subscript[q1,"N",xBodyId,#][t]]])]&/@{2(node1-1)+1,2(node1-1)+2,2(node2-1)+1,2(node2-1)+2};

	If[NumericQ[Subscript[q1,"N",xBodyId,#][t]],0,
	(Subscript[fa,"N",xBodyId,#][t]=0);
	(Subscript[fi,"N",xBodyId,#][t]=0)]&/@Complement[Range[2 xNoNodes],{2(node1-1)+1,2(node1-1)+2,2(node2-1)+1,2(node2-1)+2}];

	If[NumericQ[Subscript[q1,"B",xBodyId,3][t]],0,
	Subscript[fa,"B",xBodyId,3][t]=tz;
	Subscript[fi,"B",xBodyId,3][t]=-xMomentOfInertia D[Subscript[q1,"B",xBodyId,3][t],t]];
	];
	
];
