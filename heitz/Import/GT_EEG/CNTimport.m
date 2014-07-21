%import CNT files recorded at Georgia Tech
%add eeglab path temporarily
%addpath(path,'~/desktop/Mat_Code/eeglab/functions/sigprocfunc')
%do for all .cnt files

cd /volumes/Dump/GT_EEG_Data/
file_list = dir('*.cnt');


q = '''';
c = ',';
qcq = [q c q];
saveFlag = 0;



for file = 1:length(file_list)
    [ALLEEG] = loadcnt(file_list(file).name);
    
    %because sampling rate == 500 Hz, this actually corresponds to -600:1000
    Plot_Time = [-300 500];
    
    for chan = 1:size(ALLEEG.electloc,2)
        %eval([cell2mat(struct2cell(ALLEEG.electloc(chan))) '= ALLEEG.data(chan,:);' ])
        eval([ALLEEG.electloc(chan).lab '= ALLEEG.data(chan,:);' ])
    end
    
    %get strobes
    events = struct2cell(ALLEEG.event);
    strobes = squeeze(cell2mat(events(1,:,:)));
    strobelat = squeeze(cell2mat(events(5,:,:)));
    
    
    VEPs = find(strobes == 69 | strobes == 79);
    SS1 = find(strobes == 1);
    SS2 = find(strobes == 2);
    SS3 = find(strobes == 3);
    SS4 = find(strobes == 4);
    SS5 = find(strobes == 5);
    SS6 = find(strobes == 6);
    SS7 = find(strobes == 7);
    
    %for VEP
    for count = 1:length(VEPs)
        VEP_A1(count,1:length(Plot_Time(1):Plot_Time(2))) = A1(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_A2(count,1:length(Plot_Time(1):Plot_Time(2))) = A2(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_C3(count,1:length(Plot_Time(1):Plot_Time(2))) = C3(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_C4(count,1:length(Plot_Time(1):Plot_Time(2))) = C4(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_CP3(count,1:length(Plot_Time(1):Plot_Time(2))) = CP3(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_CP4(count,1:length(Plot_Time(1):Plot_Time(2))) = CP4(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_CPz(count,1:length(Plot_Time(1):Plot_Time(2))) = CPz(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_Cz(count,1:length(Plot_Time(1):Plot_Time(2))) = Cz(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_F3(count,1:length(Plot_Time(1):Plot_Time(2))) = F3(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_F4(count,1:length(Plot_Time(1):Plot_Time(2))) = F4(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_F7(count,1:length(Plot_Time(1):Plot_Time(2))) = F7(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_F8(count,1:length(Plot_Time(1):Plot_Time(2))) = F8(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_FC3(count,1:length(Plot_Time(1):Plot_Time(2))) = FC3(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_FC4(count,1:length(Plot_Time(1):Plot_Time(2))) = FC4(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_FCz(count,1:length(Plot_Time(1):Plot_Time(2))) = FCz(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_FT10(count,1:length(Plot_Time(1):Plot_Time(2))) = FT10(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_FT7(count,1:length(Plot_Time(1):Plot_Time(2))) = FT7(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_FT8(count,1:length(Plot_Time(1):Plot_Time(2))) = FT8(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_FT9(count,1:length(Plot_Time(1):Plot_Time(2))) = FT9(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_Fp1(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp1(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_Fp2(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp2(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_Fz(count,1:length(Plot_Time(1):Plot_Time(2))) = Fz(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_O1(count,1:length(Plot_Time(1):Plot_Time(2))) = O1(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_O2(count,1:length(Plot_Time(1):Plot_Time(2))) = O2(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_Oz(count,1:length(Plot_Time(1):Plot_Time(2))) = Oz(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_P3(count,1:length(Plot_Time(1):Plot_Time(2))) = P3(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_P4(count,1:length(Plot_Time(1):Plot_Time(2))) = P4(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_PO1(count,1:length(Plot_Time(1):Plot_Time(2))) = PO1(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_PO2(count,1:length(Plot_Time(1):Plot_Time(2))) = PO2(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_Pz(count,1:length(Plot_Time(1):Plot_Time(2))) = Pz(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_T3(count,1:length(Plot_Time(1):Plot_Time(2))) = T3(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_T4(count,1:length(Plot_Time(1):Plot_Time(2))) = T4(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_T5(count,1:length(Plot_Time(1):Plot_Time(2))) = T5(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_T6(count,1:length(Plot_Time(1):Plot_Time(2))) = T6(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_TP7(count,1:length(Plot_Time(1):Plot_Time(2))) = TP7(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_TP8(count,1:length(Plot_Time(1):Plot_Time(2))) = TP8(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_X1(count,1:length(Plot_Time(1):Plot_Time(2))) = X1(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_X2(count,1:length(Plot_Time(1):Plot_Time(2))) = X2(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_X3(count,1:length(Plot_Time(1):Plot_Time(2))) = X3(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
        VEP_X4(count,1:length(Plot_Time(1):Plot_Time(2))) = X4(strobelat(VEPs(count))-abs(Plot_Time(1)):strobelat(VEPs(count))+abs(Plot_Time(2)));
    end
    
    %for Set Size 1
    for count = 1:length(SS1)
        SS1_A1(count,1:length(Plot_Time(1):Plot_Time(2))) = A1(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_A2(count,1:length(Plot_Time(1):Plot_Time(2))) = A2(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_C3(count,1:length(Plot_Time(1):Plot_Time(2))) = C3(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_C4(count,1:length(Plot_Time(1):Plot_Time(2))) = C4(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_CP3(count,1:length(Plot_Time(1):Plot_Time(2))) = CP3(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_CP4(count,1:length(Plot_Time(1):Plot_Time(2))) = CP4(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_CPz(count,1:length(Plot_Time(1):Plot_Time(2))) = CPz(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_Cz(count,1:length(Plot_Time(1):Plot_Time(2))) = Cz(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_F3(count,1:length(Plot_Time(1):Plot_Time(2))) = F3(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_F4(count,1:length(Plot_Time(1):Plot_Time(2))) = F4(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_F7(count,1:length(Plot_Time(1):Plot_Time(2))) = F7(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_F8(count,1:length(Plot_Time(1):Plot_Time(2))) = F8(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_FC3(count,1:length(Plot_Time(1):Plot_Time(2))) = FC3(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_FC4(count,1:length(Plot_Time(1):Plot_Time(2))) = FC4(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_FCz(count,1:length(Plot_Time(1):Plot_Time(2))) = FCz(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_FT10(count,1:length(Plot_Time(1):Plot_Time(2))) = FT10(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_FT7(count,1:length(Plot_Time(1):Plot_Time(2))) = FT7(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_FT8(count,1:length(Plot_Time(1):Plot_Time(2))) = FT8(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_FT9(count,1:length(Plot_Time(1):Plot_Time(2))) = FT9(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_Fp1(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp1(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_Fp2(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp2(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_Fz(count,1:length(Plot_Time(1):Plot_Time(2))) = Fz(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_O1(count,1:length(Plot_Time(1):Plot_Time(2))) = O1(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_O2(count,1:length(Plot_Time(1):Plot_Time(2))) = O2(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_Oz(count,1:length(Plot_Time(1):Plot_Time(2))) = Oz(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_P3(count,1:length(Plot_Time(1):Plot_Time(2))) = P3(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_P4(count,1:length(Plot_Time(1):Plot_Time(2))) = P4(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_PO1(count,1:length(Plot_Time(1):Plot_Time(2))) = PO1(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_PO2(count,1:length(Plot_Time(1):Plot_Time(2))) = PO2(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_Pz(count,1:length(Plot_Time(1):Plot_Time(2))) = Pz(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_T3(count,1:length(Plot_Time(1):Plot_Time(2))) = T3(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_T4(count,1:length(Plot_Time(1):Plot_Time(2))) = T4(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_T5(count,1:length(Plot_Time(1):Plot_Time(2))) = T5(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_T6(count,1:length(Plot_Time(1):Plot_Time(2))) = T6(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_TP7(count,1:length(Plot_Time(1):Plot_Time(2))) = TP7(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_TP8(count,1:length(Plot_Time(1):Plot_Time(2))) = TP8(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_X1(count,1:length(Plot_Time(1):Plot_Time(2))) = X1(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_X2(count,1:length(Plot_Time(1):Plot_Time(2))) = X2(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_X3(count,1:length(Plot_Time(1):Plot_Time(2))) = X3(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
        SS1_X4(count,1:length(Plot_Time(1):Plot_Time(2))) = X4(strobelat(SS1(count))-abs(Plot_Time(1)):strobelat(SS1(count))+abs(Plot_Time(2)));
    end
    
    %for set size 2
    for count = 1:length(SS2)
        SS2_A1(count,1:length(Plot_Time(1):Plot_Time(2))) = A1(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_A2(count,1:length(Plot_Time(1):Plot_Time(2))) = A2(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_C3(count,1:length(Plot_Time(1):Plot_Time(2))) = C3(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_C4(count,1:length(Plot_Time(1):Plot_Time(2))) = C4(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_CP3(count,1:length(Plot_Time(1):Plot_Time(2))) = CP3(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_CP4(count,1:length(Plot_Time(1):Plot_Time(2))) = CP4(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_CPz(count,1:length(Plot_Time(1):Plot_Time(2))) = CPz(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_Cz(count,1:length(Plot_Time(1):Plot_Time(2))) = Cz(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_F3(count,1:length(Plot_Time(1):Plot_Time(2))) = F3(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_F4(count,1:length(Plot_Time(1):Plot_Time(2))) = F4(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_F7(count,1:length(Plot_Time(1):Plot_Time(2))) = F7(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_F8(count,1:length(Plot_Time(1):Plot_Time(2))) = F8(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_FC3(count,1:length(Plot_Time(1):Plot_Time(2))) = FC3(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_FC4(count,1:length(Plot_Time(1):Plot_Time(2))) = FC4(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_FCz(count,1:length(Plot_Time(1):Plot_Time(2))) = FCz(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_FT10(count,1:length(Plot_Time(1):Plot_Time(2))) = FT10(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_FT7(count,1:length(Plot_Time(1):Plot_Time(2))) = FT7(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_FT8(count,1:length(Plot_Time(1):Plot_Time(2))) = FT8(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_FT9(count,1:length(Plot_Time(1):Plot_Time(2))) = FT9(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_Fp1(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp1(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_Fp2(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp2(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_Fz(count,1:length(Plot_Time(1):Plot_Time(2))) = Fz(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_O1(count,1:length(Plot_Time(1):Plot_Time(2))) = O1(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_O2(count,1:length(Plot_Time(1):Plot_Time(2))) = O2(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_Oz(count,1:length(Plot_Time(1):Plot_Time(2))) = Oz(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_P3(count,1:length(Plot_Time(1):Plot_Time(2))) = P3(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_P4(count,1:length(Plot_Time(1):Plot_Time(2))) = P4(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_PO1(count,1:length(Plot_Time(1):Plot_Time(2))) = PO1(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_PO2(count,1:length(Plot_Time(1):Plot_Time(2))) = PO2(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_Pz(count,1:length(Plot_Time(1):Plot_Time(2))) = Pz(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_T3(count,1:length(Plot_Time(1):Plot_Time(2))) = T3(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_T4(count,1:length(Plot_Time(1):Plot_Time(2))) = T4(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_T5(count,1:length(Plot_Time(1):Plot_Time(2))) = T5(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_T6(count,1:length(Plot_Time(1):Plot_Time(2))) = T6(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_TP7(count,1:length(Plot_Time(1):Plot_Time(2))) = TP7(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_TP8(count,1:length(Plot_Time(1):Plot_Time(2))) = TP8(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_X1(count,1:length(Plot_Time(1):Plot_Time(2))) = X1(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_X2(count,1:length(Plot_Time(1):Plot_Time(2))) = X2(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_X3(count,1:length(Plot_Time(1):Plot_Time(2))) = X3(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
        SS2_X4(count,1:length(Plot_Time(1):Plot_Time(2))) = X4(strobelat(SS2(count))-abs(Plot_Time(1)):strobelat(SS2(count))+abs(Plot_Time(2)));
    end
    
    %set size 3
    for count = 1:length(SS3)
        SS3_A1(count,1:length(Plot_Time(1):Plot_Time(2))) = A1(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_A2(count,1:length(Plot_Time(1):Plot_Time(2))) = A2(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_C3(count,1:length(Plot_Time(1):Plot_Time(2))) = C3(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_C4(count,1:length(Plot_Time(1):Plot_Time(2))) = C4(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_CP3(count,1:length(Plot_Time(1):Plot_Time(2))) = CP3(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_CP4(count,1:length(Plot_Time(1):Plot_Time(2))) = CP4(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_CPz(count,1:length(Plot_Time(1):Plot_Time(2))) = CPz(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_Cz(count,1:length(Plot_Time(1):Plot_Time(2))) = Cz(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_F3(count,1:length(Plot_Time(1):Plot_Time(2))) = F3(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_F4(count,1:length(Plot_Time(1):Plot_Time(2))) = F4(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_F7(count,1:length(Plot_Time(1):Plot_Time(2))) = F7(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_F8(count,1:length(Plot_Time(1):Plot_Time(2))) = F8(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_FC3(count,1:length(Plot_Time(1):Plot_Time(2))) = FC3(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_FC4(count,1:length(Plot_Time(1):Plot_Time(2))) = FC4(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_FCz(count,1:length(Plot_Time(1):Plot_Time(2))) = FCz(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_FT10(count,1:length(Plot_Time(1):Plot_Time(2))) = FT10(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_FT7(count,1:length(Plot_Time(1):Plot_Time(2))) = FT7(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_FT8(count,1:length(Plot_Time(1):Plot_Time(2))) = FT8(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_FT9(count,1:length(Plot_Time(1):Plot_Time(2))) = FT9(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_Fp1(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp1(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_Fp2(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp2(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_Fz(count,1:length(Plot_Time(1):Plot_Time(2))) = Fz(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_O1(count,1:length(Plot_Time(1):Plot_Time(2))) = O1(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_O2(count,1:length(Plot_Time(1):Plot_Time(2))) = O2(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_Oz(count,1:length(Plot_Time(1):Plot_Time(2))) = Oz(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_P3(count,1:length(Plot_Time(1):Plot_Time(2))) = P3(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_P4(count,1:length(Plot_Time(1):Plot_Time(2))) = P4(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_PO1(count,1:length(Plot_Time(1):Plot_Time(2))) = PO1(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_PO2(count,1:length(Plot_Time(1):Plot_Time(2))) = PO2(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_Pz(count,1:length(Plot_Time(1):Plot_Time(2))) = Pz(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_T3(count,1:length(Plot_Time(1):Plot_Time(2))) = T3(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_T4(count,1:length(Plot_Time(1):Plot_Time(2))) = T4(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_T5(count,1:length(Plot_Time(1):Plot_Time(2))) = T5(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_T6(count,1:length(Plot_Time(1):Plot_Time(2))) = T6(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_TP7(count,1:length(Plot_Time(1):Plot_Time(2))) = TP7(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_TP8(count,1:length(Plot_Time(1):Plot_Time(2))) = TP8(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_X1(count,1:length(Plot_Time(1):Plot_Time(2))) = X1(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_X2(count,1:length(Plot_Time(1):Plot_Time(2))) = X2(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_X3(count,1:length(Plot_Time(1):Plot_Time(2))) = X3(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
        SS3_X4(count,1:length(Plot_Time(1):Plot_Time(2))) = X4(strobelat(SS3(count))-abs(Plot_Time(1)):strobelat(SS3(count))+abs(Plot_Time(2)));
    end
    
    %set size 4
    for count = 1:length(SS4)
        SS4_A1(count,1:length(Plot_Time(1):Plot_Time(2))) = A1(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_A2(count,1:length(Plot_Time(1):Plot_Time(2))) = A2(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_C3(count,1:length(Plot_Time(1):Plot_Time(2))) = C3(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_C4(count,1:length(Plot_Time(1):Plot_Time(2))) = C4(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_CP3(count,1:length(Plot_Time(1):Plot_Time(2))) = CP3(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_CP4(count,1:length(Plot_Time(1):Plot_Time(2))) = CP4(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_CPz(count,1:length(Plot_Time(1):Plot_Time(2))) = CPz(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_Cz(count,1:length(Plot_Time(1):Plot_Time(2))) = Cz(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_F3(count,1:length(Plot_Time(1):Plot_Time(2))) = F3(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_F4(count,1:length(Plot_Time(1):Plot_Time(2))) = F4(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_F7(count,1:length(Plot_Time(1):Plot_Time(2))) = F7(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_F8(count,1:length(Plot_Time(1):Plot_Time(2))) = F8(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_FC3(count,1:length(Plot_Time(1):Plot_Time(2))) = FC3(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_FC4(count,1:length(Plot_Time(1):Plot_Time(2))) = FC4(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_FCz(count,1:length(Plot_Time(1):Plot_Time(2))) = FCz(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_FT10(count,1:length(Plot_Time(1):Plot_Time(2))) = FT10(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_FT7(count,1:length(Plot_Time(1):Plot_Time(2))) = FT7(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_FT8(count,1:length(Plot_Time(1):Plot_Time(2))) = FT8(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_FT9(count,1:length(Plot_Time(1):Plot_Time(2))) = FT9(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_Fp1(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp1(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_Fp2(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp2(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_Fz(count,1:length(Plot_Time(1):Plot_Time(2))) = Fz(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_O1(count,1:length(Plot_Time(1):Plot_Time(2))) = O1(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_O2(count,1:length(Plot_Time(1):Plot_Time(2))) = O2(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_Oz(count,1:length(Plot_Time(1):Plot_Time(2))) = Oz(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_P3(count,1:length(Plot_Time(1):Plot_Time(2))) = P3(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_P4(count,1:length(Plot_Time(1):Plot_Time(2))) = P4(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_PO1(count,1:length(Plot_Time(1):Plot_Time(2))) = PO1(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_PO2(count,1:length(Plot_Time(1):Plot_Time(2))) = PO2(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_Pz(count,1:length(Plot_Time(1):Plot_Time(2))) = Pz(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_T3(count,1:length(Plot_Time(1):Plot_Time(2))) = T3(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_T4(count,1:length(Plot_Time(1):Plot_Time(2))) = T4(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_T5(count,1:length(Plot_Time(1):Plot_Time(2))) = T5(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_T6(count,1:length(Plot_Time(1):Plot_Time(2))) = T6(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_TP7(count,1:length(Plot_Time(1):Plot_Time(2))) = TP7(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_TP8(count,1:length(Plot_Time(1):Plot_Time(2))) = TP8(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_X1(count,1:length(Plot_Time(1):Plot_Time(2))) = X1(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_X2(count,1:length(Plot_Time(1):Plot_Time(2))) = X2(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_X3(count,1:length(Plot_Time(1):Plot_Time(2))) = X3(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
        SS4_X4(count,1:length(Plot_Time(1):Plot_Time(2))) = X4(strobelat(SS4(count))-abs(Plot_Time(1)):strobelat(SS4(count))+abs(Plot_Time(2)));
    end
    
    %set size 5
    for count = 1:length(SS5)
        SS5_A1(count,1:length(Plot_Time(1):Plot_Time(2))) = A1(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_A2(count,1:length(Plot_Time(1):Plot_Time(2))) = A2(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_C3(count,1:length(Plot_Time(1):Plot_Time(2))) = C3(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_C4(count,1:length(Plot_Time(1):Plot_Time(2))) = C4(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_CP3(count,1:length(Plot_Time(1):Plot_Time(2))) = CP3(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_CP4(count,1:length(Plot_Time(1):Plot_Time(2))) = CP4(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_CPz(count,1:length(Plot_Time(1):Plot_Time(2))) = CPz(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_Cz(count,1:length(Plot_Time(1):Plot_Time(2))) = Cz(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_F3(count,1:length(Plot_Time(1):Plot_Time(2))) = F3(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_F4(count,1:length(Plot_Time(1):Plot_Time(2))) = F4(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_F7(count,1:length(Plot_Time(1):Plot_Time(2))) = F7(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_F8(count,1:length(Plot_Time(1):Plot_Time(2))) = F8(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_FC3(count,1:length(Plot_Time(1):Plot_Time(2))) = FC3(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_FC4(count,1:length(Plot_Time(1):Plot_Time(2))) = FC4(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_FCz(count,1:length(Plot_Time(1):Plot_Time(2))) = FCz(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_FT10(count,1:length(Plot_Time(1):Plot_Time(2))) = FT10(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_FT7(count,1:length(Plot_Time(1):Plot_Time(2))) = FT7(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_FT8(count,1:length(Plot_Time(1):Plot_Time(2))) = FT8(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_FT9(count,1:length(Plot_Time(1):Plot_Time(2))) = FT9(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_Fp1(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp1(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_Fp2(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp2(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_Fz(count,1:length(Plot_Time(1):Plot_Time(2))) = Fz(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_O1(count,1:length(Plot_Time(1):Plot_Time(2))) = O1(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_O2(count,1:length(Plot_Time(1):Plot_Time(2))) = O2(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_Oz(count,1:length(Plot_Time(1):Plot_Time(2))) = Oz(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_P3(count,1:length(Plot_Time(1):Plot_Time(2))) = P3(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_P4(count,1:length(Plot_Time(1):Plot_Time(2))) = P4(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_PO1(count,1:length(Plot_Time(1):Plot_Time(2))) = PO1(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_PO2(count,1:length(Plot_Time(1):Plot_Time(2))) = PO2(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_Pz(count,1:length(Plot_Time(1):Plot_Time(2))) = Pz(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_T3(count,1:length(Plot_Time(1):Plot_Time(2))) = T3(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_T4(count,1:length(Plot_Time(1):Plot_Time(2))) = T4(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_T5(count,1:length(Plot_Time(1):Plot_Time(2))) = T5(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_T6(count,1:length(Plot_Time(1):Plot_Time(2))) = T6(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_TP7(count,1:length(Plot_Time(1):Plot_Time(2))) = TP7(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_TP8(count,1:length(Plot_Time(1):Plot_Time(2))) = TP8(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_X1(count,1:length(Plot_Time(1):Plot_Time(2))) = X1(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_X2(count,1:length(Plot_Time(1):Plot_Time(2))) = X2(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_X3(count,1:length(Plot_Time(1):Plot_Time(2))) = X3(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
        SS5_X4(count,1:length(Plot_Time(1):Plot_Time(2))) = X4(strobelat(SS5(count))-abs(Plot_Time(1)):strobelat(SS5(count))+abs(Plot_Time(2)));
    end
    
    %set size 6
    for count = 1:length(SS6)
        SS6_A1(count,1:length(Plot_Time(1):Plot_Time(2))) = A1(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_A2(count,1:length(Plot_Time(1):Plot_Time(2))) = A2(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_C3(count,1:length(Plot_Time(1):Plot_Time(2))) = C3(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_C4(count,1:length(Plot_Time(1):Plot_Time(2))) = C4(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_CP3(count,1:length(Plot_Time(1):Plot_Time(2))) = CP3(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_CP4(count,1:length(Plot_Time(1):Plot_Time(2))) = CP4(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_CPz(count,1:length(Plot_Time(1):Plot_Time(2))) = CPz(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_Cz(count,1:length(Plot_Time(1):Plot_Time(2))) = Cz(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_F3(count,1:length(Plot_Time(1):Plot_Time(2))) = F3(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_F4(count,1:length(Plot_Time(1):Plot_Time(2))) = F4(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_F7(count,1:length(Plot_Time(1):Plot_Time(2))) = F7(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_F8(count,1:length(Plot_Time(1):Plot_Time(2))) = F8(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_FC3(count,1:length(Plot_Time(1):Plot_Time(2))) = FC3(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_FC4(count,1:length(Plot_Time(1):Plot_Time(2))) = FC4(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_FCz(count,1:length(Plot_Time(1):Plot_Time(2))) = FCz(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_FT10(count,1:length(Plot_Time(1):Plot_Time(2))) = FT10(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_FT7(count,1:length(Plot_Time(1):Plot_Time(2))) = FT7(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_FT8(count,1:length(Plot_Time(1):Plot_Time(2))) = FT8(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_FT9(count,1:length(Plot_Time(1):Plot_Time(2))) = FT9(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_Fp1(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp1(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_Fp2(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp2(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_Fz(count,1:length(Plot_Time(1):Plot_Time(2))) = Fz(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_O1(count,1:length(Plot_Time(1):Plot_Time(2))) = O1(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_O2(count,1:length(Plot_Time(1):Plot_Time(2))) = O2(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_Oz(count,1:length(Plot_Time(1):Plot_Time(2))) = Oz(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_P3(count,1:length(Plot_Time(1):Plot_Time(2))) = P3(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_P4(count,1:length(Plot_Time(1):Plot_Time(2))) = P4(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_PO1(count,1:length(Plot_Time(1):Plot_Time(2))) = PO1(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_PO2(count,1:length(Plot_Time(1):Plot_Time(2))) = PO2(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_Pz(count,1:length(Plot_Time(1):Plot_Time(2))) = Pz(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_T3(count,1:length(Plot_Time(1):Plot_Time(2))) = T3(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_T4(count,1:length(Plot_Time(1):Plot_Time(2))) = T4(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_T5(count,1:length(Plot_Time(1):Plot_Time(2))) = T5(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_T6(count,1:length(Plot_Time(1):Plot_Time(2))) = T6(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_TP7(count,1:length(Plot_Time(1):Plot_Time(2))) = TP7(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_TP8(count,1:length(Plot_Time(1):Plot_Time(2))) = TP8(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_X1(count,1:length(Plot_Time(1):Plot_Time(2))) = X1(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_X2(count,1:length(Plot_Time(1):Plot_Time(2))) = X2(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_X3(count,1:length(Plot_Time(1):Plot_Time(2))) = X3(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
        SS6_X4(count,1:length(Plot_Time(1):Plot_Time(2))) = X4(strobelat(SS6(count))-abs(Plot_Time(1)):strobelat(SS6(count))+abs(Plot_Time(2)));
    end
    
    %set size 7
    for count = 1:length(SS7)
        SS7_A1(count,1:length(Plot_Time(1):Plot_Time(2))) = A1(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_A2(count,1:length(Plot_Time(1):Plot_Time(2))) = A2(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_C3(count,1:length(Plot_Time(1):Plot_Time(2))) = C3(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_C4(count,1:length(Plot_Time(1):Plot_Time(2))) = C4(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_CP3(count,1:length(Plot_Time(1):Plot_Time(2))) = CP3(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_CP4(count,1:length(Plot_Time(1):Plot_Time(2))) = CP4(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_CPz(count,1:length(Plot_Time(1):Plot_Time(2))) = CPz(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_Cz(count,1:length(Plot_Time(1):Plot_Time(2))) = Cz(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_F3(count,1:length(Plot_Time(1):Plot_Time(2))) = F3(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_F4(count,1:length(Plot_Time(1):Plot_Time(2))) = F4(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_F7(count,1:length(Plot_Time(1):Plot_Time(2))) = F7(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_F8(count,1:length(Plot_Time(1):Plot_Time(2))) = F8(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_FC3(count,1:length(Plot_Time(1):Plot_Time(2))) = FC3(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_FC4(count,1:length(Plot_Time(1):Plot_Time(2))) = FC4(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_FCz(count,1:length(Plot_Time(1):Plot_Time(2))) = FCz(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_FT10(count,1:length(Plot_Time(1):Plot_Time(2))) = FT10(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_FT7(count,1:length(Plot_Time(1):Plot_Time(2))) = FT7(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_FT8(count,1:length(Plot_Time(1):Plot_Time(2))) = FT8(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_FT9(count,1:length(Plot_Time(1):Plot_Time(2))) = FT9(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_Fp1(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp1(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_Fp2(count,1:length(Plot_Time(1):Plot_Time(2))) = Fp2(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_Fz(count,1:length(Plot_Time(1):Plot_Time(2))) = Fz(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_O1(count,1:length(Plot_Time(1):Plot_Time(2))) = O1(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_O2(count,1:length(Plot_Time(1):Plot_Time(2))) = O2(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_Oz(count,1:length(Plot_Time(1):Plot_Time(2))) = Oz(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_P3(count,1:length(Plot_Time(1):Plot_Time(2))) = P3(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_P4(count,1:length(Plot_Time(1):Plot_Time(2))) = P4(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_PO1(count,1:length(Plot_Time(1):Plot_Time(2))) = PO1(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_PO2(count,1:length(Plot_Time(1):Plot_Time(2))) = PO2(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_Pz(count,1:length(Plot_Time(1):Plot_Time(2))) = Pz(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_T3(count,1:length(Plot_Time(1):Plot_Time(2))) = T3(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_T4(count,1:length(Plot_Time(1):Plot_Time(2))) = T4(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_T5(count,1:length(Plot_Time(1):Plot_Time(2))) = T5(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_T6(count,1:length(Plot_Time(1):Plot_Time(2))) = T6(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_TP7(count,1:length(Plot_Time(1):Plot_Time(2))) = TP7(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_TP8(count,1:length(Plot_Time(1):Plot_Time(2))) = TP8(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_X1(count,1:length(Plot_Time(1):Plot_Time(2))) = X1(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_X2(count,1:length(Plot_Time(1):Plot_Time(2))) = X2(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_X3(count,1:length(Plot_Time(1):Plot_Time(2))) = X3(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
        SS7_X4(count,1:length(Plot_Time(1):Plot_Time(2))) = X4(strobelat(SS7(count))-abs(Plot_Time(1)):strobelat(SS7(count))+abs(Plot_Time(2)));
    end
    
    keep VEP_* SS1_* SS2_* SS3_* SS4_* SS5_* SS6_* SS7_* saveFlag file_list file Plot_Time ...
        q c qcq 
    
    if saveFlag == 1
        disp('Saving...')
        save(['/volumes/Dump/GT_EEG_Data/' file_list(file).name '.mat'],'-mat')
    end
    
    keep saveFlag file_list file Plot_Time q c qcq
    
end