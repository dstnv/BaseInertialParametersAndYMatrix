% Prompt enter robot number or name
function [FileIDInput,IDKey,IDNumber]=InputPrompt(RobotData,KeysNumOrder)

ValidInput=0;
while ( ~ValidInput )
    
    IDInput = input( 'Enter Robot # or Name: ', 's');
    
    if ~isempty(IDInput)
        if ~any(strcmp(IDInput(1+nnz(IDInput(1)==''''):end-nnz(IDInput(end)=='''')),{'?','help','Help'})) % display help text, %
            
            tempInputtrim = IDInput(  max([regexp(IDInput,'^[\s]*','end')+1,1])...
                :min([regexp(IDInput,'[\s]*$','start')-1,length(IDInput)])...
                ); % trims surrounding whitespace in input
            
            % looks for custom data file
            FileIDInput = IDInput;
            if ( exist(FileIDInput,'file') ~= 2 ) % Looks for file name
                FileIDInput = tempInputtrim(1+nnz(tempInputtrim(1)==''''):end-nnz(tempInputtrim(end)=='''')); % , remove quotes, whitespace trimmed
                if ( exist(FileIDInput,'file') ~= 2 ) % Looks for file name
                    FileIDInput ='';
                end
            end
            
            % looks for key #
            IDNumber = 0;
            tempDigits = isstrprop(tempInputtrim,'digit'); % logical vector of IDInput, surrounding whitespace trimed
            if nnz([tempDigits,false]&[false,tempDigits]) == nnz(tempDigits)-1  % digits are not scattered, at least one digit
                if nnz(strcmp([tempInputtrim(~(isstrprop(tempInputtrim,'wspace')|tempDigits)) ''],{'[]',''})) % only numbers and whitespaces, possibly enclosed in []
                    IDNumber = str2double(tempInputtrim(tempDigits));
                    if IDNumber>length(RobotData)
                        IDNumber = 0;
                    end
                end
            end
            
            
            % looks for key name
            IDKey = IDInput;
            if ( ~isKey(RobotData,IDKey) )
                IDKey = tempInputtrim( 1+nnz(tempInputtrim(1)==''''):end-nnz(tempInputtrim(end)=='''') ); % , remove quotes, whitespace trimmed
                if ( ~isKey(RobotData,IDKey) ) % Looks for key name
                    IDKey='';
                end
            end
            
            tempInputValidity = [~isempty(FileIDInput), ~isempty(IDKey), IDNumber~=0 && ~strcmp(KeysNumOrder{IDNumber},IDKey) ]; % logical array of valid inputs of custom file name, key name, or list number
            
            if ~any(tempInputValidity)
                display('Incorrect Pick.');
            else
                tempNotMaching = tempInputValidity&[ ~strcmp(FileIDInput,IDInput),...
                    0 ,...
                    ~strcmp(num2str(IDNumber),IDInput) ]; % logical array, input not exactly matching a custom file name, robot name or number
                
                if  ~( nnz(tempInputValidity)>1 || any(tempNotMaching) )
                    ValidInput = true;
                else % more than one match OR one or more approximate matches
                    tempi=0;
                    tempListHold=[0,0,0];
                    if tempInputValidity(1)
                        tempi=1;
                        tempListHold(1)=tempi;
                        disp(['[' num2str(tempi) '] File: ' FileIDInput]);
                    end
                    if tempInputValidity(2)
                        tempi=tempi+1;
                        tempListHold(2)=tempi;
                        disp(['[' num2str(tempi) '] Robot Name: ' IDKey]);
                    end
                    if tempInputValidity(3)
                        tempi=tempi+1;
                        tempListHold(3)=tempi;
                        disp(['[' num2str(tempi) '] Robot #: ' num2str(IDNumber)]);
                    end
                    disp(['[n] ' 'None']);
                    while (true)
                        SelectionN = input(['Did you mean (' num2str(1:tempi,' %d,') ' n/N): '],'s');
                        if length(SelectionN)==1
                            if isstrprop(SelectionN,'digit')
                                tempIndex = find(tempListHold==str2double(SelectionN));
                                if ~isempty(tempIndex)
                                    switch tempIndex
                                        case 1
                                            IDKey='';
                                            IDNumber =0;
                                        case 2
                                            FileIDInput='';
                                            IDNumber =0;
                                        case 3
                                            FileIDInput='';
                                            IDKey='';
                                    end
                                    ValidInput = true;
                                    break;
                                end
                            elseif any(strcmp(SelectionN,{'n','N'}))
                                IDKey='';
                                FileIDInput='';
                                IDNumber =0;
                                break;
                            end
                        end
                    end
                end
            end
        else
            
            fprintf(['\nSelect Robot Identifier.\n',...
                'For other robots, create a *.m file, to enter\n',...
                'the DH and physical parameters. The format is found\n',...
                'in RobotTemplate.m, KUKA4Symbolic.m\n',...
                '(The file should be located in a matlab search path)\n',...
                '\n',...
                'Alternative:\n',...
                'Enter the DH and physical parameters in symsReadDH.m and symsReadSpecs.m\n',...
                '\n']);
            disp('Press any key:');
            pause;
            DisplayList(RobotData,KeysNumOrder);
        end
    end
end
fprintf('\n');
end