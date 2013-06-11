%   DMS Mesurement Stript
%   
%   Script to measure strain on 1 to 4 dms sensors
%   
%   If normalise is set to 1
%   Wait 1 sec befor applying load to collect initial values
%
%   Simon Grob
%   sigrob@ethz.ch
%
%
%	Revision 0.1    11.06.2013
%********************************************************************

NumChannels = 4; % Number of Active Cannels 1-4

GF = 1.65; %Gauge Factor
NominalBridgeResistance = 120; %Ohm

mesurementTime = 10; % sec
SampleRate = 2; % Hz

normalise = 1; % True = 1; False = 0

s = daq.createSession('ni');
s.addAnalogInputChannel('cDAQ1Mod1', 0:NumChannels-1, 'Bridge');
for n = 1:NumChannels
    s.Channels(n).BridgeMode = 'Quarter';
    s.Channels(n).NominalBridgeResistance = NominalBridgeResistance;
    s.Channels(n).ADCTimingMode = 'HighSpeed';
end
    

s.Rate = SampleRate;
s.DurationInSeconds = mesurementTime;

 
[data,time] = s.startForeground;

if normalise == 1
    temp = zeros(mesurementTime * SampleRate, NumChannels);
    for i = 1:NumChannels
        A = data(1:SampleRate,i);
        NORM = mean(A);
        temp(:,i) = data(:,i)-NORM;
        strain = -4 * temp./ (GF*(1+2*temp));        
    end
else   
    strain = -4 * data./ (GF*(1+2*data));
end

figure;
plot(time,strain);

title('DSM mesurement');

xlabel('Time (secs)');
ylabel('Strain');


switch NumChannels
    case 1
        legend('ai0')
    case 2
        legend('ai0','ai1')
    case 3
        legend('ai0','ai1','ai2')
    case 4
        legend('ai0','ai1','ai2','ai3')
end
