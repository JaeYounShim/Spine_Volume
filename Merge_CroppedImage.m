% 20200720 
% merge spine and mRNA cropped image to single image files 

%% clear
[R_Filename R_Pathname]=uigetfile('*.tif','Select original image','MultiSelect','on');
[G_Filename G_Pathname]=uigetfile('*.tif','Select original image','MultiSelect','on');

%% rearrange filename
z=0;
for j=1:size(R_Filename,2)
    if R_Filename{1,j}(15:16)=='BF'
        z=z+1;
    end
end

zz=z;
for j=size(R_Filename,2)-z+1:size(R_Filename,2)
    R_Filename{2,zz}=R_Filename{1,j};
    zz=zz-1;        
end

zz=z+1;
for j=1:size(R_Filename,2)-z
    R_Filename{2,zz}=R_Filename{1,j};
    zz=zz+1;        
end
R_Filename(1,:)=R_Filename(2,:);
R_Filename(2,:)=[];


z=0;
for j=1:size(G_Filename,2)
    if G_Filename{1,j}(15:16)=='BF'
        z=z+1;
    end
end

zz=z;
for j=size(G_Filename,2)-z+1:size(G_Filename,2)
    G_Filename{2,zz}=G_Filename{1,j};
    zz=zz-1;        
end

zz=z+1;
for j=1:size(G_Filename,2)-z
    G_Filename{2,zz}=G_Filename{1,j};
    zz=zz+1;        
end
G_Filename(1,:)=G_Filename(2,:);
G_Filename(2,:)=[];
%%

for j=1:size(R_Filename,2)
RInfo=imfinfo(R_Filename{1,j});

for i=1:length(RInfo)
    I_R=imread([R_Pathname R_Filename{1,j}],i);
    I_G=imread([G_Pathname G_Filename{1,j}],i);
    I=imfuse(I_R,I_G,'falsecolor','Scaling','joint','ColorChannels',[2 1 0]);
        doubleC=double(I)/255;
        C16=uint16(round(doubleC*65535));
%     tiff_stack=[];
%     tiff_stack = cat(3 ,I_R,I_G,tiff_stack);
    imwrite(C16, [R_Pathname,'Merge.tif'], 'Compression','none','WriteMode' , 'append') ;
end

end