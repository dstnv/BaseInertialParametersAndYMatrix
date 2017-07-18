% Generic symbolic physical parameters
function [m,iPci,ciIi]=GenericPhysicalData(N)  
        mstring = [];
        iPcistring = [];
        ciIistring = [];
        for j=1:N
            mstring=[mstring 'sym(''mG' num2str(j) ''',''real''),' ];
            iPcistring=[iPcistring '[sym(''mXG' num2str(j) ''',''real'');sym(''mYG' num2str(j) ''',''real'');sym(''mZG' num2str(j) ''',''real'')],'];
            ciIistring=[ciIistring '[sym(''XXG' num2str(j) ''',''real''),sym(''XYG' num2str(j) ''',''real''),sym(''XZG' num2str(j) ''',''real''); sym(''XYG' num2str(j) ''',''real''),sym(''YYG' num2str(j) ''',''real''),sym(''YZG' num2str(j) ''',''real''); sym(''XZG' num2str(j) ''',''real''),sym(''YZG' num2str(j) ''',''real''),sym(''ZZG' num2str(j) ''',''real'')],'];
        end
        m = eval(['[' mstring ']']);
        iPci = eval(['[' iPcistring ']']);
        ciIi = eval(['cat(3,' ciIistring(1:end-1) ')']);
end