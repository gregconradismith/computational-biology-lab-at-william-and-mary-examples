function [] = parameter_search()

%system(['rm -rf data']);
dir = ['data_' datestr(now,30)];

system(['mkdir ' dir ]);

ntrial = 10;
for i=1:ntrial
    par = 100*rand;
    myjob(par,dir);   
end

return

function myjob(par,dir)

      x = exprnd(par,1,1000);
      hist(x,50);
      title(['\mu = ' sprintf('%06.2f',par)])
      print([ dir '/figure' sprintf('%06.2f',par) '.eps'],'-deps')
return

% dirname = 'data';
% %system(['rm -rf ' dirname]);
% %system(['mkdir ' dirname]);
% filename = [ dirname '/network_results_n=' num2str(N) ];
% system(['rm -rf ' filename]);
% system(['rm -rf ' filename '_craciun*' ]);
% 
% if verbose, diary(filename); end
% 
% if sample == 0
%     model_indices = 1:nmodel;
% else
%     model_indices = unidrnd(nmodel,1,sample);
% end
% 
% for i=1:length(model_indices)
%     disp(' ');
%     disp([' *** ']);
%     disp([' *** Working on ' num2str(i) ' of ' num2str(length(model_indices)) ...
%         ', model index ' num2str(model_indices(i)) ]);
%     disp([' *** ']);
%     
%     [ Network ] = make_network(N,NetworkMatrices{model_indices(i)}.Dimer, ...
%         NetworkMatrices{model_indices(i)}.MonBind, ...
%         NetworkMatrices{model_indices(i)}.DimBind);
% 
%     if verbose
%         disp(' ')
%         disp('Dimer')
%         disp(Network.Dimer)
% 
%         disp('MonBind')
%         disp(Network.MonBind)
% 
%         disp('DimBind')
%         disp(Network.DimBind)
% 
%         if 0 % choose whether or not to display the following matrices
%             disp('StoichMinus')
%             disp(Network.StoichMinus)
% 
%             disp('StoichPlus')
%             disp(Network.StoichPlus)
% 
%             disp('Complex')
%             disp(Network.Complex)
% 
%             disp('ReactionMinus')
%             disp(Network.ReactionMinus)
% 
%             disp('ReactionPlus')
%             disp(Network.ReactionPlus)
% 
%             disp('Reversible')
%             disp(Network.Reversible)
%         end
% 
%         disp('Species')
%         for j = 1:Network.ns
%             disp([num2str(j) ': ' Network.species{j}])
%         end
%         disp(' ')
% 
%         disp('Complexes')
%         for j = 1:Network.nc
%             disp([num2str(j) ': ' Network.complex{j}])
%         end
%         disp(' ')
% 
%         disp('Reactions')
%         for j = 1:Network.nr
%             cm = find(Network.ReactionMinus(:,j)==1);
%             cp = find(Network.ReactionPlus(:,j)==1);
%             if Network.Reversible(j) == 0
%                 disp([ Network.complex{cm} ' > ' Network.complex{cp} ])
%             elseif Network.Reversible(j) == 1
%                 disp([ Network.complex{cm} ' <> ' Network.complex{cp} ])
%             end
%         end
%         disp(' ')
% 
%         disp('Reactions Numerical')
%         for j = 1:Network.nr
%             if Network.Reversible(j) == 0
%                 disp([ '(' num2str(find(Network.ReactionMinus(:,j)==1)) ') > (' num2str(find(Network.ReactionPlus(:,j)==1)) ')' ])
%             elseif Network.Reversible(j) == 1
%                 disp([ '(' num2str(find(Network.ReactionMinus(:,j)==1)) ') <> (' num2str(find(Network.ReactionPlus(:,j)==1)) ')' ])
%             end
%         end
%         disp(' ')
% 
%         disp('Reactions Craciun-style (w/o rxns involving 0)')
%         for j = 1:Network.nr
%             cm = find(Network.ReactionMinus(:,j)==1);
%             cp = find(Network.ReactionPlus(:,j)==1);
%             if Network.Reversible(j) == 0
%                 if strcmp(Network.complex{cm},'0')~=1 && strcmp(Network.complex{cp},'0')~=1
%                     disp([ Network.complex{cm} ' > ' Network.complex{cp} ]);
%                 end
%             elseif Network.Reversible(j) == 1
%                 disp([ Network.complex{cm} ' <> ' Network.complex{cp} ]);
%             end
%         end
%         disp(' ')
%     end
% 
%     if craciun % choose whether to run Craciun code
%         
%         disp('Result from Craciun code')
%         thisfilename = [ filename '_craciun_index=' sprintf('%06.0f',i) '_model=' sprintf('%06.0f',model_indices(i)) '.dat'];
%         fid = fopen(thisfilename,'wt');
%         fprintf(fid,'%s\n',['% ' thisfilename ]);
% 
%         % producing required input file for Craciun code
%         for j = 1:Network.nr
%             cm = find(Network.ReactionMinus(:,j)==1);
%             cp = find(Network.ReactionPlus(:,j)==1);
%             if Network.Reversible(j) == 0
%                 if strcmp(Network.complex{cm},'0')~=1 && strcmp(Network.complex{cp},'0')~=1
%                     fprintf(fid,'%s\n',[ Network.complex{cm} ' > ' Network.complex{cp} ]);
%                 end
%             elseif Network.Reversible(j) == 1
%                 fprintf(fid,'%s\n',[ Network.complex{cm} ' <> ' Network.complex{cp} ]);
%             end
%         end
%         fclose(fid);
% 
%         % runing Craciun's code
%         [ numNegativeMonomials multEqFound ] = read_network(thisfilename);
% 
%         % adding results to Network
%         Network.numNegativeMonomials = numNegativeMonomials;
%         disp(['Number of negative momomials: ' num2str(numNegativeMonomials)])
% 
%         Network.multEqFound = multEqFound;
%         disp(['Multiple equilibria found (0=no, 1=yes): ' num2str(multEqFound)])
%     end
% 
%     NetworkResults{i} = Network;
%     
%     if craciun, save([filename '_tmp'],'NetworkResults'); end
% end
% 
% if verbose, diary off; end
% 
% save(filename,'NetworkResults')
% 
% return
% 
