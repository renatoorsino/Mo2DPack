AddQuasivelocity[
	xNewQV_,
	xNewActiveForce_:0,
	xNewInertiaForce_:0
	]:=
Module[{newindex=(xNewQV/.{Subscript[q1, indexes__][t]-> indexes})},

	(*Define new quasivelocities*)
	If[ValueQ[QuasivelocitiesIndexes],{},QuasivelocitiesIndexes={}];
	AppendTo[QuasivelocitiesIndexes,{newindex}];
	QuasivelocitiesIndexes=DeleteDuplicates[QuasivelocitiesIndexes];

	Subscript[fa,newindex][t]=xNewActiveForce;
	Subscript[fi,newindex][t]=xNewInertiaForce;
];