%2020.06.22
%JYS
%circlefinder 

%% load file 
clear
[Filename Pathname]=uigetfile('*.tif','Select red images','MultiSelect','on');

%% rearrange filename
z=0;
for j=1:size(Filename,2)
    if Filename{1,j}(15:16)=='BF'
        z=z+1;
    end
end

zz=z;
for j=size(Filename,2)-z+1:size(Filename,2)
    Filename{2,zz}=Filename{1,j};
    zz=zz-1;        
end

zz=z+1;
for j=1:size(Filename,2)-z
    Filename{2,zz}=Filename{1,j};
    zz=zz+1;        
end
Filename(1,:)=Filename(2,:);
Filename(2,:)=[];

%% Before test 
 j=1
    Info=imfinfo([Pathname Filename{1,j}]);
% max projection 
         clear I_R_max_bf
    for i=1:length(Info)
         I_R_max_bf(:,:,i)=imread([Pathname Filename{1,j}],i);
    end 
    I_R_max_af=max(I_R_max_bf, [], 3);
    
    %circle finder 
circleFinder(histeq(I_R_max_af),[3 7])

%% Circle finder (find Radius) - before 
% center=[];radius=[];
% 첫 번째 조건만 잡아주기, 다음이미지부터 센터 선택 시 최대한 dendrite에서 먼쪽으로 센터 선택해 
for j=1:5
    Info=imfinfo([Pathname Filename{1,j}]);
% max projection
	clear I_R_max_bf
    for i=1:length(Info)
         I_R_max_bf(:,:,i)=imread([Pathname Filename{1,j}],i);
    end 
    I_R_max_af=max(I_R_max_bf, [], 3);
    
    %circle finder 
% circleFinder(histeq(I_R_max_af),[3 7])
[centers, radii, metric] = imfindcircles(histeq(I_R_max_af), [3 7], ...
   'Sensitivity', 0.85, ...
   'EdgeThreshold', 0.35, ...
   'Method', 'twostage', ...
   'ObjectPolarity', 'Bright');
%    'Sensitivity', 0.850, ...
%    'EdgeThreshold', 0.220, ...
if ~isempty(centers) && size(centers,1)==1
    center(j,1)=centers(1,1);
    center(j,2)=centers(1,2);
    radius(j,1)=radii;
end

% viscircles(centers, radii,'EdgeColor','b')
% if isempty(centers) || size(centers,1)~=1 || center(j,1)>mean(center(1:j,1))+std(center(1:j,1))/sqrt(length([Filename(1,1:j)])) || center(j,1)< mean(center(1:j,1))-std(center(1:j,1))/sqrt(length([Filename(1,1:j)])) || center(j,2)>mean(center(1:j,2))+std(center(1:j,2))/sqrt(length([Filename(1,1:j)])) || center(j,2)< mean(center(1:j,2))-std(center(1:j,2))/sqrt(length([Filename(1,1:j)])) 
% %     circleFinder(histeq(I_R_max_af),[5 10])
%     j
%     Filename{1,j}
%      figure(1) 
%     imshow(adapthisteq(I_R_max_af),'InitialMagnification','fit') 
% %     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
%     [x,y] = getpts; % choose the center of spine
%     close 
%     center(j,1)=x;
%     center(j,2)=y;
%     radius(j,1)=radius(j-1,1);

if isempty(centers) %||center(j,1)>mean(center(1:j,1))+std(center(1:j,1))/sqrt(length([Filename(1,1:j)])) || center(j,1)< mean(center(1:j,1))-std(center(1:j,1))/sqrt(length([Filename(1,1:j)])) || center(j,2)>mean(center(1:j,2))+std(center(1:j,2))/sqrt(length([Filename(1,1:j)])) || center(j,2)< mean(center(1:j,2))-std(center(1:j,2))/sqrt(length([Filename(1,1:j)])) 
    j
    Filename{1,j}
    3
     figure(1) 
    imshow(histeq(I_R_max_af),'InitialMagnification','fit') 
%     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    [x,y] = getpts; % choose the center of spine
    close 
    center(j,1)=x;
    center(j,2)=y;
    radius(j,1)=radius(j-1,1);
    
    
    %multiple points 
elseif size(centers,1)>1 
    centers_diff=[];
     Filename{1,j}
     1
         figure(1) 
        imshow(histeq(I_R_max_af),'InitialMagnification','fit') 
    %     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        [x,y] = getpts; % choose the center of spine
        close 
        center(j,1)=x;
        center(j,2)=y;
        
    for k=1:size(centers,1)
     centers_diff(k,1)=abs(center(j,1)-centers(k,1)); % x 
     centers_diff(k,2)=abs(center(j,2)-centers(k,2)); % y 
     centers_diff(k,3)=centers_diff(k,1)+centers_diff(k,2);
    end
    [dum n]=min(centers_diff(:,3));
    
    center(j,1)=centers(n,1);
    center(j,2)=centers(n,2);
    radius(j,1)=radii(n,1);
end



end


%% After- test 

j=6
    Info=imfinfo([Pathname Filename{1,j}]);
% max projection 
          clear I_R_max_bf
    for i=1:length(Info)
         I_R_max_bf(:,:,i)=imread([Pathname Filename{1,j}],i);
    end 
    I_R_max_af=max(I_R_max_bf, [], 3);
    
    %circle finder 
circleFinder(histeq(I_R_max_af),[5 10])

%% Circle finder (find Radius) - after
% 첫 번째 조건만 잡아주기 

for j=6:length(Filename)
    Info=imfinfo([Pathname Filename{1,j}]);
% max projection 
   clear I_R_max_bf
    for i=1:length(Info)
         I_R_max_bf(:,:,i)=imread([Pathname Filename{1,j}],i);
    end 
    I_R_max_af=max(I_R_max_bf, [], 3);
    
    %circle finder 
% circleFinder(histeq(I_R_max_af),[5 13])
[centers, radii, metric] = imfindcircles(histeq(I_R_max_af), [5 10], ...
   'Sensitivity', 0.85, ...
   'EdgeThreshold', 0.37, ...
   'Method', 'twostage', ...
   'ObjectPolarity', 'Bright');
%    'Sensitivity', 0.850, ...
%    'EdgeThreshold', 0.220, ...
if ~isempty(centers) && size(centers,1)==1
    center(j,1)=centers(1,1);
    center(j,2)=centers(1,2);
    radius(j,1)=radii;
end


% viscircles(centers, radii,'EdgeColor','b') %single or weired xy point  
if isempty(centers) 
%     circleFinder(histeq(I_R_max_af),[5 10])
    j
    1
    Filename{1,j}
     figure(1) 
    imshow(histeq(I_R_max_af),'InitialMagnification','fit') 
%     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    [x,y] = getpts; % choose the center of spine
    close 
    center(j,1)=x;
    center(j,2)=y;
    radius(j,1)=radius(j-1,1);
    
    
    %multiple points 
elseif size(centers,1)>1 
    2
    centers_diff=[];
    for k=1:size(centers,1)
     centers_diff(k,1)=abs(center(j-1,1)-centers(k,1)); % x 
     centers_diff(k,2)=abs(center(j-1,2)-centers(k,2)); % y 
     centers_diff(k,3)=centers_diff(k,1)+centers_diff(k,2);
    end
    [dum n]=min(centers_diff(:,3));
    
    center(j,1)=centers(n,1);
    center(j,2)=centers(n,2);
    radius(j,1)=radii(n,1);
    
        if center(j,1)>mean(center(1:j,1))+std(center(1:j,1))/sqrt(length([Filename(1,1:j)])) || center(j,1)< mean(center(1:j,1))-std(center(1:j,1))/sqrt(length([Filename(1,1:j)])) || center(j,2)>mean(center(1:j,2))+std(center(1:j,2))/sqrt(length([Filename(1,1:j)])) || center(j,2)< mean(center(1:j,2))-std(center(1:j,2))/sqrt(length([Filename(1,1:j)])) 
                    j
                    3
        Filename{1,j}
         figure(1) 
        imshow(histeq(I_R_max_af),'InitialMagnification','fit') 
    %     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        [x,y] = getpts; % choose the center of spine
        close 
        center(j,1)=x;
        center(j,2)=y;
%         radius(j,1)=radius(j-1,1);
        end


end

end


%% 

save('information_total.mat','radius','center')

%% 
for j=56:length(center)
    center(j,1)=center(j,1)+2; 
    center(j,2)=center(j,2)-2;
end

%% manual center 
  
for j=13%1:length(Filename)
Info=imfinfo([Pathname Filename{1,j}]);
% max projection 
         clear I_R_max_bf
    for i=7:9%1:length(Info)
         I_R_max_bf(:,:,i)=imread([Pathname Filename{1,j}],i);
    end 
    I_R_max_af=max(I_R_max_bf, [], 3);
    
 j
    Filename{1,j}
     figure(1) 
    imshow(histeq(I_R_max_af),'InitialMagnification','fit') 
%     set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    [x,y] = getpts; % choose the center of spine
    close 
    center(j,1)=x;
    center(j,2)=y;
end
