function image_stats

%Author: P. Perona; Modified by A. Angelova 

FEATURES_FILE = 'WebFaces_GroundThruth.txt';
PIC_DIR = 'Caltech_WebFaces/';

DISPLAY=0;

font_size=18;
title_size=22;

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
    else
        image_count = image_count + 1;
        faces_per_ima(image_count) = 1;
        
        fid=fopen(ima_fname);
        if (fid<0)
            continue;
        end;
        fclose(fid);
        ima = imread(ima_fname);
        [sx,sy,sz]=size(ima);
        
        Xsize(image_count)=sx;
        Ysize(image_count)=sy;
        
        if DISPLAY
            figure(1); image(ima);
            hold on
            for i=1:4
                x(i) = str2num(things{2*i});
                y(i) = str2num(things{1+2*i});
                plot(x(i),y(i),'g.','MarkerSize',20);
            end;
            pause(0.001);
        end;
    end;
end;
fclose (features_file);

%average image resolution
AvgSizeWidth=sum(Ysize)/image_count
AvgSizeHeight=sum(Xsize)/image_count

figure(21); set(gca,'Fontsize',font_size);
[n,bin] = hist(Ysize,50);
plot(log10(bin),log10(n),'ko-','LineWidth',3);
title(['Histogram of the image width for ' num2str(image_count) ' images.'],'Fontsize',title_size);
xlabel('log_{10} Image width (pixels)','Fontsize',font_size);
ylabel('log_{10} Image count','Fontsize',font_size);


figure(22); set(gca,'Fontsize',font_size);
[n,bin] = hist(Xsize,50);
plot(log10(bin),log10(n),'ko-','LineWidth',3);
title(['Histogram of the image height for ' num2str(image_count) ' images.'],'Fontsize',title_size);
xlabel('log_{10} Image height (pixels)','Fontsize',font_size);
ylabel('log_{10} Image count','Fontsize',font_size);


  