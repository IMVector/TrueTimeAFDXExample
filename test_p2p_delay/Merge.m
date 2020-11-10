function m = Merge(a, b)
    n = length(a) + length(b);
    m = struct('vid',{},'bag',{},'pri',{},'lmax',{},'jit',{},'timestamp',{},'from',{},'deadline',{},'sort',{},'recvtime',{},'SN',{});
    for i = 1:n
        mt.vid = 0;
        mt.bag = 0;
        mt.pri = 0;
        mt.lmax = 0;
        mt.jit = 0;
        mt.timestamp = 0;
        mt.from = 0;
        mt.deadline = 0;
        mt.sort = 0;
        mt.recvtime = 0;
        mt.SN = 0;
        m(end + 1) = mt;
        
    end
    % 临时元素mt（意为msg_tmp）
    mt.vid = 0;
    mt.bag = 0;
    mt.pri = 0;
    mt.lmax = 0;
    mt.jit = 0;
    mt.timestamp = 0;
    mt.from = 0;
    mt.deadline = 0;
    mt.sort = inf;
    mt.recvtime = 0;
    mt.SN = 0;

    a = [a, mt];
    b = [b, mt];
    ia = 1;
    ib = 1;
    for i = 1 : n
        if a(ia).sort <= b(ib).sort
            m(i) = a(ia);
            ia = ia + 1;
        else
            m(i) = b(ib);
            ib = ib + 1;
        end
    end
end
