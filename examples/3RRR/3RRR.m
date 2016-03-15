SetDirectory["/Users/renatoorsino/PPGEM-USP/Packages/Mo2DPack/"]
<<setup.m
SetDirectory["/Users/renatoorsino/PPGEM-USP/Packages/Mo2DPack/examples/3RRR"]

Initialize[]
RigidBody[0, 3, {{1, 1}, {0, 0}}, 0, 0]
RigidBody[1, 4, {{1, 2}, {0, 0}}, Subscript[m, 1], Subscript[\[CapitalIota], 1]]
RigidBody[2, 2, {{1, 2}, {1/2, 0}}, Subscript[m, 2], Subscript[\[CapitalIota], 2]]
RigidBody[3, 2, {{1, 2}, {1/2, 0}}, Subscript[m, 2], Subscript[\[CapitalIota], 2]]
RigidBody[4, 2, {{1, 2}, {1/2, 0}}, Subscript[m, 2], Subscript[\[CapitalIota], 2]]
RigidBody[5, 2, {{1, 2}, {0, 0}}, Subscript[m, 3], Subscript[\[CapitalIota], 3]]
RigidBody[6, 2, {{1, 2}, {0, 0}}, Subscript[m, 3], Subscript[\[CapitalIota], 3]]
RigidBody[7, 2, {{1, 2}, {0, 0}}, Subscript[m, 3], Subscript[\[CapitalIota], 3]]
BaseBody[0, {
  Subscript[q0, "N", 0, 1] == 3, 
  Subscript[q0, "N", 0, 2] == 0, 
  Subscript[q0, "N", 0, 3] == -(3/2), 
  Subscript[q0, "N", 0, 4] == (3 Sqrt[3])/2, 
  Subscript[q0, "N", 0, 5] == -(3/2), 
  Subscript[q0, "N", 0, 6] == -((3 Sqrt[3])/2)
  }]
RevoluteJoint[0, 1, 5, 1, Subscript[u, 1][t]]
RevoluteJoint[0, 2, 6, 1, Subscript[u, 2][t]]
RevoluteJoint[0, 3, 7, 1, Subscript[u, 3][t]]
RevoluteJoint[1, 2, 2, 1, 0]
RevoluteJoint[1, 3, 3, 1, 0]
RevoluteJoint[1, 4, 4, 1, 0]
RevoluteJoint[2, 2, 5, 2, 0]
RevoluteJoint[3, 2, 6, 2, 0]
RevoluteJoint[4, 2, 7, 2, 0]
AddCoordinate[
  Subscript[q0, 1][t], 
  Subscript[q0, 1]'[t] - Subscript[q1, "B", 1, 3][t]
  ]
VariableReduction[]
DynamicModel[]


Subscript[T,"SI"] = 16.0;
ParametersList = {
	g -> 9.8, 
	Subscript[m, 1] -> 1., 
	Subscript[\[CapitalIota], 1] -> 0.25, 
	Subscript[m, 2] -> 0.5 , 
	Subscript[\[CapitalIota], 2] -> 1./6, 
	Subscript[m, 3] -> 0.5, 
	Subscript[\[CapitalIota], 3] -> 2./3
	};
InitialConditions = {
	Subscript[q0, "N", 1, 1][0] == 0, 
	Subscript[q0, "N", 1, 2][0] == 0, 
	Subscript[q0, "N", 1, 3][0] == 1, 
	Subscript[q0, "N", 1, 4][0] == 0, 
	Subscript[q0, "N", 2, 3][0] == 2, 
	Subscript[q0, "N", 2, 4][0] == Sqrt[3], 
	Subscript[q0, "N", 1, 5][0] == -(1/2), 
	Subscript[q0, "N", 1, 6][0] == Sqrt[3]/2, 
	Subscript[q0, "N", 3, 3][0] == -(5/2), 
	Subscript[q0, "N", 3, 4][0] == Sqrt[3]/2, 
	Subscript[q0, "N", 1, 7][0] == -(1/2), 
	Subscript[q0, "N", 1, 8][0] == -(Sqrt[3]/2), 
	Subscript[q0, "N", 4, 3][0] == 1/2, 
	Subscript[q0, "N", 4, 4][0] == -((3 Sqrt[3])/2),
	Subscript[q0, 1][0] == 0
	};
InverseSimulation[
	"SI", 
	Subscript[T,"SI"], 
	ParametersList, 
	InitialConditions, 
	{{"N", 1, 1}, {"N", 1, 2}, {1}}, 
	{-1 Sin[\[Pi]/2 #] &, 1 Sin[\[Pi]/4 #] &, \[Pi]/6 Sin[\[Pi]/4 #]^4 &}, 
	{1, 1}, 
	{Subscript[u, 1], Subscript[u, 2], Subscript[u, 3]}, 
	{"Discrete", 500}
	]
AnimationS1[t_] = Animation[t];


SP[1, 1] = SPlot[
	Subscript[q0, "N", 1, 3, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[\!\(\*SuperscriptBox[\(q\), \(\[LeftAngleBracket]0 \[RightAngleBracket]\)]\), \(N, 1, 3, SI\)]\) (m)"}, 
	"", 
	{}
	];
SP[1, 2] = SPlot[
	Subscript[q0, "N", 1, 4, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[\!\(\*SuperscriptBox[\(q\), \(\[LeftAngleBracket]0 \[RightAngleBracket]\)]\), \(N, 1, 4, SI\)]\) (m)"}, 
	"", 
	{}
	];	
SP[1, 3] = SPlot[
	Subscript[q0, "N", 2, 3, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[\!\(\*SuperscriptBox[\(q\), \(\[LeftAngleBracket]0 \[RightAngleBracket]\)]\), \(N, 2, 3, SI\)]\) (m)"}, 
	"", 
	{}
	];
SP[1, 4] = SPlot[
	Subscript[q1, "R", 0, 7, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[\!\(\*SuperscriptBox[\(q\), \(\[LeftAngleBracket]1 \[RightAngleBracket]\)]\), \(R, 0, 7, SI\)]\) (rad/s)"}, 
	"", 
	{}
	];
SP[1, 5] = SPlot[
	Subscript[q0, 1, "SI"][t]/Degree, 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[\!\(\*SuperscriptBox[\(q\), \(\[LeftAngleBracket]0 \[RightAngleBracket]\)]\), \(1, SI\)]\) (deg)"}, 
	"", 
	{}
	];
SP[1, 6] = SPlot[
	Subscript[u, 1, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[u, \(1, SI\)]\) (N.m)"}, 
	"Torque provided by actuator 1", 
	{}
	];				
SP[1, 7] = SPlot[
	Subscript[u, 2, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[u, \(2, SI\)]\) (N.m)"}, 
	"Torque provided by actuator 2", 
	{}
	];
SP[1, 8] = SPlot[
	Subscript[u, 3, "SI"][t], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\!\(\*SubscriptBox[u, \(3, SI\)]\) (N.m)"}, 
	"Torque provided by actuator 3", 
	{}
	];
SP[1, 9] = SPlot[
	Norm[D[ConstraintEquations, t] /. InitialCoordinates /. KinematicSimulationR2], 
	{t, 0, Subscript[T,"SI"]}, 
	{"t (s)", "\[LeftDoubleBracketingBar] \!\(\*SuperscriptBox[OverscriptBox[\(q\), \(_\)], \(\[LeftAngleBracket]2\[RightAngleBracket]\)]\)\!\(\*SubscriptBox[\(\[RightDoubleBracketingBar]\), \(SI\)]\)"}, 
  	"Violation of the second order constraint invariants", 
  	{}
  	];
SP[1, 10] = Graphics[{Blue, Thick, AnimationS1[4.]}, PlotRange -> {{-4, +6}, {-4.5, 4.5}}]; 
Export["fig060204I" <> ToString[#] <> ".png", SP[1, #], ImageResolution -> 288] & /@ Range[10] 	
