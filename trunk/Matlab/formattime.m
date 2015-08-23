function ftime=formattime(time)
if(time<60)
    ftime=strcat(num2str(time,3),'s');
else
    time=time/60;
    if(time<60)
        ftime=strcat(num2str(time,3),'m');
    else
        time=time/60;
        if(time<60)
            ftime=strcat(num2str(time,3),'h');
        else
            time=time/24;
            ftime=strcat(num2str(time,3),'d');
        end
    end
    
end