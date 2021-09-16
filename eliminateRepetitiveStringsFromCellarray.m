

function cellarray2 = eliminateRepetitiveStringsFromCellarray(cellarrayOfStrings)
    cellarray1 = cellarrayOfStrings;
    cellarray2 = {};
    for i = 1:length(cellarray1)
        str = char(cellarray1(i));
        if nnz(ismember(cellarray2, str)) == 0
            cellarray2 = [cellarray2, str];
        end
    end
end