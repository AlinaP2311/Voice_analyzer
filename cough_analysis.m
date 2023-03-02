clc
clear all
close all
%% extract file 

[audioIn, fs] = audioread('00a0156b-7179-4773-8a2c-4bb919e076bd.wav');

%sound(audioIn,fs)
audioIn(:,2) = [];
T=1/fs;
figure
timeVector = linspace(0,T*numel(audioIn)-1,numel(audioIn));
plot(timeVector,audioIn)
ylabel('Amplitude')
xlabel('Time (s)')
title('Cough')

%% Segment extraction
[maxA,I]=max(audioIn); %number of the loudest
audioIn=audioIn(I-(fs/2):I+(fs/2));
figure()
timeVector = linspace(0,T*(numel(audioIn)-1),numel(audioIn));
plot(timeVector,audioIn)
ylabel('Amplitude')
xlabel('Time (s)')
title('Cough')

%% Filtering


%% Spectogral analysis
%1.Amplitude spectrogramm
ft=fft(audioIn);
tmax=T*numel(audioIn);
N=(tmax*fs)-1;		% Число отсчетов в тестовом сигнале
as=zeros(N,1);
for j=1:N			% Цикл перебора всех элементов разложения
    if (j==1)		% Случай нулевой частоты:
        as(j,1)=sqrt(real(ft(j,1))^2+imag(ft(j,1))^2)/N;
    else				% Для всех частот, кроме нулевой:
        as(j,1)=sqrt(real(ft(j,1))^2+imag(ft(j,1))^2)/N*2;
    end
end

%2. Spectrogramm from 0 Hz	to 0.5fs
df=fs/N;				% Шаг по оси частот
Nd=N/2;
f=zeros(Nd,1);
for j=1:(Nd/2)
    f(j,1)=df*(j-1);	% Расчет аргумента для построения графика
end
figure()
stem(f,as(1:Nd,1),'.')	% График амплитудного спектра
ylabel('Amplitude')
xlabel('Frequency (Hz)')
title('Spectrogramm')
%Лежит в основном в области низких частот

%3. SPD - Spectral Power Density
psd=zeros(N,1);
for j=1:N	% Цикл для перебора всех элементов разложения
    if (j==1)	% Случай нулевой частоты:
        psd(j,1)=1/N*(real(ft(j,1))^2+imag(ft(j,1))^2)/fs;
    else		% Для всех частот, кроме нулевой:
        psd(j,1)=2/N*(real(ft(j,1))^2+imag(ft(j,1))^2)/fs;
    end
end
figure()
plot (f,psd(1:Nd,1))% График СПМ
ylabel('Spectral Power Density')
xlabel('Frequency (Hz)')
title('Spectral Power Density')


%% Pitch
windowLength = round(0.03*fs);
overlapLength = round(0.025*fs);

f0 = pitch(audioIn,fs,'WindowLength',windowLength,'OverlapLength',overlapLength,'Range',[50,250]);

figure
subplot(2,1,1)
plot(timeVector,audioIn)
ylabel('Amplitude')
xlabel('Time (s)')
title('Utterance - Two')

subplot(2,1,2)
timeVectorPitch = linspace(0,T*numel(audioIn)-1,numel(f0));
plot(timeVectorPitch,f0,'*')
xlim([0 timeVectorPitch(1,end)]);
ylabel('Pitch (Hz)')
xlabel('Time (s)')
title('Pitch Contour')

%% distinguish between silence and sound
%1.Rule
pwrThreshold = -20;
[segments,~] = buffer(audioIn,windowLength,overlapLength,'nodelay');
pwr = pow2db(var(segments));
Speech = (pwr > pwrThreshold);

%2.Delete silence segments
s=size(Speech,2);
for i = 1:s 
 if Speech (i) == 0
     f0(i)=NaN;
 end
end

%% After delete silence
figure
subplot(2,1,1)
plot(timeVector,audioIn)
ylabel('Amplitude')
xlabel('Time (s)')
title('Utterance - Two')

subplot(2,1,2) % ПОЧЕМУ-ТО РУГАЕТСЯ НА ОСИ AXES
plot(timeVectorPitch,f0,'*')
xlim([0 timeVectorPitch(1,end)]);
ylabel('Pitch (Hz)')
xlabel('Time (s)')
title('Pitch Contour')

%% Feature extraction
% 1. HNR
Acor=xcorr(audioIn);
HNR=zeros(length(Acor),1);
for i=1:length(Acor)
    HNR(i,1)=Acor(i,1)/Acor(1,1)-Acor(i,1);
end
HNR=zscore(HNR);

%2. Jitter & Shimmer - better be done by PRAAT not matlab
TF = islocalmax(audioIn); %local max
figure()
plot(timeVector,audioIn,timeVector(TF),audioIn(TF),'r*')
ylabel('Amplitude')
xlabel('Time (s)')
title('Local Max')

% Index of local max
k=1;
for i=1:size(TF,1)
    if TF(i,1)==1
        Ind(k)=i;
        k=k+1;
    end
end



s=size(Speech,2);
for i = 1:s 
 if Speech (i) == 0
     f0(i)=NaN;
 end
end

%% MFCC

windowLength = round(0.03*fs);
overlapLength = round(0.025*fs);

% melC = mfcc(audioIn,fs,'Window',hamming(windowLength,'periodic'),'OverlapLength',overlapLength);
% f0 = pitch(audioIn,fs,'WindowLength',windowLength,'OverlapLength',overlapLength);
% feat = [melC,f0];

%coeffs = mfcc(audioIn,fs);
[coeffs,delta,deltaDelta,loc] = mfcc(audioIn,fs);
figure()
plot(coeffs)








