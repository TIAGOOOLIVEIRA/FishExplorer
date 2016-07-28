% batch
tic
isFullData = 1;
data_masterdir = GetCurrentDataDir();

const_ClusGroup = 2;
const_Cluster = 1; % This is all cells
M_fishset = GetFishStimset();
M_stimrange = GetStimRange();

range_fish =  5:18; % range_fish = GetFishRange();

%% custom params here:
numK1 = 20;
isWkmeans = false;
isMakeFoxels = false;
masterthres = 0.7;
clusParams = struct('merge',masterthres,'cap',masterthres,'reg1',masterthres,...
    'reg2',masterthres,'minSize',10,'k1',numK1);

%%   Loop 1

% for i = 1:length(range_fish),
%     i_fish = range_fish(i);
%     %disp(i_fish);
%
%     LoadFullFish(hfig,i_fish,isFullData);
%     absIX = getappdata(hfig,'absIX');
%
%     %% Cluster indexing
%     i_ClusGroup = const_ClusGroup;% M_ClusGroup(i);
%     i_Cluster = const_ClusGroup;% M_Cluster(i);
%     [cIX_load,gIX] = LoadCluster_Direct(i_fish,i_ClusGroup,i_Cluster,absIX);
%
%     %% partitions for CV
%     timelists = getappdata(hfig,'timelists');
%     timelists_names = getappdata(hfig,'timelists_names');
%     periods = getappdata(hfig,'periods');
%
%     M_stim = M_stimrange{i_fish};
%
%     timelistsCV_raw = cell(length(M_stim),2);
%     timelistsCV = cell(1,2);
%
%     for k_stim = 1:length(M_stim), % :3
%         i_stim = M_stim(k_stim);
%         TL = timelists{i_stim};
%         period = periods(i_stim);
%         nrep = size(TL,2)/periods(i_stim); % integer
%         n = floor(nrep/2);
%         if n>0,
%             timelistsCV_raw{k_stim,1} = TL(1):TL(n*period);
%             timelistsCV_raw{k_stim,2} = TL(1+n*period):TL(2*n*period);
%         else % for spont, only one period
%             halfperiod = floor(period/2);
%             timelistsCV_raw{k_stim,1} = TL(1):TL(halfperiod);
%             timelistsCV_raw{k_stim,2} = TL(1+halfperiod):TL(2*halfperiod);
%         end
%     end
%     timelistsCV{1} = horzcat(timelistsCV_raw{:,1});
%     timelistsCV{2} = horzcat(timelistsCV_raw{:,2});
%
%     %%
%     for k = 1:2,% CV halves
%         tIX = timelistsCV{k};
%         M = GetTimeIndexedData_Default_Direct(hfig,cIX_load,tIX);
%         M_0 = GetTimeIndexedData_Default_Direct(hfig,[],tIX,'isAllCells');
%
%         gIX = Kmeans_Direct(M,numK1);
%
% %         % save
% %         name = ['k20_defS_CV' num2str(k)];
% %         clusgroupID = 4;
% %         clusIDoverride = k; %Saved in Group5, Clusters 1%2
% %         SaveCluster_Direct(cIX_load,gIX,absIX,i_fish,name,clusgroupID,clusIDoverride);
%
%         % ------custom code here---------
%         [cIX,gIX] = MakeFoxels(cIX_load,gIX,M_0,isWkmeans,clusParams);
%         [cIX,gIX] = AutoClustering(cIX,gIX,M_0,isWkmeans,clusParams,absIX,i_fish,isMakeFoxels);
%
%         % save cluster
%         name = ['Auto_defS_M0.7_CV' num2str(k)];
%         clusgroupID = 4;
%         clusIDoverride = 4+k;
%         SaveCluster_Direct(cIX,gIX,absIX,i_fish,name,clusgroupID,clusIDoverride);
%
%     end
% end
%
% SaveVARwithBackup();

%%
M_regthres = {0.7,0.5};
M_place = {1,2,3,1};
M_stimname = {'4x4','PT','OMR','defS'};
%%
for i_count = 1,%%%%%%%%%
    masterthres = M_regthres{i_count};
    clusParams = struct('merge',masterthres,'cap',masterthres,'reg1',masterthres,...
        'reg2',masterthres,'minSize',10,'k1',numK1);
    
    for i_stim = 1:4,
        if i_stim == 1,
            M_stimrange = GetStimRange('5');
        elseif i_stim == 2,
            M_stimrange = GetStimRange('P');
        elseif i_stim == 3,
            M_stimrange = GetStimRange('O');
        elseif i_stim == 4,
            M_stimrange = GetStimRange('M');
        end
        
        for i = 1:length(range_fish),
            i_fish = range_fish(i);
            disp(i_fish);
            
            % check this loop
            stimrange = M_stimrange{i_fish};
            if isempty(stimrange),
                continue;
            end
            
            % Load fish
            LoadFullFish(hfig,i_fish,isFullData);
            
            %% 1.
            % setup
            absIX = getappdata(hfig,'absIX');
            fishset = M_fishset(i_fish);
            %     i_count = 1;
            i_ClusGroup = 2;
            i_Cluster = 1;
            
            %             timelists = getappdata(hfig,'timelists');
            
            % Load cluster data
            [cIX_load,gIX] = LoadCluster_Direct(i_fish,i_ClusGroup,i_Cluster,absIX);
            
            
            %% partitions for CV
            timelists = getappdata(hfig,'timelists');
            timelists_names = getappdata(hfig,'timelists_names');
            periods = getappdata(hfig,'periods');
            
            M_stim = M_stimrange{i_fish};
            
            timelistsCV_raw = cell(length(M_stim),2);
            timelistsCV = cell(1,2);
            
            for k_stim = 1:length(M_stim), % :3
                i_stim = M_stim(k_stim);
                TL = timelists{i_stim};
                period = periods(i_stim);
                nrep = size(TL,2)/periods(i_stim); % integer
                n = floor(nrep/2);
                if n>0,
                    timelistsCV_raw{k_stim,1} = TL(1):TL(n*period);
                    timelistsCV_raw{k_stim,2} = TL(1+n*period):TL(2*n*period);
                else % for spont, only one period
                    halfperiod = floor(period/2);
                    timelistsCV_raw{k_stim,1} = TL(1):TL(halfperiod);
                    timelistsCV_raw{k_stim,2} = TL(1+halfperiod):TL(2*halfperiod);
                end
            end
            timelistsCV{1} = horzcat(timelistsCV_raw{:,1});
            timelistsCV{2} = horzcat(timelistsCV_raw{:,2});
            
            %%
            for k = 1:2,% CV halves
                tIX = timelistsCV{k};
                M = GetTimeIndexedData_Default_Direct(hfig,cIX_load,tIX);
                M_0 = GetTimeIndexedData_Default_Direct(hfig,[],tIX,'isAllCells');
                
                gIX = Kmeans_Direct(M,numK1);
                
                %         % save
                %         name = ['k20_defS_CV' num2str(k)];
                %         clusgroupID = 4;
                %         clusIDoverride = k; %Saved in Group5, Clusters 1%2
                %         SaveCluster_Direct(cIX_load,gIX,absIX,i_fish,name,clusgroupID,clusIDoverride);
                
                % ------custom code here---------
                [cIX,gIX] = MakeFoxels(cIX_load,gIX,M_0,isWkmeans,clusParams);
                [cIX,gIX] = AutoClustering(cIX,gIX,M_0,isWkmeans,clusParams,absIX,i_fish,isMakeFoxels);
                
                % save cluster
                name = ['Auto_',M_stimname{i_stim},'_M',num2str(masterthres),'_CV',num2str(k)];
                clusgroupID = 3+k; % 4 and 5
                clusIDoverride = M_place{i_stim};
                SaveCluster_Direct(cIX,gIX,absIX,i_fish,name,clusgroupID,clusIDoverride);
            end
        end
    end
    SaveVARwithBackup();
end
SaveVARwithBackup();

