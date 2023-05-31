% 2020.06.22
%JYS

%% Load file - Masking for dendrite 
clear
[Filename Pathname]=uigetfile('*.tif','Select Max_dend','MultiSelect','on');
Info=imfinfo([Pathname Filename]);
%% Masking for dendrite 

%choose each dendrite images 
    I_R_max_af=imread([Pathname Filename],1);
    figure(1);set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    BW=roipoly(adapthisteq(I_R_max_af));
    [R,C]=size(BW);
    close
    
    for j=1:length(Info)
        I=imread([Pathname Filename],j);
        for i=1:R
                for j=1:C
                    if BW(i,j)==1
                        Dend_Out(i,j)=I(i,j);
                    else
                        Dend_Out(i,j)=0;
                    end
                end
        end
        Dend_Out_16=uint16(Dend_Out);
        imwrite(Dend_Out_16,[Pathname,'16_',Filename], 'Compression','none','WriteMode' , 'append'); 
    end

% figure
% imshow(Out,[]);title('Output Image');
%% Repeat this part for dend_bf, after all 
% 모든 dendrite filtered image 연결하고 
clear
[Filename Pathname]=uigetfile('*.tif','Select Max_dend','MultiSelect','on');

for j=1:length(imfinfo([Pathname Filename]))
    I=imread([Pathname Filename],j);
imwrite(I,[Pathname,'16_max_Dend_Out_16.tif'], 'Compression','none','WriteMode' , 'append');   
end

%%
% exclude file  빼줘야함. 
clear
[Filename Pathname]=uigetfile('*.tif','Select Max_dend','MultiSelect','on');
[m_Filename m_Pathname]=uigetfile('*.mat','Select information_5stacks_final.mat','MultiSelect','on');
load([m_Pathname m_Filename]);

for i=1:size(exclude_file,1)
for j=1:length(imfinfo([Pathname Filename]))
    if j~=cell2mat(exclude_file(i,2))
        I=imread([Pathname Filename],j);
        imwrite(I,[Pathname,'max_Dend_Out_16_final.tif'], 'Compression','none','WriteMode' , 'append');   
    end
end
end

%% %% Repeat this part for dend_bf,af-1 (-5~-1min, 2,5,10,20,30 min dend) (1)
% 모든 dendrite filtered image 연결하고 
clear
[Filename Pathname]=uigetfile('*.tif','Select Max_dend','MultiSelect','on');

for j=1:length(imfinfo([Pathname Filename]))
    I=imread([Pathname Filename],j);
imwrite(I,[Pathname,'16_max_Dend_Out_16_partial.tif'], 'Compression','none','WriteMode' , 'append');   
end

%% %% %% Repeat this part for dend_bf,af-1 (-5~-1min, 2,5,10,20,30 min dend) (2)
% 모든 dendrite filtered image 연결하고 
clear
[Filename Pathname]=uigetfile('*.tif','Select Max_dend','MultiSelect','on');


for j=1:length(imfinfo([Pathname Filename]))
%     if j==1 || j==4 || j==9 || j==19 || j==29 
    I=imread([Pathname Filename],j);
imwrite(I,[Pathname,'16_max_Dend_Out_16_partial.tif'], 'Compression','none','WriteMode' , 'append');   
%     end
end 



%% dendrite amplitude 
clear
[Dend_Filename Dend_Pathname]=uigetfile('*.tif','Select dendrite max projected frame array images(max_Dend_Out_16.tif) ','MultiSelect','on');
Dend_Info=imfinfo([Dend_Pathname Dend_Filename]);
    %apply same amplitude for spine in the same frame (different amplitude by frames) 
for j=1:length(Dend_Info)
    I_Dend=imread([Dend_Pathname Dend_Filename],j);
    for i=1:size(I_Dend,1)
        Avg_Dend(i)= mean(I_Dend(i,(I_Dend(i,:)~=0)));
    end
    Avg_Dend_frame(j,1)=mean(Avg_Dend,'omitnan');
end
Avg_dend_frame_double=im2double(Avg_Dend_frame);


%% Volume files load 

[Filename Pathname]=uigetfile('*.tif','Select 5 stack images (one set of spine) ','MultiSelect','on');
[m_Filename m_Pathname]=uigetfile('*.mat','Select information_5stacks_final.mat','MultiSelect','on');
load([m_Pathname m_Filename]);
pixelscale=0.086;

% 나중에 폴더에 파티클 넘버 별로 저장해서 폴더 옮겨다니면서 불러오기로 바꿔도 됨. 

%% rearrange filename
z=0;
for j=1:size(Filename,2)
    if Filename{1,j}(19:20)=='BF'
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


%%  
zz=1;clear min_threshold_iter_fin threshold_iter_fin
threshold=[];
for j=1:5%length(Filename)
      Info=imfinfo([Pathname Filename{1,j}]);
      clear I_R_max_bf I_R_max_af
        for i=1:length(Info)
             I_R_max_bf(:,:,i)=imread([Pathname Filename{1,j}],i);
        end  
        I_R_max_af=max(I_R_max_bf, [], 3);
        [x y]=size(I_R_max_af);       

        
%             %straight x y sigma
%             z=1; 
% %             for iii=1:length(x_sigma_final(:,1)) %6 (particle)
%                       for i=1:length(x_sig_ind(1,:)) %25 (frame)
%                          x_sig(1,z)=x_sig_ind(1,i);
%                          y_sig(1,z)=x_sig_ind(1,i);
%                          z=z+1;
%                       end
% %             end

            
         %threshold iteration
         clear threshold_iter 
        for i=1:1000
            threshold=1000+(i-1)*50; %check 

              for k=1:x
                 for jj=1:y
                     if I_R_max_af(k,jj)<threshold 
                         I_R_max_af(k,jj)=0;
                     end
                 end
              end

              % x, y line amplitude 
              clear f_x f_y 
             f_y=I_R_max_af(:,round(length(I_R_max_af(:,1))/2));%-min(I_R_max_af(:,round(length(I_R_max_af(:,1))/2))); % y % subtracting background 
             f_x=I_R_max_af(round(length(I_R_max_af(1,:))/2),:)';%-min(I_R_max_af(round(length(I_R_max_af(1,:))/2),:))'; % x % subtracting background 
             

            zx=0;
            for k=1:length(f_x)
                if f_x(k,1)==0
                    zx=zx+1;
                end
            end
            
             zy=0;
            for k=1:length(f_y)
                if f_y(k,1)==0
                    zy=zy+1;
                end
            end
            
            R_x=size(f_x,1)-zx;
            R_y=size(f_y,1)-zy;
            Delta_R_x=round(radius(j,1)-(R_x/2));
            Delta_R_y=round(radius(j,1)-(R_y/2));

            threshold_iter(i,1)=threshold;
            threshold_iter(i,2)=Delta_R_x;
            threshold_iter(i,3)=Delta_R_y;
            threshold_iter(i,4)=Delta_R_x+Delta_R_y;
            
            if threshold_iter(i,4)==0
                min_threshold_iter_fin(zz,1)=j;
                min_threshold_iter_fin(zz,2)=threshold_iter(i,1);
                min_threshold_iter_fin(zz,3)=threshold_iter(i,4);
                zz=zz+1;
            end
        end
        
        threshold_iter_fin(:,4*j-3)=threshold_iter(:,1);
        threshold_iter_fin(:,4*j-2)=threshold_iter(:,2);
        threshold_iter_fin(:,4*j-1)=threshold_iter(:,3);
        threshold_iter_fin(:,4*j)=threshold_iter(:,4);
 
end

threshold=min(min_threshold_iter_fin(:,2));         
% threshold=mean(unique(min_threshold_iter_fin(:,2)));
%% spine image filtering 
%how many images in before condition? 
BF_N=0;
     for i=1:size(Filename,2)
        if Filename{1,i}(1,22)=='-'
         BF_N=BF_N+1;
        end
     end  
BF_N

 for j=1:size(Filename,2) % frame 
      Info=imfinfo([Pathname Filename{1,j}]);
      
      clear I_R_max_bf I_R_max_af
        for i=1:length(Info)
             I_R_max_bf(:,:,i)=imread([Pathname Filename{1,j}],i);
        end  
        I_R_max_af=max(I_R_max_bf, [], 3);
        [x y]=size(I_R_max_af);       

%     prompt= ['threshold?'];
%     threshold=input(prompt); 

    I_vol=imread([Pathname Filename{1,j}],1);
    zz=0; Sum_I=[]; Sum_I_fin=zeros(1,length(I_vol(:,1))); %I_inten_sum=zeros(x,y);
    for i=1:length(Info)
        I_vol=imread([Pathname Filename{1,j}],i);
        for k=1:x
             for jj=1:y
                 if I_vol(k,jj)<threshold
                     I_vol(k,jj)=0;
                 end
             end
        end
        
        
        % maxprojection filterting
       for k=1:x
             for jj=1:y
                 if I_R_max_bf(k,jj,:)<threshold
                     I_R_max_bf(k,jj,:)=0;
                 end
             end
       end
        I_R_max_af=max(I_R_max_bf, [], 3);
        
        minute=textscan(Filename{1,j},'%1s');
        
%         subplot(round(sqrt(length(Filename))),round(sqrt(length(Filename))),j)
%        imshow(adapthisteq(I_R_max_af))
%        hold all 
% %         title([minute{1,1}{22:27,1}])
%          title(sprintf('%s',num2str(j))) 

        for ii=1:size(I_vol,1)
              Sum_I(ii)= sum(I_vol(ii,(I_vol(ii,:)~=0)));
        end
        Sum_I_fin=Sum_I_fin+Sum_I;
    end
        
    
     spine_volume{j,1}=([minute{1,1}{22:27,1}]);
     spine_volume{j,2}=(0.086)^2*(0.5)*sum(Sum_I_fin)/Avg_dend_frame_double(j,1); % unit [um^3] spine estimatevolume 
     spine_volume{j,6}=spine_volume{j,2}/((pi)^2/2*(1.14)^(-1/6)*(3.18)^(-1/6));
     spine_volume{j,3}=spine_volume{j,2}/(0.086)^2/(0.5);%((pi)^2/2*(1.14)^(-1/6)*(3.18)^(-1/6)); % number of pixel 
     spine_volume{1,4}=1;
     

 end
 
 for j=1:size(Filename,2)
               spine_volume{j,4}=spine_volume{j,2}/mean([spine_volume{1:5,2}]);
 end
        
     
spine_volume{1,5}=threshold;

    
%% Save spine volume file 

Name=textscan(char(Filename{1,1}),'%1s');
save([Name{1,1}{1:11,1},'_spine_volume.mat'],'spine_volume'); 

%% volume < 1.5
small_volume=[];   
z=1;
for j=1:length(Filename)
    if spine_volume{j,4}<1.5
        small_volume{z,1}=spine_volume{j,1};
        small_volume{z,2}=spine_volume{j,4};
        z=z+1;
    end
end