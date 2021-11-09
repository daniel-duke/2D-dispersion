function [D0,D1,D2,D3,D4,D5,D6] = partition_UC_matrices(Nod_dof,N_node,D)
% Purpose: Partition matricess into block matrices beloning to each of the
% nodes and sides in the unit cells
% ----------------------------------------------
% Input:
% Nod_dof: number of degrees of freedom per node
% N_node: number of nodes
% D: Matrix to be paritioned
% ----------------------------------------------
% Output:
% D0, D1, D2, D3, D4, D5, D6: Partitioned block matrices

% Insert indexes map here
% 4---t---3
% |       |
% l   m   r
% |       |
% 1---b---2
i1 = 1:Nod_dof;
i2 = Nod_dof*N_node-[Nod_dof-1:-1:0];
i3 = Nod_dof*N_node^2-[Nod_dof-1:-1:0];
i4 = Nod_dof*N_node*(N_node-1)+[1:1:Nod_dof];
ib = i1+1:i2-1;
it = i4+1:i3-1;
il = reshape([Nod_dof*N_node:N_node*Nod_dof:...
    Nod_dof*(N_node-1)^2]+ [1:Nod_dof]',...
    [1,Nod_dof*(N_node-2)]);
ir = reshape([Nod_dof*2*N_node:N_node*Nod_dof:...
    Nod_dof*N_node*(N_node-1)]+ [0:Nod_dof-1]',...
    [1,Nod_dof*(N_node-2)]);
im=[];
for ico = 1:length(il)
    im = [im il(ico)+1:ir(ico)-1];
end
red_dof = length(i1) + length(ib) + length(il) + length(im);

% Indexes of the master degrees of freedom in the reduced matrix
D0 = zeros(red_dof); 
D1 = D0; D2 = D0; D3 = D0; D4 = D0; D5 = D0; D6 = D0;
i1_s = 1; i1_e = length(i1);
ib_s = i1_e+1; ib_e = ib_s+length(ib)-1;
il_s = ib_e+1; il_e = il_s + length(il)-1;
im_s = il_e+1; im_e = im_s+length(im)-1;



D0(i1_s:i1_e,im_s:im_e) = D(i3,im);
%
D1(i1_s:i1_e,il_s:im_e) =  [D(i4,il)+D(i3,ir) D(i4,im)];
D1(ib_s:ib_e,im_s:im_e) =  D(it,im);
%
D2(i1_s:i1_e,ib_s:ib_e) = D(i3,it)+D(i2,ib);
D2(i1_s:i1_e,im_s:im_e) = D(i2,im);
D2(il_s:il_e,im_s:im_e) = D(ir,im);
%
D3(i1_s:i1_e,:)=[D(i1,i1)+D(i2,i2)+D(i3,i3)+D(i4,i4) D(i1,ib)+D(i4,it) ...
    D(i1,il)+D(i2,ir) D(i1,im)];
D3(ib_s:ib_e,i1_s:ib_e) = [D(ib,i1)+D(it,i4) D(ib,ib)+D(it,it)];
D3(ib_s:ib_e, im_s:im_e) = D(ib,im);
D3(il_s:il_e,i1_s:i1_e) = D(il,i1)+D(ir,i2);
D3(il_s:il_e,il_s:im_e) = [D(il,il)+D(ir,ir) D(il,im)];
D3(im_s:im_e,:) = [D(im,i1) D(im,ib) D(im,il) D(im,im)];
%
D4(ib_s:ib_e,i1_s:i1_e) = D(it,i3)+D(ib,i2);
D4(im_s:im_e,i1_s:i1_e) = D(im,i2);
D4(im_s:im_e, il_s:il_e) = D(im,ir);
%
D5(il_s:il_e,i1_s:i1_e) = D(il,i4)+D(ir,i3);
D5(im_s:im_e,i1_e:ib_e) = [D(im,i4) D(im,it)];
%
D6(im_s:im_e,i1_s:i1_e) = D(i3,im);
end
