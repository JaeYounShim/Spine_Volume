%2020.06.22
%JYS

%% load file 
clear
[Filename Pathname]=uigetfile('*.tif','Select original image','MultiSelect','on');
SaveFolder='G:\Research\Project\uncaging\20200221_SpineVolumeAnalysis\Data\20200611\1\1\2';
mkdir(SaveFolder,'Crop')
% x=357;y=430; % stimulation point 
crop_size=70; 

%% crop and save 
Info=imfinfo([Pathname Filename{1,length(Filename)}]);
    for i=1:length(Info)
         I_R_max_bf(:,:,i)=imread([Pathname Filename{1,2}],i);
    end  
    I_R_max_af=max(I_R_max_bf, [], 3);
        
    figure(1) 
    imshow(adapthisteq(I_R_max_af),'InitialMagnification','fit') 
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    [x1,y1] = getpts; % choose the center of spine
    close 
    
    for i=1:length(Info)
         I_R_max_bf(:,:,i)=imread([Pathname Filename{1,length(Filename)}],i);
    end  
    I_R_max_af=max(I_R_max_bf, [], 3);
        
    figure(2) 
    imshow(adapthisteq(I_R_max_af),'InitialMagnification','fit') 
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    [x2,y2] = getpts; % choose the center of spine
    close 
    
    x=(x1+x2)/2; y=(y1+y2)/2;
    
    
cd([SaveFolder,'\Crop'])

for j=1:length(Filename)
        RG=textscan(Filename{1,j},'%1s');
        for i=1:length(Info)
        clear I_crop
        I=imread([Pathname,char(Filename{1,j})],i);
        I_crop(:,:)=imcrop(I,[x-crop_size/2 y-crop_size/2 crop_size crop_size]);
%         imshow(adapthisteq(I_crop))
        imwrite(I_crop,[[SaveFolder,'\Crop\'],RG{1,1}{length(RG{1,1})-4,1},'_Cr_',char(Filename{1,j})], 'Compression','none','WriteMode' , 'append');
        end
end
