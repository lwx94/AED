classdef DCASE2016_EventDetection_SegmentBasedMetrics < EventDetectionMetrics
    properties
        time_resolution = 1.0;
        overall = struct('Ntp',0,...
                         'Ntn',0,...
                         'Nfp',0,...
                         'Nfn',0,...
                         'Nref',0,...
                         'Nsys',0,...
                         'ER',0,...
                         'S',0,...
                         'D',0,...
                         'I',0);
        class_wise = containers.Map();       
    end
    methods
        function obj = DCASE2016_EventDetection_SegmentBasedMetrics(class_list, varargin)   
            [obj.time_resolution,unused] = process_options(varargin,'time_resolution',1.0);
            obj.class_list = class_list;
                        
            for class_id=1:length(class_list)
                obj.class_wise(obj.class_list{class_id}) = struct('Ntp',0,...
                                                                  'Ntn',0,...
                                                                  'Nfp',0,...
                                                                  'Nfn',0,...
                                                                  'Nref',0,...
                                                                  'Nsys',0,...
                                                                  'ER',0,...
                                                                  'S',0,...
                                                                  'D',0,...
                                                                  'I',0);
            end
        end
        
        function evaluate(obj, system_output, annotated_groundtruth)
            % Convert event list into frame-based representation
            system_event_roll = obj.list_to_roll(system_output, 'time_resolution',obj.time_resolution);
            annotated_event_roll = obj.list_to_roll(annotated_groundtruth, 'time_resolution',obj.time_resolution);
            %figure; imagesc(system_event_roll'); axis xy
            %figure; imagesc(annotated_event_roll'); axis xy
            
            % Fix durations of both event_rolls to be equal
            if size(annotated_event_roll,1) > size(system_event_roll,1)
                padding = zeros(size(annotated_event_roll,1) - size(system_event_roll,1), length(obj.class_list));
                system_event_roll = [system_event_roll; padding];
            end

            if size(system_event_roll,1) > size(annotated_event_roll,1)
                padding = zeros(size(system_event_roll,1) - size(annotated_event_roll,1), length(obj.class_list));
                annotated_event_roll = [annotated_event_roll; padding];
            end
           
            % Compute segment-based overall metrics
            for segment_id=1:size(annotated_event_roll,1)
                annotated_segment = annotated_event_roll(segment_id, :);
                system_segment = system_event_roll(segment_id, :);

                Ntp = sum(system_segment + annotated_segment > 1);
                Ntn = sum(system_segment + annotated_segment == 0);
                Nfp = sum(system_segment - annotated_segment > 0);
                Nfn = sum(annotated_segment - system_segment > 0);

                Nref = sum(annotated_segment);
                Nsys = sum(system_segment);

                S = min(Nref, Nsys) - Ntp;
                D = max(0, Nref - Nsys);
                I = max(0, Nsys - Nref);
                ER = max(Nref, Nsys) - Ntp;

                obj.overall.Ntp = obj.overall.Ntp + Ntp;
                obj.overall.Ntn = obj.overall.Ntn + Ntn;
                obj.overall.Nfp = obj.overall.Nfp + Nfp;
                obj.overall.Nfn = obj.overall.Nfn + Nfn;
                obj.overall.Nref = obj.overall.Nref + Nref;
                obj.overall.Nsys = obj.overall.Nsys + Nsys;
                obj.overall.S = obj.overall.S + S;
                obj.overall.D = obj.overall.D + D;
                obj.overall.I = obj.overall.I + I;
                obj.overall.ER = obj.overall.ER + ER;
            end
            
            for class_id =1:length(obj.class_list)
                class_label = obj.class_list{class_id};
                annotated_segment = annotated_event_roll(:, class_id);
                system_segment = system_event_roll(:, class_id);

                Ntp = sum(system_segment + annotated_segment > 1);
                Ntn = sum(system_segment + annotated_segment == 0);
                Nfp = sum(system_segment - annotated_segment > 0);
                Nfn = sum(annotated_segment - system_segment > 0);

                Nref = sum(annotated_segment);
                Nsys = sum(system_segment);
                
                current_class_values = obj.class_wise(class_label);
                current_class_values.Ntp = current_class_values.Ntp + Ntp;
                current_class_values.Ntn = current_class_values.Ntn + Ntn;
                current_class_values.Nfp = current_class_values.Nfp + Nfp;
                current_class_values.Nfn = current_class_values.Nfn + Nfn;
                current_class_values.Nref = current_class_values.Nref + Nref;
                current_class_values.Nsys = current_class_values.Nsys + Nsys;
                obj.class_wise(class_label) = current_class_values;
            end
        end
        
        function results = results(obj)
            results = struct('overall',struct(),'class_wise',containers.Map(),'class_wise_overall',struct());
            
            % Overall metrics
            results.overall.Pre = obj.overall.Ntp / obj.overall.Nsys;
            results.overall.Rec = obj.overall.Ntp / obj.overall.Nref;            
            results.overall.F = 2 * ((results.overall.Pre * results.overall.Rec) / (results.overall.Pre + results.overall.Rec));
            
            results.overall.ER = obj.overall.ER / obj.overall.Nref;
            results.overall.S = obj.overall.S / obj.overall.Nref;
            results.overall.D = obj.overall.D / obj.overall.Nref;
            results.overall.I = obj.overall.I / obj.overall.Nref;
            
            % Class-wise metrics
            class_wise_F = [];
            class_wise_ER = [];
            
            for class_id=1:length(obj.class_list)
                class_label = obj.class_list{class_id};
                current_class_results =  struct();
                
                current_class_results.Pre = obj.class_wise(class_label).Ntp / (obj.class_wise(class_label).Nsys + obj.eps);
                current_class_results.Rec = obj.class_wise(class_label).Ntp / (obj.class_wise(class_label).Nref + obj.eps);
                current_class_results.F = 2 * ((current_class_results.Pre * current_class_results.Rec) / (current_class_results.Pre + current_class_results.Rec + obj.eps));

                current_class_results.ER = (obj.class_wise(class_label).Nfn+obj.class_wise(class_label).Nfp) / (obj.class_wise(class_label).Nref + obj.eps);
                current_class_results.D = obj.class_wise(class_label).Nfn / (obj.class_wise(class_label).Nref + obj.eps);
                current_class_results.I = obj.class_wise(class_label).Nfp / (obj.class_wise(class_label).Nref + obj.eps);

                class_wise_F = [class_wise_F; current_class_results.F];
                class_wise_ER = [class_wise_ER; current_class_results.ER];
                
                results.class_wise(class_label) = current_class_results;
            end
            results.class_wise_average.F = mean(class_wise_F);
            results.class_wise_average.ER = mean(class_wise_ER);            
        end
    end
end