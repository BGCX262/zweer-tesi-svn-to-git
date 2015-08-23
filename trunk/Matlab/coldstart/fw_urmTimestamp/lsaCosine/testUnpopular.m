function [] = testUnpopular (days,urm,icm,itemID_icm,itemID_urm,unpopularThreshold)

addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 1;
j=0;
for i=days;
    tic;
j=j+1;
    i
	urmLSA=generateURMfromTimestampFull(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy'));
	icmLSA= prepareURMxLSA(itemID_icm(:,1),urmLSA,itemID_urm,2,icm);
	[u_icm,s_icm,v_icm]=svds(icmLSA,200);
	param.itemModel=s_icm*v_icm'; 

	[pos,neg]=extractTestSetsUnpopular(urmLSA,0.5,-1,unpopularThreshold(j),folds);


	param.ls=150	
    	[positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urmLSA,urmLSA,pos,neg,param,1);
	[recallLSA150unpop(i)]=computeRecall(positiveTests,5);  


	param.ls=100	
    	[positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urmLSA,urmLSA,pos,neg,param,1);
	[recallLSA100unpop(i)]=computeRecall(positiveTests,5);  

	param.ls=50	
    	[positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urmLSA,urmLSA,pos,neg,param,1);
	[recallLSA50unpop(i)]=computeRecall(positiveTests,5);  

	param.ls=200
    	[positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urmLSA,urmLSA,pos,neg,param,1);
	[recallLSA200unpop(i)]=computeRecall(positiveTests,5);  

	save ('recallLSAunpopular50p','recallLSA50unpop','recallLSA150unpop','recallLSA200unpop','recallLSA100unpop');

    toc
end