function [] = testAll (days,urm,icm,itemID_icm,itemID_urm)

addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;

for i=days;
    tic;
    i
	urmLSA=generateURMfromTimestampFull(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy'));
	icmLSA= prepareURMxLSA(itemID_icm(:,1),urmLSA,itemID_urm,2,icm);
	[u_icm,s_icm,v_icm]=svds(icmLSA,200);
	param.itemModel=s_icm*v_icm'; 

	[pos,neg]=extractTestSets(urmLSA,0.5,-1);


	param.ls=150;	
    	[positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urmLSA,urmLSA,pos,neg,param,1);
	[recallLSA150(i)]=computeRecall(positiveTests,5);  

	save ('recallLSAtmp','recallLSA150');

	param.ls=100;	
    	[positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urmLSA,urmLSA,pos,neg,param,1);
	[recallLSA100(i)]=computeRecall(positiveTests,5);  

	param.ls=50;	
    	[positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urmLSA,urmLSA,pos,neg,param,1);
	[recallLSA50(i)]=computeRecall(positiveTests,5);  

	param.ls=200;	
    	[positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urmLSA,urmLSA,pos,neg,param,1);
	[recallLSA200(i)]=computeRecall(positiveTests,5);  

	save ('recallLSA','recallLSA50','recallLSA150','recallLSA200','recallLSA100');

    toc
end