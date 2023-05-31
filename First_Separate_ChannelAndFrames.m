% First 
% 2020.06.17 
%make image as [Green(zstacks) - Red (zstacks)]* frames 
%choose z_stack, SaveFolder 
%% Before 

clear
z_stack=13;
[Filename Pathname]=uigetfile('*.tif','Select before cropped z stack spine images for every frames,','MultiSelect','on');
Info=imfinfo([Pathname Filename]);
SaveFolder='D:\Research\Project\uncaging\20200221_SpineVolumeAnalysis\Data\20200703\1\1';
FN=length(Info)/z_stack; % frame number 
Name=textscan(char(SaveFolder),'%1s');

for i=1:FN/2
    for j=1:z_stack
    G(:,:)=imread([Pathname Filename],2*(i-1)*z_stack+j);
    R(:,:)=imread([Pathname Filename],2*(i-1)*z_stack+z_stack+j);
%   imwrite(G,[SaveFolder,'\',Name{1,1}{60:67,1},'_',Name{1,1}{69,1},'_',Name{1,1}{71,1},'_',Name{1,1}{73,1},'_AF_-',num2str(i),'min_G.tif'], 'Compression','none','WriteMode' , 'append');  %,
%   imwrite(R,[SaveFolder,'\',Name{1,1}{60:67,1},'_',Name{1,1}{69,1},'_',Name{1,1}{71,1},'_',Name{1,1}{73,1},'_AF_-',num2str(i),'min_R.tif'], 'Compression','none','WriteMode' , 'append');   
    
    %G刚历
    imwrite(G,[SaveFolder,'\',Name{1,1}{64:71,1},'_BF_-',num2str(FN/2-(i-1)),'min_G.tif'], 'Compression','none','WriteMode' , 'append');  
    imwrite(R,[SaveFolder,'\',Name{1,1}{64:71,1},'_BF_-',num2str(FN/2-(i-1)),'min_R.tif'], 'Compression','none','WriteMode' , 'append');   
   
%     %R刚历 
%     imwrite(G,[SaveFolder,'\',Name{1,1}{64:71,1},'_BF_-',num2str(FN/2-(i-1)),'min_R.tif'], 'Compression','none','WriteMode' , 'append');  
%     imwrite(R,[SaveFolder,'\',Name{1,1}{64:71,1},'_BF_-',num2str(FN/2-(i-1)),'min_G.tif'], 'Compression','none','WriteMode' , 'append');   
    end
end

%% After 

clear
z_stack=13;
[Filename Pathname]=uigetfile('*.tif','Select before cropped z stack Red spine images for every frames,','MultiSelect','on');
Info=imfinfo([Pathname Filename]);
SaveFolder='D:\Research\Project\uncaging\20200221_SpineVolumeAnalysis\Data\20200703\1\1';
FN=length(Info)/z_stack; % frame number 
Name=textscan(char(SaveFolder),'%1s');
frame=68;
for i=1:FN/2
    for j=1:z_stack
    G(:,:)=imread([Pathname Filename],2*(i-1)*z_stack+j);
    R(:,:)=imread([Pathname Filename],2*(i-1)*z_stack+z_stack+j);
%   imwrite(G,[SaveFolder,'\',Name{1,1}{60:67,1},'_',Name{1,1}{69,1},'_',Name{1,1}{71,1},'_',Name{1,1}{73,1},'_AF_-',num2str(i),'min_G.tif'], 'Compression','none','WriteMode' , 'append');  %,
%   imwrite(R,[SaveFolder,'\',Name{1,1}{60:67,1},'_',Name{1,1}{69,1},'_',Name{1,1}{71,1},'_',Name{1,1}{73,1},'_AF_-',num2str(i),'min_R.tif'], 'Compression','none','WriteMode' , 'append');   
    
    %G刚历 
    imwrite(G,[SaveFolder,'\',Name{1,1}{64:71,1},'_AF_',num2str(i+frame),'min_G.tif'], 'Compression','none','WriteMode' , 'append');  
    imwrite(R,[SaveFolder,'\',Name{1,1}{64:71,1},'_AF_',num2str(i+frame),'min_R.tif'], 'Compression','none','WriteMode' , 'append');    
      
%     R刚历 
%     imwrite(G,[SaveFolder,'\',Name{1,1}{64:71,1},'_AF_',num2str(i+frame),'min_R.tif'], 'Compression','none','WriteMode' , 'append');  
%     imwrite(R,[SaveFolder,'\',Name{1,1}{64:71,1},'_AF_',num2str(i+frame),'min_G.tif'], 'Compression','none','WriteMode' , 'append');    

    end
end

%% Load files -  max projection for dendrite (Select BF.tif, AF.tif all in once)
clear
[Filename Pathname]=uigetfile('*.tif','Select BF image first and run, next select AF image and run','MultiSelect','on');
SaveFolder='G:\Research\Project\uncaging\20200221_SpineVolumeAnalysis\Data\20200618\1\1';
z_stack=13;

for k=1:length(Filename)
    Info=imfinfo([Pathname Filename{1,k}]);
    FN=length(Info)/z_stack; % frame number 

% max projection for dendrite 
for i=1:FN/2
    for j=1:z_stack
         I_R_max_bf(:,:,j)=imread([ Filename{1,k}],2*(i-1)*z_stack+z_stack+j); %G 刚历 
%          I_R_max_bf(:,:,j)=imread([Pathname Filename],2*(i-1)*z_stack+j); %R 刚历
    end  
    I_R_max_af=max(I_R_max_bf, [], 3);
    
    imwrite(I_R_max_af,[SaveFolder,'\','Max_dend_',Filename{1,k}], 'Compression','none','WriteMode' , 'append');   
end
end
