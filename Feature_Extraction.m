clear all
close all
clc

source_dir='E:\UniversityData\FacultyProjects\DrDayang\Combined_Features\lgg';

d = dir([source_dir]);
n=length(d);

TotalUsefulImages=0;
BaseCount=0;
ic=1;
for i = 3:n
    SubDir = strcat(source_dir,'\', d(i).name);
    SubD = dir([SubDir]);
    n2=length(SubD);
    
    SubLabel = strcat(SubDir,'\', SubD(3).name);
    SubFlair = strcat(SubDir,'\', SubD(4).name);
     SubT1 = strcat(SubDir,'\', SubD(4).name);
     SubT1c = strcat(SubDir,'\', SubD(5).name);
     SubT2 = strcat(SubDir,'\', SubD(6).name);
    ImageD = dir([SubDir, '\*.jpg']);
    ImageN=length(ImageD);
%     ImageD1 = dir([SubFlair, '\*.jpg']);
%     ImageN1=length(ImageD1);

    if (i == 3)
        ImLabel=0;
    else
        ImLabel=1;
    end
    
    %ImLabel =0;
    for j=1:ImageN
%         if (j<10)
            FlairPath = strcat(SubDir,'\OOMRI (',int2str(j),').jpg');
            FlairPath = strcat(SubFlair,'\slice_0',int2str(j),'.png');
            T1Path = strcat(SubT1,'\slice_0',int2str(j),'.png');
            T1cPath = strcat(SubT1c,'\slice_0',int2str(j),'.png');
            T2Path = strcat(SubT2,'\slice_0',int2str(j),'.png');
        else
            LabelPath = strcat(SubLabel,'\slice_',int2str(j),'.png');
            FlairPath = strcat(SubFlair,'\slice_',int2str(j),'.png');
            T1Path = strcat(SubT1,'\slice_',int2str(j),'.png');
            T1cPath = strcat(SubT1c,'\slice_',int2str(j),'.png');
            T2Path = strcat(SubT2,'\slice_',int2str(j),'.png');
        end
        imgLabel = imread(LabelPath);
        imgBW=im2bw(imgLabel);
        if(sum(imgBW(:)==1)>16)
            ImLabel=1;
        else
            ImLabel=0;
        end
        
        imgFlair = imread(FlairPath);
        imgT1 = imread(T1Path);
        imgT1c = imread(T1cPath);
        imgT2 = imread(T2Path);
        
        [feature] = Texture_Feat(imgFlair);
        TexFlairFeature(ic,1:13) = feature;
         TexFlairFeature(ic,14) = ImLabel;
        [feature] = Texture_Feat(imgT1);
        T1Feature(ic,1:13) = feature;
        T1Feature(ic,14) = ImLabel;
        [feature] = Texture_Feat(imgT1c);
        T1cFeature(ic,1:13) = feature;
        T1cFeature(ic,14) = ImLabel;
        [feature] = Texture_Feat(imgT2);
        T2Feature(ic,1:13) = feature;
        T2Feature(ic,14) = ImLabel;

        [feature] = DWT2d_Feat(imgFlair);
        dwtFlairFeature(ic,1:25) = feature;
        dwtFlairFeature(ic,26) = ImLabel;
        dwtTEXFlairFeature(ic,1:25) = dwtFlairFeature(ic,1:25);
        dwtTEXFlairFeature(ic,26:38) = TexFlairFeature(ic,1:13);
        dwtTEXFlairFeature(ic,39) = ImLabel;
        [feature] = DWT2d_Feat(imgT1);
        T1Feature(ic,1:25) = feature;
        T1Feature(ic,26) = ImLabel;
        [feature] = DWT2d_Feat(imgT1c);
        T1cFeature(ic,1:25) = feature;
        T1cFeature(ic,26) = ImLabel;
        [feature] = DWT2d_Feat(imgT2);
        T2Feature(ic,1:25) = feature;
        T2Feature(ic,26) = ImLabel;
        
        [feature] = DCT2d_Feat(imgFlair);
        FlairFeature(ic,1:25) = feature;
        FlairFeature(ic,26) = ImLabel;
        [feature] = DCT2d_Feat(imgT1);
        T1Feature(ic,1:25) = feature;
        T1Feature(ic,26) = ImLabel;
        [feature] = DCT2d_Feat(imgT1c);
        T1cFeature(ic,1:25) = feature;
        T1cFeature(ic,26) = ImLabel;
        [feature] = DCT2d_Feat(imgT2);
        T2Feature(ic,1:25) = feature;
        T2Feature(ic,26) = ImLabel;

        
        [feature] = DFT2d_Feat(imgFlair);
        FlairFeature(ic,1:25) = feature;
        FlairFeature(ic,26) = ImLabel;
        [feature] = DFT2d_Feat(imgT1);
        T1Feature(ic,1:25) = feature;
        T1Feature(ic,26) = ImLabel;
        [feature] = DFT2d_Feat(imgT1c);
        T1cFeature(ic,1:25) = feature;
        T1cFeature(ic,26) = ImLabel;
        [feature] = DFT2d_Feat(imgT2);
        T2Feature(ic,1:25) = feature;
        T2Feature(ic,26) = ImLabel;
        
        ic = ic + 1;
    end
end
writePath = 'E:\UniversityData\FacultyProjects\DrDayang\Combined_Features\lgg\';
Data_Type='com-';
%Feat_Type='Texture_Feat-';
%Feat_Type='DWT_Feat-';
%Feat_Type='DCT_Feat-';
%Feat_Type='DFT_Feat-';
SubDirTex = strcat(writePath,Data_Type,'TexFlairFeature.csv');
SubDirDWT = strcat(writePath,Data_Type,'dwtFlairFeature.csv');
SubDirDWTtext =strcat(writePath,Data_Type,'dwtTEXFlairFeature.csv');
%SubDirT2 = strcat(writePath,Data_Type,Feat_Type,'T2_26samples.csv');

csvwrite(SubDirTex,TexFlairFeature);
csvwrite(SubDirDWT,dwtFlairFeature);
csvwrite(SubDirDWTtext,dwtTEXFlairFeature);
%csvwrite(SubDirT2,T2Feature);
