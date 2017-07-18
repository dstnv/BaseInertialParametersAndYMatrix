% Display Input List
function DisplayList(RobotData,KeysNumOrder)
    disp([num2cell(1:RobotData.length).',KeysNumOrder]);
    disp({'For robots added in a *.m file, enter its file name, e.g RobotTemplate.m or KUKA4Symbolic.m'}) 
    disp({'?', 'help'});
end