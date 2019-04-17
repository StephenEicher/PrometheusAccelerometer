clc; clear all;close all;
TestData = csvread('Trial00.csv',1, 0); %import the data from the csv file
%In order for this import format to work, the csv file must be in the same
%directory as the script.
mAvg_Range = 800; %Range of moving average - lower values will give noisier data

smoothedX = movmean(TestData(:, 2), mAvg_Range); %Apply a moving average over the data to smoothe out noise
RawX = TestData(:, 2); %Raw x data, unsmoothed
smoothedZ = movmean(TestData(:, 3), mAvg_Range); %Smooth Z
smoothedY = movmean(TestData(:, 4), mAvg_Range); %smooth Y
time_raw = TestData(:, 1); %Raw time data
time_s = time_raw /10^6; %convert the time from microseconds to seconds
magnitude = sqrt((smoothedX).^2 + (smoothedZ).^2 + (smoothedY).^2);

pStart = ceil((size(time_s) / max(time_s)) * 9.6); %Entry from which the plots start
pFinish = ceil((size(time_s) / max(time_s)) * 10); %Entry at which the plots end

%Create a combined plot of all of the data from pStart to pFinish;

figure(1)
grid on;
subplot(2, 2, 1);
plot(time_s(pStart:pFinish), smoothedX(pStart:pFinish), 'LineWidth', 2);
title('Smoothed X acceleration vs time');
ylabel('Accel (g)');
xlabel('Time (s)');
%figure(2)
subplot(2, 2, 2);
plot(time_s(pStart:pFinish), smoothedY(pStart:pFinish), 'LineWidth', 2);
title('Smoothed Y acceleration vs time');
ylabel('Accel (g)');
xlabel('Time (s)');
subplot(2, 2, 3);
%figure(3)
plot(time_s(pStart:pFinish), smoothedZ(pStart:pFinish), 'LineWidth', 2);
title('Smoothed Z acceleration vs time');
ylabel('Accel (g)');
xlabel('Time (s)');
%figure(4)
subplot(2, 2, 4);
plot(time_s(pStart:pFinish), magnitude(pStart:pFinish), 'LineWidth', 2);
title('Magnitude');
ylabel('Magnitude (g)');
xlabel('Time (s)');

