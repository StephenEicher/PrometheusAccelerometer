clc; clear all;close all;
%% User Input List
testData = csvread('Trial00.csv',1, 0); %import the data from the csv file
%In order for this import format to work, the csv file must be in the same
%directory as the script.

dataStart = 1; %This variable is roughly the time at which the plots will start
dataEnd = 5; %This variable is roughly the time at which the plots will end
fullData = false; %if you set fullData to true, the dataStart and dataEnd
%start points will be overridden and the script will plot the entire range
%of collected data

plotRaw = false; %if you set plotRaw to true, the plot will be populated by
%raw, unsmoothed data instead of smoothed data;
mAvg_Range = 400; %Range of moving average - lower values will give noisier data


%% ^^^^ Everything you should need to generate plots is right up here ^^^^

%% Data Analysis Begins
%Change the trial number to change the data you want to import

%% Collect and labelling data
if plotRaw %Check if plotRaw is true
xData = testData(:, 2);
zData = testData(:, 3);
yData = testData(:, 4);
%If user specifies rawData as true, no smoothing; just copy the columns in
%to new data arrays
else
xData = movmean(testData(:, 2), mAvg_Range); %Apply a moving average over the data to smoothe out noise
zData = movmean(testData(:, 3), mAvg_Range); %Smooth Z
yData = movmean(testData(:, 4), mAvg_Range); %smooth Y
%These variables are taken by extracting the entire column from the
%imported data file and then applying the moving average.
end


time_raw = testData(:, 1); %Raw time data
time_s = time_raw /10^6; %convert the time from microseconds to seconds

magnitude = sqrt((xData).^2 + (zData).^2 + (yData).^2);
%by taking the norm of the three accelerations find the magnitude

%% Determining the plot ranges
if fullData %Check if fullData is set to true; if set to true, plot the whole data
    pStart = 1;
    pFinish = size(time_s);
else %If fullData is not set to true, set the start/end points based on the user inputs
    pStart = ceil((size(time_s) / max(time_s)) * dataStart); %Entry from which the plots start
    pFinish = ceil((size(time_s) / max(time_s)) * dataEnd); %Entry at which the plots end
end
%Create a combined plot of all of the data from pStart to pFinish;


%% Plot creation
figure(1)
grid on;
subplot(2, 2, 1); %This creates the upper left plot in the combined plot window
plot(time_s(pStart:pFinish), xData(pStart:pFinish), 'LineWidth', 2);
title('Smoothed X acceleration vs time'); %Labelling the title and the axes
ylabel('Accel (g)');
xlabel('Time (s)');
%figure(2)
subplot(2, 2, 2); %Plot in the upper right of the combined plot window
plot(time_s(pStart:pFinish), yData(pStart:pFinish), 'LineWidth', 2);
title('Smoothed Y acceleration vs time'); %Labelling the title and the axes
ylabel('Accel (g)');
xlabel('Time (s)');
subplot(2, 2, 3);
%Creates the plot in the lower left
%figure(3)
plot(time_s(pStart:pFinish), zData(pStart:pFinish), 'LineWidth', 2);
title('Smoothed Z acceleration vs time'); %Labelling the title and the axes
ylabel('Accel (g)');
xlabel('Time (s)');
%figure(4)
%Creates the plot in the lower right
subplot(2, 2, 4);
plot(time_s(pStart:pFinish), magnitude(pStart:pFinish), 'LineWidth', 2);
title('Magnitude');
ylabel('Magnitude (g)');
xlabel('Time (s)');

fprintf('The greatest accel in the x dir is: %f g \n', max(abs(xData)));
fprintf('The greatest accel in the y dir is: %f g\n', max(abs(yData)));
fprintf('The greatest accel in the z dir is: %f g\n', max(abs(zData)));
fprintf('The largest magnitude of accel is: %f g\n', max(magnitude));