%2020.06.22
%JYS

%% load file 
clear
[Filename Pathname]=uigetfile('*.tif','Select red image','MultiSelect','on');
[m_Filename m_Pathname]=uigetfile('*.mat','Select information file .mat','MultiSelect','on');   
load([m_Pathname m_Filename]);


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

%% To 5stacks 

mkdir([Pathname,'5stacks']);
exclude_file=[];
% show all z stack images 
qqq=1;
for j=1:length(Filename(1,:)) % each file 
    Info=imfinfo([Pathname Filename{1,j}]); % number of zstack 
    
    clear Histo Histo_diff
    for i=1:length(Info) % zstack %length(I_max_bf_re(1,:,:))
               clear I
               I(:,:)=imread([Pathname Filename{1,j}],i);
%                 I(:,:)=I_max_bf_re(:,:,i);  
               Amp=[];zz=1;
               for k=round(length(I(:,1))/2)-2:round(length(I(:,1))/2)+2 % x, +-2.5 pixels left and right from center
                   z=1;
                   for kk=round(length(I(1,:))/2)-2:round(length(I(1,:))/2)+2 %y, +-2.5 pixels left and right from center
                       Amp(zz,z)=I(k,kk);
                       z=z+1; 
                   end
                   zz=zz+1;
               end
               Histo(i,1)=mean(mean(Amp(:,:)));
    end
    
    
%     [Amp_max focus]=max(Histo);
%   fourier fitting 
    curveg=fit([1:length(Histo)]',Histo(:,1),fittype('fourier3'));
    x_10times=[0:0.1:length(Histo)]';
    Histo_diff(:,1)=diff(curveg(x_10times));
    Histo_diff(:,2)=x_10times(1:length(x_10times)-1,1);
    
    %find focus
    qq=1; focus=[];
    for q=1:length(Histo_diff)-1
            if sign(Histo_diff(q,1))*sign(Histo_diff(q+1,1))==-1 && Histo_diff(q,1)>0
            focus(qq,1)=round((Histo_diff(q,2)+Histo_diff(q+1,2))/2);
            qq=qq+1;
            end
    end
        
        %if focus has mutiple components 
        if length(focus)>1
            qq=1; clear Histo_max
            for q=1:length(focus(:,1))
                %exclude focus=0 and 12,13  
                if focus(q,1)~=0 && focus(q,1)<length(Histo)-1  
                    Histo_max(qq,1)=Histo(focus(q,1),1);
                    qq=qq+1;
                end
            end

            qq=1;
            while Histo(qq,1)~=max(Histo_max)
            qq=qq+1;
            end

            focus=qq;
        end
    
        

    if isempty(focus)
        exclude_file{qqq,1}=Filename{1,j};
        exclude_file{qqq,2}=j;
        qqq=qqq+1;
    elseif ~isempty(focus)
        
        if focus<3
            focus=3;
        elseif focus>length(Info)-2
            focus=length(Info)-2;            
        end
        
         %save   
         clear I_save i
        for i=focus-2:focus+2
            I_save(:,:)=imread([Pathname Filename{1,j}],i);
            imwrite(I_save,[Pathname,'5stacks\',Filename{1,j}], 'Compression','none','WriteMode' , 'append');
        end      
     end
  
end  

%% check spines with max projection 
    
k=1;
for j=1:length(Filename(1,:)) % each file
    if ~isempty(exclude_file) 
            if [exclude_file{k,2}]~=j 
                Info=imfinfo([Pathname,'5stacks\', Filename{1,j}]); % number of zstack 
                clear I_max_bf 
                for i=1:length(Info)
                     I_max_bf(:,:,i)=imread([Pathname,'5stacks\', Filename{1,j}],i);
                end  
                    I_max_af=max(I_max_bf, [], 3);

                   figure(1)
                  subplot(round(sqrt(length(Filename))),round(sqrt(length(Filename))),j)
                   imshow(histeq(I_max_af))
                   title(sprintf('%s',num2str(j)))
                   hold on 
            elseif [exclude_file{k,2}]==j 
                k=k+1;
                if k>size(exclude_file,1)
                    k=k-1;
                end

            end
        
    elseif isempty(exclude_file) 
                 Info=imfinfo([Pathname,'5stacks\', Filename{1,j}]); % number of zstack 
                clear I_max_bf 
                for i=1:length(Info)
                     I_max_bf(:,:,i)=imread([Pathname,'5stacks\', Filename{1,j}],i);
                end  
                    I_max_af=max(I_max_bf, [], 3);

                   figure(1)
                    subplot(round(sqrt(length(Filename))),round(sqrt(length(Filename))),j)                   
                    imshow(histeq(I_max_af))
                   title(sprintf('%s',num2str(j)))
                   hold on        
    end

end

%% information exclusion --> exclude file 

[m_Filename m_Pathname]=uigetfile('*.mat','Select information file .mat','MultiSelect','on');
load([m_Pathname m_Filename]);
for i=1:size(exclude_file,1)
    center(cell2mat(exclude_file(i,2)),:)=0;
    radius(cell2mat(exclude_file(i,2)),1)=0;
end
center2(:,1)=nonzeros(center(:,1));
center2(:,2)=nonzeros(center(:,2));
radius2(:,1)=nonzeros(radius(:,1));

radius=[];radius=radius2;
center=[];center=center2;


save('information_5stack_final.mat','radius','center','exclude_file')



