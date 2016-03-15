SetOptions[Plot,BaseStyle->{FontFamily->"Arial",FontSize->16}];
SetOptions[Plot3D,BaseStyle->{FontFamily->"Arial",FontSize->14}];
SetOptions[ParametricPlot,BaseStyle->{FontFamily->"Arial",FontSize->16}];
SetOptions[ParametricPlot3D,BaseStyle->{FontFamily->"Arial",FontSize->14}];
SetOptions[ListPlot,BaseStyle->{FontFamily->"Arial",FontSize->16}];
Style8={{Hue[0.6,1,1],Thickness[0.005]},{Hue[0.3,1,1],Thickness[0.006],Dashed},{Hue[1,1,1],Thickness[0.007],Dotted},{Hue[0.1,1,1],Thickness[0.005]},{Hue[0.9,1,1],Thickness[0.006],Dashed},{Hue[0.5,1,1],Thickness[0.007],Dotted},{Hue[0.2,1,1],Thickness[0.005]},{Hue[0.8,1,1],Thickness[0.006],Dashed}};

SPlot=Module[{st=Style8},TableForm[{Plot[#1,#2,PlotStyle->Style8,PlotRange->Full,Frame->True,FrameLabel->#3,PlotLabel->#4,GridLines->Automatic,ImageSize->1.15 {500,300}],Graphics[{Black,Directive[FontFamily->"Arial",FontSize->16],MapIndexed[Text[#1,{10(First[#2]-1)+6,0}]&,#5],MapIndexed[Join[Last[st=RotateLeft@st],{Line[{{10(First[#2]-1),0},{10(First[#2]-1)+3,0}}]}]&,#5]},ImageSize->1.15 {500,30}]}]]&;
