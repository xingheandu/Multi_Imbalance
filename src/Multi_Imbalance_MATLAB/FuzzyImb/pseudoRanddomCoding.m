% Reference:	
% Name: pseudoRanddomCoding.m
% 
% Authors: Chongsheng Zhang <chongsheng DOT Zhang AT yahoo DOT com>
% 
% Copyright: (c) 2018 Chongsheng Zhang <chongsheng DOT Zhang AT yahoo DOT com>
% 
% This file is a part of Multi_Imbalance software, a software package for multi-class Imbalance learning. 
% 
% Multi_Imbalance software is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License 
% as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
%
% Multi_Imbalance software is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License along with this program. 
% If not, see <http://www.gnu.org/licenses/>.

function ECOC_Matrix=pseudoRanddomCoding(N_classes,columns,zero_prob)

classes=1:N_classes;
if length(classes) < 5, iterations=1000; else iterations=5000; end;

max_min_pair_distance=0;
for iterations_count=1:iterations;

  ECOCs=zeros([length(classes) columns]);
  for z=1:columns
    satistified_condition=0;
    while satistified_condition==0; % generate ECOC one column until satisfy 2 criteria
      if zero_prob==0
        tmp=floor(2*rand(length(classes),1));
        tmp2=tmp==0;
        tmp(tmp2)=-1;
        ECOCs(:,z)=tmp;
      elseif zero_prob==0.5,
        ECOCs(:,z)=round(2*rand(length(classes),1)-1);
      elseif zero_prob==1/3,
        ECOCs(:,z)=floor(3*rand(length(classes),1)-1);
      end

      % first, suppose that the column (dichotomizer) is a good column! then check 2 critera
      % 1st criterion: each column had to have at least one +1 and one -1 value
      % 2nd criterion: each column and its negative should not be the same as its previous coulmns
      satistified_condition=1;
      if (sum(ECOCs(:,z)==1)==0 || sum(ECOCs(:,z)==-1)==0), % if
        satistified_condition=0;
      else
        for u=1:z-1
          if ECOCs(:,z)==ECOCs(:,u), satistified_condition=0; end;
          if ECOCs(:,z)==-ECOCs(:,u), satistified_condition=0; end;
        end
      end
    end

  end
  counter=0;
  min_pair_distan=1000;

  for j=1:length(classes)-1
    for k=j+1:length(classes)
      pair_distance=0.5 * sum((1-(ECOCs(j,:).* ECOCs(k,:))) .*  abs (ECOCs(j,:).* ECOCs(k,:)));
      %pair_distance=0.5 * sum(1-(ECOCs(j,:).* ECOCs(k,:)));
      %pair_distance=sum(abs((ECOCs(j,:)-ECOCs(k,:)).*ECOCs(k,:).*ECOCs(j,:)))/2;
      counter=counter+1;
      %pair_distances(counter)=pair_distance;
      if pair_distance < min_pair_distan
        min_pair_distan = pair_distance;
      end
    end
  end

  if min_pair_distan > max_min_pair_distance
    max_min_pair_distance=min_pair_distan;
    ECOC_Matrix=ECOCs;
  end

end
end

