function [D0,D1,D2,D3,D4,D5,D6,D7,D8] = reduce_partition_DS_matrix(Nod_dof,N_node,D)
% Purpose: Partition matrices into block matrices belonging to each of the
% nodes and sides in the unit cells
% ----------------------------------------------
% Input:
% Nod_dof: number of degrees of freedom per node
% N_node: number of nodes
% D: Matrix to be paritioned
% ----------------------------------------------
% Output:
% D_red: reduced dynamic stiffness matrix

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
ib = i1(end)+1:i2(1)-1;
it = i4(end)+1:i3(1)-1;
il = reshape([Nod_dof*N_node:N_node*Nod_dof:...
    Nod_dof*(N_node-1)^2]+ [1:Nod_dof]',...
    [1,Nod_dof*(N_node-2)]);
ir = reshape([Nod_dof*2*N_node:N_node*Nod_dof:...
    Nod_dof*N_node*(N_node-1)]+ [0:Nod_dof-1]',...
    [1,Nod_dof*(N_node-2)])-(Nod_dof-1);
im=[];
for ico = Nod_dof:Nod_dof:length(il)
    im = [im il(ico)+1:ir(ico)-Nod_dof];
end

% Reordering D to prepare it for condensation
n = size(D,1)-length(im); 
m = length(im); 
ind_ord = [i1 i2 i3 i4 ib it il ir im]; 
D_full = D(ind_ord, ind_ord);
ind_n = 1:n; 
ind_m = n+1:n+m; 

% Dynamic condensation of the middle degrees of freedom
D=D_full(ind_n,ind_n)-(D_full(ind_m,ind_n)).'*inv(D_full(ind_m,ind_m))...
    *D_full(ind_m,ind_n);
D = full(D);
% Indexes in new condensed matrix
i1 = 1:length(i1);
i2 = i1(end)+1:i1(end)+length(i2);
i3 = i2(end)+1:i2(end)+length(i3);
i4 = i3(end)+1:i3(end)+length(i4);

if ~isempty(ib) && ~isempty(it) && ~isempty(il) && ~isempty(ir)
    ib = i4(end)+1:i4(end)+length(ib);
    it = ib(end)+1:ib(end)+length(it);
    il = it(end)+1:it(end)+length(il);
    ir = il(end)+1:il(end)+length(ir);
    mid_indic = 1; % set to 0 if there are no middle nodes
end


% Partitioning the dynamic stiffness matrix
red_dof = length(i1) + length(ib) + length(il);

% Indexes of the master degrees of freedom in the reduced matrix
D0 = zeros(red_dof); 
D1 = D0; D2 = D0; D3 = D0; D4 = D0; D5 = D0; D6 = D0; D7 = D0; D8 = D0;
i1_s = 1; i1_e = length(i1);
ib_s = i1_e+1; ib_e = i1_e+length(ib);
il_s = ib_e+1; il_e = ib_e+length(il);

% Arranging the polynomial EVP
D0(i1_s:i1_e,:) = [D(i3,i1) D(i3,ib) D(i3,il)];
%
D1(i1_s:i1_e,:) =  [D(i4,i1)+D(i3,i2) D(i4,ib) D(i4,il)+D(i3,ir)]; 
D1(ib_s:ib_e,:) =  [D(it,i1) D(it,ib) D(it,il)];
%
D2(i1_s:i1_e,:) = [D(i2,i1)+D(i3,i4) D(i3,it)+D(i2,ib) D(i2,il)];
D2(il_s:il_e,:) = [D(ir,i1) D(ir,ib) D(ir,il)];
%
D3=[D(i1,i1)+D(i2,i2)+D(i3,i3)+D(i4,i4) D(i1,ib)+D(i4,it) D(i1,il)+D(i2,ir);...
    D(ib,i1)+D(it,i4) D(ib,ib)+D(it,it) D(ib,il);...
    D(il,i1)+D(ir,i2) D(il,ib) D(il,il)+D(ir,ir)];
D3 = 1/2*(D3 + D3'); % symmtrize D3 to avoid rounding errors or machine errors or whatever
%
D4 = D2';
%
D5 = D1'; 
%
D6 = D0';
%
D7(i1_s:ib_e,i1_s:i1_e) = [D(i4,i2); D(it,i2)];
D7(i1_s:ib_e,il_s:il_e) = [D(i4,ir); D(it,ir)];

%
D8 = D7';
end
