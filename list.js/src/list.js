var arrayProto = Array.prototype;

arrayProto.head = function () {
    return this[0];
};

arrayProto.tail = function () {
    return this.slice(1);
};

arrayProto.init = function () {
    return this.slice(0, -1);
};

arrayProto.last = function () {
    return this[this.length - 1];
};

function foldl (f, init, xs) {
    xs.forEach(function (x) {
        init = f(init, x);
    });
    return init;
}

function foldr (f, init, xs) {
    if (xs.length == 0){
        return init;
    }else{
        return f(xs.head(), foldr(f, init, xs.tail()));
    }
}

function foldl1(f, xs) {
    return foldl(f, xs.head(), xs.tail());
}

function foldr1(f, xs) {
    return foldr(f, xs.last(), xs.init());
}

function scanl(f, init, xs) {
    var res = [init];
    xs.forEach(function (x) {
        res[res.length] = f(res[res.length - 1], x);
    });
    return res;
}