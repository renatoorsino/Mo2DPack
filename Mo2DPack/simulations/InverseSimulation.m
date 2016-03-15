InverseSimulation[
	SimulationLabel_,
	SimulationTime_,
	SimulationData_,
	InitialNodalCoordinates_,
	PrescribedCoordinatesIndexes_,
	PrescribedMotionsFunctions_,
	BaumgarteStabilizationConstants_,
	InverseSimulationUnknowns_,
	InverseDynamicsMethod_
	]:=
Module[{},

	Inner[(#1[t_]=#2[t])&,Subscript[q0,##,SimulationLabel]&@@@PrescribedCoordinatesIndexes,PrescribedMotionsFunctions,List];

	InitialCoordinates=Join[(InitialNodalCoordinates/.(Equal-> Rule)),Flatten@NSolve[Join[Flatten[((#==0)&/@(HolonomicConstraintEquations/.{t->0}))/.SimulationData/.(InitialNodalCoordinates/.(Equal-> Rule))],Flatten[(Subscript[a,##]>0)&@@@ParametersIndexes]],Join[Flatten@Complement[Coordinates[0],(#[[1]])&/@InitialNodalCoordinates],Subscript[a,##]&@@@ParametersIndexes]]];

	PrescribedCoordinatesReplace=Flatten[({(Subscript[q0,##][t_]->Subscript[q0,##,SimulationLabel][t]),(Subscript[q0,##]'[t_]->Subscript[q0,##,SimulationLabel]'[t]),
	(Subscript[q0,##]''[t_]->Subscript[q0,##,SimulationLabel]''[t])}&@@@PrescribedCoordinatesIndexes)];

	UnknownMotionVariables0=Join[Complement[Subscript[q0,##]'[0]&@@@VariableCoordinatesIndexes,Subscript[q0,##]'[0]&@@@PrescribedCoordinatesIndexes],Subscript[q1,##][0]&@@@VariableQuasivelocitiesIndexes];

	UnknownMotionVariables1=Join[Complement[Subscript[q0,##]&@@@VariableCoordinatesIndexes,Subscript[q0,##]&@@@PrescribedCoordinatesIndexes],Subscript[q1,##]&@@@VariableQuasivelocitiesIndexes];

	UnknownMotionVariables2=Join[Complement[Subscript[q0,##]&@@@VariableCoordinatesIndexes,Subscript[q0,##]&@@@PrescribedCoordinatesIndexes],Subscript[q1,##]&@@@VariableQuasivelocitiesIndexes,Subscript[q1,##]'&@@@VariableQuasivelocitiesIndexes];

	KinematicSimulationR1=Join[InitialCoordinates,Flatten@NSolve[Join[(#==0)&/@(ConstraintEquations),(#==0)&/@(QuasivelocitiesTransformations)]/.PrescribedCoordinatesReplace/.{t->0}/.SimulationData/.InitialCoordinates,UnknownMotionVariables0]];

	KinematicSimulationR2=Join[Flatten[({(Subscript[q0,##][t_]->Subscript[q0,##,SimulationLabel][t]),(Subscript[q0,##]'[t_]->D[Subscript[q0,##,SimulationLabel][t],t])}&@@@PrescribedCoordinatesIndexes)],
	Flatten[NDSolve[((Join[(#==0)&/@((D[ConstraintEquations,t]+BaumgarteStabilizationConstants[[1]]ConstraintEquations)/.InitialCoordinates),
	(#==0)&/@(QuasivelocitiesTransformations/.InitialCoordinates),(#==(#/.KinematicSimulationR1))&/@Join[Complement[Coordinates[0],Subscript[q0,##][0]&@@@PrescribedCoordinatesIndexes],Quasivelocities[0]]]/.SimulationData)/.PrescribedCoordinatesReplace),UnknownMotionVariables2,{t,0,SimulationTime}]//Quiet]];

	Inner[(#1[t_]=#2[t])&,UnknownMotionVariables1/.(Subscript[head_,indexes__]->Subscript[head,indexes,SimulationLabel] ),UnknownMotionVariables1/.KinematicSimulationR2,List];

	PrescribedMotionRules[t_]:=Join[(Subscript[q0,##]-> Subscript[q0,##,SimulationLabel][t])&@@@VariableCoordinatesIndexes,(Subscript[q1,##]-> Subscript[q1,##,SimulationLabel][t])&@@@VariableQuasivelocitiesIndexes,(Subscript[q1,##]'->(Subscript[q1,##]'[t]/.KinematicSimulationR2))&@@@VariableQuasivelocitiesIndexes,
	(#-> #[t])&/@InverseSimulationUnknowns];

	InverseDynamicsEquations[t_]:=(DynamicEquations[Join[PrescribedMotionRules[t],SimulationData,InitialCoordinates]]/.SimulationData/.InitialCoordinates);

	If[InverseDynamicsMethod[[1]]=="Continuous",
	DynamicSimulationR=NDSolve[Join[(#==0)&/@(InverseDynamicsEquations[t]),{foo'[t]==0,foo[0]==0}],Join[InverseSimulationUnknowns,{foo}],{t,0,SimulationTime},Method->{"IndexReduction"->{True,"ConstraintMethod"->"Projection"}}];
	Inner[(#1[t_]=#2[t])&,InverseSimulationUnknowns/.(Subscript[head_,indexes__]->Subscript[head,indexes,SimulationLabel] ),InverseSimulationUnknowns/.DynamicSimulationR,List];
	,0];

	If[InverseDynamicsMethod[[1]]=="Discrete",
	Module[{DiscreteInverseDynamicsSimulation,DiscreteTimeRange},
	DiscreteTimeRange=(SimulationTime Range[0,InverseDynamicsMethod[[2]]]/InverseDynamicsMethod[[2]]);(DiscreteInverseDynamicsSimulation[#]=Flatten[NSolve[InverseDynamicsEquations[#],(Function[var,var[#]]/@InverseSimulationUnknowns)]])&/@DiscreteTimeRange;
	Inner[(#1[t_]=
	Interpolation[Function[timevar,{timevar,(#2[timevar]/.DiscreteInverseDynamicsSimulation[timevar])}]/@DiscreteTimeRange][t])&,InverseSimulationUnknowns/.(Subscript[head_,indexes__]-> Subscript[head,indexes,SimulationLabel]),InverseSimulationUnknowns,List];];
	,0];

	Animation[t_]:=(Function[{var1,var2},Line[Join[Subscript[n,var1,#][t]&/@var2,{Subscript[n,var1,First[var2]][t]}]]]@@@(Reap[Sow[#2,{#1}]&@@@NodesIndexes,_,List][[2]]))/.((Subscript[q0,##][t]-> Subscript[q0,##,SimulationLabel][t])&@@@VariableCoordinatesIndexes);
];