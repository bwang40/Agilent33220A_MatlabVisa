classdef FunctionGenerator < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        BasicFunGen            matlab.ui.container.Panel
        ModeWaveSel            matlab.ui.container.Panel
        ButtonGroup            matlab.ui.container.ButtonGroup
        Sine                   matlab.ui.control.ToggleButton
        Square                 matlab.ui.control.ToggleButton
        Triangle               matlab.ui.control.ToggleButton
        Rampup                 matlab.ui.control.ToggleButton
        RampDown               matlab.ui.control.ToggleButton
        Arb                    matlab.ui.control.ToggleButton
        ButtonGroup2           matlab.ui.container.ButtonGroup
        continuous             matlab.ui.control.ToggleButton
        burst                  matlab.ui.control.ToggleButton
        AM                     matlab.ui.control.ToggleButton
        FM                     matlab.ui.control.ToggleButton
        WaveformPlot           matlab.ui.container.Panel
        UIAxes                 matlab.ui.control.UIAxes
        Connection             matlab.ui.container.Panel
        ConnectionSW           matlab.ui.control.ToggleSwitch
        ConnectionLamp         matlab.ui.control.Lamp
        LabelConnectionLamp    matlab.ui.control.Label
        EnableOutputSW         matlab.ui.control.ToggleSwitch
        LabelEnableOutputLamp  matlab.ui.control.Label
        EnableOutputLamp       matlab.ui.control.Lamp
        LableIPADD             matlab.ui.control.Label
        IPADD                  matlab.ui.control.EditField
        Label3                 matlab.ui.control.Label
        ValueSetup             matlab.ui.container.Panel
        Amplitude              matlab.ui.container.Panel
        AmplitudeTextbox       matlab.ui.control.NumericEditField
        Label                  matlab.ui.control.Label
        AmplitudeSlider        matlab.ui.control.Slider
        OutputImpedence        matlab.ui.container.Panel
        ImpedanceTextbox       matlab.ui.control.NumericEditField
        LabelSlider            matlab.ui.control.Label
        ImpedanceSlider        matlab.ui.control.Slider
        Panel2                 matlab.ui.container.Panel
        FrequencyTextbox       matlab.ui.control.NumericEditField
        SetFreqBtn             matlab.ui.control.Button
        Panel3                 matlab.ui.container.Panel
        Label2                 matlab.ui.control.Label
        Slider                 matlab.ui.control.Slider
        NumericEditField       matlab.ui.control.NumericEditField
        ArbiFunGen             matlab.ui.container.Panel
        Waveform1              matlab.ui.container.Panel
        loadwav1               matlab.ui.control.Button
        clearwav1              matlab.ui.control.Button
        UIWave1                matlab.ui.control.UIAxes
        Button                 matlab.ui.control.Button
        Waveform2              matlab.ui.container.Panel
        loadwav2               matlab.ui.control.Button
        clearwav2              matlab.ui.control.Button
        UIAxes2                matlab.ui.control.UIAxes
        Button2                matlab.ui.control.Button
        Waveform3              matlab.ui.container.Panel
        loadwav3               matlab.ui.control.Button
        clearwav3              matlab.ui.control.Button
        UIAxes3                matlab.ui.control.UIAxes
        Button3                matlab.ui.control.Button
        Waveform4              matlab.ui.container.Panel
        loadwav4               matlab.ui.control.Button
        clearwav4              matlab.ui.control.Button
        UIAxes4                matlab.ui.control.UIAxes
        Button4                matlab.ui.control.Button
        LabelDropDown          matlab.ui.control.Label
        DropDown               matlab.ui.control.DropDown
    end




    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            global myFGen;
            myFGen = fgen();
            ipadd = app.IPADD.Value;
            myFGen.Resource = strcat('TCPIP0::',ipadd,'::inst0::INSTR');
        end

        % Callback function
        function Connect(app, event)
            
        end

        % Value changed function: EnableOutputSW
        function OutputEnable(app, event)
            global myFGen;
            value = app.EnableOutputSW.Value;
            if strcmp(app.ConnectionSW.Value,'On')
                if strcmp(value,'Off') 
                    disableOutput(myFGen);
                    app.EnableOutputLamp.Enable = 'Off';
                elseif strcmp(value,'On')
                    enableOutput(myFGen);
                    app.EnableOutputLamp.Enable = 'On';
                end
            end

        end

        % Value changed function: ConnectionSW
        function ConnectSW(app, event)
            global myFGen;
            value = app.ConnectionSW.Value;
            if strcmp(value,'On')
                connect(myFGen);
                app.ConnectionLamp.Enable = 'On';
            elseif strcmp(value,'Off')
                disconnect(myFGen);
                app.ConnectionLamp.Enable = 'Off';
            end
            
        end

        % Selection changed function: ButtonGroup
        function ButtonGroupSelectionChanged(app, event)
            global myFGen;
            selectedButton = app.ButtonGroup.SelectedObject;
            if strcmp(app.ConnectionSW.Value,'On')
                switch selectedButton
                    case app.Sine
                        myFGen.Waveform = 'sine';
                    case app.Square
                        myFGen.Waveform = 'Square';
                    case app.Triangle
                        myFGen.Waveform = 'Triangle';
                    case app.Rampup
                        myFGen.Waveform = 'Rampup';
                    case app.RampDown
                        myFGen.Waveform = 'RampDown';
                    case app.Arb
                        myFGen.Waveform = 'Arb';
                end
            end
        end

        % Selection changed function: ButtonGroup2
        function ButtonGroup2SelectionChanged(app, event)
            global myFGen;
            selectedButton = app.ButtonGroup2.SelectedObject;
            if strcmp(app.ConnectionSW.Value,'On')
                switch selectedButton
                    case app.continuous
                        myFGen.Mode = 'continuous';
                    case app.burst
                        myFGen.Mode = 'burst';
                    case app.AM
                        myFGen.Mode = 'AM';
                    case app.FM
                        myFGen.Mode = 'FM';
                end
            end
        end

        % Button pushed function: SetFreqBtn
        function SetFreqBtnButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                freq = app.FrequencyTextbox.Value;
                myFGen.Frequency = freq;
            end
        end

        % Value changed function: FrequencyTextbox
        function FrequencyTextboxValueChanged(app, event)
            value = app.FrequencyTextbox.Value;
        end

        % Value changed function: ImpedanceSlider
        function ImpedanceSliderValueChanged(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                value = app.ImpedanceSlider.Value;
                value = round(value);
                app.ImpedanceTextbox.Value = value;
                myFGen.OutputImpedance = value;
            end
        end

        % Value changed function: ImpedanceTextbox
        function ImpedanceTextboxValueChanged(app, event)
            value = app.ImpedanceTextbox.Value;
        end

        % Value changed function: AmplitudeSlider
        function AmplitudeSliderValueChanged(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                value = app.AmplitudeSlider.Value;
                value = round(value*1000)/1000;
                app.AmplitudeTextbox.Value = value;
                myFGen.Amplitude = value;
            end
        end

        % Value changed function: AmplitudeTextbox
        function AmplitudeTextboxValueChanged(app, event)
            value = app.AmplitudeTextbox.Value;
            
        end

        % Value changed function: Slider
        function SliderValueChanged(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                value = app.Slider.Value;
                value = round(value*1000)/1000;
                app.NumericEditField.Value = value;
                myFGen.Offset = value;
            end
        end

        % Value changed function: NumericEditField
        function NumericEditFieldValueChanged(app, event)
            value = app.NumericEditField.Value;
        end

        % Button pushed function: loadwav1
        function loadwav1ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                if strcmp(app.DropDown.Value,'Default');
                    fs = 65535; %65,535*200 = 13,107,000
                    T = 1/fs;
                    f1 = 5000000/10000; %5Mhz freq = 10000
                    t = 0:T:1/f1*10;    %10 cycles
                    sin_wave = sin(2*pi*f1*t);
                    sin_wave_with_zero = [sin_wave, zeros(65535-length(sin_wave),1)'];
                    h1 = downloadWaveform (myFGen, sin_wave_with_zero);
                    plot(app.UIWave1,sin_wave_with_zero(1:3000));
                end
            end
            
        end

        % Button pushed function: clearwav1
        function clearwav1ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                removeWaveform(myFGen,1);
                plot(app.UIWave1,zeros(65535,1));
            end
        end

        % Button pushed function: clearwav2
        function clearwav2ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                removeWaveform(myFGen,2);
                plot(app.UIAxes2,zeros(65535,1));
            end
        end

        % Button pushed function: clearwav3
        function clearwav3ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                removeWaveform(myFGen,3);
                plot(app.UIAxes3,zeros(65535,1));
            end
        end

        % Button pushed function: clearwav4
        function clearwav4ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                removeWaveform(myFGen,4);
                plot(app.UIAxes4,zeros(65535,1));
            end
        end

        % Button pushed function: loadwav2
        function loadwav2ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                if strcmp(app.DropDown.Value,'Default');
                    fs = 65535; %65,535*200 = 13,107,000
                    T = 1/fs;
                    f1 = 5000000/10000; %5Mhz freq = 10000
                    t = 0:T:1/f1*10;    %10 cycles
                    freq1=4750000/10000;   %start freq = 4.75 Mhz
                    freq2=5250000/10000;   %stop freq = 5.25 Mhz
                    f=freq1:(freq2-freq1)/length(t):freq2-(freq2-freq1)/length(t); 
                    chirp_wave=sin(2*pi*f.*t);
                    chirp_wave_with_zero = [chirp_wave, zeros(65535-length(chirp_wave),1)'];
                    plot(app.UIAxes2,chirp_wave_with_zero(1:3000));
                    h1 = downloadWaveform (myFGen, chirp_wave_with_zero);
                end
            end
        end

        % Callback function
        function EditFieldValueChanged(app, event)
            value = app.EditField.Value;
            
            
        end

        % Button pushed function: loadwav3
        function loadwav3ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                if strcmp(app.DropDown.Value,'Default');
                    fs = 65535; %65,535*200 = 13,107,000
                    T = 1/fs;
                    f1 = 5000000/10000; %5Mhz freq = 10000
                    a = 1/(65535*10000);
                    b = 1/5000000;
                    c = round(b/a/2);
                    rect = [ones(1,c) -ones(1,c)];
                    rect_wave = [rect rect rect rect rect rect rect rect rect rect];
                    rect_wave_with_zero = [rect_wave, zeros(65535-length(rect_wave),1)'];
                    plot(app.UIAxes3,rect_wave_with_zero(1:3000));
                    h3 = downloadWaveform (myFGen, rect_wave_with_zero);
                end
                
            end
            
        end

        % Button pushed function: loadwav4
        function loadwav4ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                if strcmp(app.DropDown.Value,'Default');
                    fs = 65535; %65,535*200 = 13,107,000
                    T = 1/fs;
                    f1 = 5000000/10000; %5Mhz freq = 10000
                    t = 0:T:1/f1*1;    %10 cycles
                    single_sin_wave = sin(2*pi*f1*t);
                    single_sin_wave_with_zero = [single_sin_wave, zeros(65535-length(single_sin_wave),1)'];
                    plot(app.UIAxes4,single_sin_wave_with_zero(1:3000));
                    h4 = downloadWaveform (myFGen, single_sin_wave_with_zero);
                end
            end
        end

        % Button pushed function: Button
        function ButtonButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                selectWaveform (myFGen, 1);
            end
        end

        % Button pushed function: Button2
        function Button2ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                selectWaveform (myFGen, 2);
            end
        end

        % Button pushed function: Button3
        function Button3ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                selectWaveform (myFGen, 3);
            end
        end

        % Button pushed function: Button4
        function Button4ButtonPushed(app, event)
            global myFGen;
            if strcmp(app.ConnectionSW.Value,'On')
                selectWaveform (myFGen, 4);
            end
        end

        % Value changed function: DropDown
        function DropDownValueChanged(app, event)
            value = app.DropDown.Value;
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [101 101 1116 670];
            app.UIFigure.Name = 'UI Figure';

            % Create BasicFunGen
            app.BasicFunGen = uipanel(app.UIFigure);
            app.BasicFunGen.Position = [27 10 626 653];

            % Create ModeWaveSel
            app.ModeWaveSel = uipanel(app.BasicFunGen);
            app.ModeWaveSel.Position = [304 0 152 404];

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.ModeWaveSel);
            app.ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);
            app.ButtonGroup.TitlePosition = 'centertop';
            app.ButtonGroup.Title = 'Waveform Type';
            app.ButtonGroup.BackgroundColor = [0.8275 0.6196 0.9686];
            app.ButtonGroup.FontWeight = 'bold';
            app.ButtonGroup.FontSize = 14;
            app.ButtonGroup.Position = [13 0 125 223];

            % Create Sine
            app.Sine = uitogglebutton(app.ButtonGroup);
            app.Sine.Text = 'Sine';
            app.Sine.FontSize = 16;
            app.Sine.FontWeight = 'bold';
            app.Sine.Position = [11 167 100 31];
            app.Sine.Value = true;

            % Create Square
            app.Square = uitogglebutton(app.ButtonGroup);
            app.Square.Text = 'Square';
            app.Square.FontSize = 16;
            app.Square.FontWeight = 'bold';
            app.Square.Position = [11 135 100 31];

            % Create Triangle
            app.Triangle = uitogglebutton(app.ButtonGroup);
            app.Triangle.Text = 'Triangle';
            app.Triangle.FontSize = 16;
            app.Triangle.FontWeight = 'bold';
            app.Triangle.Position = [11 103 100 31];

            % Create Rampup
            app.Rampup = uitogglebutton(app.ButtonGroup);
            app.Rampup.Text = 'Rampup';
            app.Rampup.FontSize = 16;
            app.Rampup.FontWeight = 'bold';
            app.Rampup.Position = [11 71 100 31];

            % Create RampDown
            app.RampDown = uitogglebutton(app.ButtonGroup);
            app.RampDown.Text = 'RampDown';
            app.RampDown.FontSize = 16;
            app.RampDown.FontWeight = 'bold';
            app.RampDown.Position = [11 39 100 31];

            % Create Arb
            app.Arb = uitogglebutton(app.ButtonGroup);
            app.Arb.Text = 'Arb';
            app.Arb.FontSize = 16;
            app.Arb.FontWeight = 'bold';
            app.Arb.Position = [11 7 100 31];

            % Create ButtonGroup2
            app.ButtonGroup2 = uibuttongroup(app.ModeWaveSel);
            app.ButtonGroup2.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroup2SelectionChanged, true);
            app.ButtonGroup2.TitlePosition = 'centertop';
            app.ButtonGroup2.Title = 'Mode';
            app.ButtonGroup2.BackgroundColor = [0.9255 0.7216 0.6588];
            app.ButtonGroup2.FontWeight = 'bold';
            app.ButtonGroup2.FontSize = 14;
            app.ButtonGroup2.Position = [13 222 125 182];

            % Create continuous
            app.continuous = uitogglebutton(app.ButtonGroup2);
            app.continuous.Text = 'Continuous';
            app.continuous.FontSize = 16;
            app.continuous.FontWeight = 'bold';
            app.continuous.Position = [11 124 100 33];
            app.continuous.Value = true;

            % Create burst
            app.burst = uitogglebutton(app.ButtonGroup2);
            app.burst.Text = 'burst';
            app.burst.FontSize = 16;
            app.burst.FontWeight = 'bold';
            app.burst.Position = [11 94 100 29];

            % Create AM
            app.AM = uitogglebutton(app.ButtonGroup2);
            app.AM.Text = 'AM';
            app.AM.FontSize = 16;
            app.AM.FontWeight = 'bold';
            app.AM.Position = [11 66 100 27];

            % Create FM
            app.FM = uitogglebutton(app.ButtonGroup2);
            app.FM.Text = 'FM';
            app.FM.FontSize = 16;
            app.FM.FontWeight = 'bold';
            app.FM.Position = [11 38 100 27];

            % Create WaveformPlot
            app.WaveformPlot = uipanel(app.BasicFunGen);
            app.WaveformPlot.Position = [0 403 625 250];

            % Create UIAxes
            app.UIAxes = uiaxes(app.WaveformPlot);
            xlabel(app.UIAxes, 'Time')
            ylabel(app.UIAxes, 'Amplitude')
            app.UIAxes.GridAlpha = 0.15;
            app.UIAxes.MinorGridAlpha = 0.25;
            app.UIAxes.Box = 'on';
            app.UIAxes.Color = [0 0 0];
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [6 22 587 218];

            % Create Connection
            app.Connection = uipanel(app.BasicFunGen);
            app.Connection.ForegroundColor = [0.1216 0.0824 0.0824];
            app.Connection.TitlePosition = 'centertop';
            app.Connection.Title = 'Connection';
            app.Connection.BackgroundColor = [0.9373 0.9373 0.9373];
            app.Connection.FontWeight = 'bold';
            app.Connection.Position = [455 0 170 404];

            % Create ConnectionSW
            app.ConnectionSW = uiswitch(app.Connection, 'toggle');
            app.ConnectionSW.ValueChangedFcn = createCallbackFcn(app, @ConnectSW, true);
            app.ConnectionSW.Position = [27 236 20 45];

            % Create ConnectionLamp
            app.ConnectionLamp = uilamp(app.Connection);
            app.ConnectionLamp.Enable = 'off';
            app.ConnectionLamp.Position = [27 196 20 20];

            % Create LabelConnectionLamp
            app.LabelConnectionLamp = uilabel(app.Connection);
            app.LabelConnectionLamp.HorizontalAlignment = 'center';
            app.LabelConnectionLamp.FontWeight = 'bold';
            app.LabelConnectionLamp.Position = [13 174 48 15];
            app.LabelConnectionLamp.Text = 'Connect';

            % Create EnableOutputSW
            app.EnableOutputSW = uiswitch(app.Connection, 'toggle');
            app.EnableOutputSW.ValueChangedFcn = createCallbackFcn(app, @OutputEnable, true);
            app.EnableOutputSW.Position = [109 236 20 45];

            % Create LabelEnableOutputLamp
            app.LabelEnableOutputLamp = uilabel(app.Connection);
            app.LabelEnableOutputLamp.HorizontalAlignment = 'center';
            app.LabelEnableOutputLamp.FontWeight = 'bold';
            app.LabelEnableOutputLamp.Position = [79 174 80 15];
            app.LabelEnableOutputLamp.Text = 'Output Enable';

            % Create EnableOutputLamp
            app.EnableOutputLamp = uilamp(app.Connection);
            app.EnableOutputLamp.Enable = 'off';
            app.EnableOutputLamp.Position = [109 196 20 20];
            app.EnableOutputLamp.Color = [1 0 0];

            % Create LableIPADD
            app.LableIPADD = uilabel(app.Connection);
            app.LableIPADD.HorizontalAlignment = 'right';
            app.LableIPADD.VerticalAlignment = 'top';
            app.LableIPADD.Position = [11 345 46 15];
            app.LableIPADD.Text = 'IP ADD :';

            % Create IPADD
            app.IPADD = uieditfield(app.Connection, 'text');
            app.IPADD.HorizontalAlignment = 'center';
            app.IPADD.FontColor = [0 1 0];
            app.IPADD.BackgroundColor = [0 0 0];
            app.IPADD.Position = [61 342 102 20];
            app.IPADD.Value = '192.168.1.120';

            % Create Label3
            app.Label3 = uilabel(app.Connection);
            app.Label3.HorizontalAlignment = 'center';
            app.Label3.FontSize = 16;
            app.Label3.FontWeight = 'bold';
            app.Label3.Position = [11 29 149 95];
            app.Label3.Text = {'Agilent 33220A'; 'Function Generator'; 'Written By:'; 'Boyang Wang'; 'Version 1.0'};

            % Create ValueSetup
            app.ValueSetup = uipanel(app.BasicFunGen);
            app.ValueSetup.Position = [0 0 305 404];

            % Create Amplitude
            app.Amplitude = uipanel(app.ValueSetup);
            app.Amplitude.TitlePosition = 'centertop';
            app.Amplitude.Title = 'Amplitude';
            app.Amplitude.BackgroundColor = [0.9255 0.6039 0.8235];
            app.Amplitude.FontWeight = 'bold';
            app.Amplitude.FontSize = 16;
            app.Amplitude.Position = [0 295 305 109];

            % Create AmplitudeTextbox
            app.AmplitudeTextbox = uieditfield(app.Amplitude, 'numeric');
            app.AmplitudeTextbox.Limits = [0.01 10];
            app.AmplitudeTextbox.ValueChangedFcn = createCallbackFcn(app, @AmplitudeTextboxValueChanged, true);
            app.AmplitudeTextbox.HorizontalAlignment = 'center';
            app.AmplitudeTextbox.FontColor = [0 1 0];
            app.AmplitudeTextbox.BackgroundColor = [0.0588 0.0549 0.0549];
            app.AmplitudeTextbox.Position = [184 50 100 22];
            app.AmplitudeTextbox.Value = 1;

            % Create Label
            app.Label = uilabel(app.Amplitude);
            app.Label.HorizontalAlignment = 'right';
            app.Label.VerticalAlignment = 'top';
            app.Label.Position = [21 56 55 15];
            app.Label.Text = 'Amplitude';

            % Create AmplitudeSlider
            app.AmplitudeSlider = uislider(app.Amplitude);
            app.AmplitudeSlider.Limits = [0.01 10];
            app.AmplitudeSlider.ValueChangedFcn = createCallbackFcn(app, @AmplitudeSliderValueChanged, true);
            app.AmplitudeSlider.Position = [21 44 263 3];
            app.AmplitudeSlider.Value = 1;

            % Create OutputImpedence
            app.OutputImpedence = uipanel(app.ValueSetup);
            app.OutputImpedence.TitlePosition = 'centertop';
            app.OutputImpedence.Title = 'Output Impedance';
            app.OutputImpedence.BackgroundColor = [0.9255 0.898 0.6039];
            app.OutputImpedence.FontWeight = 'bold';
            app.OutputImpedence.FontSize = 16;
            app.OutputImpedence.Position = [0 186 305 109];

            % Create ImpedanceTextbox
            app.ImpedanceTextbox = uieditfield(app.OutputImpedence, 'numeric');
            app.ImpedanceTextbox.Limits = [1 10000];
            app.ImpedanceTextbox.ValueChangedFcn = createCallbackFcn(app, @ImpedanceTextboxValueChanged, true);
            app.ImpedanceTextbox.HorizontalAlignment = 'center';
            app.ImpedanceTextbox.FontColor = [0 1 0];
            app.ImpedanceTextbox.BackgroundColor = [0.0588 0.0549 0.0549];
            app.ImpedanceTextbox.Position = [184 39 100 22];
            app.ImpedanceTextbox.Value = 50;

            % Create LabelSlider
            app.LabelSlider = uilabel(app.OutputImpedence);
            app.LabelSlider.HorizontalAlignment = 'right';
            app.LabelSlider.VerticalAlignment = 'top';
            app.LabelSlider.Position = [15 45 100 15];
            app.LabelSlider.Text = 'Output Impedance';

            % Create ImpedanceSlider
            app.ImpedanceSlider = uislider(app.OutputImpedence);
            app.ImpedanceSlider.Limits = [1 10000];
            app.ImpedanceSlider.ValueChangedFcn = createCallbackFcn(app, @ImpedanceSliderValueChanged, true);
            app.ImpedanceSlider.Position = [21 31 263 3];
            app.ImpedanceSlider.Value = 50;

            % Create Panel2
            app.Panel2 = uipanel(app.ValueSetup);
            app.Panel2.TitlePosition = 'centertop';
            app.Panel2.Title = 'Frequency';
            app.Panel2.BackgroundColor = [0.6039 0.9255 0.7843];
            app.Panel2.FontWeight = 'bold';
            app.Panel2.FontSize = 16;
            app.Panel2.Position = [0 0 305 77];

            % Create FrequencyTextbox
            app.FrequencyTextbox = uieditfield(app.Panel2, 'numeric');
            app.FrequencyTextbox.Limits = [20 20000000];
            app.FrequencyTextbox.ValueChangedFcn = createCallbackFcn(app, @FrequencyTextboxValueChanged, true);
            app.FrequencyTextbox.HorizontalAlignment = 'center';
            app.FrequencyTextbox.FontColor = [0 1 0];
            app.FrequencyTextbox.BackgroundColor = [0.0588 0.0549 0.0549];
            app.FrequencyTextbox.Position = [184 11 100 22];
            app.FrequencyTextbox.Value = 1000;

            % Create SetFreqBtn
            app.SetFreqBtn = uibutton(app.Panel2, 'push');
            app.SetFreqBtn.ButtonPushedFcn = createCallbackFcn(app, @SetFreqBtnButtonPushed, true);
            app.SetFreqBtn.Position = [34 11 100 22];
            app.SetFreqBtn.Text = 'SetFreq';

            % Create Panel3
            app.Panel3 = uipanel(app.ValueSetup);
            app.Panel3.TitlePosition = 'centertop';
            app.Panel3.Title = 'Offset';
            app.Panel3.BackgroundColor = [0.6039 0.7333 0.9255];
            app.Panel3.FontWeight = 'bold';
            app.Panel3.FontSize = 16;
            app.Panel3.Position = [0 77 305 109];

            % Create Label2
            app.Label2 = uilabel(app.Panel3);
            app.Label2.HorizontalAlignment = 'right';
            app.Label2.VerticalAlignment = 'top';
            app.Label2.Position = [52 67 31 15];
            app.Label2.Text = 'Offset';

            % Create Slider
            app.Slider = uislider(app.Panel3);
            app.Slider.Limits = [-4.995 4.995];
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider.Position = [21 51 263 3];

            % Create NumericEditField
            app.NumericEditField = uieditfield(app.ValueSetup, 'numeric');
            app.NumericEditField.Limits = [-4.995 4.995];
            app.NumericEditField.ValueChangedFcn = createCallbackFcn(app, @NumericEditFieldValueChanged, true);
            app.NumericEditField.HorizontalAlignment = 'center';
            app.NumericEditField.FontColor = [0 1 0];
            app.NumericEditField.BackgroundColor = [0.0588 0.0549 0.0549];
            app.NumericEditField.Position = [184 140 100 22];

            % Create ArbiFunGen
            app.ArbiFunGen = uipanel(app.UIFigure);
            app.ArbiFunGen.Position = [652 10 443 653];

            % Create Waveform1
            app.Waveform1 = uipanel(app.ArbiFunGen);
            app.Waveform1.TitlePosition = 'centertop';
            app.Waveform1.Title = 'Waveform1';
            app.Waveform1.BackgroundColor = [0.9412 0.6118 0.6118];
            app.Waveform1.FontWeight = 'bold';
            app.Waveform1.Position = [7 501 430 143];

            % Create loadwav1
            app.loadwav1 = uibutton(app.Waveform1, 'push');
            app.loadwav1.ButtonPushedFcn = createCallbackFcn(app, @loadwav1ButtonPushed, true);
            app.loadwav1.Position = [323 84 100 33];
            app.loadwav1.Text = 'LOAD';

            % Create clearwav1
            app.clearwav1 = uibutton(app.Waveform1, 'push');
            app.clearwav1.ButtonPushedFcn = createCallbackFcn(app, @clearwav1ButtonPushed, true);
            app.clearwav1.Position = [323 46 100 33];
            app.clearwav1.Text = 'CLEAR';

            % Create UIWave1
            app.UIWave1 = uiaxes(app.Waveform1);
            app.UIWave1.GridAlpha = 0.15;
            app.UIWave1.MinorGridAlpha = 0.25;
            app.UIWave1.Position = [6 7 308 110];

            % Create Button
            app.Button = uibutton(app.Waveform1, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonButtonPushed, true);
            app.Button.Position = [323 7 100 33];
            app.Button.Text = 'SELECT';

            % Create Waveform2
            app.Waveform2 = uipanel(app.ArbiFunGen);
            app.Waveform2.TitlePosition = 'centertop';
            app.Waveform2.Title = 'Waveform2';
            app.Waveform2.BackgroundColor = [0.7137 0.6824 0.9451];
            app.Waveform2.FontWeight = 'bold';
            app.Waveform2.Position = [7 358 430 143];

            % Create loadwav2
            app.loadwav2 = uibutton(app.Waveform2, 'push');
            app.loadwav2.ButtonPushedFcn = createCallbackFcn(app, @loadwav2ButtonPushed, true);
            app.loadwav2.Position = [323 84 100 33];
            app.loadwav2.Text = 'LOAD';

            % Create clearwav2
            app.clearwav2 = uibutton(app.Waveform2, 'push');
            app.clearwav2.ButtonPushedFcn = createCallbackFcn(app, @clearwav2ButtonPushed, true);
            app.clearwav2.Position = [323 46 100 33];
            app.clearwav2.Text = 'CLEAR';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.Waveform2);
            app.UIAxes2.GridAlpha = 0.15;
            app.UIAxes2.MinorGridAlpha = 0.25;
            app.UIAxes2.Position = [6 7 308 110];

            % Create Button2
            app.Button2 = uibutton(app.Waveform2, 'push');
            app.Button2.ButtonPushedFcn = createCallbackFcn(app, @Button2ButtonPushed, true);
            app.Button2.Position = [323 8 100 33];
            app.Button2.Text = 'SELECT';

            % Create Waveform3
            app.Waveform3 = uipanel(app.ArbiFunGen);
            app.Waveform3.TitlePosition = 'centertop';
            app.Waveform3.Title = 'Waveform3';
            app.Waveform3.BackgroundColor = [0.651 0.9529 0.5922];
            app.Waveform3.FontWeight = 'bold';
            app.Waveform3.Position = [7 215 430 143];

            % Create loadwav3
            app.loadwav3 = uibutton(app.Waveform3, 'push');
            app.loadwav3.ButtonPushedFcn = createCallbackFcn(app, @loadwav3ButtonPushed, true);
            app.loadwav3.Position = [323 84 100 33];
            app.loadwav3.Text = 'LOAD';

            % Create clearwav3
            app.clearwav3 = uibutton(app.Waveform3, 'push');
            app.clearwav3.ButtonPushedFcn = createCallbackFcn(app, @clearwav3ButtonPushed, true);
            app.clearwav3.Position = [323 45 100 33];
            app.clearwav3.Text = 'CLEAR';

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.Waveform3);
            app.UIAxes3.GridAlpha = 0.15;
            app.UIAxes3.MinorGridAlpha = 0.25;
            app.UIAxes3.Position = [6 7 308 110];

            % Create Button3
            app.Button3 = uibutton(app.Waveform3, 'push');
            app.Button3.ButtonPushedFcn = createCallbackFcn(app, @Button3ButtonPushed, true);
            app.Button3.Position = [323 5 100 33];
            app.Button3.Text = 'SELECT';

            % Create Waveform4
            app.Waveform4 = uipanel(app.ArbiFunGen);
            app.Waveform4.TitlePosition = 'centertop';
            app.Waveform4.Title = 'Waveform4';
            app.Waveform4.BackgroundColor = [0.9412 0.9294 0.6471];
            app.Waveform4.FontWeight = 'bold';
            app.Waveform4.Position = [7 72 430 143];

            % Create loadwav4
            app.loadwav4 = uibutton(app.Waveform4, 'push');
            app.loadwav4.ButtonPushedFcn = createCallbackFcn(app, @loadwav4ButtonPushed, true);
            app.loadwav4.Position = [323 82 100 33];
            app.loadwav4.Text = 'LOAD';

            % Create clearwav4
            app.clearwav4 = uibutton(app.Waveform4, 'push');
            app.clearwav4.ButtonPushedFcn = createCallbackFcn(app, @clearwav4ButtonPushed, true);
            app.clearwav4.Position = [323 43 100 33];
            app.clearwav4.Text = 'CLEAR';

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.Waveform4);
            app.UIAxes4.GridAlpha = 0.15;
            app.UIAxes4.MinorGridAlpha = 0.25;
            app.UIAxes4.Position = [6 7 308 110];

            % Create Button4
            app.Button4 = uibutton(app.Waveform4, 'push');
            app.Button4.ButtonPushedFcn = createCallbackFcn(app, @Button4ButtonPushed, true);
            app.Button4.Position = [323 5 100 33];
            app.Button4.Text = 'SELECT';

            % Create LabelDropDown
            app.LabelDropDown = uilabel(app.ArbiFunGen);
            app.LabelDropDown.HorizontalAlignment = 'right';
            app.LabelDropDown.VerticalAlignment = 'top';
            app.LabelDropDown.Position = [122 30 74 15];
            app.LabelDropDown.Text = 'Other Signals';

            % Create DropDown
            app.DropDown = uidropdown(app.ArbiFunGen);
            app.DropDown.Items = {'Default', 'Option1', 'Option2', 'Option 3', 'Option 4'};
            app.DropDown.ValueChangedFcn = createCallbackFcn(app, @DropDownValueChanged, true);
            app.DropDown.Position = [211 26 100 22];
            app.DropDown.Value = 'Default';
        end
    end

    methods (Access = public)

        % Construct app
        function app = FunctionGenerator

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end 