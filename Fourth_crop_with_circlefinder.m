% 2020.06.22
%JYS 
%% Load file 
clear
[Filename Pathname]=uigetfile('*.tif','Select red images','MultiSelect','on');
[m_Filename m_Pathname]=uigetfile('*.mat','Select information file .mat','MultiSelect','on');
load([m_Pathname m_Filename]);
mkdir(Pathname,'Crop_VolumeAnalysis')

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
%% crop and save 
mkdir(Pathname,'Crop_VolumeAnalysis')
crop_size=1.5;

for j=13%86:length(Filename)
        Info=imfinfo([Pathname Filename{1,j}]);
        for i=1:length(Info)
        clear I_crop
        I=imread([Pathname,char(Filename{1,j})],i);
        I_crop(:,:)=imcrop(I,[center(j,1)-mean(radius(:,1))*crop_size center(j,2)-mean(radius(:,1))*crop_size mean(radius(:,1))*2*crop_size mean(radius(:,1))*2*crop_size]);
%         imshow(adapthisteq(I_crop))
        imwrite(I_crop,[[Pathname,'Crop_VolumeAnalysis\'],'vol_',char(Filename{1,j})], 'Compression','none','WriteMode' , 'append');
        end
end


%% check spines with max projection
    

for j=1:length(Filename(1,:)) % each file
                Info=imfinfo([Pathname,'Crop_VolumeAnalysis\','vol_', Filename{1,j}]); % number of zstack 
                clear I_max_bf 
                for i=1:length(Info)
                     I_max_bf(:,:,i)=imread([Pathname,'Crop_VolumeAnalysis\','vol_', Filename{1,j}],i);
                end  
                    I_max_af=max(I_max_bf, [], 3);

                   figure(1)
                  subplot(round(sqrt(length(Filename))),round(sqrt(length(Filename))),j)
                   imshow(histeq(I_max_af))
                   title(sprintf('%s',num2str(j)))
                   hold on 

 end
        