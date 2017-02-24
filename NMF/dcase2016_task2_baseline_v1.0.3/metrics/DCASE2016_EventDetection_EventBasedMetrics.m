classdef DCASE2016_EventDetection_EventBasedMetrics < EventDetectionMetrics
    properties
        time_resolution = 1.0;
        t_collar = 0.2;
        
        overall = struct('Nref',0,...
                         'Nsys',0,...
                         'Nsubs',0,...                     
                         'Ntp',0,...
                         'Nfp',0,...
                         'Nfn',0);
                     
        class_wise = containers.Map();       
    end
    methods
        function obj = DCASE2016_EventDetection_EventBasedMetrics(class_list, varargin)   
            [obj.time_resolution,obj.t_collar,unused] = process_options(varargin,'time_resolution',1.0,'t_collar',0.2);
            obj.class_list = class_list;            
            
            for class_id=1:length(class_list)
                obj.class_wise(obj.class_list{class_id}) = struct('Nref',0,...
                                                                  'Nsys',0,...
                                                                  'Nsubs',0,...                     
                                                                  'Ntp',0,...
                                                                  'Nfp',0,...
                                                                  'Nfn',0);
            end
        end
        
        function condition = onset_condition(obj, annotated_event, system_event, varargin)
            [t_collar,unused] = process_options(varargin,'t_collar',0.2);
            condition = abs(annotated_event.event_onset - system_event.event_onset) <= t_collar;
        end

        function condition = offset_condition(obj, annotated_event, system_event, varargin)
            [t_collar,percentage_of_length,unused] = process_options(varargin,'t_collar',0.2,'percentage_of_length',0.5);
            
            annotated_length = annotated_event.event_offset - annotated_event.event_onset;
            condition = abs(annotated_event.event_offset - system_event.event_offset) <= max(t_collar, percentage_of_length * annotated_length);
        end
        
        function evaluate(obj, system_output, annotated_groundtruth)
            % Overall metrics

            % Total number of detected and reference events
            Nsys = size(system_output,1);
            Nref = size(annotated_groundtruth,1);

            sys_correct = zeros(Nsys,1);
            ref_correct = zeros(Nref,1);
            
            
            % Number of correctly transcribed events, onset within a t_collar range
            for j=1:length(annotated_groundtruth)
                for i=1:length(system_output)
                    label_condition = strcmp(annotated_groundtruth(j).event_label, system_output(i).event_label);
                    
                    onset_condition = obj.onset_condition(annotated_groundtruth(j), system_output(i), 't_collar', obj.t_collar);

                    % Offset within a +/-100 ms range or within 20% of ground-truth event's duration
                    offset_condition = obj.offset_condition(annotated_groundtruth(j), system_output(i), 't_collar', obj.t_collar);

                    %if(label_condition && onset_condition && %offset_condition) % Emmanouil's change
                    if(label_condition && onset_condition)
                        ref_correct(j) = 1;
                        sys_correct(i) = 1;
                        break
                    end
                end
            end
            
            Ntp = sum(sys_correct);
                        
            sys_leftover = find(~sys_correct)';
            ref_leftover = find(~ref_correct)';

            Nsubs = 0;
            for j=ref_leftover
                for i=sys_leftover
                    onset_condition = obj.onset_condition(annotated_groundtruth(j), system_output(i), 't_collar', obj.t_collar);

                    % Offset within a +/-100 ms range or within 20% of ground-truth event's duration
                    offset_condition = obj.offset_condition(annotated_groundtruth(j), system_output(i), 't_collar', obj.t_collar);

                    %if(onset_condition && offset_condition) % Emmanouil's change
                    if(onset_condition)
                        Nsubs = Nsubs + 1;
                        break;
                    end
                end
            end

            Nfp = Nsys - Ntp - Nsubs;
            Nfn = Nref - Ntp - Nsubs;
            
            obj.overall.Nref = obj.overall.Nref + Nref;
            obj.overall.Nsys = obj.overall.Nsys + Nsys;
            obj.overall.Ntp = obj.overall.Ntp + Ntp;
            obj.overall.Nsubs = obj.overall.Nsubs + Nsubs;
            obj.overall.Nfp = obj.overall.Nfp + Nfp;
            obj.overall.Nfn = obj.overall.Nfn + Nfn;

            % Class-wise metrics
            for class_id=1:length(obj.class_list)
                class_label = obj.class_list{class_id};
            
                Nref = 0.0;
                Nsys = 0.0;
                Ntp = 0.0;

                % Count event frequencies in the ground truth
                for i=1:length(annotated_groundtruth)
                    if strcmp(annotated_groundtruth(i).event_label, class_label)
                        Nref = Nref + 1;
                    end
                end

                % Count event frequencies in the system output
                for i=1:length(system_output)
                    if strcmp(system_output(i).event_label, class_label)
                        Nsys = Nsys + 1;
                    end
                end

                for j=1:length(annotated_groundtruth)
                    for i=1:length(system_output)
                        if strcmp(annotated_groundtruth(j).event_label,class_label) && strcmp(system_output(i).event_label, class_label)
                            onset_condition = obj.onset_condition(annotated_groundtruth(j), system_output(i), 't_collar', obj.t_collar);

                            % Offset within a +/-100 ms range or within 20% of ground-truth event's duration
                            offset_condition = obj.offset_condition(annotated_groundtruth(j), system_output(i), 't_collar', obj.t_collar);

                            %if(onset_condition && offset_condition) % Emmanouil's change
                            if(onset_condition)
                                Ntp = Ntp + 1;
                                break
                            end
                        end
                    end
                end
                                
                Nfp = Nsys - Ntp;
                Nfn = Nref - Ntp;
                
                current_class_values = obj.class_wise(class_label);
                current_class_values.Nref = current_class_values.Nref + Nref;
                current_class_values.Nsys = current_class_values.Nsys + Nsys;
                
                current_class_values.Ntp = current_class_values.Ntp + Ntp;
                current_class_values.Nfp = current_class_values.Nfp + Nfp;
                current_class_values.Nfn = current_class_values.Nfn + Nfn;
                obj.class_wise(class_label) = current_class_values;
            end
            
        end
        
        function results = results(obj)          
            results = struct('overall',struct(),'class_wise',containers.Map(),'class_wise_overall',struct());
            
            % Overall metrics
            results.overall.Pre = obj.overall.Ntp / (obj.overall.Nsys + obj.eps);
            results.overall.Rec = obj.overall.Ntp / obj.overall.Nref;            
            results.overall.F = 2 * ((results.overall.Pre * results.overall.Rec) / (results.overall.Pre + results.overall.Rec + obj.eps));
            
            results.overall.ER = (obj.overall.Nfn + obj.overall.Nfp + obj.overall.Nsubs) / obj.overall.Nref;
            results.overall.S = obj.overall.Nsubs / obj.overall.Nref;
            results.overall.D = obj.overall.Nfn / obj.overall.Nref;
            results.overall.I = obj.overall.Nfp / obj.overall.Nref;
            
            % Class-wise metrics
            class_wise_F = [];
            class_wise_ER = [];
            
            for class_id=1:length(obj.class_list)
                class_label = obj.class_list{class_id};
                current_class_results =  struct();
                
                current_class_results.Pre = obj.class_wise(class_label).Ntp / (obj.class_wise(class_label).Nsys + obj.eps);
                current_class_results.Rec = obj.class_wise(class_label).Ntp / obj.class_wise(class_label).Nref;
                current_class_results.F = 2 * ((current_class_results.Pre * current_class_results.Rec) / (current_class_results.Pre + current_class_results.Rec + obj.eps));

                current_class_results.ER = (obj.class_wise(class_label).Nfn+obj.class_wise(class_label).Nfp) / obj.class_wise(class_label).Nref;
                current_class_results.D = obj.class_wise(class_label).Nfn / obj.class_wise(class_label).Nref;
                current_class_results.I = obj.class_wise(class_label).Nfp / obj.class_wise(class_label).Nref;

                class_wise_F = [class_wise_F; current_class_results.F];
                class_wise_ER = [class_wise_ER; current_class_results.ER];
                
                results.class_wise(class_label) = current_class_results;
            end
            results.class_wise_average.F = mean(class_wise_F);
            results.class_wise_average.ER = mean(class_wise_ER);  
        end
    end
end