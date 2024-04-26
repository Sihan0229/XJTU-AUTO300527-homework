function face_stats

%Author: P. Perona; Modified by A. Angelova 

FEATURES_FILE = 'WebFaces_GroundThruth.txt';
PIC_DIR = 'Caltech_WebFaces/';

font_size=12;
title_size=12;

features_file = fopen(FEATURES_FILE,'r');

face_count=0;
image_count = 0;

ima_fname = '';

%compute statistics and display images
while(1),
    line = fgetl(features_file);
    if line < 0, break; end;
    
    face_count=face_count+1;

    %fprintf(1,'%s\n',line);
    things=strread(line,'%s');
    
    old_ima_fname = ima_fname;
    ima_fname = [PIC_DIR things{1}];
    
    if strcmp(ima_fname,old_ima_fname),
        faces_per_ima(image_count) = faces_per_ima(image_count) + 1;
    else,
        image_count = image_count + 1;
        faces_per_ima(image_count) = 1;
    end;
    
    for i=1:4
        x(i) = str2num(things{2*i});
        y(i) = str2num(things{1+2*i});
    end;
    sz(face_count) = sqrt((x(2)-x(1))^2 + (y(2)-y(1))^2);
end;
fclose (features_file);

%plot a histogram of the eye distance of the faces (to get an idea of the resolution)
figure(31); set(gca,'Fontsize',font_size);
[n,bin] = hist(sz,30);
plot(log10(bin),log10(n),'ko-','LineWidth',3);
title(['Histogram of the eye distance for ' num2str(face_count) ' faces.'],'Fontsize',title_size);
xlabel('log_{10} Eye distance (pixels)','Fontsize',font_size);
ylabel('log_{10} Face count','Fontsize',font_size);


%plot a histogram of the number of faces per image
figure(32); set(gca,'Fontsize',font_size);
[n,bin] = hist(faces_per_ima,[1:max(faces_per_ima)]);
plot(bin,log10(n),'ko-','LineWidth',3);
%plot(bin,log10(max(1,n)),'o-','LineWidth',2,'MarkerSize',6);
AvgFaceCount=(face_count/image_count);
title(['Number of faces per image. ' num2str(AvgFaceCount,3) ' faces per image'],'Fontsize',title_size);
ylabel('log_{10} Number of images','Fontsize',font_size);
xlabel('Number of faces','Fontsize',font_size);