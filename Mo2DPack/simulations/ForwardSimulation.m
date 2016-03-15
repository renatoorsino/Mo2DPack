ForwardSimulation[
	SimulationLabel_,
	SimulationTime_,
	SimulationData_,
	InitialNodalStates_,
	BaumgarteStabilizationConstants_
	]:=
Module[{},
		
	InitialStates=Join[(InitialNodalStates/.(Equal-> Rule)),Flatten@NSolve[Join[Flatten[((#==0)&/@(HolonomicConstraintEquations/.{t->0}))/.SimulationData/.(InitialNodalStates/.(Equal-> Rule))],Flatten[(Subscript[a,##]>0)&@@@ParametersIndexes],Flatten[((#==0)&/@(ConstraintEquations/.{t->0}))/.SimulationData/.(InitialNodalStates/.(Equal-> Rule))],Flatten[((#==0)&/@(QuasivelocitiesTransformations/.{t->0}))/.SimulationData/.(InitialNodalStates/.(Equal-> Rule))]],Join[Flatten@Complement[Join[Coordinates[0],Coordinates'[0],Quasivelocities[0]],(#[[1]])&/@InitialNodalStates],Subscript[a,##]&@@@ParametersIndexes]]];

	UnknownStateVariables=Join[Subscript[q0,##]&@@@VariableCoordinatesIndexes,Subscript[q1,##]&@@@VariableQuasivelocitiesIndexes];

	MotionRules[t_]:=Join[(Subscript[q0,##]-> Subscript[q0,##][t])&@@@VariableCoordinatesIndexes,(Subscript[q1,##]-> Subscript[q1,##][t])&@@@VariableQuasivelocitiesIndexes,(Subscript[q1,##]'->Subscript[q1,##]'[t])&@@@VariableQuasivelocitiesIndexes];

	ForwardDynamicsEquations[t_]:=Join[(#==0)&/@(DynamicEquations[MotionRules[t]]/.SimulationData/.InitialStates),(#==0)&/@((D[ConstraintEquations,t]+BaumgarteStabilizationConstants[[1]]ConstraintEquations)/.SimulationData/.InitialStates),(#==0)&/@(QuasivelocitiesTransformations/.SimulationData/.InitialStates),((#==(#/.InitialStates))&/@Join[Coordinates[0],Quasivelocities[0]]/.SimulationData)];

	ForwardDynamicSimulationR=Flatten@NDSolve[(ForwardDynamicsEquations[t]),UnknownStateVariables,{t,0,SimulationTime}]//Quiet;

	Inner[(#1[t_]=#2[t])&,UnknownStateVariables/.(Subscript[head_,indexes__]->Subscript[head,indexes,SimulationLabel] ),UnknownStateVariables/.ForwardDynamicSimulationR,List];

	ForwardDynamicsAnimation[t_]:=(Function[{var1,var2},Line[Subscript[n,var1,#][t]&/@var2]]@@@(Reap[Sow[#2,{#1}]&@@@NodesIndexes,_,List][[2]]))/.((Subscript[q0,##][t]-> Subscript[q0,##,SimulationLabel][t])&@@@VariableCoordinatesIndexes);
];